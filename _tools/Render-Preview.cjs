// Run with Playwright and sharp on NODE_PATH. Uses the installed Chrome browser.
const fs = require('node:fs/promises');
const path = require('node:path');
const http = require('node:http');
const { chromium } = require('playwright');
const sharp = require('sharp');
const root = path.resolve(__dirname, '..');
const qa = path.join(root, '.build/preview-qa');
(async () => {
 await fs.mkdir(qa, { recursive:true });
 const server = http.createServer(async (req,res) => {
  try {
   const name = path.basename(new URL(req.url,'http://localhost').pathname);
   if (!['preview.html','preview-palette.json','Preview.png'].includes(name)) { res.writeHead(404).end(); return; }
   res.setHeader('Content-Type', name.endsWith('.json')?'application/json':name.endsWith('.png')?'image/png':'text/html');
   res.end(await fs.readFile(path.join(root,'Art',name)));
  } catch { res.writeHead(500).end(); }
 });
 await new Promise(resolve=>server.listen(0,'127.0.0.1',resolve));
 let browser;
 try {
  browser = await chromium.launch({ channel:'chrome', headless:true });
  const page = await browser.newPage({ viewport:{ width:896,height:504 },deviceScaleFactor:1 });
  await page.goto(`http://127.0.0.1:${server.address().port}/preview.html`);
  await page.evaluate(()=>window.previewReady);
  const client=await page.context().newCDPSession(page);
  await client.send('DOM.enable'); await client.send('CSS.enable');
  const doc=await client.send('DOM.getDocument');
  const node=await client.send('DOM.querySelector',{nodeId:doc.root.nodeId,selector:'.name'});
  const fonts=await client.send('CSS.getPlatformFontsForNode',{nodeId:node.nodeId});
  const bounds=await page.evaluate(()=>Object.fromEntries(['.name','.suffix','.tag','.line'].map(s=>{const r=document.querySelector(s).getBoundingClientRect();return [s,{x:r.x,y:r.y,width:r.width,height:r.height}]})));
  const output=path.join(qa,'Preview.png');
  await page.screenshot({path:output});
  await sharp(output).resize({width:268}).toFile(path.join(qa,'Preview-268.png'));
  await page.addStyleTag({content:'.plate,.version {visibility:hidden}'});
  const background=await page.screenshot({path:path.join(qa,'background.png')});
  const {data,info}=await sharp(background).removeAlpha().raw().toBuffer({resolveWithObject:true});
  const palette=JSON.parse((await fs.readFile(path.join(root,'Art/preview-palette.json'),'utf8')).replace(/^\uFEFF/,''));
  const luminance=rgb=>rgb.map(v=>{v/=255;return v<=.04045?v/12.92:((v+.055)/1.055)**2.4}).reduce((a,v,i)=>a+v*[.2126,.7152,.0722][i],0);
  const lumHex=h=>luminance(h.match(/[a-f0-9]{2}/gi).map(x=>parseInt(x,16)));
  const contrast=(a,b)=>(Math.max(a,b)+.05)/(Math.min(a,b)+.05);
  const minima={};
  for(const [sel,r] of Object.entries(bounds)) {
   const ink=lumHex(palette[sel==='.tag'||sel==='.suffix'?'inkSecondary':'inkPrimary']);
   let min=Infinity;
   for(let y=Math.floor(r.y);y<Math.ceil(r.y+r.height);y++) for(let x=Math.floor(r.x);x<Math.ceil(r.x+r.width);x++) {
    const offset=(y*info.width+x)*info.channels;
    min=Math.min(min,contrast(ink,luminance([...data.subarray(offset,offset+3)])));
   }
   minima[sel]=Number(min.toFixed(2));
  }
  minima.badge=Number(contrast(lumHex(palette.badgeInk),lumHex(palette.accent)).toFixed(2));
  const report={fonts:fonts.fonts,bounds,contrastMinima:minima,...await sharp(output).metadata()};
  await fs.writeFile(path.join(qa,'results.json'),JSON.stringify(report,null,2));
  if(Object.values(minima).some(v=>v<4.5)) throw Error('Contrast below 4.5: '+JSON.stringify(minima));
  if(!fonts.fonts.every(f=>/^Segoe UI(?: Semibold)?$/.test(f.familyName))) throw Error('Unexpected font fallback');
  if((await fs.stat(output)).size>=1000000) throw Error('Preview exceeds size limit');
  await fs.copyFile(output,path.join(root,'Mod/About/Preview.png'));
  console.log(JSON.stringify({fonts:fonts.fonts,contrastMinima:minima,bytes:(await fs.stat(output)).size}));
 } finally { if(browser) await browser.close(); await new Promise(resolve=>server.close(resolve)); }
})().catch(error=>{console.error(error);process.exitCode=1;});
