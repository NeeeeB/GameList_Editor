unit F_Scraper;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes, System.NetEncoding,
   System.IOUtils, System.Generics.Collections,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage,
   Vcl.Imaging.jpeg, Vcl.ExtCtrls,
   IdHTTP, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdURI,
   IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdException, IdIOHandler, IdIOHandlerSocket,
   Xml.XMLDoc, Xml.XMLIntf, Xml.xmldom,
   U_Resources, U_Game, U_gnugettext;

type
   TFrm_Scraper = class(TForm)
      Pnl_Back: TPanel;
      Ind_HTTP: TIdHTTP;
      IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
      XMLDoc: TXMLDocument;

      procedure FormCreate(Sender: TObject);
      procedure FormClose(Sender: TObject; var Action: TCloseAction);

   private
      FGame: TGame;
      FXmlPath: string;
      FImgList: TObjectList<TImage>;

      procedure DisplayPictures;

      function GetGameInfos( const aSysId: string; aGame: TGame ): Boolean;
      function LoadPictures: Boolean;
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
   FImgList:= TObjectList<TImage>.Create;
end;

procedure TFrm_Scraper.Execute( const aSysId: string; aGame: TGame );
begin
   Screen.Cursor:= crHourGlass;
   FGame:= aGame;
   if GetGameInfos( aSysId, FGame ) and LoadPictures then begin
      DisplayPictures;
      Screen.Cursor:= crDefault;
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
            ShowMessage('Oops !! An error has occured while reading the stream !!');
            Exit;
         end;
      end;
   finally
      Stream.Free;
   end;

   Result:= True;
end;

//Crée les images (si possible) depuis le fichier xml récupéré.
function TFrm_Scraper.LoadPictures: Boolean;

   procedure LoadPng( aStream: TMemoryStream );
   var
      Png: TPngImage;
      Img: TImage;
   begin
      Png:= TPngImage.Create;
      Img:= TImage.Create( Pnl_Back );
      Img.Width:= 300;
      Img.Height:= 300;
      Img.Center:= True;
      Img.Proportional:= True;
      Img.Visible:= False;
      try
         Png.LoadFromStream( aStream );
         Img.Picture.Graphic:= Png;
         FImgList.Add( Img );
      finally
         Png.Free;
      end;
   end;

   procedure LoadJpg( aStream: TMemoryStream );
   var
      Jpg: TJPEGImage;
      Img: TImage;
   begin
      Jpg:= TJPEGImage.Create;
      Img:= TImage.Create( Pnl_Back );
      Img.Width:= 300;
      Img.Height:= 300;
      Img.Center:= True;
      Img.Proportional:= True;
      Img.Visible:= False;
      try
         Jpg.LoadFromStream( aStream );
         Img.Picture.Graphic:= Jpg;
         FImgList.Add( Img );
      finally
         Jpg.Free;
      end;
   end;

var
   Nodes: IXMLNodeList;
   ii: Integer;
   Stream: TMemoryStream;
   Query: string;
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
         Query:= Nodes[ii].Text;
         Stream:= TMemoryStream.Create;
         try
            try
               Ind_HTTP.Get( Query, Stream );
               Stream.Position:= 0;
               if ( Nodes[ii].Attributes['format'] = 'png' ) then
                  LoadPng( Stream )
               else LoadJpg( Stream );
            except
               on E: EIdHTTPProtocolException do begin
                  Screen.Cursor:= crDefault;
                  ShowMessage('Oops !! An error has occured while reaching the server !!');
                  Exit;
               end;
               on E : Exception do begin
                  Screen.Cursor:= crDefault;
                  ShowMessage('Oops !! An error has occured while reading the stream !!');
                  Exit;
               end;
            end;
         finally
            Stream.Free;
         end;
         Result:= True;
      end;
   end;

   //si on a pas trouvé de médias on le signale
   if not Result then begin
      Screen.Cursor:= crDefault;
      ShowMessage( 'Looks like there is no media for this game !!' );
   end;
end;

//Affichage des images récupérées
procedure TFrm_Scraper.DisplayPictures;
var
   ii, Left, Count: Integer;
begin
   Left:= 10;
   Count:= FImgList.Count;
   for ii:= 0 to Pred( Count ) do begin
      FImgList.Items[ii].Parent:= Pnl_Back;
      FImgList.Items[ii].Top:= 10;
      FImgList.Items[ii].Left:= Left;
      FImgList.Items[ii].Width:= 100;
      FImgList.Items[ii].Height:= 100;
      FImgList.Items[ii].Visible:= True;
      Left:= Left + 110;
   end;
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
   FImgList.Free;
end;

end.
