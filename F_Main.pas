unit F_Main;

interface

uses
   Winapi.Windows, Winapi.Messages, Winapi.ShellAPI,
   System.SysUtils, System.Variants, System.Classes, System.IniFiles, System.Generics.Collections,
   System.RegularExpressions, System.UITypes, System.ImageList, System.StrUtils,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Styles, Vcl.Themes, Vcl.ImgList,
   Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls,
   Xml.omnixmldom, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, Xml.Win.msxmldom,
   F_MoreInfos, F_About, F_Help, F_ConfigureSSH, F_Scraper, U_gnugettext, U_Resources, U_Game,
   F_ConfigureNetwork;

type
   TFrm_Editor = class(TForm)
      XMLDoc: TXMLDocument;
      OpenDialog: TFileOpenDialog;
      Cbx_Systems: TComboBox;
      Lbx_Games: TListBox;
      Lbl_NbGamesFound: TLabel;
      Lbl_SelectSystem: TLabel;
      Mmo_Description: TMemo;
      Edt_Rating: TEdit;
      Edt_ReleaseDate: TEdit;
      Edt_Developer: TEdit;
      Edt_Publisher: TEdit;
      Edt_Genre: TEdit;
      Edt_NbPlayers: TEdit;
      Img_Game: TImage;
      Img_BackGround: TImage;
      Edt_Name: TEdit;
      MainMenu: TMainMenu;
      Mnu_File: TMenuItem;
      Mnu_Choosefolder: TMenuItem;
      Mnu_Quit: TMenuItem;
      Mnu_Actions: TMenuItem;
      Btn_SaveChanges: TButton;
      OpenFile: TOpenDialog;
      Btn_ChangeImage: TButton;
      Btn_SetDefaultPicture: TButton;
      Btn_ChangeAll: TButton;
      Cbx_Filter: TComboBox;
      Lbl_Filter: TLabel;
      Img_Logo: TImage;
      Img_System: TImage;
      Edt_Region: TEdit;
      Btn_MoreInfos: TButton;
      Mnu_Options: TMenuItem;
      Mnu_About: TMenuItem;
      Mnu_GodMode: TMenuItem;
      Mnu_AutoHash: TMenuItem;
      Mnu_System: TMenuItem;
      Mnu_Game: TMenuItem;
      Mnu_LowerCase: TMenuItem;
      Mnu_UpperCase: TMenuItem;
      Mnu_GaLowerCase: TMenuItem;
      Mnu_GaUpperCase: TMenuItem;
      Mnu_RemoveRegion: TMenuItem;
      Btn_Delete: TButton;
      Img_List: TImageList;
      Mnu_DeleteWoPrompt: TMenuItem;
      ProgressBar: TProgressBar;
      Btn_RemovePicture: TButton;
      Mnu_Theme: TMenuItem;
      Mnu_Theme1: TMenuItem;
      Mnu_Theme2: TMenuItem;
      Mnu_Theme3: TMenuItem;
      Mnu_Theme4: TMenuItem;
      Mnu_Theme5: TMenuItem;
      Mnu_Theme6: TMenuItem;
      Mnu_Theme7: TMenuItem;
      Mnu_Theme8: TMenuItem;
      Mnu_Theme9: TMenuItem;
      Mnu_Theme10: TMenuItem;
      Mnu_Theme11: TMenuItem;
      Mnu_Theme12: TMenuItem;
      Mnu_Theme13: TMenuItem;
      Mnu_Theme14: TMenuItem;
      Mnu_Theme15: TMenuItem;
      Mnu_Theme16: TMenuItem;
      N1: TMenuItem;
      Mnu_Help: TMenuItem;
      Mnu_Genesis: TMenuItem;
      Mnu_ShowTips: TMenuItem;
      Mnu_PiPrompts: TMenuItem;
      Mnu_SSH: TMenuItem;
      Mnu_ConfigSSH: TMenuItem;
      N3: TMenuItem;
      Cbx_Hidden: TComboBox;
      Cbx_Favorite: TComboBox;
      Mnu_Theme17: TMenuItem;
      N4: TMenuItem;
      Mnu_Language: TMenuItem;
      Mnu_Lang1: TMenuItem;
      Mnu_Lang2: TMenuItem;
      Edt_RomPath: TEdit;
      Mnu_Lang3: TMenuItem;
      Edt_Search: TEdit;
      Lbl_Search: TLabel;
      Mnu_DeleteOrphans: TMenuItem;
      Mnu_Lang4: TMenuItem;
      Mnu_Lang5: TMenuItem;
      Mnu_General: TMenuItem;
      Mnu_DeleteDuplicates: TMenuItem;
      Btn_Scrape: TButton;
      Lbl_Name: TLabel;
      Lbl_Region: TLabel;
      Lbl_Date: TLabel;
      Lbl_Players: TLabel;
      Lbl_Rating: TLabel;
      Lbl_Hidden: TLabel;
      Lbl_Favorite: TLabel;
      Lbl_Publisher: TLabel;
      Lbl_Developer: TLabel;
      Lbl_Genre: TLabel;
      Lbl_Description: TLabel;
      Mnu_NetWork: TMenuItem;
      N2: TMenuItem;
      Mnu_ConfigureNetwork: TMenuItem;

      procedure FormCreate(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure Cbx_SystemsChange(Sender: TObject);
      procedure Lbx_GamesClick(Sender: TObject);
      procedure Mnu_QuitClick(Sender: TObject);
      procedure Mnu_ChoosefolderClick(Sender: TObject);
      procedure ChkClick(Sender: TObject);
      procedure Btn_SaveChangesClick(Sender: TObject);
      procedure FieldChange(Sender: TObject);
      procedure Mmo_DescriptionKeyPress(Sender: TObject; var Key: Char);
      procedure Btn_ChangeImageClick(Sender: TObject);
      procedure Btn_SetDefaultPictureClick(Sender: TObject);
      procedure Cbx_FilterChange(Sender: TObject);
      procedure Btn_ChangeAllClick(Sender: TObject);
      procedure Btn_MoreInfosClick(Sender: TObject);
      procedure Mnu_GodModeClick(Sender: TObject);
      procedure Mnu_AutoHashClick(Sender: TObject);
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
      procedure Btn_DeleteClick(Sender: TObject);
      procedure Mnu_DeleteWoPromptClick(Sender: TObject);
      procedure ChangeCaseClick(Sender: TObject);
      procedure ChangeCaseGameClick(Sender: TObject);
      procedure FormShow(Sender: TObject);
      procedure Btn_RemovePictureClick(Sender: TObject);
      procedure Mnu_AboutClick(Sender: TObject);
      procedure Mnu_RemoveRegionClick(Sender: TObject);
      procedure Mnu_ThemeClick(Sender: TObject);
      procedure Mnu_GenesisClick(Sender: TObject);
      procedure Mnu_HelpClick(Sender: TObject);
      procedure Mnu_ShowTipsClick(Sender: TObject);
      procedure Mnu_PiPromptsClick(Sender: TObject);
      procedure Mnu_ConfigSSHClick(Sender: TObject);
      procedure Mnu_LangClick(Sender: TObject);
      procedure Edt_SearchChange(Sender: TObject);
      procedure Mnu_DeleteOrphansClick(Sender: TObject);
      procedure Mnu_DeleteDuplicatesClick(Sender: TObject);
      procedure Btn_ScrapeClick(Sender: TObject);
      procedure Mnu_ConfigureNetworkClick(Sender: TObject);

   private

      FThemeNumber, FLanguage: Integer;
      FRootPath: string;
      FCurrentFolder: string;
      FImageFolder: string;
      FXmlImageFolderPath: string;
      FIsLoading: Boolean;
      FGodMode, FAutoHash, FDelWoPrompt, FGenesisLogo,
      FShowTips, FFolderIsOnPi, FPiPrompts, FSysIsRecal,
      FPiLoadedOnce: Boolean;
      FRecalLogin, FRecalPwd, FRetroLogin, FRetroPwd: string;
      FSSLogin, FSSPwd, FProxyServer, FProxyUser,
      FProxyPwd, FProxyPort: string;
      FProxyUse: Boolean;
      GSystemList: TObjectDictionary<string,TObjectList<TGame>>;

      procedure LoadFromIni;
      procedure SaveToIni;
      procedure BuildSystemsList;
      procedure LoadGamesList( const aSystem: string );
      procedure LoadGame( aGame: TGame );
      procedure ClearAllFields;
      procedure SaveChangesToGamelist;
      procedure EnableControls( aValue: Boolean );
      procedure CheckIfChangesToSave;
      procedure ChangeImage( const aPath: string; aGame: TGame );
      procedure LoadSystemLogo( aPictureName: string );
      procedure DeleteGame( aGame: TGame );
      procedure DeleteGamePicture;
      procedure CheckMenuItem( aNumber: Integer; aLang: Boolean = False );
      procedure RemoveRegionFromGameName( aGame: TGame; aStartPos: Integer );
      procedure ConvertFieldsCase( aGame: TGame; aUnique: Boolean = False;
                                   aUp: Boolean = False );
      procedure StopOrStartES( aStop, aRecal: Boolean );
      procedure DeleteDuplicates( aSystem: string );
      procedure ReloadIni;

      function getSystemKind: TSystemKind;
      function getCurrentFolderName: string;
      function GetCurrentLogoName: string;
      function GetCurrentSystemId: string;
      function BuildGamesList( const aPathToFile: string ): TObjectList<TGame>;
      function FormatDateFromString( const aDate: string; aIso: Boolean = False ): string;
      function GetThemeEnum( aNumber: Integer ): TThemeName;
      function GetLangEnum( aNumber: Integer ): TLangName;
      function GetPhysicalRomPath( const aRomPath: string ): string;
      function GetPhysicalImagePath( const aImagePath: string ): string;
      function MyMessageDlg( const Msg: string; DlgTypt: TmsgDlgType; button: TMsgDlgButtons;
                            Caption: array of string; dlgcaption: string ): Integer;

   end;

var
   Frm_Editor: TFrm_Editor;

implementation

{$R *.dfm}

function TFrm_Editor.GetPhysicalRomPath( const aRomPath: string ): string;
var
   _Pos: Integer;
begin
   _Pos:= Pos( '/', aRomPath );
   Result:= FRootPath + FCurrentFolder + Copy( aRomPath, Succ( _Pos ), ( aRomPath.Length - _Pos ) );
   Result:= StringReplace( Result, '/', '\', [rfReplaceAll] );
end;

function TFrm_Editor.GetPhysicalImagePath( const aImagePath: string ): string;
var
   _Pos: Integer;
begin
   if aImagePath.IsEmpty then Result:= ''
   else begin
      _Pos:= Pos( '/', aImagePath );
      Result:= FRootPath + FCurrentFolder + Copy( aImagePath, Succ( _Pos ), ( aImagePath.Length - _Pos ) );
      Result:= StringReplace( Result, '/', '\', [rfReplaceAll] );
   end;
end;

//Formate correctement la date depuis la string récupérée du xml
//ou renvoie une date format Iso pour sauvegarde selon l'appel (aIso)
function TFrm_Editor.FormatDateFromString( const aDate: string; aIso: Boolean = False ): string;
var
   FullStr, Day, Month, Year: string;
   DayInt, MonthInt, YearInt: Integer;
begin
   FullStr:= aDate;
   Result:= '';

   //si on formate pour affichage et que la chaine passée
   //répond au critère
   if ( not aIso ) and ( FullStr.Contains( Cst_DateSuffix ) ) then begin
      SetLength( FullStr, 8 );
      Day:= Copy( FullStr, 7, 2 );
      Month:= Copy( FullStr, 5, 2 );
      Year:= Copy( FullStr, 1, 4 );
      if ( TryStrToInt( Day, DayInt ) ) and ( DayInt > 0 ) then
         Result:= Result + Day + '/';
      if ( TryStrToInt( Month, MonthInt ) ) and ( MonthInt > 0 ) then
         Result:= Result + Month + '/';
      if ( TryStrToInt( Year, YearInt ) ) and ( YearInt > 0 ) then
         Result:= Result + Year;

      //sinon si on formate pour enregistrement dans le .xml
      //et que la chaine ne contient que des chiffres ou /
   end else if aIso and ( TRegEx.IsMatch( FullStr, '^[0-9]' ) ) then begin

      //si la chaine fait 4 caractères de long
      if ( Length( FullStr) = 4 ) then
         Result:= FullStr + Cst_DateLongFill + Cst_DateSuffix;

      //si la chaine fait 7 caractères de long
      if ( Length( FullStr) = 7 ) then begin
         Month:= Copy( FullStr, 1, 2 );
         Year:= Copy( FullStr, 4, 4 );
         Result:= Year + Month + Cst_DateShortFill + Cst_DateSuffix;
      end;

      //si la chaine fait 10 caractères de long
      if ( Length( FullStr) = 10 ) then begin
         Day:= Copy( FullStr, 1, 2 );
         Month:= Copy( FullStr, 4, 2 );
         Year:= Copy( FullStr, 7, 4 );
         Result:= Year + Month + Day + Cst_DateSuffix;
      end;
   end;
end;

//Construction d'une messagedlg custom (pour pouvoir traduire les boutons)
function TFrm_Editor.MyMessageDlg(const Msg: string; DlgTypt: TmsgDlgType; button: TMsgDlgButtons;
                      Caption: array of string; dlgcaption: string ): Integer;
var
   aMsgdlg: TForm;
   ii: Integer;
   Dlgbutton: Tbutton;
   Captionindex: Integer;
begin
   aMsgdlg := CreateMessageDialog(  Msg, DlgTypt, button   );
   aMsgdlg.Caption := dlgcaption;
   aMsgdlg.BiDiMode := bdLeftToRight;
   Captionindex := 0;
   for ii:= 0 to Pred( aMsgdlg.ComponentCount ) do begin
      if (aMsgdlg.components[ii] is Tbutton) then Begin
         Dlgbutton:= Tbutton( aMsgdlg.Components[ii]   );
         if ( Captionindex <= High( Caption ) ) then
            Dlgbutton.Caption:= Caption[Captionindex];
         Inc( Captionindex );
      end;
   end;
   Result:= aMsgdlg.Showmodal;
end;

//Chargement des paramètres depuis le fichier INI
procedure TFrm_Editor.LoadFromIni;
var
   FileIni: TIniFile;
begin
   FileIni:= TIniFile.Create( ExtractFilePath( Application.ExeName ) + Cst_IniFilePath );
   try
      //On tent de lire les fichier ini, si on ne trouve pas on met tout à false par défaut
      FGodMode:= FileIni.ReadBool( Cst_IniOptions, Cst_IniGodMode, False );
      Mnu_GodMode.Checked:= FGodMode;
      Mnu_DeleteWoPrompt.Enabled:= FGodMode;
      Btn_Delete.Visible:= FGodMode;

      FAutoHash:= FileIni.ReadBool( Cst_IniOptions, Cst_IniAutoHash, False );
      Mnu_AutoHash.Checked:= FAutoHash;

      FDelWoPrompt:= FileIni.ReadBool( Cst_IniOptions, Cst_IniDelWoPrompt, False );
      Mnu_DeleteWoPrompt.Checked:= FDelWoPrompt;

      FPiPrompts:= FileIni.ReadBool( Cst_IniOptions, Cst_IniPiPrompts, False );
      Mnu_PiPrompts.Checked:= FPiPrompts;

      FGenesisLogo:= FileIni.ReadBool( Cst_IniOptions, Cst_IniGenesisLogo, False );
      Mnu_Genesis.Checked:= FGenesisLogo;

      FShowTips:= FileIni.ReadBool(  Cst_IniOptions, Cst_ShowTips, True );
      Mnu_ShowTips.Checked:= FShowTips;

      FThemeNumber:= FileIni.ReadInteger( Cst_IniOptions, Cst_ThemeNumber, 5 );
      FLanguage:= FileIni.ReadInteger( Cst_IniOptions, Cst_IniLanguage, 0 );

      FRecalLogin:= FileIni.ReadString( Cst_IniOptions, Cst_IniRecalLogin, Cst_RecalLogin);
      FRecalPwd:= FileIni.ReadString( Cst_IniOptions, Cst_IniRecalPwd, Cst_RecalPwd);
      FRetroLogin:= FileIni.ReadString( Cst_IniOptions, Cst_IniRetroLogin, Cst_RetroLogin);
      FRetroPwd:= FileIni.ReadString( Cst_IniOptions, Cst_IniRetroPwd, Cst_RetroPwd);

      FSSLogin:= FileIni.ReadString( Cst_IniOptions, Cst_IniSSUser, '');
      FSSPwd:= FileIni.ReadString( Cst_IniOptions, Cst_IniSSPwd, '');
      FProxyUser:= FileIni.ReadString( Cst_IniOptions, Cst_IniProxyUser, '');
      FProxyPwd:= FileIni.ReadString( Cst_IniOptions, Cst_IniProxyPwd, '');
      FProxyServer:= FileIni.ReadString( Cst_IniOptions, Cst_IniProxyServer, '');
      FProxyPort:= FileIni.ReadString( Cst_IniOptions, Cst_IniProxyPort, '0');
      FProxyUse:= FileIni.ReadBool( Cst_IniOptions, Cst_IniProxyUse, False);
   finally
      FileIni.Free;
   end;
end;

//Enregistrement des paramètres dans le fichier INI
procedure TFrm_Editor.SaveToIni;
var
   FileIni: TIniFile;
begin
   FileIni:= TIniFile.Create( ExtractFilePath( Application.ExeName ) + Cst_IniFilePath );
   try
      FileIni.WriteBool( Cst_IniOptions, Cst_IniGodMode, FGodMode );
      FileIni.WriteBool( Cst_IniOptions, Cst_IniAutoHash, FAutoHash );
      FileIni.WriteBool( Cst_IniOptions, Cst_IniDelWoPrompt, ( FGodMode and FDelWoPrompt ) );
      FileIni.WriteBool( Cst_IniOptions, Cst_IniGenesisLogo, FGenesisLogo );
      FileIni.WriteBool( Cst_IniOptions, Cst_ShowTips, FShowTips );
      FileIni.WriteBool( Cst_IniOptions, Cst_IniPiPrompts, FPiPrompts );
      FileIni.WriteInteger( Cst_IniOptions, Cst_ThemeNumber, FThemeNumber );
      FileIni.WriteInteger( Cst_IniOptions, Cst_IniLanguage, FLanguage );
      FileIni.WriteString( Cst_IniOptions, Cst_IniRecalLogin, FRecalLogin);
      FileIni.WriteString( Cst_IniOptions, Cst_IniRecalPwd, FRecalPwd);
      FileIni.WriteString( Cst_IniOptions, Cst_IniRetroLogin, FRetroLogin);
      FileIni.WriteString( Cst_IniOptions, Cst_IniRetroPwd, FRetroPwd);
      FileIni.WriteString( Cst_IniOptions, Cst_IniSSUser, FSSLogin);
      FileIni.WriteString( Cst_IniOptions, Cst_IniSSPwd, FSSPwd);
      FileIni.WriteString( Cst_IniOptions, Cst_IniProxyUser, FProxyUser);
      FileIni.WriteString( Cst_IniOptions, Cst_IniProxyPwd, FProxyPwd);
      FileIni.WriteString( Cst_IniOptions, Cst_IniProxyServer, FProxyServer);
      if ( FProxyPort.IsEmpty ) then FileIni.WriteString( Cst_IniOptions, Cst_IniProxyPort, '0' )
      else FileIni.WriteString( Cst_IniOptions, Cst_IniProxyPort, FProxyPort );
      FileIni.WriteBool( Cst_IniOptions, Cst_IniProxyUse, FProxyUse);
   finally
      FileIni.Free;
   end;
end;

//Recup l'enum du theme en fonction de l'entier du fichier ini
function TFrm_Editor.GetThemeEnum( aNumber: Integer ): TThemeName;
var
   _ThemeName: TThemeName;
begin
   Result:= tnCharcoalDarkSlate;
   for _ThemeName:= Low( TThemeName )to High( TThemeName ) do begin
      if ( aNumber = Ord( _ThemeName ) ) then begin
         Result:= _ThemeName;
         Break;
      end;
   end;
end;

//Recup de l'enum de la langue en fonction de l'entier du fichier ini
function TFrm_Editor.GetLangEnum( aNumber: Integer ): TLangName;
var
   _LangName: TLangName;
begin
   Result:= lnEnglish;
   for _LangName:= Low( TLangName ) to High( TLangName ) do begin
      if ( aNumber = Ord( _LangName ) ) then begin
         Result:= _LangName;
         Break;
      end;
   end;
end;

//A l'ouverture du programme
procedure TFrm_Editor.FormCreate(Sender: TObject);
begin
   TranslateComponent( Self );
   Lbl_NbGamesFound.Caption:= '';
   GSystemList:= TObjectDictionary<string, TObjectList<TGame>>.Create([doOwnsValues]);
   LoadFromIni;
   TStyleManager.TrySetStyle( Cst_ThemeNameStr[GetThemeEnum( FThemeNumber )] );
   FPiLoadedOnce:= False;
end;

//Met le focus sur le combo system à l'affichage de la fenêtre
procedure TFrm_Editor.FormShow(Sender: TObject);
var
   Frm_Help: TFrm_Help;
begin
   UseLanguage( Cst_LangNameStr[GetLangEnum( FLanguage )] );
   RetranslateComponent( Self );
   CheckMenuItem( Succ( FThemeNumber ) );
   CheckMenuItem( Succ( FLanguage ), True );
   if FShowTips then begin
      //Affiche la fenêtre "Help"
      Frm_Help:= TFrm_Help.Create(nil);
      try
         FShowTips:= Frm_Help.Execute( not FShowTips );
      finally
         Frm_Help.Free;
      end;
   end;
   Mnu_ShowTips.Checked:= FShowTips;
   Lbx_Games.SetFocus;
end;

//Pour checker le menuitem du numéro de thème ou langue récupéré depuis le fichier ini
procedure TFrm_Editor.CheckMenuItem( aNumber: Integer; aLang: Boolean = False );
var
   _MenuItem: TMenuItem;
   _CompName: string;
begin
   if aLang then _CompName:= Cst_MenuLang + IntToStr( aNumber )
   else _CompName:= Cst_MenuTheme + IntToStr( aNumber );
   _MenuItem:= ( FindComponent( _CompName ) as TMenuItem ) ;
   _MenuItem.Checked:= True;
end;

//Action au click sur le menuitem "choose folder"
procedure TFrm_Editor.Mnu_ChoosefolderClick(Sender: TObject);
begin
   Img_BackGround.Visible:= True;
   EnableControls( False );
   Edt_Search.Enabled:= False;
   Lbl_Search.Enabled:= False;
   ClearAllFields;
   Lbx_Games.Items.Clear;
   BuildSystemsList;
   Btn_SaveChanges.Enabled:= False;
end;

//permet d'éxecuter la ligne de commande qui stop/start Emulation Station
//utilisé si on accède aux gamelist directement sur le Pi sinon les modifs ne
//sont pas prises en compte. Utilise le petit utilitaire plink.exe
procedure TFrm_Editor.StopOrStartES( aStop, aRecal: Boolean );
var
   _PathToPlink: string;
begin
   _PathToPlink:= ExtractFilePath( Application.ExeName ) + Cst_ResourcesFolder;
   if aStop then begin
      if aRecal then
         ShellExecute( 0, nil, 'cmd.exe', PChar( Cst_PlinkCommand + FRecalLogin +
                       Cst_PlinkCommandRecal + FRecalPwd +
                       Cst_PlinkCommandStop ), PChar( _PathToPlink ), SW_HIDE )
      else
         ShellExecute( 0, nil, 'cmd.exe', PChar( Cst_PlinkCommand + FRetroLogin +
                       Cst_PlinkCommandRetro + FRetroPwd +
                       Cst_PlinkCommandStop ), PChar( _PathToPlink ), SW_HIDE );
   end else begin
      if aRecal then
         ShellExecute( 0, nil, 'cmd.exe', PChar( Cst_PlinkCommand + FRecalLogin +
                       Cst_PlinkCommandRecal + FRecalPwd +
                       Cst_PlinkCommandStart ), PChar( _PathToPlink ), SW_HIDE )
      else
         ShellExecute( 0, nil, 'cmd.exe', PChar( Cst_PlinkCommand + FRetroLogin +
                       Cst_PlinkCommandRetro + FRetroPwd +
                       Cst_PlinkCommandStart ), PChar( _PathToPlink ), SW_HIDE )
   end;
end;

//Construction de la liste des systèmes trouvés (et des listes de jeux associées)
procedure TFrm_Editor.BuildSystemsList;
var
   _GameListPath: string;
   Info: TSearchRec;
   IsFound: Boolean;
   ValidFolderCount: Integer;
   TmpList: TObjectList<TGame>;
   _system: TSystemKindObject;
begin
   //on met à vide le chemin de base et le logo systeme
   FRootPath:= '';
   Img_System.Picture.Graphic:= nil;

   //On vide le combobox des systèmes
   //Et on désactive les Controls non nécessaires
   Cbx_Systems.Items.Clear;
   Cbx_Systems.Enabled:= False;
   Cbx_Filter.Enabled:= False;
   Lbl_SelectSystem.Enabled:= False;
   Lbl_Filter.Enabled:= False;
   Lbl_NbGamesFound.Caption:= '';
   Btn_ChangeAll.Enabled:= False;
   Cbx_Hidden.ItemIndex:= -1;
   Cbx_Favorite.ItemIndex:= -1;
   Edt_Search.Text:= '';

    //On vide la liste globale des systèmes (cas 2eme ouverture)
    GSystemList.Clear;

   //On met le compteur de dossiers valides à 0
   ValidFolderCount:= 0;

   //On sélectionne le dossier parent où se trouvent les dossiers de systèmes
   if ( OpenDialog.Execute ) then begin

      //On récupère le chemin vers le dossier parent
      FRootPath:= IncludeTrailingPathDelimiter( OpenDialog.FileName );

      //On check si le dossier n'est pas vide
      IsFound:= ( FindFirst( FRootPath + '*.*', faAnyFile, Info) = 0 );

      //Si le dossier est vide : message utilisateur
      if not IsFound then begin
         ShowMessage( Rst_WrongFolder );
         Exit;
      end;

      //On boucle sur les dossiers trouvés pour les lister
      while IsFound do begin

         //Si le dossier trouvé ne commence pas par un . et qu'il contient
         //bien un fichier gamelist.xml alors on crée la liste de jeux
         if ( (Info.Attr and faDirectory) <> 0 ) and
            ( Info.Name[1] <> '.' ) and
            ( FileExists( FRootPath + IncludeTrailingPathDelimiter( Info.Name ) +
                          Cst_GameListFileName ) ) then begin

            //on chope le nom du dossier en cours pour construire les chemins
            FCurrentFolder:= IncludeTrailingPathDelimiter( Info.Name );

            //Ici on récupère le chemin vers le fichier gamelist.xml
            _GameListPath:= FRootPath + FCurrentFolder + Cst_GameListFileName;

            //On tente de construire la liste des jeux depuis le .xml
            TmpList:= BuildGamesList( _GameListPath );

            //Si la liste n'est pas vide, on traite, sinon on zappe
            if Assigned( TmpList ) then begin

               //On construit la liste des jeux du système
               //et on joute le système à la liste globale de systèmes
               GSystemList.Add( Info.Name, TmpList );

               //On ajoute ensuite le nom du systeme au combobox des systemes trouvés
               _system:= TSystemKindObject.Create( Info.Name );
               if ( _system.FSystemKind = skMegaDrive ) and FGenesisLogo then
                  Cbx_Systems.Items.AddObject( Cst_SystemKindStr[skGenesis], _system )
               else
               Cbx_Systems.Items.AddObject( Cst_SystemKindStr[_system.FSystemKind], _system );

               //On incrémente le compteur de dossier système valides
               Inc( ValidFolderCount );
            end;
         end;

         //Enfin, on passe au dossier suivant (s'il y en a un)
         IsFound:= ( FindNext(Info) = 0 );
      end;
      FindClose(Info);

      //Si le compteur de dossier valide est à zéro, message utilisateur
      if ( ValidFolderCount = 0 ) then begin
         ShowMessage( Rst_WrongFolder );
         Screen.Cursor:= crDefault;
         Exit;

         //On active le Combobox des systemes si au moins un systeme a été trouvé
         //Idem pour le listbox des jeux du systeme et on charge la liste du premier système
      end else begin

         //si le dossier sélectionné se trouve sur le Pi,
         //on prévient l'utilisateur qu'on va stopper ES
         FFolderIsOnPi:= FRootPath.StartsWith( Cst_Recalbox ) or
                         FRootPath.StartsWith( Cst_Retropie );

         if FFolderIsOnPi and not FPiLoadedOnce then begin
            FPiLoadedOnce:= True;
            if not FPiPrompts then
               MyMessageDlg( Rst_StopES, mtInformation, [mbOK], [Rst_Ok], Rst_Info );
            if FRootPath.StartsWith( Cst_Recalbox ) then begin
               StopOrStartES( True, True );
               FSysIsRecal:= True;
            end else begin
               StopOrStartES( True, False );
               FSysIsRecal:= False;
            end;
         end;

         Cbx_Systems.Enabled:= True;
         Lbl_SelectSystem.Enabled:= Cbx_Systems.Enabled;
         Cbx_Filter.Enabled:= Cbx_Systems.Enabled;
         Lbl_Filter.Enabled:= Cbx_Systems.Enabled;
         Cbx_Systems.ItemIndex:= 0;
         EnableControls( True );
         Cbx_Filter.ItemIndex:= 0;
         Edt_Search.Enabled:= True;
         Lbl_Search.Enabled:= True;
         LoadGamesList( getCurrentFolderName );

         //On remet le curseur par défaut
         Screen.Cursor:= crDefault;
      end;
   end;
end;

//Construction de la liste des jeux (objets) pour un systeme donné
function TFrm_Editor.BuildGamesList( const aPathToFile: string ): TObjectList<TGame>;

   //Permet de s'assurer que le noeud cherché existe, et si ce n'est pas le cas
   //renvoie chaine vide, sinon renvoie la valeur texte du noeud
   function GetNodeValue( aNode: IXMLNode; const aNodeName: string ): string;
   begin
      Result:= '';
      if Assigned( aNode.ChildNodes.FindNode( aNodeName ) ) then
         Result:= aNode.ChildNodes.Nodes[aNodeName].Text;
   end;

var
   _GameList: TObjectList<TGame>;
   _Game: TGame;
   _Node: IXmlNode;
begin
   //on met le curseur sablier pour montrer que ça bosse.
   Screen.Cursor:= crHourGlass;

   //Initialisation à nil au cas où liste de jeux vide
   Result:= nil;

   //On ouvre et active le gamelist.xml pour le parcourir
   XMLDoc.FileName:= aPathToFile;
   XMLDoc.Active:= True;

   //On cherche le premier "jeu"
   _Node := XMLDoc.DocumentElement.ChildNodes.FindNode( Cst_Game );

   //Si pas de jeu trouvé on sort et on renvoie nil
   if not Assigned( _Node ) then Exit;

    //On crée la liste d'objets TGame
    _GameList:= TObjectList<TGame>.Create( True );

   //Ensuite on boucle sur tous les jeux et pour chaque jeu
   //on crée un objet TGame qu'on renseigne et ajoute à la _Gamelist
   repeat
      //On ne crée un "jeu" que si le noeud n'est pas vide.
      if _Node.HasChildNodes then begin

         //Création de l'objet TGame et passage des infos en argument
         _Game:= TGame.Create( GetNodeValue( _Node, Cst_Path ),
                               GetNodeValue( _Node, Cst_Name ),
                               GetNodeValue( _Node,Cst_Description ),
                               GetNodeValue( _Node, Cst_ImageLink ),
                               GetNodeValue( _Node, Cst_Rating ),
                               GetNodeValue( _Node, Cst_Developer ),
                               GetNodeValue( _Node, Cst_Publisher ),
                               GetNodeValue( _Node, Cst_Genre ),
                               GetNodeValue( _Node, Cst_Players ),
                               FormatDateFromString( GetNodeValue( _Node, Cst_ReleaseDate ) ),
                               GetNodeValue( _Node, Cst_Region ),
                               GetNodeValue( _Node, Cst_Playcount ),
                               GetNodeValue( _Node, Cst_LastPlayed ),
                               GetNodeValue( _Node, Cst_Hidden ),
                               GetNodeValue( _Node, Cst_Favorite ) );

         _Game.PhysicalRomPath:= GetPhysicalRomPath( _Game.RomPath );
         _Game.PhysicalImagePath:= GetPhysicalImagePath( _Game.ImagePath );
         _Game.IsOrphan:= not FileExists( _Game.PhysicalRomPath );

         //On ajoute à la _Gamelist
         _GameList.Add( _Game );
      end;

      //On passe au jeu suivant
      _Node := _Node.NextSibling;
   until ( _Node = nil );

   XMLDoc.Active:= False;

   Result:= _GameList;
end;

//Action à la sélection d'un filtre
procedure TFrm_Editor.Cbx_FilterChange(Sender: TObject);
begin
   LoadGamesList( getCurrentFolderName );
end;

//Action à la sélection d'un item du combobox systemes
procedure TFrm_Editor.Cbx_SystemsChange(Sender: TObject);
begin
   Edt_Search.Text:= '';
   LoadGamesList( getCurrentFolderName );
end;

//quand on tape du texte dans le champ de recherche
procedure TFrm_Editor.Edt_SearchChange(Sender: TObject);
begin
   LoadGamesList( getCurrentFolderName );
end;

//Je fais une procédure juste pour activer les controls
//pour pas se les retaper à chaque changement d'état
procedure TFrm_Editor.EnableControls( aValue: Boolean );
begin
   Lbl_Name.Enabled:= aValue;
   Lbl_Genre.Enabled:= aValue;
   Lbl_Rating.Enabled:= aValue;
   Lbl_Developer.Enabled:= aValue;
   Lbl_Publisher.Enabled:= aValue;
   Lbl_Players.Enabled:= aValue;
   Lbl_Date.Enabled:= aValue;
   Lbl_Description.Enabled:= aValue;
   Lbl_Region.Enabled:= aValue;
   Lbl_Hidden.Enabled:= aValue;
   Lbl_Favorite.Enabled:= aValue;
   Btn_ChangeImage.Enabled:= aValue;
   Btn_Scrape.Enabled:= aValue;
   Btn_RemovePicture.Enabled:= aValue;
   Btn_SetDefaultPicture.Enabled:= aValue;
   Btn_MoreInfos.Enabled:= aValue;
   Btn_Delete.Enabled:= aValue;
   Mnu_System.Enabled:= aValue or not ( GSystemList.Count = 0 );
   Mnu_Game.Enabled:= aValue and not ( Lbx_Games.Items.Count = 0 );
   Edt_Name.Enabled:= aValue;
   Edt_Genre.Enabled:= aValue;
   Edt_Rating.Enabled:= aValue;
   Edt_Region.Enabled:= aValue;
   Edt_Developer.Enabled:= aValue;
   Edt_Publisher.Enabled:= aValue;
   Edt_ReleaseDate.Enabled:= aValue;
   Edt_NbPlayers.Enabled:= aValue;
   Mmo_Description.Enabled:= aValue;
   Cbx_Hidden.Enabled:= aValue;
   Cbx_Favorite.Enabled:= aValue;
end;

//Action lorsqu'on change le contenu d'un des champs
procedure TFrm_Editor.FieldChange(Sender: TObject);
begin
   CheckIfChangesToSave;
end;

//On vérifie si il y a des changements pour activer le bouton
// "Save changes" ou non
procedure TFrm_Editor.CheckIfChangesToSave;
var
   _Game: TGame;
begin
   if FIsLoading then Exit;

   _Game:= ( Lbx_Games.Items.Objects[Lbx_Games.ItemIndex] as TGame );
   Btn_SaveChanges.Enabled:= not ( _Game.Name.Equals( Edt_Name.Text ) ) or
                             not ( _Game.Genre.Equals( Edt_Genre.Text ) ) or
                             not ( _Game.Rating.Equals( Edt_Rating.Text ) ) or
                             not ( _Game.Players.Equals( Edt_NbPlayers.Text ) ) or
                             not ( _Game.Developer.Equals( Edt_Developer.Text ) ) or
                             not ( _Game.Publisher.Equals( Edt_Publisher.Text ) ) or
                             not ( _Game.ReleaseDate.Equals( Edt_ReleaseDate.Text ) ) or
                             not ( _Game.Description.Equals( Mmo_Description.Text ) ) or
                             not ( _Game.Region.Equals( Edt_Region.Text ) ) or
                             not ( _Game.Hidden = Cbx_Hidden.ItemIndex ) or
                             not ( _Game.Favorite = Cbx_Favorite.ItemIndex );
end;

//Chargement de la liste des jeux d'un système dans le listbox des jeux
procedure TFrm_Editor.LoadGamesList( const aSystem: string );

   //permet de récupérer le chemin vers les images (du xml)
   procedure GetImageFolder( aGame: TGame );
   var
      StartPos, EndPos: Integer;
   begin
      StartPos:= Succ( Pos( '/', aGame.ImagePath ) );
      EndPos:= LastDelimiter( '/', aGame.ImagePath );
      FImageFolder:= Copy( aGame.ImagePath, StartPos, ( EndPos - StartPos ) );

      FXmlImageFolderPath:= Copy( aGame.ImagePath, 1, EndPos );
   end;

   //Permet de vérifier si l'image existe "physiquement"
   //car il se peut que le lien soit renseigné mais que l'image
   //n'existe pas dans le dossier des images...
   function CheckIfImageMissing( const aLink: string ): Boolean;
   begin
      Result:= aLink.IsEmpty or not ( FileExists( aLink ) );
   end;

var
   _TmpList: TObjectList<TGame>;
   _TmpGame: TGame;
   _FilterIndex: Integer;
   _FolderFound: Boolean;
begin
   //on stocke le "numero" de filtre.
   _FilterIndex:= Cbx_Filter.ItemIndex;
   _FolderFound:= False;

   //On essaye de récupérer la liste de jeux du système choisi
   if GSystemList.TryGetValue( aSystem, _TmpList ) then begin

      //On charge le logo du systeme choisi
      if ( GetCurrentLogoName = Cst_SystemKindImageNames[skMegaDrive] ) and
         FGenesisLogo then
         LoadSystemLogo( Cst_SystemKindImageNames[skGenesis] )
      else
         LoadSystemLogo( GetCurrentLogoName );

      //on récupère le nom du dossier de roms chargé
      FCurrentFolder:= IncludeTrailingPathDelimiter( getCurrentFolderName );

      //On désactive les évènements sur les changements dans les champs
      //Sinon ça pète quand on change de système (indice hors limite)
      FIsLoading:= True;

      //On commence par vider le listbox
      Lbx_Games.Items.Clear;

      //On boucle sur la liste de jeux pour ajouter les noms
      //dans le listbox de la liste des jeux
      for _TmpGame in _TmpList do begin

         //Récup du lien vers les images pour ce système (lien xml)
         if not ( _TmpGame.ImagePath.IsEmpty ) and
            not _FolderFound then begin
            GetImageFolder( _TmpGame );
            _FolderFound:= True;
         end;

         //Attention usine à gaz booléenne pour gérer les filtres ^^
         if ( _FilterIndex = 0 ) or
            ( ( _FilterIndex = 1 ) and ( CheckIfImageMissing( _TmpGame.PhysicalImagePath ) ) ) or
            ( ( _FilterIndex = 2 ) and ( _TmpGame.ReleaseDate.IsEmpty ) ) or
            ( ( _FilterIndex = 3 ) and ( _TmpGame.Players.IsEmpty ) ) or
            ( ( _FilterIndex = 4 ) and ( _TmpGame.Rating.IsEmpty ) ) or
            ( ( _FilterIndex = 5 ) and ( _TmpGame.Developer.IsEmpty ) ) or
            ( ( _FilterIndex = 6 ) and ( _TmpGame.Publisher.IsEmpty ) ) or
            ( ( _FilterIndex = 7 ) and ( _TmpGame.Description.IsEmpty ) ) or
            ( ( _FilterIndex = 8 ) and ( _TmpGame.Genre.IsEmpty ) ) or
            ( ( _FilterIndex = 9 ) and ( _TmpGame.Region.IsEmpty ) ) or
            ( ( _FilterIndex = 10 ) and ( _TmpGame.Hidden = 1 ) ) or
            ( ( _FilterIndex = 11 ) and ( _TmpGame.Favorite = 1 ) ) or
            ( ( _FilterIndex = 12 ) and ( _TmpGame.IsOrphan ) ) then begin

            if ( Edt_Search.Text = '' ) or
               ContainsText( _TmpGame.Name, Edt_Search.Text ) then
               Lbx_Games.Items.AddObject( _TmpGame.Name, _TmpGame );
         end
      end;

      //On indique le nombre de jeux trouvés
      if Cbx_Filter.ItemIndex = 0 then
         Lbl_NbGamesFound.Caption:= IntToStr( Lbx_Games.Items.Count ) + Rst_GamesFound
      else
         Lbl_NbGamesFound.Caption:= IntToStr( Lbx_Games.Items.Count ) + ' / ' +
                                    IntToStr( _TmpList.Count ) + Rst_GamesFound;

      //On met le focus sur le premier jeu de la liste
      ClearAllFields;

      //Si il y a des jeux dans la liste on affiche auto le premier
      if ( Lbx_Games.Items.Count > 0 ) then begin
         EnableControls( True );
         Lbx_Games.Selected[0]:= True;
         LoadGame( ( Lbx_Games.Items.Objects[0] as TGame ) );
         Btn_ChangeAll.Enabled:= ( Cbx_Filter.ItemIndex = 1 );
      end else begin
         Btn_ChangeAll.Enabled:= False;
         EnableControls( False );
      end;

      //on remet les évènements sur les champs
      FIsLoading:= False;
   end;
end;

//Charge le logo du système sélectionné dans le TImage prévu
procedure TFrm_Editor.LoadSystemLogo( aPictureName: string );
var
   _Image: TPngImage;
begin
   _Image:= TPngImage.Create;
   try
      _Image.LoadFromFile( ExtractFilePath( Application.ExeName ) +
                           Cst_LogoPicsFolder + aPictureName );
      Img_System.Picture.Graphic:= _Image;
   finally
      _Image.Free;
   end;
end;

//Click sur un jeu dans la liste
procedure TFrm_Editor.Lbx_GamesClick(Sender: TObject);
begin
   ClearAllFields;
   LoadGame( ( Lbx_Games.Items.Objects[Lbx_Games.ItemIndex] as TGame ) )
end;

//Chargement dans les différents champs des infos du jeu sélectionné
procedure TFrm_Editor.LoadGame( aGame: TGame );
var
   _Image: TPngImage;
   _ImageJpg: TJPEGImage;
begin
   //on remet les évènements sur les champs
   FIsLoading:= True;

   Img_BackGround.Visible:= True;
   Edt_Name.Text:= aGame.Name;
   Edt_Rating.Text:= aGame.Rating;
   Edt_ReleaseDate.Text:= aGame.ReleaseDate;
   Edt_Publisher.Text:= aGame.Publisher;
   Edt_Developer.Text:= aGame.Developer;
   Edt_NbPlayers.Text:= aGame.Players;
   Edt_Genre.Text:= aGame.Genre;
   Mmo_Description.Text:= aGame.Description;
   Edt_Region.Text:= aGame.Region;
   Cbx_Hidden.ItemIndex:= aGame.Hidden;
   Cbx_Favorite.ItemIndex:= aGame.Favorite;
   Edt_RomPath.Text:= aGame.RomPath;

   //on remet les évènements sur les champs
   FIsLoading:= False;

   if not ( aGame.ImagePath.IsEmpty ) and
          FileExists( aGame.PhysicalImagePath ) then begin
      if ( ExtractFileExt( aGame.PhysicalImagePath ) = '.png' ) then begin
         _Image:= TPngImage.Create;
         try
            _Image.LoadFromFile( aGame.PhysicalImagePath );
            Img_Game.Picture.Graphic:= _Image;
            Btn_RemovePicture.Enabled:= True;
            //on affiche l'image background que si le jeu n'a pas d'image
            Img_BackGround.Visible:= ( Img_Game.Picture.Graphic = nil );
            Btn_Scrape.Enabled:= FileExists( aGame.PhysicalRomPath );
            Exit;
         finally
            _Image.Free;
         end;
      end else if ( ExtractFileExt( aGame.PhysicalImagePath ) = '.jpg' ) or
                  ( ExtractFileExt( aGame.PhysicalImagePath ) = '.jpeg' ) then begin
         _ImageJpg:= TJPEGImage.Create;
         try
            _ImageJpg.LoadFromFile( aGame.PhysicalImagePath );
            Img_Game.Picture.Graphic:= _ImageJpg;
            Btn_RemovePicture.Enabled:= True;
            //on affiche l'image background que si le jeu n'a pas d'image
            Img_BackGround.Visible:= ( Img_Game.Picture.Graphic = nil );
            Btn_Scrape.Enabled:= FileExists( aGame.PhysicalRomPath );
            Exit;
         finally
            _ImageJpg.Free;
         end;
      end;
   end else begin
      Btn_RemovePicture.Enabled:= False;
      Btn_Scrape.Enabled:= FileExists( aGame.PhysicalRomPath );
   end;
end;

//Action au click sur bouton "change image"
//Ouvre une boite de dialogue pour changer l'image du jeu sélectionné
procedure TFrm_Editor.Btn_ChangeImageClick(Sender: TObject);
var
   _Game: TGame;
begin
   if OpenFile.Execute and ( OpenFile.FileName <> '' ) then begin
      _Game:= ( Lbx_Games.Items.Objects[Lbx_Games.ItemIndex] as TGame );
      ChangeImage( OpenFile.FileName, _Game );
      LoadGame( _Game );
      Lbx_Games.SetFocus;
   end;
end;

//Action au click sur bouton "change picture to default"
//Change l'image actuelle du jeu sélectionné pour celle par défaut
procedure TFrm_Editor.Btn_SetDefaultPictureClick(Sender: TObject);
var
   PathToDefault: string;
   _Game: TGame;
begin
   _Game:= ( Lbx_Games.Items.Objects[Lbx_Games.ItemIndex] as TGame );

   //On construit le lien vers l'image défaut selon le système
   PathToDefault:= ExtractFilePath(Application.ExeName) +
                   Cst_DefaultPicsFolderPath +
                   getCurrentFolderName +
                   Cst_DefaultImageNameSuffix;

   //si l'image defaut du systeme n'existe pas on prend la générique
   if not FileExists( PathToDefault ) then
      PathToDefault:= ExtractFilePath(Application.ExeName) +
                      Cst_DefaultPicsFolderPath +
                      Cst_DefaultImageName;

   ChangeImage( PathToDefault, _Game );
   LoadGame( _Game );
   Lbx_Games.SetFocus;
end;

//Action au click "change all missing to default"
//Assigne l'image defaut du système à tous les jeux qui n'ont pas d'image
procedure TFrm_Editor.Btn_ChangeAllClick(Sender: TObject);
var
   ii: Integer;
   PathToDefault: string;
   _Game: TGame;
begin
   //On construit le lien vers l'image défaut selon le système
   PathToDefault:= ExtractFilePath(Application.ExeName) +
                   Cst_DefaultPicsFolderPath + '\' +
                   getCurrentFolderName +
                   Cst_DefaultImageNameSuffix;

    //si l'image defaut du systeme n'existe pas on prend la générique
    if not FileExists( PathToDefault ) then
       PathToDefault:= ExtractFilePath(Application.ExeName) +
                       Cst_DefaultPicsFolderPath + '\' +
                       Cst_DefaultImageName;

   //et on boucle sur tous les jeux de la liste pour remplacer l'image
   ProgressBar.Visible:= True;
   ProgressBar.Max:= Pred( Lbx_Games.Items.Count );
   ProgressBar.Position:= 0;
   for ii:= 0 to Pred( Lbx_Games.Items.Count ) do begin
      _Game:= ( Lbx_Games.Items.Objects[ii] as TGame );
      ChangeImage( PathToDefault, _Game );
      ProgressBar.Position:= ( ProgressBar.Position + 1 );
   end;
   ProgressBar.Visible:= False;
   LoadGamesList( getCurrentFolderName );
   Lbx_Games.SetFocus;
end;

//Remplace l'image actuelle du jeu (par autre ou défaut).
procedure TFrm_Editor.ChangeImage( const aPath: string; aGame: TGame );
var
   _Image: TPngImage;
   _ImageJpg: TJPEGImage;
   _ImageLink: string;
   _Node: IXMLNode;
   _NodeAdded: Boolean;
begin
   _NodeAdded:= False;
   Screen.Cursor:= crHourGlass;

   //on détermine ensuite l'extension du fichier chargé et
   //on crée l'objet qui va bien pour affecter au TImage
   if ( ExtractFileExt( aPath ) = '.png' ) then begin
      _Image:= TPngImage.Create;
      try
         _Image.LoadFromFile( aPath );
         Img_Game.Picture.Graphic:= _Image;
      finally
         _Image.Free;
      end;
   end else begin
      _ImageJpg:= TJPEGImage.Create;
      try
         _ImageJpg.LoadFromFile( aPath );
         Img_Game.Picture.Graphic:= _ImageJpg;
      finally
         _ImageJpg.Free;
      end;
   end;

   //on sauvegarde l'image dans le dossier avec les autres !!
   // et on ajoute le chemin dans le xml
   Img_Game.Picture.SaveToFile( FRootPath + FCurrentFolder + FImageFolder +
                                '\' + aGame.RomNameWoExt + Cst_ImageSuffixPng );

   //On ouvre le fichier xml
   XMLDoc.LoadFromFile( FRootPath + FCurrentFolder + Cst_GameListFileName );

   //On récupère le premier noeud "game"
   _Node := XMLDoc.DocumentElement.ChildNodes.FindNode( Cst_Game );

   //Et on boucle pour trouver le noeud avec le bon Id
   repeat
      if ( _Node.ChildNodes.Nodes[Cst_Path].Text = aGame.RomPath ) then Break;
      _Node := _Node.NextSibling;
   until not Assigned( _Node );

   //on écrit le chemin vers l'image
   _ImageLink:= FXmlImageFolderPath + aGame.RomNameWoExt + Cst_ImageSuffixPng;

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
   aGame.ImagePath:= _ImageLink;
   aGame.PhysicalImagePath:= FRootPath + FCurrentFolder +
                             IncludeTrailingPathDelimiter( FImageFolder ) +
                             aGame.RomNameWoExt + Cst_ImageSuffixPng;

   Screen.Cursor:= crDefault;
end;

//Au click sur le bouton delete picture
procedure TFrm_Editor.Btn_RemovePictureClick(Sender: TObject);
begin
   DeleteGamePicture;
   Lbx_Games.SetFocus;
end;

//Supprime l'image d'un jeu (dans le xml et physiquement)
procedure TFrm_Editor.DeleteGamePicture;
var
   _Game: TGame;
   _GameListPath: string;
   _Node: IXMLNode;
begin
   //on commence par récupérer l'objet TGame correspondant
   _Game:= ( Lbx_Games.Items.Objects[Lbx_Games.ItemIndex] as TGame );

   //on construit le chemin vers le gamelist.xml
   _GameListPath:= FRootPath + FCurrentFolder + Cst_GameListFileName;

   //On ouvre le fichier xml
   XMLDoc.LoadFromFile( _GameListPath );

   //On récupère le premier noeud "game"
   _Node := XMLDoc.DocumentElement.ChildNodes.FindNode( Cst_Game );

   //Et on boucle pour trouver le bon noeud
   repeat
      if ( _Node.ChildNodes.Nodes[Cst_Path].Text = _Game.RomPath ) then Break;
         _Node := _Node.NextSibling;
   until not Assigned( _Node );

   //on vire le noeud du fichier xml
   _Node.ChildNodes.FindNode( Cst_ImageLink ).Text:= '';
   XMLDoc.Active:= True;
   XMLDoc.SaveToFile( _GameListPath );
   XMLDoc.Active:= False;

   //On supprime l'image du jeu
   DeleteFile( _Game.PhysicalImagePath );

   //on vide l'image jeu
   Img_Game.Picture.Graphic:= nil;

   //on update l'objet TGame
   _Game.ImagePath:= '';

   //on recharge le jeu pour refléter les changements
   LoadGame( _Game );
end;

//Récupère le nom d'enum du systeme sélectionné dans le combobox
function TFrm_Editor.getSystemKind: TSystemKind;
begin
   Result:= TSystemKindObject( Cbx_Systems.Items.Objects[Cbx_Systems.ItemIndex] ).FSystemKind;
end;

//Récupère le nom du dossier du systeme selectionné dans le combobox
function TFrm_Editor.getCurrentFolderName: string;
begin
   Result:= Cst_SystemKindFolderNames[getSystemKind];
end;

//Récupère le nom du logo du système sélectionné dans le combobox
function TFrm_Editor.GetCurrentLogoName: string;
begin
   Result:= Cst_SystemKindImageNames[getSystemKind];
end;

//Récupère le systemid du système sélectionné dans le combobox
function TFrm_Editor.GetCurrentSystemId: string;
begin
   Result:= Cst_SystemKindId[getSystemKind];
end;

//Action au click sur bouton "save changes"
procedure TFrm_Editor.Btn_SaveChangesClick(Sender: TObject);
begin
   SaveChangesToGamelist;
   Btn_SaveChanges.Enabled:= False;
   Lbx_Games.SetFocus;
end;

//Au click sur le bouton Scraper
procedure TFrm_Editor.Btn_ScrapeClick(Sender: TObject);
var
   SysId: string;
   Frm_Scrape: TFrm_Scraper;
   _List: TStringList;
begin
   //on désactive pour éviter les clicks intempestifs pendant le chargement
   Enabled:= False;
   SysId:= GetCurrentSystemId;
   Frm_Scrape:= TFrm_Scraper.Create( nil );
   _List:= TStringList.Create;
   try
      _List.Add(FSSLogin);
      _List.Add(FSSPwd);
      _List.Add(FProxyUser);
      _List.Add(FProxyPwd);
      _List.Add(FProxyServer);
      _List.Add(FProxyPort);
      Frm_Scrape.Execute( SysId, FRootPath, FCurrentFolder, FImageFolder, FXmlImageFolderPath,
                          ( Lbx_Games.Items.Objects[Lbx_Games.ItemIndex] as TGame ), _List, FProxyUse );

   finally
      Frm_Scrape.Free;
      _List.Free;

   end;
   LoadGame( ( Lbx_Games.Items.Objects[Lbx_Games.ItemIndex] as TGame ) );
   Enabled:= True;
   Application.MainForm.SetFocus;
end;

//Enregistre les changements effectués pour le jeu dans le fichier .xml
//et rafraichit le listbox si besoin
procedure TFrm_Editor.SaveChangesToGamelist;

   //Permet de s'assurer q'un noeud existe
   function NodeExists( aNode: IXMLNode; const aNodeName: string ): Boolean;
   begin
      Result:= False;
      if Assigned( aNode.ChildNodes.FindNode( aNodeName ) ) then
         Result:= True;
   end;

var
   _Node: IXMLNode;
   _Game: TGame;
   _GameListPath, _Date: string;
   _NodeAdded, _NameChanged: Boolean;
begin
   _NodeAdded:= False;
   _NameChanged:= False;
   //On récupère le chemin du fichier gamelist.xml
   _GameListPath:= FRootPath + FCurrentFolder + Cst_GameListFileName;

   //On récupère l'objet TGame qu'on souhaite modifier
   _Game:= ( Lbx_Games.Items.Objects[Lbx_Games.ItemIndex] as TGame );

   //On ouvre le fichier xml
   XMLDoc.LoadFromFile( _GameListPath );

   //On récupère le premier noeud "game"
   _Node := XMLDoc.DocumentElement.ChildNodes.FindNode( Cst_Game );

   //Et on boucle pour trouver le bon noeud
   repeat
      if ( _Node.ChildNodes.Nodes[Cst_Path].Text = _Game.RomPath ) then Break;
      _Node := _Node.NextSibling;
   until not Assigned( _Node );

   //On peut maintenant mettre les infos à jour dans le xml si besoin
   if not ( _Game.Name.Equals( Edt_Name.Text ) ) then begin
      _Node.ChildNodes.Nodes[Cst_Name].Text:= Edt_Name.Text;
      _Game.Name:= Edt_Name.Text;
      Lbx_Games.Items[Lbx_Games.ItemIndex]:= Edt_Name.Text;
      _NameChanged:= True;
   end;
   if not ( _Game.Genre.Equals( Edt_Genre.Text ) ) then begin
      _Node.ChildNodes.Nodes[Cst_Genre].Text:= Edt_Genre.Text;
      _Game.Genre:= Edt_Genre.Text;
   end;
   if not ( _Game.Rating.Equals( Edt_Rating.Text ) ) then begin
      _Node.ChildNodes.Nodes[Cst_Rating].Text:= Edt_Rating.Text;
      _Game.Rating:= Edt_Rating.Text;
   end;
   if not ( _Game.Players.Equals( Edt_NbPlayers.Text ) ) then begin
      _Node.ChildNodes.Nodes[Cst_Players].Text:= Edt_NbPlayers.Text;
      _Game.Players:= Edt_NbPlayers.Text;
   end;
   if not ( _Game.Developer.Equals( Edt_Developer.Text ) ) then begin
      _Node.ChildNodes.Nodes[Cst_Developer].Text:= Edt_Developer.Text;
      _Game.Developer:= Edt_Developer.Text;
   end;
   if not ( _Game.ReleaseDate.Equals( Edt_ReleaseDate.Text ) ) then begin
      _Date:= FormatDateFromString( Edt_ReleaseDate.Text, True );
      if not _Date.IsEmpty then
         _Game.ReleaseDate:= Edt_ReleaseDate.Text
      else begin
         _Game.ReleaseDate:= '';
         Edt_ReleaseDate.Text:= '';
      end;
      _Node.ChildNodes.Nodes[Cst_ReleaseDate].Text:= _Date;
   end;
   if not ( _Game.Publisher.Equals( Edt_Publisher.Text ) ) then begin
      _Node.ChildNodes.Nodes[Cst_Publisher].Text:= Edt_Publisher.Text;
      _Game.Publisher:= Edt_Publisher.Text;
   end;
   if not ( _Game.Description.Equals( Mmo_Description.Text ) ) then begin
      _Node.ChildNodes.Nodes[Cst_Description].Text:= Mmo_Description.Text;
      _Game.Description:= Mmo_Description.Text;
   end;
   if not ( _Game.Region.Equals( Edt_Region.Text ) ) then begin
      if not ( NodeExists( _Node, Cst_Region ) ) then begin
         _Node.AddChild( Cst_Region );
         _NodeAdded:= True;
      end;
      _Node.ChildNodes.Nodes[Cst_Region].Text:= Edt_Region.Text;
      _Game.Region:= Edt_Region.Text;
   end;
   if not ( _Game.Hidden = Cbx_Hidden.ItemIndex ) then begin
      if not ( NodeExists( _Node, Cst_Hidden ) ) then begin
         _Node.AddChild( Cst_Hidden );
         _NodeAdded:= True;
      end;
      if ( Cbx_Hidden.ItemIndex = 0 ) then _Node.ChildNodes.Nodes[Cst_Hidden].Text:= Cst_False
      else _Node.ChildNodes.Nodes[Cst_Hidden].Text:= Cst_True;
      _Game.Hidden:= Cbx_Hidden.ItemIndex;
   end;
   if not ( _Game.Favorite = Cbx_Favorite.ItemIndex ) then begin
      if not ( NodeExists( _Node, Cst_Favorite ) ) then begin
         _Node.AddChild( Cst_Favorite );
         _NodeAdded:= True;
      end;
      if ( Cbx_Favorite.ItemIndex = 0 ) then _Node.ChildNodes.Nodes[Cst_Favorite].Text:= Cst_False
      else _Node.ChildNodes.Nodes[Cst_Favorite].Text:= Cst_True;
      _Game.Favorite:= Cbx_Favorite.ItemIndex;
   end;

   //Et enfin on enregistre le fichier (en formatant correctement si on a ajouté un noeud)
   if _NodeAdded then begin
      Screen.Cursor:= crHourGlass;
      XMLDoc.XML.Text:= Xml.Xmldoc.FormatXMLData( XMLDoc.XML.Text );
      Screen.Cursor:= crDefault;
      XMLDoc.Active:= True;
   end;
   XMLDoc.SaveToFile( _GameListPath );
   XMLDoc.Active:= False;

   //si on a changé le nom du jeu, on rafraichit la liste
   if _NameChanged then  LoadGamesList( getCurrentFolderName );

end;

//Action au click sur le bouton delete this game
procedure TFrm_Editor.Btn_DeleteClick(Sender: TObject);
var
   _Index: Integer;
begin
   if FDelWoPrompt or
      ( MyMessageDlg( Rst_DeleteWarning, mtInformation,
                    [mbYes, mbNo], [Rst_Yes, Rst_No], Rst_Info ) = mrYes ) then begin
      //on mémorise l'index du listbox pour remettre à la fin
      _Index:= Lbx_Games.ItemIndex;
      //on supprime le jeu
      DeleteGame( ( Lbx_Games.Items.Objects[Lbx_Games.ItemIndex] as TGame ) );
      //et on remet la sélection sur le jeu précédent le supprimé( si possible )
      if ( ( _Index = 0 ) and ( Lbx_Games.Count = 0 ) ) or
         ( ( _Index > 1 ) and ( Lbx_Games.Count > 1 ) ) then
         Lbx_Games.ItemIndex:= Pred( _Index )
      else Lbx_Games.ItemIndex:= _Index;
      //et on charge les infos du jeu (si liste non vide)
      if ( Lbx_Games.Count > 0 ) then
         LoadGame( ( Lbx_Games.Items.Objects[Lbx_Games.ItemIndex] as TGame ) );
      Lbx_Games.SetFocus;
   end;
end;

//Au click sur le menu item delete orphans
procedure TFrm_Editor.Mnu_DeleteOrphansClick(Sender: TObject);
var
   _List: TObjectList<TGame>;
   ii: Integer;
begin
   //on boucle sur les jeux de la liste pour supprimer les orphelins.
   GSystemList.TryGetValue( getCurrentFolderName, _List );
   Screen.Cursor:= crHourGlass;
   ProgressBar.Visible:= True;
   ProgressBar.Max:= Pred( _List.Count );
   ProgressBar.Position:= 0;
   for ii:= Pred( _List.Count ) downto 0 do begin
      if _List.Items[ii].IsOrphan then
         DeleteGame( _List.Items[ii] );
      ProgressBar.Position:= ( ProgressBar.Position + 1);
   end;
   ProgressBar.Visible:= False;
   Screen.Cursor:= crDefault;
end;

//Supprime un jeu du gamelist et physiquement sur le disque (ou carte SD ou clé...)
procedure TFrm_Editor.DeleteGame( aGame: TGame );
var
   _Node: IXMLNode;
   _GameListPath: string;
   _List: TObjectList<TGame>;
begin
   //on construit le chemin vers le gamelist.xml
   _GameListPath:= FRootPath + FCurrentFolder + Cst_GameListFileName;

   //on chope la liste de jeux correspondante
   GSystemList.TryGetValue( getCurrentFolderName, _List );

    //On ouvre le fichier xml
    XMLDoc.LoadFromFile( _GameListPath );

    //On récupère le premier noeud "game"
    _Node := XMLDoc.DocumentElement.ChildNodes.FindNode( Cst_Game );

    //Et on boucle pour trouver le bon noeud
    repeat
       if ( _Node.ChildNodes.Nodes[Cst_Path].Text = aGame.RomPath ) then Break;
       _Node := _Node.NextSibling;
    until not Assigned( _Node );

    //on vire le noeud du fichier xml
    XMLDoc.DocumentElement.ChildNodes.Remove( _Node );
    XMLDoc.Active:= True;
    XMLDoc.SaveToFile( _GameListPath );
    XMLDoc.Active:= False;

    //On supprime l'image du jeu
    DeleteFile( aGame.PhysicalImagePath );

    //suppression du jeu physiquement (action spéciale pour PSX)
    if ( getSystemKind = skPS ) then begin
       DeleteFile( StringReplace( aGame.PhysicalRomPath, '.cue', '.bin', [rfReplaceAll] ) );
       DeleteFile( StringReplace( aGame.PhysicalRomPath, '.bin', '.cue', [rfReplaceAll] ) );
    end else
       DeleteFile( aGame.PhysicalRomPath );

    //Suppression du jeu dans sa liste mère
    _List.Remove( aGame );

    //et mise à jour de l'affichage du listbox pour prendre en compte la suppression
    LoadGamesList( getCurrentFolderName );
end;

//au click sur le menu itzm delete duplicates
procedure TFrm_Editor.Mnu_DeleteDuplicatesClick(Sender: TObject);
begin
   DeleteDuplicates( getCurrentFolderName );
end;

//Delete duplicates in the gamelist.xml
procedure TFrm_Editor.DeleteDuplicates( aSystem: string );
var
   _NodeList: IXMLNodeList;
   _Node1, _Node2: IXMLNode;
   ii, jj, Count: Integer;
   _List: TObjectList<TGame>;
   _GameListPath: string;
begin
   //on commence par vider les champs
   Lbx_Games.Clear;
   ClearAllFields;

   //on construit le chemin vers le gamelist.xml
   _GameListPath:= FRootPath + FCurrentFolder + Cst_GameListFileName;

   //On ouvre le fichier xml
   XMLDoc.LoadFromFile( _GameListPath );

   //on l'active
   XMLDoc.Active:= True;

   //On récupère la liste de noeuds "game"
   _NodeList:= XMLDoc.DocumentElement.ChildNodes;
   Count:= _NodeList.Count;

   //on active la progressbar
   Screen.Cursor:= crHourGlass;
   ProgressBar.Visible:= True;
   ProgressBar.Max:= Pred( Count );
   ProgressBar.Position:= 0;

   //on boucle sur tous les noeuds pour check si doublon
   //si c'est le cas on supprime
   for ii:= Pred( Count ) downto 0 do begin
      _Node1:= _NodeList.Nodes[ii];
      for jj:= 0 to Pred( ii ) do begin
         _Node2:= _NodeList.Nodes[jj];
         if ( _Node1.ChildNodes.FindNode( Cst_Path ).Text =
              _Node2.ChildNodes.FindNode( Cst_Path ).Text ) then begin
            _NodeList.Remove( _Node1 );
            Break;
         end;
      end;
      ProgressBar.Position:= ( ProgressBar.Position + 1 );
   end;

   //on désactive la progressbar
   ProgressBar.Visible:= False;

   //ensuite on sauvegarde le gamelist nettoyé
   XMLDoc.SaveToFile( _GameListPath );
   XMLDoc.Active:= False;

   //on supprime la liste de jeu de la liste générale des sytèmes
   //et on la reconstruit et ajoute
   GSystemList.Remove( aSystem );
   _List:= BuildGamesList( _GameListPath );
   GSystemList.Add( aSystem, _List );

   //on recharge la liste des jeux
   LoadGamesList( aSystem );
   Screen.Cursor:= crDefault;
end;

//Vidage de tous les champs et de l'image
procedure TFrm_Editor.ClearAllFields;
begin
   //On désactive les évènements sur les changements dans les champs
   FIsLoading:= True;

   Edt_Name.Text:= '';
   Edt_Rating.Text:= '';
   Edt_ReleaseDate.Text:= '';
   Edt_Publisher.Text:= '';
   Edt_Developer.Text:= '';
   Edt_NbPlayers.Text:= '';
   Edt_Genre.Text:= '';
   Edt_Region.Text:= '';
   Edt_RomPath.Text:= '';
   Mmo_Description.Text:= '';
   Img_Game.Picture.Graphic:= nil;
   Cbx_Hidden.ItemIndex:= -1;
   Cbx_Favorite.ItemIndex:= -1;

   //on remet les évènements sur les champs
   FIsLoading:= False;
end;

//Centralisation de l'évènement click sur checkbox
//(passage du champ correspondant en read/write)
procedure TFrm_Editor.ChkClick(Sender: TObject);
begin
   //Si la liste de jeux est vide, on sort
   if Lbx_Games.Items.Count = 0 then Exit;

   //On active le champ correspondant au checkbox coché ou non

   Edt_Name.ReadOnly:= not (Sender as TCheckBox).Checked;
   Edt_ReleaseDate.ReadOnly:= not (Sender as TCheckBox).Checked;
   Edt_NbPlayers.ReadOnly:= not (Sender as TCheckBox).Checked;
   Edt_Rating.ReadOnly:= not (Sender as TCheckBox).Checked;
   Edt_Publisher.ReadOnly:= not (Sender as TCheckBox).Checked;
   Edt_Developer.ReadOnly:= not (Sender as TCheckBox).Checked;
   Edt_Genre.ReadOnly:= not (Sender as TCheckBox).Checked;
   Mmo_Description.ReadOnly:= not (Sender as TCheckBox).Checked;
   Edt_Region.ReadOnly:= not (Sender as TCheckBox).Checked;
   Cbx_Hidden.Enabled:= (Sender as TCheckBox).Checked;
   Cbx_Favorite.Enabled:= (Sender as TCheckBox).Checked;

end;

//Au click sur le menuitem godmode on change la visibilité du bouton delete
procedure TFrm_Editor.Mnu_GodModeClick(Sender: TObject);
begin
   Btn_Delete.Visible:= Mnu_GodMode.Checked;
   FGodMode:= Mnu_GodMode.Checked;
   Mnu_DeleteWoPrompt.Enabled:= FGodMode;
   if not FGodMode then begin
      Mnu_DeleteWoPrompt.Checked:= False;
      FDelWoPrompt:= False;
   end;
end;

//au click sur le menu item use genesis logo
procedure TFrm_Editor.Mnu_GenesisClick(Sender: TObject);
var
   ii: Integer;
begin
   FGenesisLogo:= Mnu_Genesis.Checked;

   //on boucle sur les items du combo pour trouver le bon et changer son nom
   for ii:= 0 to Pred( Cbx_Systems.Items.Count ) do begin
      if ( ( Cbx_Systems.Items.Objects[ii] as TSystemKindObject).FSystemKind = skMegadrive ) then begin
         if FGenesisLogo then
            Cbx_Systems.Items[ii]:= Cst_SystemKindStr[skGenesis]
         else if not FGenesisLogo then
            Cbx_Systems.Items[ii]:= Cst_SystemKindStr[skMegaDrive];
         Break;
      end;
   end;

   //et on recharge la liste
   Cbx_Systems.ItemIndex:= ii;
   LoadGamesList( getCurrentFolderName );
end;

//Au click sur Menuitem autohash
procedure TFrm_Editor.Mnu_AutoHashClick(Sender: TObject);
begin
   FAutoHash:= Mnu_AutoHash.Checked;
end;

//Au click sur le menu item Del Without Prompt
procedure TFrm_Editor.Mnu_DeleteWoPromptClick(Sender: TObject);
begin
   FDelWoPrompt:= Mnu_DeleteWoPrompt.Checked;
end;

//au click sur le menu item configure SSH
procedure TFrm_Editor.Mnu_ConfigSSHClick(Sender: TObject);
var
   Frm_ConfigSSH: TFrm_ConfigureSSH;
begin
   //on affiche la fenêtre pour saisir les id de connexion SSH
   Frm_ConfigSSH:= TFrm_ConfigureSSH.Create( nil );
   try
      Frm_ConfigSSH.Execute( FRecalLogin, FRecalPwd, FRetroLogin, FRetroPwd );
   finally
      Frm_ConfigSSH.Free;
   end;
end;

//Au click sur menu item configure network
procedure TFrm_Editor.Mnu_ConfigureNetworkClick(Sender: TObject);
var
   Frm_Network: TFrm_Network;
begin
   //on affiche la fenêtre pour saisir les id screenscraper et proxy
   Frm_Network:= TFrm_Network.Create( nil );
   try
      Frm_Network.Execute( FSSLogin, FSSPwd, FProxyUser, FProxyPwd,
                           FProxyServer, FProxyPort, FProxyUse );
   finally
      Frm_Network.Free;
   end;
   ReloadIni;
end;

//permet de recharger certaines infos depuis le fichier ini
procedure TFrm_Editor.ReloadIni;
var
   FileIni: TIniFile;
begin
   FileIni:= TIniFile.Create( ExtractFilePath( Application.ExeName ) + Cst_IniFilePath );
   try
      FSSLogin:= FileIni.ReadString( Cst_IniOptions, Cst_IniSSUser, '');
      FSSPwd:= FileIni.ReadString( Cst_IniOptions, Cst_IniSSPwd, '');
      FProxyUser:= FileIni.ReadString( Cst_IniOptions, Cst_IniProxyUser, '');
      FProxyPwd:= FileIni.ReadString( Cst_IniOptions, Cst_IniProxyPwd, '');
      FProxyServer:= FileIni.ReadString( Cst_IniOptions, Cst_IniProxyServer, '');
      FProxyPort:= FileIni.ReadString( Cst_IniOptions, Cst_IniProxyPort, '');
      FProxyUse:= FileIni.ReadBool( Cst_IniOptions, Cst_IniProxyUse, False);
   finally
      FileIni.Free;
   end;
end;

//Au click sur le menu item convert to lower ou upper case (system)
procedure TFrm_Editor.ChangeCaseClick(Sender: TObject);
var
   _Game: TGame;
   ii: Integer;
   _List: TObjectList<TGame>;
begin
   GSystemList.TryGetValue( getCurrentFolderName, _List );

   Screen.Cursor:= crHourGlass;
   ProgressBar.Visible:= True;
   ProgressBar.Max:= Pred( _List.Count );
   ProgressBar.Position:= 0;
   for ii:= 0 to Pred( _List.Count ) do begin
      _Game:= ( Lbx_Games.Items.Objects[ii] as TGame );
      if ( ( sender as TMenuItem ).Tag = 10 ) then
         ConvertFieldsCase( _Game )
      else if ( ( sender as TMenuItem ).Tag = 11 ) then
         ConvertFieldsCase( _Game, False, True );
      ProgressBar.Position:= ( ProgressBar.Position + 1 );
   end;
   LoadGamesList( getCurrentFolderName );
   ProgressBar.Visible:= False;
   Screen.Cursor:= crDefault;
end;

//Au click sur le menu item convert to lower ou upper case (game)
procedure TFrm_Editor.ChangeCaseGameClick(Sender: TObject);
var
   _Game: TGame;
begin
   _Game:= ( Lbx_Games.Items.Objects[Lbx_Games.ItemIndex] as TGame );
   if ( ( sender as TMenuItem ).Tag = 12 ) then
      ConvertFieldsCase( _Game, True )
   else if ( ( sender as TMenuItem ).Tag = 13 ) then
      ConvertFieldsCase( _Game, True, True );
end;

//Permet de convertir les champs en majuscule ou minuscule en fonction
// des paramètres passés (fonctionne par systeme ou par jeu)
procedure TFrm_Editor.ConvertFieldsCase( aGame: TGame; aUnique: Boolean = False;
                                          aUp: Boolean = False );

   //rafraichit les données des champs EDIT dans le cas de modif d'un seul jeu
   procedure RefreshDisplay( aGame: TGame );
   begin
      Edt_Name.Text:= aGame.Name;
      Edt_Genre.Text:= aGame.Genre;
      Edt_Region.Text:= aGame.Region;
      Edt_Publisher.Text:= aGame.Publisher;
      Edt_Developer.Text:= aGame.Developer;
      Mmo_Description.Text:= aGame.Description;
      Lbx_Games.Items[Lbx_Games.ItemIndex]:= Edt_Name.Text;
   end;

   //factorisation de code
   function ConvertUpOrLow( aNode: IXMLNode; const aNodeName: string; aUp: Boolean; aField: string ): string;
   begin
      if aUp then begin
         Result:= UpperCase( aField );
      end else begin
         Result:= LowerCase( aField );
      end;
      if Assigned( aNode.ChildNodes.FindNode( aNodeName ) ) then
         aNode.ChildNodes.Nodes[aNodeName].Text:= Result;
   end;

var
   _Node: IXMLNode;
   _GameListPath: string;
begin
   //on construit le chemin vers le gamelist.xml
   _GameListPath:= FRootPath + FCurrentFolder + Cst_GameListFileName;

   //On ouvre le fichier xml
   XMLDoc.LoadFromFile( _GameListPath );

   //on l'active
   XMLDoc.Active:= True;

   //On récupère le premier noeud correspondant au jeu
   _Node := XMLDoc.DocumentElement.ChildNodes.FindNode( Cst_Game );

   //Et on boucle pour trouver le bon noeud
   repeat
      if ( _Node.ChildNodes.Nodes[Cst_Path].Text = aGame.RomPath ) then Break;
         _Node := _Node.NextSibling;
   until not Assigned( _Node );

   //on met à jour le xml et l'objet game
   aGame.Name:= ConvertUpOrLow( _Node, Cst_Name, aUp, aGame.Name );
   aGame.Region:= ConvertUpOrLow( _Node, Cst_Region, aUp, aGame.Region );
   aGame.Developer:= ConvertUpOrLow( _Node, Cst_Developer, aUp, aGame.Developer );
   aGame.Publisher:= ConvertUpOrLow( _Node, Cst_Publisher, aUp, aGame.Publisher );
   aGame.Genre:= ConvertUpOrLow( _Node, Cst_Genre, aUp, aGame.Genre );
   aGame.Description:= ConvertUpOrLow( _Node, Cst_Description, aUp, aGame.Description );

   //si maj d'un seul jeu on met à jour l'affichage du jeu
   if aUnique then RefreshDisplay( aGame );

   //on enregistre le fichier xml
   XMLDoc.SaveToFile( _GameListPath );
   XMLDoc.Active:= False;
end;

//Action au click sur menu item About
procedure TFrm_Editor.Mnu_AboutClick(Sender: TObject);
var
   Frm_About: TFrm_About;
begin
   //Affiche la fenêtre "About"
   Frm_About:= TFrm_About.Create(nil);
   try
      Frm_About.Execute;
   finally
      Frm_About.Free;
   end;
end;

//au click sur le menu item Help
procedure TFrm_Editor.Mnu_HelpClick(Sender: TObject);
var
   Frm_Help: TFrm_Help;
begin
   //Affiche la fenêtre "Help"
   Frm_Help:= TFrm_Help.Create(nil);
   Frm_Help.Chk_ShowTips.Visible:= False;
   try
      FShowTips:= Frm_Help.Execute( FShowTips);
   finally
      Frm_Help.Free;
   end;
end;

//au click sur le menu item disable pi prompts
procedure TFrm_Editor.Mnu_PiPromptsClick(Sender: TObject);
begin
   FPiPrompts:= Mnu_PiPrompts.Checked;
end;

//Sans ça pas de Ctrl+A dans le mémo...(c'est triste en 2017)
procedure TFrm_Editor.Mmo_DescriptionKeyPress(Sender: TObject; var Key: Char);
begin
   if ( Key = ^A ) then begin
      (Sender as TMemo).SelectAll;
       Key:= #0;
   end;
end;

//Click sur le bouton more infos pour afficher la fenêtre de complément d'infos
//sur le jeu sélectionné
procedure TFrm_Editor.Btn_MoreInfosClick(Sender: TObject);
var
   _Game: TGame;
   MoreInfos: TFrm_MoreInfos;
begin
   //on récupère le jeu sélectionné
   _Game:= TGame( Lbx_Games.Items.Objects[Lbx_Games.ItemIndex] );

   //On ajoute les hash si nécessaire.
   if ( ( _Game.Md5.IsEmpty ) or
        ( _Game.Sha1.IsEmpty ) or
        ( _Game.Crc32.IsEmpty ) ) then begin
      if FAutoHash or
         ( ( not FAutoHash ) and ( MyMessageDlg( Rst_HashWarning, mtInformation,
         [mbYes, mbNo], [Rst_Yes, Rst_No], Rst_Info ) = mrYes ) ) then begin

         _Game.Md5:= _Game.CalculateMd5( _Game.PhysicalRomPath );
         _Game.Sha1:= _Game.CalculateSha1( _Game.PhysicalRomPath );
         _Game.Crc32:= _Game.CalculateCrc32( _Game.PhysicalRomPath );
      end;
   end;

   //et on affiche la fenêtre
   MoreInfos:= TFrm_MoreInfos.Create( nil );
   try
      MoreInfos.Execute( _Game );
   finally
      MoreInfos.Free;
   end;
   Lbx_Games.SetFocus;
end;

//click sur le menu item remove region from games names
procedure TFrm_Editor.Mnu_RemoveRegionClick(Sender: TObject);
var
   ii, _Pos: Integer;
   _List: TObjectList<TGame>;
   _Game: TGame;
begin
   //on chope la liste de jeux
   GSystemList.TryGetValue( getCurrentFolderName, _List );

   Screen.Cursor:= crHourGlass;
   ProgressBar.Visible:= True;
   ProgressBar.Max:= Pred( _List.Count );
   ProgressBar.Position:= 0;

   //on boucle sur les jeux de la liste
   for ii:= 0 to Pred( _List.Count ) do begin
      _Game:= ( Lbx_Games.Items.Objects[ii] as TGame );
      _Pos:= Pos( '[', _Game.Name );

      //si on trouve le caractère, on traite
      if not ( _Pos = 0 ) then
         RemoveRegionFromGameName( _Game, Pred( _Pos ) );
      ProgressBar.Position:= ( ProgressBar.Position + 1 );
   end;
   LoadGamesList( getCurrentFolderName );
   ProgressBar.Visible:= False;
   Screen.Cursor:= crDefault;
   Lbx_Games.SetFocus;
end;

//au click sur le menu item ShowTips at start
procedure TFrm_Editor.Mnu_ShowTipsClick(Sender: TObject);
begin
   FShowTips:= Mnu_ShowTips.Checked;
end;

//supprime le tag entre [] de region dans le nom des jeux
procedure TFrm_Editor.RemoveRegionFromGameName( aGame: TGame; aStartPos: Integer );
var
   _Node: IXMLNode;
   _GameListPath, _Name: string;
   _EndPos: Integer;
begin
   //on construit le chemin vers le gamelist.xml
   _GameListPath:= FRootPath + FCurrentFolder + Cst_GameListFileName;

   //On ouvre le fichier xml
   XMLDoc.LoadFromFile( _GameListPath );

   //on l'active
   XMLDoc.Active:= True;

   //On récupère le premier noeud correspondant au jeu
   _Node := XMLDoc.DocumentElement.ChildNodes.FindNode( Cst_Game );

   //Et on boucle pour trouver le bon noeud
   repeat
      if ( _Node.ChildNodes.Nodes[Cst_Path].Text = aGame.RomPath ) then Break;
         _Node := _Node.NextSibling;
   until not Assigned( _Node );

   //on repère la position du caractère ]
   _EndPos:= Pos( ']', aGame.Name );

    //On met à jour l'objet TGame
    _Name:= aGame.Name;
    Delete( _Name, aStartPos,  Succ( _EndPos - aStartPos ) );
    aGame.Name:= _Name;

   //on change le text dans le xml
   _Node.ChildNodes.FindNode( Cst_Name ).Text:= aGame.Name;

   //on enregistre le fichier xml
   XMLDoc.SaveToFile( _GameListPath );
   XMLDoc.Active:= False;
end;

//choix du theme
procedure TFrm_Editor.Mnu_ThemeClick(Sender: TObject);
begin
   TStyleManager.TrySetStyle( Cst_ThemeNameStr[GetThemeEnum( ( Sender as TMenuItem).Tag )] );
   FThemeNumber:= ( Sender as TMenuItem ).Tag;
end;

//Choix de la langue
procedure TFrm_Editor.Mnu_LangClick(Sender: TObject);
var
   index, index2, index3: Integer;
   _TmpList: TObjectList<TGame>;
begin
   index:= Cbx_Filter.ItemIndex;
   index2:= Cbx_Hidden.ItemIndex;
   index3:= Cbx_Favorite.ItemIndex;
   UseLanguage( Cst_LangNameStr[GetLangEnum( ( Sender as TMenuItem).Tag )] );
   FLanguage:= ( Sender as TMenuItem ).Tag;
   RetranslateComponent( Self );
   Cbx_Filter.ItemIndex:= index;
   Cbx_Hidden.ItemIndex:= index2;
   Cbx_Favorite.ItemIndex:= index3;

   //On indique le nombre de jeux trouvés
   //Je suis obligé de refaire ça ici sinon le label reste sur l'ancienne langue
   //tant qu'on a pas changé de système (pas trouvé d'autre moyen)
   if ( Cbx_Systems.ItemIndex <> -1 ) then begin
      Lbl_NbGamesFound.Caption:= '';
      GSystemList.TryGetValue( getCurrentFolderName, _TmpList );
      if Cbx_Filter.ItemIndex = 0 then
         Lbl_NbGamesFound.Caption:= IntToStr( Lbx_Games.Items.Count ) + Rst_GamesFound
      else
         Lbl_NbGamesFound.Caption:= IntToStr( Lbx_Games.Items.Count ) + ' / ' +
                                    IntToStr( _TmpList.Count ) + Rst_GamesFound;
   end;
end;

//Click sur le menuitem "Quit"
procedure TFrm_Editor.Mnu_QuitClick(Sender: TObject);
begin
   //on save les options dans le ini
   SaveToIni;
   //si on a chargé au moins une fois le dossier depuis le bi, on reboot
   if FPiLoadedOnce then begin
      //on affiche ou non le prompt d'info reboot
      if not FPiPrompts then
         MyMessageDlg( Rst_RebootRecal, mtInformation, [mbOK], [Rst_Ok], Rst_Info );
      if FSysIsRecal then StopOrStartES( False, True )
      else StopOrStartES( False, False );
   end;
   Application.Terminate;
end;

//Juste avant la fermeture du programme, on sauvegarde les options dansle .INI
procedure TFrm_Editor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   //on save les options dans le ini
   SaveToIni;
   //si on a chargé au moins une fois le dossier depuis le bi, on reboot
   if FPiLoadedOnce then begin
      //on affiche ou non le prompt d'info reboot
      if not FPiPrompts then
         MyMessageDlg( Rst_RebootRecal, mtInformation, [mbOK], [Rst_Ok], Rst_Info );
      if FSysIsRecal then StopOrStartES( False, True )
      else StopOrStartES( False, False );
   end;
end;

//Nettoyage mémoire à la fermeture du programme
procedure TFrm_Editor.FormDestroy(Sender: TObject);
begin
   //Toutes les listes étant "owner" de leurs objets
   //un simple Free sur cette liste videra automatiquement les autres
   GSystemList.Free;
end;

end.
