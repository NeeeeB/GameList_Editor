unit Main;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes, System.IniFiles, System.Generics.Collections,
   System.DateUtils, System.RegularExpressions,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
   Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, Vcl.StdCtrls, Xml.Win.msxmldom, Winapi.msxml,
   Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, Vcl.Menus, Vcl.ComCtrls;

resourcestring
   Rst_NoValidFolder = 'No folder with gamelist.xml found';
   Rst_GamesFound = ' game(s) found.';

type
   TSystemKind = ( skNES,
                   skSNES,
                   skMasterSystem,
                   skMegaDrive,
                   skNeoGeo,
                   skCPC,
                   skAT2600,
                   skAT7800,
                   skATST,
                   skCS,
                   skFCD,
                   skFBA,
                   skFBALib,
                   skGW,
                   skGBC,
                   skGG,
                   skGB,
                   skGBA,
                   skIV,
                   skLU,
                   skLYNX,
                   skMAME,
                   skML,
                   skMSX,
                   skMSX1,
                   skMSX2,
                   skNGP,
                   skNGPC,
                   skN64,
                   skODY,
                   skPCE,
                   skPCECD,
                   skPS,
                   skPRB,
                   skSVM,
                   skS32X,
                   skSCD,
                   skSG1000,
                   skSGFX,
                   skVCX,
                   skVB,
                   skWS,
                   skWSC,
                   skZXS,
                   skZX81,
                   skAM1200,
                   skAM600,
                   skAPPLE,
                   skCV,
                   skC64,
                   skDB,
                   skDC,
                   skGC,
                   skPSP,
                   skWII );

   TSystemKindObject = class
   public
      FSystemKind: TSystemKind;
      constructor Create( const aName: string );
   end;

   TGame = class
   private
      FId: string;
      FRomName: string;
      FName: string;
      FDescription: string;
      FImagePath: string;
      FRating: string;
      FReleaseDate: string;
      FDeveloper: string;
      FPublisher: string;
      FGenre: string;
      FPlayers: string;
      procedure Load( aId, aPath, aName, aDescription, aImagePath, aRating,
                      aDeveloper, aPublisher, aGenre, aPlayers, aDate: string );
   public
      constructor Create( aId, aPath, aName, aDescription, aImagePath, aRating,
                          aDeveloper, aPublisher, aGenre, aPlayers, aDate: string ); reintroduce;
   end;

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
      Chk_Rating: TCheckBox;
      Chk_ReleaseDate: TCheckBox;
      Chk_Developer: TCheckBox;
      Chk_Publisher: TCheckBox;
      Chk_Genre: TCheckBox;
      Chk_NbPlayers: TCheckBox;
      Chk_Description: TCheckBox;
      Img_Game: TImage;
      Img_BackGround: TImage;
      Edt_Name: TEdit;
      Chk_Name: TCheckBox;
      MainMenu: TMainMenu;
      Mnu_File: TMenuItem;
      Mnu_Choosefolder: TMenuItem;
      Mnu_Quit: TMenuItem;
      Mnu_Actions: TMenuItem;
      Btn_SaveChanges: TButton;
      OpenFile: TOpenDialog;
      Btn_ChangeImage: TButton;
      Btn_SetDefaultPicture: TButton;
      Lbl_Info: TLabel;
      Btn_ChangeAll: TButton;
      Cbx_Filter: TComboBox;
      Lbl_Filter: TLabel;
      Img_Logo: TImage;
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
   private
      FRootPath: string;
      FRootRomsPath: string;
      FRootImagesPath: string;
      FXmlImagesPath: string;
      FXmlRomsPath: string;
      GSystemList: TObjectDictionary<string,TObjectList<TGame>>;
      procedure BuildSystemsList;
      function BuildGamesList( aPathToFile: string ): TObjectList<TGame>;
      procedure LoadGamesList( aSystem: string );
      procedure LoadGame( aGame: TGame );
      procedure ClearAllFields;
      function FormatDateFromString( aDate: string; aIso: Boolean = False ): string;
      procedure SaveChangesToGamelist;
      procedure EnableControls( aValue: Boolean );
      procedure SetCheckBoxes( aValue: Boolean );
      procedure SetFieldsReadOnly( aValue: Boolean );
      procedure CheckIfChangesToSave;
      procedure ChangeImage( aPath: string; aGame: TGame );
      function  getSystemKind: TSystemKind;
      function  getCurrentFolderName: string;
   end;

const
   Cst_Id = 'id';
   Cst_Path = 'path';
   Cst_Game = 'game';
   Cst_Name = 'name';
   Cst_Description = 'desc';
   Cst_ImageLink = 'image';
   Cst_Rating = 'rating';
   Cst_ReleaseDate = 'releasedate';
   Cst_Developer = 'developer';
   Cst_Publisher = 'publisher';
   Cst_Genre = 'genre';
   Cst_Players = 'players';
   Cst_GameListFileName = 'gamelist.xml';
   Cst_DateShortFill = '00';
   Cst_DateLongFill = '0000';
   Cst_DateSuffix = 'T000000';
   Cst_ImageSuffixPng = '-image.png';
   Cst_ImageSuffixJpg = '-image.jpg';
   Cst_ImageSuffixJpeg = '-image.jpeg';
   Cst_DefaultPicsFolderPath = 'Resources\DefaultPictures\';
   Cst_DefaultImageNameSuffix = '-default.png';
   Cst_PngExt = '.png';

