program GameListEditor;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Frm_Editor},
  Vcl.Themes,
  Vcl.Styles,
  MoreInfos in 'MoreInfos.pas' {Frm_MoreInfos};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Charcoal Dark Slate');
  Application.CreateForm(TFrm_Editor, Frm_Editor);
  Application.Run;
end.
