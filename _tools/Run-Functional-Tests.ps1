<#
.SYNOPSIS
  Asks the installed game whether it still does what this mod hooks into. No RimWorld launched.

.DESCRIPTION
  TESTING.md at the repository root lists what to watch for in a running colony. This asks the
  questions that can be settled without one.

  This mod has never been run. It was ported by reading the 1.6 assembly, and every claim the port
  rests on was settled by reflection rather than by play. Those claims are written in the CHANGELOG
  as prose, where nothing ever rechecks them. This file rechecks them, against the game that is
  installed right now.

  What the mod is: three Harmony patches, one float-menu provider, one list of terrain names, and
  one private field read out of the renderer. Two of those five fail LOUDLY when the game moves -
  a patch aimed at a method that no longer exists throws before the main menu. The other three fail
  in silence, and they are why this file exists:

    - PawnRenderer.DynamicDrawPhaseAt stops calling RenderPawnAt. The postfix is still attached,
      still valid, and simply never runs. The board stops being drawn. Nothing throws, nothing is
      logged, and no test but this one would notice.
    - FloatMenuMakerMap stops discovering providers by subclass sweep. The class is still declared,
      still correct, and nothing ever instantiates it. The right-click option disappears.
    - A vanilla floor is renamed. That floor silently stops being skateable, and the mod keeps
      working everywhere else, which is the worst way for it to break.

  The access section comes first for a different reason. On 2026-09-12 this assembly was found with
  no [assembly: IgnoresAccessChecksTo]: Krafs.Publicizer applies it through the SDK's generated
  AssemblyInfo, and this project sets GenerateAssemblyInfo to false, so the attribute's TYPE was
  embedded and the grant never applied. The build was clean and the log said nothing. The token
  scan, the grant invariant and the compile probe are the FieldworkCompanions, FireworkStand and
  EntityGazing sessions' work, taken over wholesale; the probe is turned around the same way, to
  assert WHICH non-public member is needed rather than that none is.

  READ A FAILURE THERE CORRECTLY. It means "this mod reaches for something it was not granted",
  which is true and worth fixing. It does NOT mean "this mod is broken in play": the Architect
  Studio session found a non-public call of its own, outside any try/catch, in an assembly with no
  grant, working in a real game. RimWorld runs on Mono; everything measured here runs under
  PowerShell on the desktop CLR.

  SEVEN OF THESE THIRTEEN HAVE BEEN SEEN TO FAIL, one fault at a time in a copy of the mod, never
  in the real files, the first three rebuilt so the fault reached the assembly:

    Source/AccessChecks.cs deleted          -> the grant invariant, AND the token scan, which names
                                               PawnRenderer.pawn and the method that reads it
    a HarmonyPatch aimed at "Ticks"         -> the attribute test
    the class-level [HarmonyPatch] removed  -> the class-attribute test, AND the attribute count
    a second PatchAll call added            -> the single-registration test
    a terrain name misspelt                 -> the floor list
    a French key dropped                    -> the translation test

  That third one is the 1.5 mod's own bug, and it is the reason the class-attribute test does not
  look for [HarmonyPostfix] alone. This mod names its bodies Prefix and Postfix and marks them with
  nothing, which is the form Harmony recognises by name - so a class that loses its attribute keeps
  compiling, keeps looking like a patch, and is skipped in silence. A test that only looked for
  marked methods would have passed on the mutation. It was written that way first.

  SIX COULD NOT BE, and this says so rather than letting the count imply otherwise. The harness
  test, the compile probe, the three hook signatures, the draw-phase call, the provider's base
  class and the discovery sweep are claims about Assembly-CSharp and the shipped defs. Mutating
  those to prove a test would mean rewriting the game. They are the tests that matter most and they
  are the ones with no red run behind them.

  Exit code 0 when everything passes, 1 otherwise.

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1
#>

param(
    [string]$ModRoot  = (Split-Path -Parent $PSScriptRoot),
    [string]$GameData = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Data',
    [string]$Managed  = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\RimWorldWin64_Data\Managed',
    # The mod compiles against Harmony but ships none of it (ExcludeAssets runtime), so reading its
    # [HarmonyPatch] attributes needs a copy from somewhere. The Harmony mod's own is the honest
    # one; the NuGet cache is the fallback for a machine without it subscribed.
    [string]$HarmonyDll = 'C:\Program Files (x86)\Steam\steamapps\workshop\content\294100\2009463077\Current\Assemblies\0Harmony.dll'
)

