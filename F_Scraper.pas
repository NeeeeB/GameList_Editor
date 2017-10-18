unit F_Scraper;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes, System.NetEncoding,
   System.IOUtils,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg,
   IdHTTP, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdURI,
   IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdException,
   Xml.XMLDoc, Xml.XMLIntf, Xml.xmldom,
   U_Resources, U_Game, U_gnugettext, IdIOHandler, IdIOHandlerSocket;

type
   TFrm_Scraper = class(TForm)
      Ind_HTTP: TIdHTTP;
      IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
      XMLDoc: TXMLDocument;
      procedure FormCreate(Sender: TObject);
      procedure FormClose(Sender: TObject; var Action: TCloseAction);

   private
      FGame: TGame;
      FXmlPath: string;

      function GetGameInfos( const aSysId: string; aGame: TGame ): Boolean;
      function CreatePictures: Boolean;
      function GetFileSize( const aPath: string ): string;

   public
      procedure Execute( const aSysId: string; aGame: TGame );
   end;

implementation

{$R *.dfm}

//à la création de la form
procedure TFrm_Scraper.FormCreate(Sender: TObject);
begin
   FXmlPath:= ExtractFilePath( Application.ExeName ) + Cst_TempXml;
end;

procedure TFrm_Scraper.Execute( const aSysId: string; aGame: TGame );
begin
   FGame:= aGame;
   if GetGameInfos( aSysId, FGame ) then begin
      ShowModal;
   end else
      Close;
end;

//Requête GET pour récupérer le XML des infos du jeu.
function TFrm_Scraper.GetGameInfos( const aSysId: string; aGame: TGame ): Boolean;
var
   Query, Crc32, Size: String;
   Stream: TMemoryStream;
begin
   Result:= False;
   Screen.Cursor:= crHourGlass;
  //Calcul du Crc et de la taille fichier
   Crc32:= aGame.CalculateCrc32( aGame.PhysicalRomPath );
   Size:= GetFileSize( aGame.PhysicalRomPath );

   //construction de la requête API pour le jeu
   Query:= Cst_ScraperAddress + Cst_Category + Cst_ScrapeLogin + Cst_ScrapePwd +
           Cst_DevSoftName + Cst_Output + Cst_Crc + Crc32 + Cst_SystemId + aSysId +
           Cst_RomName + TIdURI.ParamsEncode( aGame.RomName ) + Cst_RomSize + Size;

   //chargement dans un stream pour ne pas corrompre l'encodage
   Stream:= TMemoryStream.Create;
   try
      try
         Ind_HTTP.Get( Query, Stream );
         Stream.Position:= 0;
         XMLDoc.LoadFromStream( Stream );
         XMLDoc.SaveToFile( FXmlPath );
      except
         on E: EIdHTTPProtocolException do begin
            Screen.Cursor:= crDefault;
            ShowMessage('Oops !! An error has occured while reaching the server !!');
            Exit;
         end;
         on E : Exception do begin
            Screen.Cursor:= crDefault;
            Exit;
         end;
      end;
   finally
      Stream.Free;
   end;

   Result:= True;
   Screen.Cursor:= crDefault;
end;

//Crée les images (si possible) depuis le fichier xml récupéré.
function TFrm_Scraper.CreatePictures: Boolean;

   function LoadPicture( aLink: string; aPng: Boolean ): Boolean;
   var
      Stream: TMemoryStream;
      Png: TPNGImage;
      Jpg: TJPEGImage;
   begin
      Result:= False;
      Stream:= TMemoryStream.Create;
      if aPng then Png:= TPngImage.Create
      else Jpg:= TJPEGImage.Create;
      try
         try
            Ind_HTTP.Get( aLink, Stream );
            Stream.Position:= 0;

         except
            on E: EIdHTTPProtocolException do begin
               Screen.Cursor:= crDefault;
               ShowMessage('Oops !! An error has occured while reaching the server !!');
               Exit;
            end;
            on E : Exception do begin
               Screen.Cursor:= crDefault;
               Exit;
            end;
         end;
      finally
         Stream.Free;
         if aPng then Png.Free
         else Jpg.Free;
      end;
      Result:= True;
   end;

var
   Nodes: IXMLNodeList;
   ii: Integer;
begin
   Result:= False;

   //ouverture du fichier xml
   XMLDoc.LoadFromFile( FXmlPath );

   //On trouve le noeud qui nous intéresse
   Nodes:= XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_MediaNode].ChildNodes;
   if ( Nodes.Count = 0 ) then begin
      ShowMessage( 'Looks like there is no media for this game !!' );
      Exit;
   end;

   //Et on boucle pour trouver les noeuds qui nous intéressent
   for ii:= 0 to Pred( Nodes.Count ) do begin
      if ( Nodes[ii].Attributes[Cst_AttType] = Cst_MediaBox2d ) then begin
         if ( Nodes[ii].Attributes['format'] = 'png' ) then
            Result:= LoadPicture( Nodes[ii].Text, True )
         else
            Result:= LoadPicture( Nodes[ii].Text, False );
      end;
   end;

   //si on a pas trouvé de médias on le signale
   if not Result then ShowMessage( 'Looks like there is no media for this game !!' )
end;

//Pour récupérer la taille du fichier du jeu
function TFrm_Scraper.GetFileSize( const aPath: string ): string;
var
   Reader: TFileStream;
begin
   Reader:= TFile.OpenRead( aPath );
   try
      Result:= IntToStr( Reader.Size );
   finally
      Reader.Free;
   end;
end;

//A la fermeture de la form
procedure TFrm_Scraper.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   DeleteFile( FXmlPath );
end;

end.
