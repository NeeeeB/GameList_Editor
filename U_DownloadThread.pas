unit U_DownloadThread;

interface

uses
   System.Classes, System.SysUtils,
   Vcl.ExtCtrls, Vcl.Graphics, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage,
   IdIOHandler, IdIOHandlerSocket, IdURI, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
   IdBaseComponent, IdComponent, IdException, IdTCPConnection, IdTCPClient, IdHTTP,
   U_Resources;

type
   TDOwnThread = class( TThread )
   private
      IndyHTTP: TIdHTTP;
      IndySSL: TIdSSLIOHandlerSocketOpenSSL;
      Img: TImage;
      Graph: TGraphic;
      procedure AddPicture;
   protected
      procedure Execute; override;
   public
      Url: string;
      Ext: string;
      constructor Create; reintroduce;
      destructor Destroy; override;
   end;

implementation

uses
   F_Main;

constructor TDOwnThread.Create;
begin
   inherited Create( True );
   IndyHTTP:= TIdHTTP.Create;
   IndySSL:= TIdSSLIOHandlerSocketOpenSSL.Create;
   if Frm_Editor.FProxyUse then begin
      IndyHTTP.ProxyParams.ProxyUsername:= Frm_Editor.FProxyUser;
      IndyHTTP.ProxyParams.ProxyPassword:= Frm_Editor.FProxyPwd;
      IndyHTTP.ProxyParams.ProxyServer:= Frm_Editor.FProxyServer;
      IndyHTTP.ProxyParams.ProxyPort:= StrToInt( Frm_Editor.FProxyPort );
   end else begin
      IndyHTTP.ProxyParams.ProxyUsername:= '';
      IndyHTTP.ProxyParams.ProxyPassword:= '';
      IndyHTTP.ProxyParams.ProxyServer:= '';
      IndyHTTP.ProxyParams.ProxyPort:= 0;
   end;

   IndyHTTP.IOHandler:= IndySSL;
   IndyHTTP.Request.UserAgent:= 'Mozilla/3.0 (compatible; Indy Library)';
   IndyHTTP.Request.Accept:= 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8';

   Img:= TImage.Create( nil );
   Img.AutoSize:= True;
   Img.Center:= True;
   Img.Proportional:= True;
   Img.Visible:= False;

   FreeOnTerminate:= True;
end;

destructor TDOwnThread.Destroy;
begin
   IndyHTTP.Free;
   IndySSL.Free;
   inherited;
end;

procedure TDOwnThread.Execute;
var
   Stream: TBytesStream;
begin
   Stream:= TBytesStream.Create;
   try
      try
         IndyHTTP.Get( Url, Stream );
         if ( Stream.Size = 0 ) then begin
            Frm_Editor.WarnUser( Rst_StreamError );
            Exit;
         end;
         Stream.Position:= 0;
         //on crée le graphic qui va bien en fonction de l'extension
         if ( Ext = Cst_PngExt ) then Graph:= TPngImage.Create
         else Graph:= TJPEGImage.create;
         Graph.LoadFromStream( Stream );
         Img.Picture.Graphic:= Graph;
      except
         //gestion des erreurs de connexion
         on E: EIdHTTPProtocolException do begin
            case E.ErrorCode of
               400: Frm_Editor.WarnUser( Rst_ServerError1 );
               401: Frm_Editor.WarnUser( Rst_ServerError2 );
               403: Frm_Editor.WarnUser( Rst_ServerError3 );
               404: Frm_Editor.WarnUser( Rst_ServerError4 );
               423: Frm_Editor.WarnUser( Rst_ServerError5 );
               426: Frm_Editor.WarnUser( Rst_ServerError6 );
               429: Frm_Editor.WarnUser( Rst_ServerError7 );
            end;
            Exit;
         end;
         on E: EIdException do begin
            Frm_Editor.WarnUser( Rst_ServerError8 );
            Exit;
         end;
      end;
   finally
      Stream.Free;
   end;
   Synchronize( AddPicture );
end;

procedure TDOwnThread.AddPicture;
begin
   Frm_Editor.FImgList.Add( Img );
end;

end.