$ErrorActionPreference = 'Stop'

$script:ran = 0
$script:failed = 0

# A body returns nothing when all is well, or one string per problem. Returning strings rather
# than $true/$false is what lets a test report four faults at once instead of the first.
function It([string]$name, [scriptblock]$body) {
    $script:ran++
    $problems = @()
    try   { $problems = @(& $body | Where-Object { $_ }) }
    catch { $problems = @("threw: $($_.Exception.GetBaseException().Message)") }
    if ($problems.Count -eq 0) { Write-Output "  ok    $name" }
    else {
        $script:failed++
        Write-Output "  FAIL  $name"
        foreach ($p in $problems) { Write-Output "          $p" }
    }
}
function Section([string]$name) { Write-Output ''; Write-Output $name }
function Note([string]$text)    { Write-Host "        $text" -ForegroundColor DarkGray }

# ---------------------------------------------------------------------------------------------
# The two assemblies
# ---------------------------------------------------------------------------------------------

# Assembly-CSharp names Unity assemblies that are not beside this script. Remember what has been
# tried: an unresolvable name asked for twice recurses to a stack overflow rather than an error.
if (-not (Test-Path $HarmonyDll)) {
    $cached = Get-ChildItem (Join-Path $env:USERPROFILE '.nuget\packages\lib.harmony') -Recurse -Filter '0Harmony.dll' -ErrorAction SilentlyContinue |
              Sort-Object FullName | Select-Object -Last 1
    if ($cached) { $HarmonyDll = $cached.FullName }
}
$script:probeDirs = @($Managed)
if (Test-Path $HarmonyDll) { $script:probeDirs += (Split-Path -Parent $HarmonyDll) }

$script:probed = @{}
[System.AppDomain]::CurrentDomain.add_AssemblyResolve([System.ResolveEventHandler]{
    param($sender, $e)
    if ($null -eq $script:probed) { return $null }
    $short = $e.Name.Split(',')[0]
    if ($script:probed.ContainsKey($short)) { return $null }
    $script:probed[$short] = $true
    foreach ($d in $script:probeDirs) {
        $p = Join-Path $d "$short.dll"
        if (Test-Path $p) { return [System.Reflection.Assembly]::LoadFrom($p) }
    }
    return $null
})

# GetTypes() always throws here - Unity is missing - but the exception carries every type it did
# resolve, which is all of them but a handful. PowerShell wraps it, so both shapes are caught.
function Get-AssemblyTypes([System.Reflection.Assembly]$a) {
    try     { return $a.GetTypes() }
    catch [System.Reflection.ReflectionTypeLoadException] { return $_.Exception.Types | Where-Object { $_ } }
    catch   { return $_.Exception.InnerException.Types | Where-Object { $_ } }
}

$BFall = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,Static,DeclaredOnly'
$BFis  = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,Static'
$BFd   = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,DeclaredOnly'
$BFn   = [System.Reflection.BindingFlags]'Public,NonPublic'

$gameAsm   = [System.Reflection.Assembly]::LoadFrom((Join-Path $Managed 'Assembly-CSharp.dll'))
$gameTypes = @(Get-AssemblyTypes $gameAsm)
$byName = @{}
foreach ($t in $gameTypes) { if ($t.Name -and -not $byName.ContainsKey($t.Name)) { $byName[$t.Name] = $t } }

$modDllPath = Join-Path $ModRoot 'Mod\Assemblies\FoldingSkateboard.dll'
$modAsm     = [System.Reflection.Assembly]::LoadFrom($modDllPath)
$modTypes   = @(Get-AssemblyTypes $modAsm)

function Read-Text([string]$p) { Get-Content $p -Raw -Encoding UTF8 }