var
   Frm_Editor: TFrm_Editor;

implementation

{$R *.dfm}

resourcestring
   Rst_SystemKindNES = 'Nintendo';
   Rst_SystemKindSNES = 'Super Nintendo';
   Rst_SystemKindMS = 'Master System';
   Rst_SystemKindMD = 'MegaDrive';
   Rst_SystemKindNEOGEO = 'Neo Geo';
   Rst_SystemKindCPC = 'Amstrad CPC';
   Rst_SystemKindAT2600 = 'Atari 2600';
   Rst_SystemKindAT7800 = 'Atari 7800';
   Rst_SystemKindATST = 'Atari ST';
   Rst_SystemKindCS = 'CaveStory';
   Rst_SystemKindFCD = 'Family Computer Disk';
   Rst_SystemKindFBA = 'Final Burn Alpha';
   Rst_SystemKindFBALib = 'Final Burn Alpha Libretro';
   Rst_SystemKindGW = 'Game & Watch';
   Rst_SystemKindGBC = 'Gameboy Color';
   Rst_SystemKindGG = 'Game Gear';
   Rst_SystemKindGB = 'Gameboy';
   Rst_SystemKindGBA = 'Gameboy Advance';
   Rst_SystemKindIV = 'Image Viewer';
   Rst_SystemKindLU = 'Lutro';
   Rst_SystemKindLYNX = 'Lynx';
   Rst_SystemKindMAME = 'Mame';
   Rst_SystemKindML = 'Moonlight';
   Rst_SystemKindMSX = 'MSX 1-2-2+';
   Rst_SystemKindMSX1 = 'MSX 1';
   Rst_SystemKindMSX2 = 'MSX 2+';
   Rst_SystemKindNGP = 'Neo Geo Pocket B&W';
   Rst_SystemKindNGPC = 'Neo Geo Pocket Color';
   Rst_SystemKindN64 = 'Nintendo 64';
   Rst_SystemKindODY = 'Odyssey 2';
   Rst_SystemKindPCE = 'PC Engine';
   Rst_SystemKindPCECD = 'PC Engine CD';
   Rst_SystemKindPS = 'Playstation';
   Rst_SystemKindPRB = 'PR Boom';
   Rst_SystemKindSVM = 'Scumm VM';
   Rst_SystemKindS32X = 'Sega 32X';
   Rst_SystemKindSCD = 'Sega CD';
   Rst_SystemKindSG1000 = 'Sega SG 1000';
   Rst_SystemKindSGFX = 'Supergrafx';
   Rst_SystemKindVCX = 'Vectrex';
   Rst_SystemKindVB = 'Virtual Boy';
   Rst_SystemKindWS = 'Wonderswan B&W';
   Rst_SystemKindWSC = 'Wonderswan Color';
   Rst_SystemKindZXS = 'ZX Spectrum';
   Rst_SystemKindZX81 = 'ZX81';
   Rst_SystemKindAM1200 = 'Amiga 1200';
   Rst_SystemKindAM600 = 'Amiga 600';
   Rst_SystemKindAPPLE = 'Apple II';
   Rst_SystemKindCV = 'Colecovision';
   Rst_SystemKindC64 = 'Commodore 64';
   Rst_SystemKindDB = 'DosBox';
   Rst_SystemKindDC = 'Dreamcast';
   Rst_SystemKindGC = 'Gamecube';
   Rst_SystemKindPSP = 'Playstation Portable';
   Rst_SystemKindWII = 'Wii';

