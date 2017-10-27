unit F_Scraper;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes, System.NetEncoding,
   System.IOUtils, System.Generics.Collections,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage,
   Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.StdCtrls,
   IdHTTP, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdURI,
   IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdException, IdIOHandler, IdIOHandlerSocket,
   Xml.XMLDoc, Xml.XMLIntf, Xml.xmldom,
   U_Resources, U_Game, U_gnugettext, F_SplashLoading;

type
   TFrm_Scraper = class(TForm)
      Pnl_Back: TPanel;
      Ind_HTTP: TIdHTTP;
      IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
      XMLDoc: TXMLDocument;
      Pnl_Top: TPanel;
      Pnl_Bottom: TPanel;
      Scl_Games: TScrollBox;
      Btn_Close: TButton;
      Lbl_Instructions: TLabel;
      Img_ScreenScraper: TImage;

      procedure FormCreate(Sender: TObject);
      procedure Btn_CloseClick(Sender: TObject);
      procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
                MousePos: TPoint; var Handled: Boolean);
      procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
                MousePos: TPoint; var Handled: Boolean);
      procedure FormDestroy(Sender: TObject);


   private
      FGame: TGame;
      FXmlPath: string;
      FRootPath: string;
      FCurrentFolder: string;
      FImageFolder: string;
      FXmlImageFolderPath: string;
      FSSLogin, FSSPwd, FProxyServer, FProxyUser,
      FProxyPwd, FProxyPort: string;
      FProxyUse: Boolean;
      FImgList: TObjectList<TImage>;
      FInfosList: TStringList;

      procedure DisplayPictures;
      procedure WarnUser( aMessage: string );
      procedure ChangeImage( aImg: TImage );
      procedure ImgDblClick( Sender: TObject );
      procedure ParseXml;

      function GetGameXml( const aSysId: string; aGame: TGame ): Boolean;
      function LoadPictures: Boolean;
      function GetFileSize( const aPath: string ): string;

   public
      procedure Execute( const aSysId, aRootPath, aCurrentFolder, aImageFolder,
                         aXmlImageFolderPath: string; aGame: TGame; aList: TStringList;
                         aProxyUse: Boolean );
   end;

implementation

{$R *.dfm}

//à la création de la form
procedure TFrm_Scraper.FormCreate(Sender: TObject);
begin
   FXmlPath:= ExtractFilePath( Application.ExeName ) + Cst_TempXml;
   FImgList:= TObjectList<TImage>.Create;
   FInfosList:= TStringList.Create( True );
   TranslateComponent( Self );
end;

procedure TFrm_Scraper.Execute( const aSysId, aRootPath, aCurrentFolder, aImageFolder,
                                aXmlImageFolderPath: string; aGame: TGame; aList: TStringList;
                                aProxyUse: Boolean );
begin
   Screen.Cursor:= crHourGlass;
   FGame:= aGame;
   FRootPath:= aRootPath;
   FCurrentFolder:= aCurrentFolder;
   FImageFolder:= aImageFolder;
   FXmlImageFolderPath:= aXmlImageFolderPath;

   FSSLogin:= aList.Strings[0];
   FSSPwd:= aList.Strings[1];
   FProxyUser:= aList.Strings[2];
   FProxyPwd:= aList.Strings[3];
   FProxyServer:= aList.Strings[4];
   if aList.Strings[5].IsEmpty then FProxyPort:= '0'
   else FProxyPort:= aList.Strings[5];
   FProxyUse:= aProxyUse;

   //si proxy, on le renseigne
   if FProxyUse then begin
      Ind_HTTP.ProxyParams.ProxyUsername:= FProxyUser;
      Ind_HTTP.ProxyParams.ProxyPassword:= FProxyPwd;
      Ind_HTTP.ProxyParams.ProxyServer:= FProxyServer;
      Ind_HTTP.ProxyParams.ProxyPort:= StrToInt( FProxyPort );
   end else begin
      Ind_HTTP.ProxyParams.ProxyUsername:= '';
      Ind_HTTP.ProxyParams.ProxyPassword:= '';
      Ind_HTTP.ProxyParams.ProxyServer:= '';
      Ind_HTTP.ProxyParams.ProxyPort:= 0;
   end;

   //Splash loading
   FrmSplash.Show;
   FrmSplash.Refresh;

   if GetGameXml( aSysId, FGame ) and LoadPictures then begin
      ParseXml;
      DisplayPictures;
      Screen.Cursor:= crDefault;
      FrmSplash.Close;
      ShowModal;
   end;