# ---------------------------------------------------------------------------------------------
# Reading IL
# ---------------------------------------------------------------------------------------------
#
# Only the opcodes this suite asks about, each a byte followed by a four-byte metadata token.
#
# ldflda (0x7C) and ldsflda (0x7F) are in the list on purpose. A field of STRUCT type is read
# through its address, so a scan that knows only ldfld and stfld reports such a field as touched
# by nobody - which looks exactly like a real finding and is not. The EntityGazing session lost a
# run to that on an IntRange.
function Get-Refs($method) {
    $out = @()
    $body = $null
    try { $body = $method.GetMethodBody() } catch { }
    if (-not $body) { return $out }
    $il = $body.GetILAsByteArray()
    if (-not $il) { return $out }
    $mod = $method.Module
    for ($i = 0; $i -lt $il.Length - 4; $i++) {
        $op = $il[$i]
        $kind = $null; $at = $i + 1; $resolve = $null
        if     ($op -eq 0x28 -or $op -eq 0x6F -or $op -eq 0x73) { $kind = 'call'; $resolve = 'method' }
        elseif ($op -in 0x7B, 0x7C, 0x7D, 0x7E, 0x7F, 0x80)     { $kind = 'fld';  $resolve = 'field'  }
        elseif ($op -eq 0x74 -or $op -eq 0x75)                  { $kind = 'type'; $resolve = 'type'   }
        elseif ($op -eq 0xFE -and $i + 5 -lt $il.Length -and ($il[$i+1] -eq 0x06 -or $il[$i+1] -eq 0x07)) {
            $kind = $(if ($il[$i+1] -eq 0x06) { 'ldftn' } else { 'ldvirtftn' })
            $at = $i + 2; $resolve = 'method'
        }
        if (-not $kind) { continue }
        $tok = [BitConverter]::ToInt32($il, $at)
        $m = $null
        try {
            switch ($resolve) {
                'method' { $m = $mod.ResolveMethod($tok) }
                'field'  { $m = $mod.ResolveField($tok) }
                'type'   { $m = $mod.ResolveType($tok) }
            }
        } catch { }
        if ($m) { $out += ,@{ Kind = $kind; Member = $m } }
    }
    return $out
}

function Get-AllMethods([Type]$t) {
    $types = @($t) + @($t.GetNestedTypes($BFn))
    $out = @()
    foreach ($x in $types) {
        $out += @($x.GetMethods($BFall))
        $out += @($x.GetConstructors($BFall))
        foreach ($p in $x.GetProperties($BFd)) {
            $g = $p.GetGetMethod($true); if ($g) { $out += $g }
        }
    }
    return $out
}

function Get-Ancestry([Type]$t) {
    $names = @{}
    $cur = $t
    while ($cur -and $cur.FullName -ne 'System.Object') { $names[$cur.Name] = $true; $cur = $cur.BaseType }
    return $names
}

# The three gestures, as the mod hooks them. Tick is patched by string because it turned protected
# in 1.6 and nameof no longer compiles against it.
$Hooks = @(
    @{ Type = 'PawnRenderer'; Method = 'RenderPawnAt'; First = 'Vector3' }
    @{ Type = 'Pawn';         Method = 'Tick';         First = $null     }
    @{ Type = 'Pawn';         Method = 'DeSpawn';      First = 'DestroyMode' }
)

Write-Output ''
Write-Output 'Folding Skateboard Renew - functional tests'

# =============================================================================================
Section 'The harness itself'
# =============================================================================================

# Every negative test below - "nothing reaches what it should not", "no name is missing" - passes
# for free when its inputs are empty. These are counted first for that reason.
It 'the game and the mod assembly both loaded, with types in them' {
    if ($gameTypes.Count -lt 10000) { "only $($gameTypes.Count) types resolved out of Assembly-CSharp" }
    if ($modTypes.Count -lt 5)      { "only $($modTypes.Count) types resolved out of the mod assembly" }
    foreach ($n in 'PawnRenderer', 'Pawn', 'FloatMenuOptionProvider', 'FloatMenuMakerMap', 'TerrainDef') {
        if (-not $byName[$n]) { "the game has no $n any more" }
    }
}

# =============================================================================================
Section 'Access: what the publiciser opened, and what the build applied'
# =============================================================================================

