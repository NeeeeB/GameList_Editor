unit F_ConfigureNetwork;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes, System.IniFiles,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
   U_Resources, U_gnugettext;

type
   TFrm_Network = class(TForm)
      Lbl_ScreenScraper: TLabel;
      Lbl_ScreenLogin: TLabel;
      Edt_ScreenLogin: TEdit;
      Edt_ScreenPwd: TEdit;
      Edt_ProxyServer: TEdit;
      Edt_ProxyPort: TEdit;
      Edt_ProxyUser: TEdit;
      Edt_ProxyPwd: TEdit;
      Lbl_ScreenPassword: TLabel;
      Lbl_ProxyPassword: TLabel;
      Lbl_ProxyUser: TLabel;
      Lbl_Host: TLabel;
      Lbl_Port: TLabel;
      Chk_Proxy: TCheckBox;
      Btn_Save: TButton;
      Btn_Cancel: TButton;
      procedure Btn_SaveClick(Sender: TObject);
      procedure Btn_CancelClick(Sender: TObject);
      procedure Chk_ProxyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
   private
      procedure SaveToIni;
      procedure EnableControls( aValue: Boolean );
   public
      procedure Execute( const aSSId, aSSPwd, aProxUser, aProxPwd,
                         aProxServer, aProxPort: string; aProxUse: Boolean );
   end;

implementation

{$R *.dfm}

procedure TFrm_Network.Execute( const aSSId, aSSPwd, aProxUser, aProxPwd,
                                aProxServer, aProxPort: string; aProxUse: Boolean );
begin
   Edt_ScreenLogin.Text:= aSSId;
   Edt_ScreenPwd.Text:= aSSPwd;
   Edt_ProxyUser.Text:= aProxUser;
   Edt_ProxyPwd.Text:= aProxPwd;
   Edt_ProxyServer.Text:= aProxServer;
   Edt_ProxyPort.Text:= aProxPort;
   Chk_Proxy.Checked:= aProxUse;
   EnableControls( aProxUse );
   ShowModal;
end;

procedure TFrm_Network.FormCreate(Sender: TObject);
begin
   TranslateComponent( Self );
end;

procedure TFrm_Network.Chk_ProxyClick(Sender: TObject);
begin
   EnableControls( Chk_Proxy.Checked );
end;

procedure TFrm_Network.EnableControls( aValue: Boolean );
begin
   Edt_ProxyPort.Enabled:= aValue;
   Edt_ProxyPwd.Enabled:= aValue;
   Edt_ProxyUser.Enabled:= aValue;
   Edt_ProxyServer.Enabled:= aValue;
   Lbl_Host.Enabled:= aValue;
   Lbl_ProxyUser.Enabled:= aValue;
   Lbl_Port.Enabled:= aValue;
   Lbl_ProxyPassword.Enabled:= aValue;
end;

procedure TFrm_Network.Btn_CancelClick(Sender: TObject);
begin
   Close;
end;

//Enregistrement des paramètres dans le fichier INI
procedure TFrm_Network.SaveToIni;
var
   FileIni: TIniFile;
begin
   FileIni:= TIniFile.Create( ExtractFilePath( Application.ExeName ) + Cst_IniFilePath );
   try
      FileIni.WriteString( Cst_IniOptions, Cst_IniSSUser, Edt_ScreenLogin.Text );
      FileIni.WriteString( Cst_IniOptions, Cst_IniSSPwd, Edt_ScreenPwd.Text );
      FileIni.WriteString( Cst_IniOptions, Cst_IniProxyUser, Edt_ProxyUser.Text );
      FileIni.WriteString( Cst_IniOptions, Cst_IniProxyPwd, Edt_ProxyPwd.Text );
      FileIni.WriteString( Cst_IniOptions, Cst_IniProxyServer, Edt_ProxyServer.Text );
      FileIni.WriteString( Cst_IniOptions, Cst_IniProxyPort, Edt_ProxyPort.Text );
      FileIni.WriteBool( Cst_IniOptions, Cst_IniProxyUse, Chk_Proxy.Checked );
   finally
      FileIni.Free;
   end;
end;

procedure TFrm_Network.Btn_SaveClick(Sender: TObject);
begin
   SaveToIni;
   Close;
end;

end.