const
   Cst_SystemKindStr: array[TSystemKind] of string =
    ( Rst_SystemKindNES,
      Rst_SystemKindSNES,
      Rst_SystemKindMS,
      Rst_SystemKindMD,
      Rst_SystemKindNEOGEO,
      Rst_SystemKindCPC,
      Rst_SystemKindAT2600,
      Rst_SystemKindAT7800,
      Rst_SystemKindATST,
      Rst_SystemKindCS,
      Rst_SystemKindFCD,
      Rst_SystemKindFBA,
      Rst_SystemKindFBALib,
      Rst_SystemKindGW,
      Rst_SystemKindGBC,
      Rst_SystemKindGG,
      Rst_SystemKindGB,
      Rst_SystemKindGBA,
      Rst_SystemKindIV,
      Rst_SystemKindLU,
      Rst_SystemKindLYNX,
      Rst_SystemKindMAME,
      Rst_SystemKindML,
      Rst_SystemKindMSX,
      Rst_SystemKindMSX1,
      Rst_SystemKindMSX2,
      Rst_SystemKindNGP,
      Rst_SystemKindNGPC,
      Rst_SystemKindN64,
      Rst_SystemKindODY,
      Rst_SystemKindPCE,
      Rst_SystemKindPCECD,
      Rst_SystemKindPS,
      Rst_SystemKindPRB,
      Rst_SystemKindSVM,
      Rst_SystemKindS32X,
      Rst_SystemKindSCD,
      Rst_SystemKindSG1000,
      Rst_SystemKindSGFX,
      Rst_SystemKindVCX,
      Rst_SystemKindVB,
      Rst_SystemKindWS,
      Rst_SystemKindWSC,
      Rst_SystemKindZXS,
      Rst_SystemKindZX81,
      Rst_SystemKindAM1200,
      Rst_SystemKindAM600,
      Rst_SystemKindAPPLE,
      Rst_SystemKindCV,
      Rst_SystemKindC64,
      Rst_SystemKindDB,
      Rst_SystemKindDC,
      Rst_SystemKindGC,
      Rst_SystemKindPSP,
      Rst_SystemKindWII );

   Cst_SystemKindFolderNames: array[TSystemKind] of string =
    ( 'nes',
      'snes',
      'mastersystem',
      'megadrive',
      'neogeo',
      'amstradcpc',
      'atari2600',
      'atari7800',
      'atarist',
      'cavestory',
      'fds',
      'fba',
      'fba_libretro',
      'gw',
      'gbc',
      'gamegear',
      'gb',
      'gba',
      'imageviewer',
      'lutro',
      'lynx',
      'mame',
      'moonlight',
      'msx',
      'msx1',
      'msx2',
      'ngp',
      'ngpc',
      'n64',
      'odyssey2',
      'pcengine',
      'pcenginecd',
      'psx',
      'prboom',
      'scummvm',
      'sega32x',
      'segacd',
      'sg1000',
      'supergrafx',
      'vectrex',
      'virtualboy',
      'wonderswan',
      'wonderswancolor',
      'zxspectrum',
      'z81',
      'amiga1200',
      'amiga600',
      'apple2',
      'colecovision',
      'c64',
      'pc',
      'dreamcast',
      'gc',
      'psp',
      'wii' );


   Cst_SystemKindImageNames: array[TSystemKind] of string =
    ( 'nes.png',
      'snes.png',
      'mastersystem.png',
      'megadrive.png',
      'neogeo.png',
      'amstradcpc.png',
      'atari2600.png',
      'atari7800.png',
      'atarist.png',
      'cavestory.png',
      'fds.png',
      'fba.png',
      'fba_libretro.png',
      'gw.png',
      'gbc.png',
      'gamegear.png',
      'gb.png',
      'gba.png',
      'imageviewer.png',
      'lutro.png',
      'lynx.png',
      'mame.png',
      'moonlight.png',
      'msx.png',
      'msx1.png',
      'msx2.png',
      'ngp.png',
      'ngpc.png',
      'n64.png',
      'odyssey2.png',
      'pcengine.png',
      'pcenginecd.png',
      'psx.png',
      'prboom.png',
      'scummvm.png',
      'sega32x.png',
      'segacd.png',
      'sg1000.png',
      'supergrafx.png',
      'vectrex.png',
      'virtualboy.png',
      'wonderswan.png',
      'wonderswancolor.png',
      'zxspectrum.png',
      'z81.png',
      'amiga1200.png',
      'amiga600.png',
      'apple2.png',
      'colecovision.png',
      'c64.png',
      'pc.png',
      'dreamcast.png',
      'gc.png',
      'psp.png',
      'wii.png' );


//Constructeur oject SystemKindObject
constructor TSystemKindObject.Create( const aName: string );
var
 _systemKind: TSystemKind;
begin
   for _systemKind:= Low( TSystemKind )to High( _systemKind ) do begin
      if ( Cst_SystemKindFolderNames[_systemKind] = aName ) then begin
         FSystemKind:= _systemKind;
         Break;
      end;
   end;
end;

//Constructeur de l'objet TGame
constructor TGame.Create( aId, aPath, aName, aDescription, aImagePath, aRating,
                          aDeveloper, aPublisher, aGenre, aPlayers, aDate: string );
begin
   Load( aId, aPath, aName, aDescription, aImagePath, aRating,
         aDeveloper, aPublisher, aGenre, aPlayers, aDate );
end;

//Chargement des attributs dans l'objet TGame
procedure TGame.Load( aId, aPath, aName, aDescription, aImagePath, aRating,
                      aDeveloper, aPublisher, aGenre, aPlayers, aDate: string );
begin
   FId:= aId;
   FRomName:= aPath;
   FName:= aName;
   FDescription:= aDescription;
   FImagePath:= aImagePath;
   FRating:= aRating;
   FReleaseDate:= aDate;
   FDeveloper:= aDeveloper;
   FPublisher:= aPublisher;
   FGenre:= aGenre;
   FPlayers:= aPlayers;
end;

//Formate correctement la date depuis la string récupérée du xml
//ou renvoie une date format Iso pour sauvegarde selon l'appel (aIso)
function TFrm_Editor.FormatDateFromString( aDate: string; aIso: Boolean = False ): string;
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