# The fault of 2026-09-12, and the check that does not lie. Grepping the DLL for the attribute
# name finds the TYPE whether the grant was applied or not, which is exactly the shape of the trap.
It 'the access grant and the publiciser agree: both declared, or neither' {
    $grant = @($modAsm.GetCustomAttributesData() |
               Where-Object { $_.AttributeType.Name -like 'IgnoresAccessChecksTo*' })
    $publicised = (Read-Text (Join-Path $ModRoot 'Source\FoldingSkateboard.csproj')) -match '<Publicize\b'
    Note ("publiciser declared: $publicised; access grant present: $($grant.Count -gt 0)")
    if ($publicised -ne ($grant.Count -gt 0)) {
        'a publiciser with no grant is the silent failure; a grant with no publiciser means the csproj changed under this test'
    }
}

# The same fault read from the other end: not "is the grant there" but "is anything reached that
# would need it". This one names the offender.
It 'the mod reaches for nothing in the game it is not allowed to reach for' {
    $hasGrant = @($modAsm.GetCustomAttributesData() |
                  Where-Object { $_.AttributeType.Name -like 'IgnoresAccessChecksTo*' }).Count -gt 0
    foreach ($t in $modTypes) {
        $family = Get-Ancestry $t
        foreach ($m in (Get-AllMethods $t)) {
            foreach ($r in (Get-Refs $m)) {
                if ($r.Kind -eq 'type') { continue }
                $member = $r.Member
                $decl = $member.DeclaringType
                if (-not $decl -or $decl.Assembly -ne $gameAsm) { continue }
                if ($member.IsPublic) { continue }
                # A protected member is legal from a subclass, with no grant at all. That is the
                # whole of the float-menu provider: four protected properties it overrides.
                if (($member.IsFamily -or $member.IsFamilyOrAssembly) -and $family.ContainsKey($decl.Name)) { continue }
                if ($hasGrant) { continue }
                "$($t.Name).$($m.Name) touches $($decl.Name).$($member.Name), which is not public, and this assembly carries no access grant"
            }
        }
    }
}

# EntityGazing's compile probe, turned around. This mod DOES need the publiciser, so the useful
# assertion is WHICH member it needs: exactly one, the renderer's own pawn. A second name here is
# a new reach into the game's private parts and should be a decision, not a diff nobody read.
It 'the source needs exactly the one non-public member it is known to need' {
    if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) { Note 'dotnet not on PATH, skipped'; return }
    # A short path on purpose: NuGet writes PublicizedAssemblies\<32 hex> under obj, and a session
    # scratchpad prefix pushes that past MAX_PATH - the build fails, and the cleanup fails after it.
    $probe = Join-Path $env:LOCALAPPDATA ('Temp\fsk-' + [guid]::NewGuid().ToString('N').Substring(0, 6))
    New-Item -ItemType Directory $probe -Force | Out-Null
    try {
        Copy-Item (Join-Path $ModRoot 'Source\*.cs') $probe
        # AccessChecks.cs cannot come along: the attribute type it uses is defined BY the
        # publiciser, so without one the probe would fail on our own file and never reach the game.
        Remove-Item (Join-Path $probe 'AccessChecks.cs') -ErrorAction SilentlyContinue
        @"
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Library</OutputType><TargetFramework>net48</TargetFramework>
    <AssemblyName>FskAccessProbe</AssemblyName>
    <GenerateAssemblyInfo>false</GenerateAssemblyInfo>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="Assembly-CSharp"><HintPath>$Managed\Assembly-CSharp.dll</HintPath><Private>false</Private></Reference>
    <Reference Include="UnityEngine.CoreModule"><HintPath>$Managed\UnityEngine.CoreModule.dll</HintPath><Private>false</Private></Reference>
    <Reference Include="UnityEngine"><HintPath>$Managed\UnityEngine.dll</HintPath><Private>false</Private></Reference>
    <PackageReference Include="Lib.Harmony" Version="2.*"><ExcludeAssets>runtime</ExcludeAssets></PackageReference>
  </ItemGroup>
</Project>
"@ | Set-Content (Join-Path $probe 'Probe.csproj') -Encoding UTF8
        $out = & dotnet build (Join-Path $probe 'Probe.csproj') -c Release -v q --nologo 2>&1 | Out-String
        $errs = @([regex]::Matches($out, '(?m)error CS\d+:.*$') | ForEach-Object { $_.Value } | Sort-Object -Unique)

        # Two codes are the subject here and nothing else is. CS0122 for a private or protected
        # member, CS1061 for an internal one, which member lookup does not even see across
        # assemblies. Anything else means the probe broke rather than the mod reaching too far.
        foreach ($e in @($errs | Where-Object { $_ -notmatch 'error CS(0122|1061):' } | Select-Object -First 3)) {
            "unexpected: $e"
        }
        if (@($errs | Where-Object { $_ -notmatch 'error CS(0122|1061):' })) { return }

        # Identifiers are not translated, so the quoted names survive a localised compiler where
        # the sentence around them does not.
        # The member arrives as its own quoted name and the type as another - CS1061 for a private
        # field, which member lookup does not see across assemblies at all - so a reach is
        # recognised by the PAIR of names, never by one. The sentence around them is localised;
        # the identifiers are not.
        $wanted = @{ 'PawnRenderer.pawn' = @{ Names = @('PawnRenderer', 'pawn'); Why = 'whose renderer the postfix is running on' } }
        $hit = @{}
        foreach ($e in $errs) {
            $names = @([regex]::Matches($e, "'([A-Za-z_][\w.]*)'") | ForEach-Object { $_.Groups[1].Value })
            $known = @($wanted.Keys | Where-Object { -not (@($wanted[$_].Names | Where-Object { $names -notcontains $_ })) })
            if ($known) { foreach ($k in $known) { $hit[$k] = $true } }
            else { "a non-public member is reached that this test does not know about: $e" }
        }
        Note ("non-public members needed: " + (@($hit.Keys | Sort-Object) -join ', '))
        foreach ($k in $wanted.Keys) {
            if (-not $hit.ContainsKey($k)) {
                "$k no longer needs the publiciser ($($wanted[$k].Why)) - either the game made it public, or the mod stopped reading it; if nothing needs it, drop the publiciser and Source/AccessChecks.cs together"
            }
        }
    } finally { Remove-Item $probe -Recurse -Force -ErrorAction SilentlyContinue }
}

