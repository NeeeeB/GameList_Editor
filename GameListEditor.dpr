program GameListEditor;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Frm_Editor},
  Vcl.Themes,
  Vcl.Styles,
  MoreInfos in 'MoreInfos.pas' {Frm_MoreInfos},
  About in 'About.pas' {Frm_About},
  Help in 'Help.pas' {Frm_Help},
  ConfigureSSH in 'ConfigureSSH.pas' {Frm_ConfigureSSH},
  gnugettext in 'gnugettext.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Charcoal Dark Slate');
  Application.CreateForm(TFrm_Editor, Frm_Editor);
  Application.Run;
end.