end;

//Requête GET pour récupérer le XML des infos du jeu.
function TFrm_Scraper.GetGameXml( const aSysId: string; aGame: TGame ): Boolean;
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
           Cst_DevSoftName + Cst_Output;

   if ( not FSSLogin.IsEmpty ) and ( not FSSPwd.IsEmpty ) then
      Query:= Query + Cst_SSId + FSSLogin + Cst_SSPwd + FSSPwd;

   Query:= Query + Cst_Crc + Crc32 + Cst_SystemId + aSysId +
           Cst_RomName + TIdURI.ParamsEncode( aGame.RomName ) + Cst_RomSize + Size;

   //chargement dans un stream pour ne pas corrompre l'encodage
   Stream:= TMemoryStream.Create;
   try
      try
         Ind_HTTP.Get( Query, Stream );
         if ( Stream.Size = 0 ) then begin
            WarnUser( Rst_StreamError );
            Exit;
         end;
         Stream.Position:= 0;
         XMLDoc.LoadFromStream( Stream );
         XMLDoc.SaveToFile( FXmlPath );
      except
         //gestion des erreurs de connexion
         on E: EIdHTTPProtocolException do begin
            case E.ErrorCode of
               400: WarnUser( Rst_ServerError1 );
               401: WarnUser( Rst_ServerError2 );
               403: WarnUser( Rst_ServerError3 );
               404: WarnUser( Rst_ServerError4 );
               423: WarnUser( Rst_ServerError5 );
               426: WarnUser( Rst_ServerError6 );
               429: WarnUser( Rst_ServerError7 );
            end;
            Exit;
         end;
         on E: EIdException do begin
            WarnUser( Rst_ServerError8 );
            Exit;
         end;
      end;
   finally
      Stream.Free;
   end;

   Result:= True;
end;

//parsing du Xml pour récupérer tout ce qui est description, région, nombre joueurs etc...
procedure TFrm_Scraper.ParseXml;

   function CreateDict( aNodeList: IXMLNodeList; aAttName: string ): TDictionary<string, string>;
   var
      ii: Integer;
   begin
      Result:= TDictionary<string, string>.Create;
      for ii:= 0 to Pred( aNodeList.Count ) do begin
         Result.Add( aNodeList[ii].Attributes[aAttName], aNodeList[ii].Text );
      end;
   end;

var
   Nodes: IXMLNodeList;
   ii: Integer;
   List: TStringList;
begin
   //ouverture du fichier xml
   XMLDoc.LoadFromFile( FXmlPath );

   //On trouve le noeud qui nous intéresse
   Nodes:= XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_NamesNode].ChildNodes;
   FInfosList.AddObject( Cst_NamesNode, CreateDict( Nodes, Cst_AttRegion ) );

   Nodes:= XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_RegionsNode].ChildNodes;
   List:= TStringList.Create;
   for ii:= 0 to Pred( Nodes.Count ) do begin
      List.Add( Nodes[ii].Text );
   end;
   FInfosList.AddObject( Cst_RegionsNode, List );

   Nodes:= XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_SynopNode].ChildNodes;
   FInfosList.AddObject( Cst_SynopNode, CreateDict( Nodes, Cst_AttLang ) );

   Nodes:= XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_DateNode].ChildNodes;
   FInfosList.AddObject( Cst_DateNode, CreateDict( Nodes, Cst_AttRegion ) );

   Nodes:= XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_GenreNode].ChildNodes;
   FInfosList.AddObject( Cst_GenreNode, CreateDict( Nodes, Cst_AttLang ) );

   FInfosList.Add( XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_EditNode].Text );

   FInfosList.Add( XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_DevNode].Text );

   FInfosList.Add( XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_PlayersNode].Text );

   FInfosList.Add( XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_NoteNode].Text );

