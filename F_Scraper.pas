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
   TMediaInfo = class
      FileExt: string;
      FileLink: string;
   end;

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
      FPictureLinks: TObjectList<TMediaInfo>;
      FMaxThreads: Integer;

      procedure DisplayPictures;
      procedure WarnUser( aMessage: string );
      procedure ChangeImage( aImg: TImage );
      procedure ImgDblClick( Sender: TObject );
      procedure ParseXml;

      function GetGameXml( const aSysId: string; aGame: TGame ): Boolean;
      procedure LoadPictures;
      function GetFileSize( const aPath: string ): string;
      function StringToIsoDate( const aDate: string ): string;

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
   FPictureLinks:= TObjectList<TMediaInfo>.Create;
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

   if GetGameXml( aSysId, FGame ) then begin
      ParseXml;
      if ( FPictureLinks.Count > 0 ) then begin
         LoadPictures;
         DisplayPictures;
      end;
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

   function CreateGenreDict( aNodeList: IXMLNodeList; aAttId, aAttLang: string ): TObjectDictionary<string, TDictionary<string, string>>;
   var
      ii: Integer;
      id: string;
      List: TDictionary<string, string>;
   begin
      Result:= TObjectDictionary<string, TDictionary<string, string>>.Create( [doOwnsValues] );
      List:= TDictionary<string, string>.Create;
      id:= aNodeList[0].Attributes[aAttId];
      for ii:= 0 to Pred( aNodeList.Count ) do begin
         if ( aNodeList[ii].Attributes[aAttId] = id ) then
            List.Add( aNodeList[ii].Attributes[aAttLang], aNodeList[ii].Text )
         else begin
            Result.Add( id, List );
            id:= aNodeList[ii].Attributes[aAttId];
            List:= TDictionary<string, string>.Create;
            List.Add( aNodeList[ii].Attributes[aAttLang], aNodeList[ii].Text );
         end;
      end;
      Result.Add( id, List );
   end;

var
   Nodes: IXMLNodeList;
   ii: Integer;
   List: TStringList;
   Media: TMediaInfo;
begin
   //ouverture du fichier xml
   XMLDoc.LoadFromFile( FXmlPath );

   //On trouve le noeud qui nous intéresse
   Nodes:= XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_NamesNode].ChildNodes;
   if Assigned( Nodes ) then FInfosList.AddObject( Cst_NamesNode, CreateDict( Nodes, Cst_AttRegion ) );

   Nodes:= XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_RegionsNode].ChildNodes;
   if Assigned( Nodes ) then begin
      List:= TStringList.Create;
      for ii:= 0 to Pred( Nodes.Count ) do begin
         List.Add( Nodes[ii].Text );
      end;
      FInfosList.AddObject( Cst_RegionsNode, List );
   end;

   Nodes:= XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_SynopNode].ChildNodes;
   if Assigned( Nodes ) then FInfosList.AddObject( Cst_SynopNode, CreateDict( Nodes, Cst_AttLang ) );

   Nodes:= XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_DateNode].ChildNodes;
   if Assigned( Nodes ) then FInfosList.AddObject( Cst_DateNode, CreateDict( Nodes, Cst_AttRegion ) );

   Nodes:= XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_GenreNode].ChildNodes;
   if Assigned( Nodes ) then FInfosList.AddObject( Cst_GenreNode, CreateGenreDict( Nodes, Cst_AttId, Cst_AttLang ) );

   FInfosList.Add( XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_EditNode].Text );

   FInfosList.Add( XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_DevNode].Text );

   FInfosList.Add( XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_PlayersNode].Text );

   FInfosList.Add( XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_NoteNode].Text );

   Nodes:= XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_GameNode].ChildNodes[Cst_MediaNode].ChildNodes;
   if Assigned( Nodes ) and ( Nodes.Count > 0 ) then begin
      //Et on boucle pour trouver les noeuds qui nous intéressent
      for ii:= 0 to Pred( Nodes.Count ) do begin
         //C'est moche mais ça évite le "ne répond pas"
         Application.ProcessMessages;

         if ( Nodes[ii].Attributes[Cst_AttType] = Cst_MediaBox2d ) or
            ( Nodes[ii].Attributes[Cst_AttType] = Cst_MediaScreenShot ) or
            ( Nodes[ii].Attributes[Cst_AttType] = Cst_MediaSsTitle ) or
            ( Nodes[ii].Attributes[Cst_AttType] = Cst_MediaBox3d ) or
            ( Nodes[ii].Attributes[Cst_AttType] = Cst_MediaMix1 ) or
            ( Nodes[ii].Attributes[Cst_AttType] = Cst_MediaMix2 ) or
            ( Nodes[ii].Attributes[Cst_AttType] = Cst_MediaArcadeBox1 ) or
            ( Nodes[ii].Attributes[Cst_AttType] = Cst_MediaWheel ) then begin
            Media:= TMediaInfo.Create;
            Media.FileExt:= Nodes[ii].Attributes[Cst_AttFormat];
            Media.FileLink:= Nodes[ii].Text;
            FPictureLinks.Add( Media );
         end;
      end;
   end;

   if not TryStrToInt( XMLDoc.ChildNodes[Cst_DataNode].ChildNodes[Cst_UserNode].ChildNodes[Cst_ThreadNode].Text, FMaxThreads ) then
      FMaxThreads:= 1;