# =============================================================================================
Section 'The three hooks'
# =============================================================================================

It 'each patched method is still there, with one overload and the expected first parameter' {
    foreach ($h in $Hooks) {
        $t = $byName[$h.Type]
        if (-not $t) { "the game has no $($h.Type)"; continue }
        $ms = @($t.GetMethods($BFis) | Where-Object { $_.Name -eq $h.Method -and $_.DeclaringType -eq $t })
        if ($ms.Count -eq 0) { "$($h.Type).$($h.Method) is gone"; continue }
        # Harmony patches by name. Two overloads and it throws AmbiguousMatch at startup rather
        # than picking one, so the count is part of the contract, not a detail.
        if ($ms.Count -gt 1) { "$($h.Type).$($h.Method) now has $($ms.Count) overloads, and the patch names no parameter types" }
        $p = @($ms[0].GetParameters())
        if ($h.First) {
            if ($p.Count -lt 1 -or $p[0].ParameterType.Name -ne $h.First) {
                "$($h.Type).$($h.Method) no longer takes $($h.First) first"
            }
        } elseif ($p.Count -ne 0) {
            "$($h.Type).$($h.Method) now takes $($p.Count) parameters, and the patch expects none"
        }
    }
}

# The claim the whole port rests on. 1.6 rebuilt pawn drawing around PawnRenderNode and
# PawnRenderTree, and RenderPawnAt survived only because the rewrite moved what happens INSIDE it.
# If a later version stops calling it, the postfix stays attached, stays valid, and never runs.
It 'the draw phase still calls the method this mod postfixes' {
    $t = $byName['PawnRenderer']
    $callers = @($t.GetMethods($BFis) | Where-Object { $_.Name -eq 'DynamicDrawPhaseAt' })
    if ($callers.Count -eq 0) { 'PawnRenderer.DynamicDrawPhaseAt is gone, and with it the once-per-frame call'; return }
    $found = $false
    foreach ($c in $callers) {
        foreach ($r in (Get-Refs $c)) {
            if ($r.Kind -eq 'call' -and $r.Member.Name -eq 'RenderPawnAt') { $found = $true }
        }
    }
    if (-not $found) {
        'DynamicDrawPhaseAt no longer calls RenderPawnAt: the board would stop being drawn, silently, with the patch still attached'
    }
}