end;

//Crée les images (si possible) depuis le fichier xml récupéré.
function TFrm_Scraper.LoadPictures: Boolean;

   procedure LoadPng( aStream: TMemoryStream );
   var
      Png: TPngImage;
      Img: TImage;
   begin
      Png:= TPngImage.Create;
      Img:= TImage.Create( Scl_Games );
      Img.AutoSize:= True;
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
      Img:= TImage.Create( Scl_Games );
      Img.AutoSize:= True;
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
      WarnUser( Rst_NoMediaFound );
      Exit;
   end;

   //Et on boucle pour trouver les noeuds qui nous intéressent
   for ii:= 0 to Pred( Nodes.Count ) do begin
      //C'est moche mais ça évite le "na répond pas"
      Application.ProcessMessages;

      if ( Nodes[ii].Attributes[Cst_AttType] = Cst_MediaBox2d ) or
         ( Nodes[ii].Attributes[Cst_AttType] = Cst_MediaScreenShot ) or
         ( Nodes[ii].Attributes[Cst_AttType] = Cst_MediaSsTitle ) or
         ( Nodes[ii].Attributes[Cst_AttType] = Cst_MediaBox3d ) or
         ( Nodes[ii].Attributes[Cst_AttType] = Cst_MediaMix1 ) or
         ( Nodes[ii].Attributes[Cst_AttType] = Cst_MediaMix2 ) or
         ( Nodes[ii].Attributes[Cst_AttType] = Cst_MediaArcadeBox1 ) or
         ( Nodes[ii].Attributes[Cst_AttType] = Cst_MediaWheel ) then begin
         Query:= Nodes[ii].Text;
         Stream:= TMemoryStream.Create;
         try
            try
               Ind_HTTP.Get( Query, Stream );
               if ( Stream.Size = 0 ) then begin
                  WarnUser( Rst_StreamError );
                  Exit;
               end;
               Stream.Position:= 0;
               if ( Nodes[ii].Attributes[Cst_AttFormat] = Cst_PngExt ) then
                  LoadPng( Stream )
               else LoadJpg( Stream );
            except
               //gestion des erreurs de connexion
               on E: EIdHTTPProtocolException do begin
                  case E.ErrorCode of
                     400: WarnUser( Rst_ServerError1 );
                     401: WarnUser( Rst_ServerError2 );
                     403: WarnUser( Rst_ServerError3 );
                     404: WarnUser( Rst_ServerError4 );
                     423: WarnUser( Rst_ServerError5 );
                     426: WarnUser( Rst_ServerError6 );
                     429: WarnUser( Rst_ServerError7 );
                  end;
                  Exit;
               end;
               on E: EIdException do begin
                  WarnUser( Rst_ServerError8 );
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
      WarnUser( Rst_NoMediaFound );
   end;
end;

//Pour prévenir le user si problème ou pas de médias trouvés
procedure TFrm_Scraper.WarnUser( aMessage: string );
begin
   FrmSplash.Close;
   Screen.Cursor:= crDefault;
   ShowMessage( aMessage );
end;

//Affichage des images récupérées
procedure TFrm_Scraper.DisplayPictures;
var
   ii, Left, Count: Integer;
