; ZAIA Karaoke - Modern Edition
; Inno Setup 6 script. Build with build_setup.bat (it builds dist\ first).
; The version below must match <Version> in src\Zaia.App\Zaia.App.csproj.

#define AppName "ZAIA Karaoke"
#define AppVersion "0.9.5"
#define AppExe "ZaiaKaraoke.exe"

[Setup]
AppId={{6B0E5C1A-3F4D-4E7B-9A52-7A1A0C4A0E93}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion} Beta
AppPublisher=ZAIA
DefaultDirName={autopf}\ZAIA Karaoke
DefaultGroupName=ZAIA Karaoke
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
OutputDir=..\release
OutputBaseFilename=ZaiaKaraoke-Setup-{#AppVersion}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
SetupIconFile=..\assets\app.ico
UninstallDisplayIcon={app}\{#AppExe}
UninstallDisplayName={#AppName} {#AppVersion}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "..\dist\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExe}"
Name: "{group}\{cm:UninstallProgram,{#AppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExe}"; Description: "{cm:LaunchProgram,{#AppName}}"; Flags: nowait postinstall skipifsilent