It 'every HarmonyPatch attribute on the mod resolves to a real method' {
    $seen = 0
    foreach ($t in $modTypes) {
        foreach ($a in $t.GetCustomAttributesData()) {
            if ($a.AttributeType.Name -ne 'HarmonyPatch') { continue }
            $args = @($a.ConstructorArguments)
            if ($args.Count -lt 2) { continue }
            $target = $args[0].Value -as [Type]
            $name = [string]$args[1].Value
            if (-not $target) { "a HarmonyPatch on $($t.Name) names a type that no longer resolves"; continue }
            $seen++
            if (-not @($target.GetMethods($BFis) | Where-Object { $_.Name -eq $name })) {
                "$($t.Name) patches $($target.Name).$name, which does not exist"
            }
        }
    }
    if ($seen -lt 3) { "only $seen HarmonyPatch attributes found, and this mod has three patches" }
}

# The 1.5 mod's own bug, kept as a test because it cost a caravan patch that never ran and nobody
# noticed for a year. PatchClassProcessor returns before doing anything when the TYPE carries no
# [HarmonyPatch]: a [HarmonyPostfix] on a method inside such a class is silently ignored.
It 'every class holding a patch method also carries a class-level HarmonyPatch' {
    $patchNames = 'Prefix', 'Postfix', 'Transpiler', 'Finalizer'
    foreach ($t in $modTypes) {
        $onClass = @($t.GetCustomAttributesData() | Where-Object { $_.AttributeType.Name -eq 'HarmonyPatch' }).Count -gt 0
        foreach ($m in @($t.GetMethods($BFall))) {
            # Harmony recognises a patch body two ways: by an attribute on the method, or by its
            # name alone. This mod uses the second, which is the form that made the 1.5 bug
            # invisible - nothing about $($t.Name).Postfix says out loud that it is a patch.
            $marked = @($m.GetCustomAttributesData() |
                        Where-Object { $_.AttributeType.Name -in 'HarmonyPostfix', 'HarmonyPrefix', 'HarmonyTranspiler', 'HarmonyFinalizer' }).Count -gt 0
            if (($marked -or $m.Name -in $patchNames) -and -not $onClass) {
                "$($t.Name).$($m.Name) is a patch body in a class with no [HarmonyPatch]: PatchClassProcessor returns before doing anything, and PatchAll skips it in silence"
            }
        }
        if ($onClass) {
            $bodies = @($t.GetMethods($BFall) | Where-Object { $_.Name -in $patchNames -or
                @($_.GetCustomAttributesData() | Where-Object { $_.AttributeType.Name -like 'Harmony*' }).Count -gt 0 })
            if ($bodies.Count -eq 0) { "$($t.Name) is declared a HarmonyPatch and holds no Prefix or Postfix" }
        }
    }
}