//A l'ouverture du programme
procedure TFrm_Editor.FormCreate(Sender: TObject);
begin
   Lbl_NbGamesFound.Caption:= '';
   GSystemList:= TObjectDictionary<string, TObjectList<TGame>>.Create([doOwnsValues]);
end;

//Action au click sur le menuitem "choose folder"
procedure TFrm_Editor.Mnu_ChoosefolderClick(Sender: TObject);
begin
   EnableControls( False );
   ClearAllFields;
   Lbx_Games.Items.Clear;
   BuildSystemsList;
   SetCheckBoxes( False );
   Btn_SaveChanges.Enabled:= False;
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
   //on met à vide tous les chemins
   FRootPath:= '';
   FRootRomsPath:= '';
   FRootImagesPath:= '';

   //On vide le combobox des systèmes
   //Et on désactive les Controls non nécessaires
   Cbx_Systems.Items.Clear;
   Cbx_Systems.Enabled:= False;
   Cbx_Filter.Enabled:= False;
   Lbx_Games.Enabled:= False;
   Lbl_SelectSystem.Enabled:= False;
   Lbl_Filter.Enabled:= False;
   Lbl_NbGamesFound.Caption:= '';
   Btn_ChangeAll.Enabled:= False;

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
      if not IsFound then
         ShowMessage( Rst_NoValidFolder );

      //On boucle sur les dossiers trouvés pour les lister
      while IsFound do begin

         //Si le dossier trouvé ne commence pas par un . et qu'il contient
         //bien un fichier gamelist.xml alors on crée la liste de jeux
         if ( (Info.Attr and faDirectory) <> 0 ) and
            ( Info.Name[1] <> '.' ) and
            ( FileExists( FRootPath + Info.Name + '\' + Cst_GameListFileName ) ) then begin

            //Ici on récupère le chemin vers le fichier gamelist.xml
            _GameListPath:= FRootPath + Info.Name + '\' + Cst_GameListFileName;

            //On tente de construire la liste des jeux depuis le .xml
            TmpList:= BuildGamesList( _GameListPath );

            //Si la liste n'est pas vide, on traite, sinon on zappe
            if Assigned( TmpList ) then begin

               //On construit la liste des jeux du système
               //et on joute le système à la liste globale de systèmes
               GSystemList.Add( Info.Name, TmpList );

               //On ajoute ensuite le nom du systeme au combobox des systemes trouvés
               _system:= TSystemKindObject.Create( Info.Name );
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
         ShowMessage( Rst_NoValidFolder );
         Exit;
      end;

      //On active le Combobox des systemes si au moins un systeme a été trouvé
      //Idem pour le listbox des jeux du systeme et on charge la liste du premier système
      if not ( ValidFolderCount = 0 ) then begin
         Cbx_Systems.Enabled:= True;
         Lbx_Games.Enabled:= Cbx_Systems.Enabled;
         Lbl_SelectSystem.Enabled:= Cbx_Systems.Enabled;
         Cbx_Filter.Enabled:= Cbx_Systems.Enabled;
         Lbl_Filter.Enabled:= Cbx_Systems.Enabled;
         Cbx_Systems.ItemIndex:= 0;
//         LoadGamesList( Cbx_Systems.Items[0] );
         LoadGamesList( getCurrentFolderName );
         EnableControls( True );
      end;

      //On remet le curseur par défaut
      Cursor:= crDefault;
   end;
end;

//Construction de la liste des jeux (objets) pour un systeme donné
function TFrm_Editor.BuildGamesList( aPathToFile: string ): TObjectList<TGame>;

   //Permet de s'assurer que le noeud cherché existe, et si ce n'est pas le cas
   //renvoie chaine vide, sinon renvoie la valeur texte du noeud
   function GetNodeValue( aNode: IXMLNode; aNodeName: string ): string;
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
   Cursor:= crHourGlass;

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
         _Game:= TGame.Create( _Node.AttributeNodes[Cst_Id].Text,
                               GetNodeValue( _Node, Cst_Path ),
                               GetNodeValue( _Node, Cst_Name ),
                               GetNodeValue( _Node,Cst_Description ),
                               GetNodeValue( _Node, Cst_ImageLink ),
                               GetNodeValue( _Node, Cst_Rating ),
                               GetNodeValue( _Node, Cst_Developer ),
                               GetNodeValue( _Node, Cst_Publisher ),
                               GetNodeValue( _Node, Cst_Genre ),
                               GetNodeValue( _Node, Cst_Players ),
                               FormatDateFromString( GetNodeValue( _Node, Cst_ReleaseDate ) ) );

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
   LoadGamesList( getCurrentFolderName );
end;

//Je fais une procédure juste pour activer les controls
//pour pas se les retaper à chaque changement d'état
procedure TFrm_Editor.EnableControls( aValue: Boolean );
begin
   Chk_Name.Enabled:= aValue;
   Chk_Genre.Enabled:= aValue;
   Chk_Rating.Enabled:= aValue;
   Chk_Developer.Enabled:= aValue;
   Chk_Publisher.Enabled:= aValue;
   Chk_NbPlayers.Enabled:= aValue;
   Chk_ReleaseDate.Enabled:= aValue;
   Chk_Description.Enabled:= aValue;
   Btn_ChangeImage.Enabled:= aValue;
   Btn_SetDefaultPicture.Enabled:= aValue;
   Lbl_Info.Enabled:= aValue;
end;

//Permet de tout cocher ou décocher les checkboxes d'un coup
procedure TFrm_Editor.SetCheckBoxes( aValue: Boolean );
begin
   Chk_Name.Checked:= aValue;
   Chk_Genre.Checked:= aValue;
   Chk_Rating.Checked:= aValue;
   Chk_Developer.Checked:= aValue;
   Chk_Publisher.Checked:= aValue;
   Chk_NbPlayers.Checked:= aValue;
   Chk_ReleaseDate.Checked:= aValue;
   Chk_Description.Checked:= aValue;
end;

//Repasse tous les champs en readonly ou non
procedure TFrm_Editor.SetFieldsReadOnly( aValue: Boolean );
begin
   Edt_Name.ReadOnly:= aValue;
   Edt_Genre.ReadOnly:= aValue;
   Edt_Rating.ReadOnly:= aValue;
   Edt_Developer.ReadOnly:= aValue;
   Edt_Publisher.ReadOnly:= aValue;
   Edt_NbPlayers.ReadOnly:= aValue;
   Edt_ReleaseDate.ReadOnly:= aValue;
   Mmo_Description.ReadOnly:= aValue;
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
   _Game:= ( Lbx_Games.Items.Objects[Lbx_Games.ItemIndex] as TGame );
   Btn_SaveChanges.Enabled:= not ( _Game.FName.Equals( Edt_Name.Text ) ) or
                             not ( _Game.FGenre.Equals( Edt_Genre.Text ) ) or
                             not ( _Game.FRating.Equals( Edt_Rating.Text ) ) or
                             not ( _Game.FPlayers.Equals( Edt_NbPlayers.Text ) ) or
                             not ( _Game.FDeveloper.Equals( Edt_Developer.Text ) ) or
                             not ( _Game.FPublisher.Equals( Edt_Publisher.Text ) ) or
                             not ( _Game.FReleaseDate.Equals( Edt_ReleaseDate.Text ) ) or
                             not ( _Game.FDescription.Equals( Mmo_Description.Text ) );
end;

//Chargement de la liste des jeux d'un système dans le listbox des jeux
procedure TFrm_Editor.LoadGamesList( aSystem: string );
var
   _PathFound: Boolean;

   //permet de récupérer le chemin vers les images (du xml)
   //et roms pour le système sélectionné
   procedure GetPaths( aGame: TGame );
   var
      Pos: Integer;
      tmpStr: string;
   begin
      Pos:= LastDelimiter( '/', aGame.FImagePath );
      FXmlImagesPath:= Copy( aGame.FImagePath, 1, Pos );
      Pos:= LastDelimiter( '/', aGame.FRomName );
      FXmlRomsPath:= Copy( aGame.FImagePath, 1, Pos );
      FRootRomsPath:= IncludeTrailingPathDelimiter( FRootPath +
                                                    getCurrentFolderName );
      tmpStr:= Copy( FXmlImagesPath, 1, Pred( FXmlImagesPath.Length ) );
      Pos:= LastDelimiter( '/', tmpStr );
      tmpStr:= Copy( FXmlImagesPath, Succ( Pos ), ( FXmlImagesPath.Length - Succ( Pos ) ) );
      FRootImagesPath:= IncludeTrailingPathDelimiter( FRootRomsPath + tmpStr );
   end;

   //Permet de vérifier si l'image existe "physiquement"
   //car il se peut que le lien soit renseigné mais que l'image
   //n'existe pas dans le dossier des images...
   function CheckIfImageMissing( aLink: string ): Boolean;
   var
      Pos: Integer;
      _ImagePath: string;
   begin
      Result:= True;
      Pos:= LastDelimiter( '/', aLink );
      _ImagePath:= FRootImagesPath + Copy( aLink, Succ( Pos ), ( aLink.Length - Pos ) );
      if FileExists( _ImagePath ) then Result:= False;
   end;

var
   _TmpList: TObjectList<TGame>;
   _TmpGame: TGame;
   _FilterIndex: Integer;
begin
   //on stocke le "numero" de filtre.
   _FilterIndex:= Cbx_Filter.ItemIndex;
   _PathFound:= False;

   //On essaye de récupérer la liste de jeux du système choisi
   if GSystemList.TryGetValue( aSystem, _TmpList ) then begin

      //On désactive les évènements sur les changements dans les champs
      //Sinon ça pète quand on change de système (indice hors limite)
      Edt_Name.OnChange:= nil;
      Edt_Rating.OnChange:= nil;
      Edt_ReleaseDate.OnChange:= nil;
      Edt_Genre.OnChange:= nil;
      Edt_Developer.OnChange:= nil;
      Edt_Publisher.OnChange:= nil;
      Edt_NbPlayers.OnChange:= nil;
      Mmo_Description.OnChange:= nil;

      //On commence par vider le listbox
      Lbx_Games.Items.Clear;

      //On boucle sur la liste de jeux pour ajouter les noms
      //dans le listbox de la liste des jeux
      for _TmpGame in _TmpList do begin

         //Récup du lien vers les images pour ce système (lien xml)
         if not ( _TmpGame.FImagePath.IsEmpty ) and
            not _PathFound then begin
            GetPaths( _TmpGame );
            _PathFound:= True;
         end;

         //Attention usine à gaz booléenne pour gérer les filtres ^^
         if ( _FilterIndex = 0 ) or
            ( ( _FilterIndex = 1 ) and ( CheckIfImageMissing( _TmpGame.FImagePath ) ) ) or
            ( ( _FilterIndex = 2 ) and ( _TmpGame.FReleaseDate.IsEmpty ) ) or
            ( ( _FilterIndex = 3 ) and ( _TmpGame.FPlayers.IsEmpty ) ) or
            ( ( _FilterIndex = 4 ) and ( _TmpGame.FRating.IsEmpty ) ) or
            ( ( _FilterIndex = 5 ) and ( _TmpGame.FDeveloper.IsEmpty ) ) or
            ( ( _FilterIndex = 6 ) and ( _TmpGame.FPublisher.IsEmpty ) ) or
            ( ( _FilterIndex = 7 ) and ( _TmpGame.FDescription.IsEmpty ) ) or
            ( ( _FilterIndex = 8 ) and ( _TmpGame.FGenre.IsEmpty ) ) then begin

            Lbx_Games.Items.AddObject( _TmpGame.FName, _TmpGame );
         end
      end;

      //On indique le nombre de jeux trouvés
      Lbl_NbGamesFound.Caption:= aSystem + ' : ' + IntToStr( Lbx_Games.Items.Count ) + Rst_GamesFound;

      //On met le focus sur le premier jeu de la liste
      ClearAllFields;
      Lbx_Games.SetFocus;

      //Si il y a des jeux dans la liste on affiche auto le premier
      if ( Lbx_Games.Items.Count > 0 ) then begin
         Lbx_Games.Selected[0]:= True;
         LoadGame( ( Lbx_Games.Items.Objects[0] as TGame ) );
         Btn_ChangeAll.Enabled:= ( Cbx_Filter.ItemIndex = 1 );
         EnableControls( True );
      end else begin
         Btn_ChangeAll.Enabled:= False;
         EnableControls( False );
      end;

      //on remet les évènements sur les champs
      Edt_Name.OnChange:= FieldChange;
      Edt_Rating.OnChange:= FieldChange;
      Edt_ReleaseDate.OnChange:= FieldChange;
      Edt_Genre.OnChange:= FieldChange;
      Edt_Developer.OnChange:= FieldChange;
      Edt_Publisher.OnChange:= FieldChange;
      Edt_NbPlayers.OnChange:= FieldChange;
      Mmo_Description.OnChange:= FieldChange;
   end;
end;

//Click sur un jeu dans la liste
procedure TFrm_Editor.Lbx_GamesClick(Sender: TObject);
begin
   ClearAllFields;
   SetCheckBoxes( False );
   LoadGame( ( Lbx_Games.Items.Objects[Lbx_Games.ItemIndex] as TGame ) )
end;

//Chargement dans les différents champs des infos du jeu sélectionné
procedure TFrm_Editor.LoadGame( aGame: TGame );
var
   _Image: TPngImage;
   _ImageJpg: TJPEGImage;
   _RawGameName, _PathToImage: string;
begin
   Edt_Name.Text:= aGame.FName;
   Edt_Rating.Text:= aGame.FRating;
   Edt_ReleaseDate.Text:= aGame.FReleaseDate;
   Edt_Publisher.Text:= aGame.FPublisher;
   Edt_Developer.Text:= aGame.FDeveloper;
   Edt_NbPlayers.Text:= aGame.FPlayers;
   Edt_Genre.Text:= aGame.FGenre;
   Mmo_Description.Text:= aGame.FDescription;

   //on récupère le nom brut du jeu pour construire le chemin vers l'image
   _RawGameName:= Copy( aGame.FRomName, 3, ( aGame.FRomName.Length - 2 ) );
   SetLength( _RawGameName, LastDelimiter( '.', _RawGameName ) - 1 );
   _PathToImage:= FRootImagesPath + _RawGameName;

   //si l'image existe (et chemin existe dans xml)
   //on la charge pour affichage (détection du format) sinon on laisse l'image par défaut
   if FileExists( _PathToImage + Cst_ImageSuffixPng ) and
      not ( aGame.FImagePath.IsEmpty ) then begin
      _Image:= TPngImage.Create;
      try
         _Image.LoadFromFile( _PathToImage + Cst_ImageSuffixPng );
         Img_Game.Picture.Graphic:= _Image;
         Exit;
      finally
         _Image.Free;
      end;
   end else if FileExists( _PathToImage + Cst_ImageSuffixJpg ) and
               not ( aGame.FImagePath.IsEmpty ) then begin
      _ImageJpg:= TJPEGImage.Create;
      try
         _ImageJpg.LoadFromFile( _PathToImage + Cst_ImageSuffixJpg );
         Img_Game.Picture.Graphic:= _ImageJpg;
         Exit;
      finally
         _ImageJpg.Free;
      end;
   end else if FileExists( _PathToImage + Cst_ImageSuffixJpeg ) and
               not ( aGame.FImagePath.IsEmpty ) then begin
      _ImageJpg:= TJPEGImage.Create;
      try
         _ImageJpg.LoadFromFile( _PathToImage + Cst_ImageSuffixJpeg );
         Img_Game.Picture.Graphic:= _ImageJpg;
         Exit;
      finally
         _ImageJpg.Free;
      end;
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
      LoadGamesList( getCurrentFolderName );
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
                   Cst_DefaultPicsFolderPath + '\' +
                   getCurrentFolderName +
                   Cst_DefaultImageNameSuffix;

   ChangeImage( PathToDefault, _Game );

   //on update la liste pour refléter les changements
   LoadGamesList( getCurrentFolderName );
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

   //et on boucle sur tous les jeux de la liste pour remplacer l'image
   for ii:= 0 to Pred( Lbx_Games.Items.Count ) do begin
      _Game:= ( Lbx_Games.Items.Objects[ii] as TGame );
      ChangeImage( PathToDefault, _Game );
   end;

   //on update la liste pour refléter les changements
   LoadGamesList( getCurrentFolderName );
end;

//Remplace l'image actuelle du jeu (par autre ou défaut).
procedure TFrm_Editor.ChangeImage( aPath: string; aGame: TGame );
var
   _Image: TPngImage;
   _ImageJpg: TJPEGImage;
   _GameName, _ImageLink: string;
   _Node: IXMLNode;

begin
   Cursor:= crHourGlass;

   //on récupère le nom du jeu pour construire le nom de l'image
   _GameName:= Copy( aGame.FRomName, 3, ( aGame.FRomName.Length - 2 ) );
   SetLength( _GameName, LastDelimiter( '.', _GameName ) - 1 );

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
   Img_Game.Picture.SaveToFile( FRootImagesPath + _GameName + Cst_ImageSuffixPng );

   //On ouvre le fichier xml
   XMLDoc.LoadFromFile( FRootRomsPath + Cst_GameListFileName );
   XMLDoc.Active:= True;

   //On récupère le premier noeud "game"
   _Node := XMLDoc.DocumentElement.ChildNodes.FindNode( Cst_Game );

   //Et on boucle pour trouver le noeud avec le bon Id
   repeat
      if ( _Node.AttributeNodes[Cst_Id].Text = aGame.FId ) then Break;
      _Node := _Node.NextSibling;
   until not Assigned( _Node );

   //on écrit le chemin vers l'image
   _ImageLink:= FXmlImagesPath + _GameName + Cst_ImageSuffixPng;
   _Node.ChildNodes.Nodes[Cst_ImageLink].Text:= _ImageLink;

   //On enregistre le fichier.
   XMLDoc.SaveToFile( FRootRomsPath + Cst_GameListFileName );
   XMLDoc.Active:= False;

   //Et enfin on met à jour l'objet TGame associé
   aGame.FImagePath:= _ImageLink;

   Cursor:= crDefault;
end;

function TFrm_Editor.getSystemKind: TSystemKind;
begin
   Result:= TSystemKindObject( Cbx_Systems.Items.Objects[Cbx_Systems.ItemIndex] ).FSystemKind;
end;

function TFrm_Editor.getCurrentFolderName: string;
begin
   Result:= Cst_SystemKindFolderNames[getSystemKind];
end;

//Action au click sur bouton "save changes"
procedure TFrm_Editor.Btn_SaveChangesClick(Sender: TObject);
begin
   SaveChangesToGamelist;
   LoadGamesList( getCurrentFolderName );
   SetCheckBoxes( False );
   SetFieldsReadOnly( True );
   Btn_SaveChanges.Enabled:= False;
end;

//Enregistre les changements effectués pour le jeu dans le fichier .xml
//et rafraichit le listbox si besoin
procedure TFrm_Editor.SaveChangesToGamelist;
var
   _Node: IXMLNode;
   _Game: TGame;
   _GameListPath, _Date: string;
begin
   //On récupère le chemin du fichier gamelist.xml
   _GameListPath:= FRootRomsPath + Cst_GameListFileName;

   //On récupère l'objet TGame qu'on souhaite modifier
   _Game:= ( Lbx_Games.Items.Objects[Lbx_Games.ItemIndex] as TGame );

   //On ouvre le fichier xml
   XMLDoc.LoadFromFile( _GameListPath );
   XMLDoc.Active:= True;

   //On récupère le premier noeud "game"
   _Node := XMLDoc.DocumentElement.ChildNodes.FindNode( Cst_Game );

   //Et on boucle pour trouver le noeud avec le bon Id
   repeat
      if ( _Node.AttributeNodes[Cst_Id].Text = _Game.FId ) then Break;
      _Node := _Node.NextSibling;
   until not Assigned( _Node );

   //On peut maintenant mettre les infos à jour dans le xml si besoin
   if not ( _Game.FName.Equals( Edt_Name.Text ) ) then begin
      _Node.ChildNodes.Nodes[Cst_Name].Text:= Edt_Name.Text;
      _Game.FName:= Edt_Name.Text;
      Lbx_Games.Items[Lbx_Games.ItemIndex]:= Edt_Name.Text;
   end;
   if not ( _Game.FGenre.Equals( Edt_Genre.Text ) ) then begin
      _Node.ChildNodes.Nodes[Cst_Genre].Text:= Edt_Genre.Text;
      _Game.FGenre:= Edt_Genre.Text;
   end;
   if not ( _Game.FRating.Equals( Edt_Rating.Text ) ) then begin
      _Node.ChildNodes.Nodes[Cst_Rating].Text:= Edt_Rating.Text;
      _Game.FRating:= Edt_Rating.Text;
   end;
   if not ( _Game.FPlayers.Equals( Edt_NbPlayers.Text ) ) then begin
      _Node.ChildNodes.Nodes[Cst_Players].Text:= Edt_NbPlayers.Text;
      _Game.FPlayers:= Edt_NbPlayers.Text;
   end;
   if not ( _Game.FDeveloper.Equals( Edt_Developer.Text ) ) then begin
      _Node.ChildNodes.Nodes[Cst_Developer].Text:= Edt_Developer.Text;
      _Game.FDeveloper:= Edt_Developer.Text;
   end;
   if not ( _Game.FReleaseDate.Equals( Edt_ReleaseDate.Text ) ) then begin
      _Date:= FormatDateFromString( Edt_ReleaseDate.Text, True );
      if not _Date.IsEmpty then
         _Game.FReleaseDate:= Edt_ReleaseDate.Text
      else begin
         _Game.FReleaseDate:= '';
         Edt_ReleaseDate.Text:= '';
      end;
      _Node.ChildNodes.Nodes[Cst_ReleaseDate].Text:= _Date;
   end;
   if not ( _Game.FPublisher.Equals( Edt_Publisher.Text ) ) then begin
      _Node.ChildNodes.Nodes[Cst_Publisher].Text:= Edt_Publisher.Text;
      _Game.FPublisher:= Edt_Publisher.Text;
   end;
   if not ( _Game.FDescription.Equals( Mmo_Description.Text ) ) then begin
      _Node.ChildNodes.Nodes[Cst_Description].Text:= Mmo_Description.Text;
      _Game.FDescription:= Mmo_Description.Text;
   end;

   //Et enfin on enregistre le fichier.
   XMLDoc.SaveToFile( _GameListPath );
   XMLDoc.Active:= False;
end;

//Vidage de tous les champs et de l'image
procedure TFrm_Editor.ClearAllFields;
begin
   Edt_Name.Text:= '';
   Edt_Rating.Text:= '';
   Edt_ReleaseDate.Text:= '';
   Edt_Publisher.Text:= '';
   Edt_Developer.Text:= '';
   Edt_NbPlayers.Text:= '';
   Edt_Genre.Text:= '';
   Mmo_Description.Text:= '';
   Img_Game.Picture.Graphic:= nil;
end;

//Centralisation de l'évènement click sur checkbox
//(passage du champ correspondant en read/write)
procedure TFrm_Editor.ChkClick(Sender: TObject);
begin
   //Si la liste de jeux est vide, on sort
   if Lbx_Games.Items.Count = 0 then Exit;

   //On active le champ correspondant au checkbox coché ou non
   case (Sender as TCheckBox).Tag of
      1: Edt_Name.ReadOnly:= not (Sender as TCheckBox).Checked;
      2: Edt_ReleaseDate.ReadOnly:= not (Sender as TCheckBox).Checked;
      3: Edt_NbPlayers.ReadOnly:= not (Sender as TCheckBox).Checked;
      4: Edt_Rating.ReadOnly:= not (Sender as TCheckBox).Checked;
      5: Edt_Publisher.ReadOnly:= not (Sender as TCheckBox).Checked;
      6: Edt_Developer.ReadOnly:= not (Sender as TCheckBox).Checked;
      7: Edt_Genre.ReadOnly:= not (Sender as TCheckBox).Checked;
      8: Mmo_Description.ReadOnly:= not (Sender as TCheckBox).Checked;
   end;
end;

//Sans ça pas de Ctrl+A dans le mémo...(c'est triste en 2017)
procedure TFrm_Editor.Mmo_DescriptionKeyPress(Sender: TObject; var Key: Char);
begin
   if ( Key = ^A ) then begin
      (Sender as TMemo).SelectAll;
       Key:= #0;
   end;
end;

//Click sur le menuitem "Quit"
procedure TFrm_Editor.Mnu_QuitClick(Sender: TObject);
begin
   Application.Terminate;
end;

//Nettoyage mémoire à la fermeture du programme
procedure TFrm_Editor.FormDestroy(Sender: TObject);
begin
   //Toutes les listes étant "owner" de leurs objets
   //un simple Free sur cette liste videra automatiquement les autres
   GSystemList.Free;
end;

end.
