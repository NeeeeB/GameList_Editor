unit F_ConfigureSSH;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
   U_gnugettext;

type
   TFrm_ConfigureSSH = class(TForm)
      Lbl_RecalLogin: TLabel;
      Lbl_RecalPwd: TLabel;
      Lbl_RetroPwd: TLabel;
      Lbl_RetroLogin: TLabel;
      Edt_RecalLogin: TEdit;
      Edt_RecalPwd: TEdit;
      Edt_RetroLogin: TEdit;
      Edt_RetroPwd: TEdit;
      Btn_Save: TButton;
      Btn_Cancel: TButton;
      procedure FormShow(Sender: TObject);
      procedure FormCreate(Sender: TObject);
   private
    { Déclarations privées }
   public
      function Execute( var aRecalLogin, aRecalPwd, aRetroLogin, aRetroPwd: string ): Boolean;
   end;

implementation

{$R *.dfm}

//On passe les paramètres en var pour récupérer les changements directement
function TFrm_ConfigureSSH.Execute( var aRecalLogin, aRecalPwd, aRetroLogin, aRetroPwd: string ): Boolean;
begin
   Edt_RecalLogin.Text:= aRecalLogin;
   Edt_RecalPwd.Text:= aRecalPwd;
   Edt_RetroLogin.Text:= aRetroLogin;
   Edt_RetroPwd.Text:= aRetroPwd;

   ShowModal;

   Result:= ( ModalResult = mrOk );

   //si on a cliqué sur Ok, on change les valeurs des paramètres
   //pour renvoyer dans la fenêtre principale
   if Result then begin
      aRecalLogin:= Edt_RecalLogin.Text;
      aRecalPwd:= Edt_RecalPwd.Text;
      aRetroLogin:= Edt_RetroLogin.Text;
      aRetroPwd:= Edt_RetroPwd.Text;
   end;
end;

procedure TFrm_ConfigureSSH.FormCreate(Sender: TObject);
begin
   TranslateComponent( Self );
end;

//à lapparition de la fenêtre on met le focus sur cancel
procedure TFrm_ConfigureSSH.FormShow(Sender: TObject);
begin
   Btn_Cancel.SetFocus;
end;

end.
