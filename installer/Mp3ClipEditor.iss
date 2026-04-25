#define MyAppName "MP3 Clip Editor"
#define MyAppExeName "Mp3ClipEditorTagger.exe"
#define MyAppPublisher "Noel Stephenson"
#define MyAppURL "https://github.com/noelstephenson/Mp3ClipEditor"

#ifndef MyAppVersion
  #define MyAppVersion "1.0.0"
#endif

#ifndef PublishDir
  #error PublishDir define is required.
#endif

#ifndef OutputDir
  #error OutputDir define is required.
#endif

#ifndef RepoRoot
  #error RepoRoot define is required.
#endif

[Setup]
AppId={{B5F6F0BC-B4F6-4A6E-8D96-42D7D4543E95}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={localappdata}\Programs\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir={#OutputDir}
OutputBaseFilename=Mp3ClipEditor-Setup-{#MyAppVersion}
SetupIconFile={#RepoRoot}\Mp3ClipEditor.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional shortcuts:"; Flags: unchecked

[Files]
Source: "{#PublishDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Launch {#MyAppName}"; Flags: nowait postinstall skipifsilent