begin
   Count:= FImgList.Count;
   case Count of
      1: Left:= 325;
      2: Left:= 170;
      else Left:= 50;
   end;

   for ii:= 0 to Pred( Count ) do begin
      FImgList.Items[ii].Parent:= Scl_Games;
      FImgList.Items[ii].Top:= 25;
      FImgList.Items[ii].Left:= Left;
      FImgList.Items[ii].Constraints.MinHeight:= 300;
      FImgList.Items[ii].Constraints.MaxHeight:= 300;
      FImgList.Items[ii].Constraints.MaxWidth:= 300;
      FImgList.Items[ii].OnDblClick:= ImgDblClick;
      FImgList.Items[ii].Center:= True;
      FImgList.Items[ii].Visible:= True;
      Left:= Left + FImgList.Items[ii].Width + 50;
   end;
end;

procedure TFrm_Scraper.ImgDblClick( Sender: TObject );
begin
   ChangeImage( ( Sender as TImage ) );
end;

//Remplace l'image actuelle du jeu (par autre ou défaut).
procedure TFrm_Scraper.ChangeImage( aImg: TImage );
var
   _ImageLink: string;
   _Node: IXMLNode;
   _NodeAdded: Boolean;
begin
   _NodeAdded:= False;
   Screen.Cursor:= crHourGlass;

   //on sauvegarde l'image dans le dossier avec les autres !!
   // et on ajoute le chemin dans le xml
   aImg.Picture.SaveToFile( FRootPath + FCurrentFolder + FImageFolder +
                            '\' + FGame.RomNameWoExt + Cst_ImageSuffixPng );

   //On ouvre le fichier xml
   XMLDoc.LoadFromFile( FRootPath + FCurrentFolder + Cst_GameListFileName );

   //On récupère le premier noeud "game"
   _Node := XMLDoc.DocumentElement.ChildNodes.FindNode( Cst_Game );

   //Et on boucle pour trouver le noeud avec le bon Id
   repeat
      if ( _Node.ChildNodes.Nodes[Cst_Path].Text = FGame.RomPath ) then Break;
      _Node := _Node.NextSibling;
   until not Assigned( _Node );

   //on écrit le chemin vers l'image
   _ImageLink:= FXmlImageFolderPath + FGame.RomNameWoExt + Cst_ImageSuffixPng;

   if not Assigned( _Node.ChildNodes.FindNode( Cst_ImageLink ) ) then begin
      _Node.AddChild( Cst_ImageLink );
      _NodeAdded:= True;
   end;
   _Node.ChildNodes.Nodes[Cst_ImageLink].Text:= _ImageLink;

   //On enregistre le fichier.
   if _NodeAdded then begin
      XMLDoc.XML.Text:= Xml.Xmldoc.FormatXMLData( XMLDoc.XML.Text );
      XMLDoc.Active:= True;
   end;
   XMLDoc.SaveToFile( FRootPath + FCurrentFolder + Cst_GameListFileName );
   XMLDoc.Active:= False;

   //Et enfin on met à jour l'objet TGame associé
   FGame.ImagePath:= _ImageLink;
   FGame.PhysicalImagePath:= FRootPath + FCurrentFolder +
                             IncludeTrailingPathDelimiter( FImageFolder ) +
                             FGame.RomNameWoExt + Cst_ImageSuffixPng;
   Screen.Cursor:= crDefault;
   Close;
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

 //scroll horizontal avec souris
procedure TFrm_Scraper.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
          MousePos: TPoint; var Handled: Boolean);
begin
   Scl_Games.Perform(WM_HSCROLL,1,0);
end;

 //scroll horizontal avec souris
procedure TFrm_Scraper.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
   Scl_Games.Perform(WM_HSCROLL,0,0);
end;

//au click sur le bouton close
procedure TFrm_Scraper.Btn_CloseClick(Sender: TObject);
begin
   Close;
end;

//A la Destruction de la form
procedure TFrm_Scraper.FormDestroy(Sender: TObject);
begin
   DeleteFile( FXmlPath );
   FImgList.Free;
   FInfosList.Free;
end;

end.