end;

//Crée les images depuis la liste globale des liens.
procedure TFrm_Scraper.LoadPictures;

   procedure CreateImage( aGraph: TGraphic );
   var
      Img: TImage;
   begin
      Img:= TImage.Create( Scl_Games );
      Img.AutoSize:= True;
      Img.Center:= True;
      Img.Proportional:= True;
      Img.Visible:= False;
      Img.Picture.Graphic:= aGraph;
      FImgList.Add( Img );
   end;

var
   Stream: TMemoryStream;
   Query: string;
   Media: TMediaInfo;
   Graph: TGraphic;
begin
   for Media in FPictureLinks do begin
      //C'est moche mais ça évite le "ne répond pas"
      Application.ProcessMessages;

      Query:= Media.FileLink;
      Stream:= TMemoryStream.Create;
      try
         try
            Ind_HTTP.Get( Query, Stream );
            if ( Stream.Size = 0 ) then begin
               WarnUser( Rst_StreamError );
               Continue;
            end;
            Stream.Position:= 0;

            //on crée le graphic qui va bien en fonction de l'extension
            if ( Media.FileExt = Cst_PngExt ) then Graph:= TPngImage.Create
            else Graph:= TJPEGImage.create;

            Graph.LoadFromStream( Stream );
            CreateImage( Graph );

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
               Continue;
            end;
            on E: EIdException do begin
               WarnUser( Rst_ServerError8 );
               Continue;
            end;
         end;
      finally
         Stream.Free;
      end;
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

//Renvoie une date format Iso pour sauvegarde dans XML
function TFrm_Scraper.StringToIsoDate( const aDate: string ): string;
var
   FullStr, Day, Month, Year: string;
begin
   FullStr:= aDate;
   Result:= '';

   //si la chaine fait 4 caractères de long
   if ( Length( FullStr) = 4 ) then
      Result:= FullStr + Cst_DateLongFill + Cst_DateSuffix;

   //si la chaine fait 7 caractères de long
   if ( Length( FullStr) = 7 ) then begin
      Month:= Copy( FullStr, 6, 2 );
      Year:= Copy( FullStr, 1, 4 );
      Result:= Year + Month + Cst_DateShortFill + Cst_DateSuffix;
   end;

   //si la chaine fait 10 caractères de long
   if ( Length( FullStr) = 10 ) then begin
      Day:= Copy( FullStr, 9, 2 );
      Month:= Copy( FullStr, 6, 2 );
      Year:= Copy( FullStr, 1, 4 );
      Result:= Year + Month + Day + Cst_DateSuffix;
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
   FPictureLinks.Free;
end;

end.