# The other half of the same defect: the 1.5 mod called PatchAll from two places under two ids, so
# every patch ran twice and the board was drawn twice per frame.
It 'PatchAll is called from exactly one place, under one id' {
    # Comments are stripped first, and not for tidiness: FoldingSkateboardMod.cs explains the
    # double-PatchAll bug in its own doc comment, so a scan of the raw text counts the explanation
    # as a second call and fails on a file that is correct.
    $src = @(Get-ChildItem (Join-Path $ModRoot 'Source') -Recurse -Filter '*.cs' | ForEach-Object { Read-Text $_.FullName }) -join "`n"
    $src = [regex]::Replace($src, '/\*.*?\*/', '', 'Singleline')
    $src = [regex]::Replace($src, '(?m)^\s*//.*$', '')
    $calls = @([regex]::Matches($src, 'PatchAll\s*\('))
    if ($calls.Count -ne 1) { "PatchAll is called $($calls.Count) times in the source; two calls means every patch applied twice" }
    $ids = @([regex]::Matches($src, 'new\s+Harmony\s*\(\s*"([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
    if ($ids.Count -ne 1) { "the source builds $($ids.Count) Harmony instances: $($ids -join ', ')" }
    elseif ($ids[0] -ne 'nelim.foldingskateboardrenew') { "the Harmony id is $($ids[0]), which is no longer the packageId" }
}

# =============================================================================================
Section 'The right-click option, which is a subclass and not a patch'
# =============================================================================================

# 1.6 replaced FloatMenuMakerMap.ChoicesAtFor - which the 1.5 mod patched - with providers found by
# subclass sweep. Declaring the class IS the registration, so there is no patch to fail loudly:
# if the sweep goes, the option just stops appearing.
It 'the provider still derives from the game class, and overrides members the game still declares' {
    $base = $byName['FloatMenuOptionProvider']
    if (-not $base) { 'FloatMenuOptionProvider is gone; the option has no way to register'; return }
    if (-not $base.IsAbstract) { 'FloatMenuOptionProvider is no longer abstract, which is how the sweep filters candidates' }

    $mine = @($modTypes | Where-Object { $_.BaseType -and $_.BaseType.Name -eq 'FloatMenuOptionProvider' })
    if ($mine.Count -ne 1) { "the mod declares $($mine.Count) providers, and it should declare one"; return }
    $p = $mine[0]
    if ($p.IsAbstract) { "$($p.Name) is abstract, so the sweep would skip it" }
    if (-not $p.GetConstructor([Type]::EmptyTypes)) { "$($p.Name) has no parameterless constructor, and the sweep uses Activator.CreateInstance" }

    foreach ($n in 'Drafted', 'Undrafted', 'Multiselect', 'RequiresManipulation') {
        $prop = $base.GetProperty($n, $BFn -bor [System.Reflection.BindingFlags]::Instance)
        if (-not $prop) { "FloatMenuOptionProvider no longer declares $n, which this provider overrides" }
    }
    if (-not @($base.GetMethods($BFis) | Where-Object { $_.Name -eq 'GetOptionsFor' })) {
        'FloatMenuOptionProvider no longer declares GetOptionsFor, which is where the option comes from'
    }
}

It 'the game still discovers providers by sweeping subclasses' {
    $t = $byName['FloatMenuMakerMap']
    $found = $false
    foreach ($m in (Get-AllMethods $t)) {
        foreach ($r in (Get-Refs $m)) {
            if ($r.Kind -ne 'call') { continue }
            if ($r.Member.Name -like 'AllSubclassesNonAbstract*') { $found = $true }
        }
    }
    if (-not $found) {
        'FloatMenuMakerMap no longer calls AllSubclassesNonAbstract: declaring the provider may no longer register it, and nothing would throw'
    }
}

# =============================================================================================
Section 'The floors the board rolls on'
# =============================================================================================

# The quietest failure of the three. A renamed floor resolves to nothing, the mod keeps working
# everywhere else, and the only symptom is a pawn who walks across one patch of ground.
It 'every vanilla floor the mod names still exists, and the generated stone ones still can' {
    $src = Read-Text (Join-Path $ModRoot 'Source\SkateableTerrain.cs')
    $block = [regex]::Match($src, 'VanillaNames\s*=\s*\{(.*?)\};', 'Singleline')
    if (-not $block.Success) { 'VanillaNames is no longer a braced list in SkateableTerrain.cs'; return }
    $names = @([regex]::Matches($block.Groups[1].Value, '"([^"]+)"') | ForEach-Object { $_.Groups[1].Value })
    if ($names.Count -lt 20) { "only $($names.Count) vanilla floor names read out of the source"; return }

    $terrainDir = Join-Path $GameData 'Core\Defs\TerrainDefs'
    if (-not (Test-Path $terrainDir)) { "no TerrainDefs folder at $terrainDir"; return }
    $declared = @{}
    foreach ($f in (Get-ChildItem $terrainDir -Filter '*.xml')) {
        foreach ($m in [regex]::Matches((Read-Text $f.FullName), '<defName>([^<]+)</defName>')) {
            $declared[$m.Groups[1].Value] = $true
        }
    }
    # Stone floors are not in any XML: RimWorld builds "{rock}_Rough" and "{rock}_RoughHewn" for
    # each rock type at load. What can be checked is that the rock still exists.
    # The rocks are ThingDefs_Misc\Various_Stone.xml, not ThingDefs_Buildings as the name suggests:
    # the def is the chunk-and-block family, and the natural rock building hangs off it.
    $rocks = @{}
    foreach ($f in (Get-ChildItem (Join-Path $GameData 'Core\Defs') -Recurse -Filter '*.xml' -ErrorAction SilentlyContinue | Where-Object { $_.DirectoryName -like '*ThingDefs*' })) {
        foreach ($m in [regex]::Matches((Read-Text $f.FullName), '<defName>([^<]+)</defName>')) {
            $rocks[$m.Groups[1].Value] = $true
        }
    }
    $generated = 0
    foreach ($n in $names) {
        if ($n -match '^(.+?)_(Rough|RoughHewn|Smooth)$') {
            $generated++
            if (-not $rocks[$Matches[1]]) { "$n is generated from a rock called $($Matches[1]), and no such def is shipped" }
            continue
        }
        if (-not $declared[$n]) { "$n is named as a skateable floor and is no TerrainDef the game ships" }
    }
    Note ("$($names.Count) vanilla names: $($names.Count - $generated) declared floors, $generated generated from rock")
}

# =============================================================================================
Section 'The interface'
# =============================================================================================

It 'every key the assembly asks for exists in English, and French matches key for key' {
    $src = @(Get-ChildItem (Join-Path $ModRoot 'Source') -Recurse -Filter '*.cs' | ForEach-Object { Read-Text $_.FullName }) -join "`n"
    $used = @([regex]::Matches($src, '"(FoldingSkateboard\.[A-Za-z0-9.]+)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
    if ($used.Count -lt 2) { "only $($used.Count) keys found in the source, which cannot be right"; return }

    $keysOf = {
        param($p)
        $x = New-Object System.Xml.XmlDocument
        $x.Load($p)
        @($x.DocumentElement.ChildNodes | Where-Object { $_.NodeType -eq 'Element' } | ForEach-Object { $_.Name }) | Sort-Object -Unique
    }
    $en = & $keysOf (Join-Path $ModRoot 'Mod\Languages\English\Keyed\FoldingSkateboard.xml')
    $fr = & $keysOf (Join-Path $ModRoot 'Mod\Languages\French\Keyed\FoldingSkateboard.xml')
    Note ("keys used: $($used.Count); English: $($en.Count); French: $($fr.Count)")

    foreach ($k in $used) { if ($en -notcontains $k) { "$k is asked for by the code and is in no English file" } }
    foreach ($k in $en)   { if ($fr -notcontains $k) { "$k is in English and missing from French" } }
    foreach ($k in $fr)   { if ($en -notcontains $k) { "$k is in French and missing from English" } }

    # Two keys are borrowed from the game rather than shipped. They are the reason the menu entry
    # can say why it is greyed out without translating anything, and they are not ours to keep.
    $borrowed = @([regex]::Matches($src, '"([A-Za-z][A-Za-z0-9]*)"\.Translate') | ForEach-Object { $_.Groups[1].Value } |
                  Where-Object { $_ -notlike 'FoldingSkateboard*' } | Sort-Object -Unique)
    $coreKeyed = Join-Path $GameData 'Core\Languages\English\Keyed'
    if (Test-Path $coreKeyed) {
        $vanilla = @{}
        foreach ($f in (Get-ChildItem $coreKeyed -Recurse -Filter '*.xml')) {
            foreach ($m in [regex]::Matches((Read-Text $f.FullName), '<([A-Za-z][A-Za-z0-9_.]*)>')) {
                $vanilla[$m.Groups[1].Value] = $true
            }
        }
        foreach ($k in $borrowed) {
            if (-not $vanilla[$k]) { "$k is borrowed from the game's own keys and the game no longer ships it" }
        }
        Note ("borrowed from vanilla: " + (@($borrowed) -join ', '))
    }
}

# =============================================================================================
Write-Output ''
if ($script:failed -eq 0) {
    Write-Output "$($script:ran) tests, all passed."
    exit 0
}
Write-Output "$($script:ran) tests, $($script:failed) failed."
exit 1
