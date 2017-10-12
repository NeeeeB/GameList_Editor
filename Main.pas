unit Main;

interface

uses
   Winapi.Windows, Winapi.Messages, Winapi.ShellAPI,
   System.SysUtils, System.Variants, System.Classes, System.IniFiles, System.Generics.Collections,
   System.RegularExpressions, System.UITypes, System.ImageList,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Styles, Vcl.Themes, Vcl.ImgList,
   Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls,
   Xml.omnixmldom, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, Xml.Win.msxmldom,
   IdHashMessageDigest, IdHashSHA, IdHashCRC,
   MoreInfos, About, Help, ConfigureSSH, gnugettext;

resourcestring
   Rst_WrongFolder = 'Oops !! It looks like you selected the wrong folder !' + SlineBreak +
                     'Please select the root folder where your systems folders are stored.';

   Rst_GamesFound = ' game(s) found.';

   Rst_HashWarning = 'Hashing a file can be extremly slow depending on' + sLineBreak +
                     'the file size, your computer, your HDD...' + sLineBreak +
                     'Do you want to hash anyway ?';

   Rst_DeleteWarning = 'This will delete the entry in the gamelist,' + sLinebreak +
                       'the rom itself and the associated image permanently.' + sLineBreak +
                       'Proceed anyway ?';

   Rst_StopES = 'Your systems folder seems to be located on your Pi.' + sLineBreak +
                'EmulationStation will be stopped for' + sLineBreak +
                'the gamelist.xml changes to take effect.';

   Rst_RebootRecal = 'Recalbox/Retropie will be restarted to reflect your changes.';

type
   //enumération pour les différents systèmes
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
                   skWII,
                   skGenesis );

   //enum noms des themes
   TThemeName = ( tnAmakrits,
                  tnAquaGraphite,
                  tnAquaLightSlate,
                  tnAuric,
                  tnCarbon,
                  tnCharcoalDarkSlate,
                  tnDiamond,
                  tnEmerald,
                  tnEmeraldLightSlate,
                  tnGlossy,
                  tnLight,
                  tnRubyGraphite,
                  tnSky,
                  tnVapor,
                  tnWindows10,
                  tnWindows10Dark,
                  tnWindowsBasic );

   //enum pour les langues
   TLangName = ( lnEnglish,
                 lnFrench,
                 lnGerman );

   //Objet stockant uniquement le type système (enum) pour
   //combobox systems, permet de retrouver facile l'image et le nom du systeme
   TSystemKindObject = class
   public
      FSystemKind: TSystemKind;
      constructor Create( const aName: string );
   end;

   TGame = class
   private

      FRomPath: string;
      FRomName: string;
      FRomNameWoExt: string;
      FPhysicalRomPath: string;
      FImagePath: string;
      FPhysicalImagePath: string;
      FName: string;
      FDescription: string;
      FRating: string;
      FReleaseDate: string;
      FDeveloper: string;
      FPublisher: string;
      FGenre: string;
      FPlayers: string;
      FRegion: string;
      FPlaycount: string;
      FLastplayed: string;
      FCrc32: string;
      FMd5: string;
      FSha1: string;
      FHidden: Integer;
      FFavorite: Integer;

      procedure Load( aPath, aName, aDescription, aImagePath, aRating,
                      aDeveloper, aPublisher, aGenre, aPlayers, aDate,
                      aRegion, aPlaycount, aLastplayed, aHidden, aFavorite: string );

      function GetRomName( const aRomPath: string ): string;
      function GetMd5( const aFileName: string ): string;
      function GetSha1( const aFileName: string ): string;
      function GetCrc32( const aFileName: string ): string;

   public

      constructor Create( aPath, aName, aDescription, aImagePath, aRating,
                          aDeveloper, aPublisher, aGenre, aPlayers, aDate,
                          aRegion, aPlaycount, aLastplayed, aHidden, aFavorite: string ); reintroduce;
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
      Btn_ChangeAll: TButton;
      Cbx_Filter: TComboBox;
      Lbl_Filter: TLabel;
      Img_Logo: TImage;
      Img_System: TImage;
      Chk_Region: TCheckBox;
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
      N2: TMenuItem;
      Mnu_Genesis: TMenuItem;
      Mnu_ShowTips: TMenuItem;
      Mnu_PiPrompts: TMenuItem;
      Mnu_SSH: TMenuItem;
      Mnu_ConfigSSH: TMenuItem;
      N3: TMenuItem;
      Chk_Hidden: TCheckBox;
      Chk_Favorite: TCheckBox;
      Cbx_Hidden: TComboBox;
      Cbx_Favorite: TComboBox;
      Mnu_Theme17: TMenuItem;
      N4: TMenuItem;
      Mnu_Language: TMenuItem;
      Mnu_Lang1: TMenuItem;
      Mnu_Lang2: TMenuItem;
      Edt_RomPath: TEdit;
    Mnu_Lang3: TMenuItem;

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
      GSystemList: TObjectDictionary<string,TObjectList<TGame>>;

      procedure LoadFromIni;
      procedure SaveToIni;
      procedure BuildSystemsList;
      procedure LoadGamesList( const aSystem: string );
      procedure LoadGame( aGame: TGame );
      procedure ClearAllFields;
      procedure SaveChangesToGamelist;
      procedure EnableControls( aValue: Boolean );
      procedure SetCheckBoxes( aValue: Boolean );
      procedure SetFieldsReadOnly( aValue: Boolean );
      procedure CheckIfChangesToSave;
      procedure ChangeImage( const aPath: string; aGame: TGame );
      procedure LoadSystemLogo( aPictureName: string );
      procedure DeleteGame;
      procedure DeleteGamePicture;
      procedure CheckMenuItem( aNumber: Integer; aLang: Boolean = False );
      procedure RemoveRegionFromGameName( aGame: TGame; aStartPos: Integer );
      procedure ConvertFieldsCase( aGame: TGame; aUnique: Boolean = False;
                                   aUp: Boolean = False );
      procedure StopOrStartES( aStop, aRecal: Boolean );

      function getSystemKind: TSystemKind;
      function getCurrentFolderName: string;
      function GetCurrentLogoName: string;
      function BuildGamesList( const aPathToFile: string ): TObjectList<TGame>;
      function FormatDateFromString( const aDate: string; aIso: Boolean = False ): string;
      function GetThemeEnum( aNumber: Integer ): TThemeName;
      function GetLangEnum( aNumber: Integer ): TLangName;
      function GetPhysicalRomPath( const aRomPath: string ): string;
      function GetPhysicalImagePath( const aImagePath: string ): string;

   end;

const
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
   Cst_Region = 'region';
   Cst_Playcount = 'playcount';
   Cst_LastPlayed = 'lastplayed';
   Cst_Hidden = 'hidden';
   Cst_Favorite = 'favorite';
   Cst_GameListFileName = 'gamelist.xml';
   Cst_DateShortFill = '00';
   Cst_DateLongFill = '0000';
   Cst_DateSuffix = 'T000000';
   Cst_ImageSuffixPng = '-image.png';
   Cst_ImageSuffixJpg = '-image.jpg';
   Cst_ImageSuffixJpeg = '-image.jpeg';
   Cst_DefaultPicsFolderPath = 'Resources\DefaultPictures\';
   Cst_DefaultImageNameSuffix = '-default.png';
   Cst_DefaultImageName = 'default.png';
   Cst_LogoPicsFolder = 'Resources\SystemsLogos\';
   Cst_IniFilePath = 'Resources\Settings.ini';
   Cst_ResourcesFolder = 'Resources\';
   Cst_IniOptions = 'Options';
   Cst_IniGodMode = 'GodMode';
   Cst_IniAutoHash = 'AutoHash';
   Cst_IniDelWoPrompt = 'DelWoPrompt';
   Cst_IniPiPrompts = 'PiPrompts';
   Cst_ShowTips = 'ShowTips';
   Cst_IniGenesisLogo = 'GenesisLogo';
   Cst_IniRecalLogin = 'SSHRecalLogin';
   Cst_IniRecalPwd = 'SSHRecalPwd';
   Cst_IniRetroLogin = 'SSHRetroLogin';
   Cst_IniRetroPwd = 'SSHRetroPwd';
   Cst_IniLanguage = 'Language';
   Cst_GenesisLogoName = 'genesis.png';
   Cst_ThemeNumber = 'ThemeNumber';
   Cst_MenuTheme = 'Mnu_Theme';
   Cst_MenuLang = 'Mnu_Lang';
   Cst_PlinkCommand = '/C plink -v ';
   Cst_PlinkCommandRecal = '@recalbox -pw ';
   Cst_PlinkCommandRetro = '@retropie -pw ';
   Cst_PlinkCommandStop = ' killall emulationstation';
   Cst_PlinkCommandStart = ' /sbin/reboot';
   Cst_RecalLogin = 'root';
   Cst_RecalPwd = 'recalboxroot';
   Cst_RetroLogin = 'pi';
   Cst_RetroPwd = 'raspberry';
   Cst_Recalbox = '\\RECALBOX';
   Cst_Retropie = '\\RETROPIE';
   Cst_True = 'true';
   Cst_False = 'false';

var
   Frm_Editor: TFrm_Editor;

implementation

{$R *.dfm}

resourcestring
   //noms des systemes tels qu'ils seront affichés dans la combobox
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
   Rst_SystemKindGenesis = 'Genesis';

const
   //tableau de liaison enum themes / noms themes
   Cst_ThemeNameStr: array[TThemeName] of string =
      ( 'Amakrits',
        'Aqua Graphite',
        'Aqua Light Slate',
        'Auric',
        'Carbon',
        'Charcoal Dark Slate',
        'Diamond',
        'Emerald',
        'Emerald Light Slate',
        'Glossy',
        'Light',
        'Ruby Graphite',
        'Sky',
        'Vapor',
        'Windows10',
        'Windows10 Dark',
        'Windows' );

   //tableau de liaison enum langues / noms langues
   Cst_LangNameStr: array[TLangName] of string =
      ( 'en',
        'fr',
        'de' );

   //tableau de liaison enum systemes / noms systems affichés
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
      Rst_SystemKindWII,
      Rst_SystemKindGenesis );

   //tableau de liaison enum systemes/nom des dossiers systeme
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
      'wii',
      'genesis' );

   //tableau de liaison enum systemes/nom image systeme
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
      'wii.png',
      'genesis.png' );


//Constructeur object SystemKindObject
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
constructor TGame.Create( aPath, aName, aDescription, aImagePath, aRating,
                          aDeveloper, aPublisher, aGenre, aPlayers, aDate,
                          aRegion, aPlaycount, aLastplayed, aHidden, aFavorite: string );
begin
   Load( aPath, aName, aDescription, aImagePath, aRating,
         aDeveloper, aPublisher, aGenre, aPlayers, aDate, aRegion, aPlaycount,
         aLastplayed, aHidden, aFavorite );
end;

//Chargement des attributs dans l'objet TGame
procedure TGame.Load( aPath, aName, aDescription, aImagePath, aRating,
                      aDeveloper, aPublisher, aGenre, aPlayers, aDate,
                      aRegion, aPlaycount, aLastplayed, aHidden, aFavorite: string );
begin
   FRomPath:= aPath;
   FRomName:= GetRomName( aPath );
   FRomNameWoExt:= ChangeFileExt( FRomName, '' );
   FPhysicalRomPath:= Frm_Editor.GetPhysicalRomPath( aPath );
   FImagePath:= aImagePath;
   FPhysicalImagePath:= Frm_Editor.GetPhysicalImagePath( aImagePath );
   FName:= aName;
   FDescription:= aDescription;
   FRating:= aRating;
   FReleaseDate:= aDate;
   FDeveloper:= aDeveloper;
   FPublisher:= aPublisher;
   FGenre:= aGenre;
   FPlayers:= aPlayers;
   FRegion:= aRegion;
   FPlaycount:= aPlaycount;
   FLastplayed:= aLastplayed;
   if ( aHidden = Cst_True ) then FHidden:= 1
   else FHidden:= 0;
   if ( aFavorite = Cst_True ) then FFavorite:= 1
   else FFavorite:= 0;
end;

//Fonction permettant de récupérer le nom de la rom avec son extension
function TGame.GetRomName( const aRomPath: string ): string;
var
   _Pos: Integer;
begin
   _Pos:= LastDelimiter( '/', aRomPath );
   Result:= Copy( aRomPath, Succ( _Pos ), ( aRomPath.Length - _Pos ) );
end;

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

//Fonction permettant de récupérer le MD5 des roms
function TGame.GetMd5( const aFileName: string ): string;
var
   IdMD5: TIdHashMessageDigest5;
   FS: TFileStream;
begin
   if FileExists( aFileName ) then begin
      IdMD5:= TIdHashMessageDigest5.Create;
      FS:= TFileStream.Create( aFileName, fmOpenRead or fmShareDenyWrite );
      try
         Result:= IdMD5.HashStreamAsHex(FS)
      finally
         FS.Free;
         IdMD5.Free;
      end;
   end;
end;

//fonction permettant de récupérer le SHA1 des roms
function TGame.GetSha1( const aFileName: string ): string;
var
   IdSHA1: TIdHashSHA1;
   FS: TFileStream;
begin
   if FileExists( aFileName ) then begin
      IdSHA1:= TIdHashSHA1.Create;
      FS:= TFileStream.Create( aFileName, fmOpenRead or fmShareDenyWrite );
      try
         Result:= IdSHA1.HashStreamAsHex(FS)
      finally
         FS.Free;
         IdSHA1.Free;
      end;
   end;
end;

//fonction permettant de récupérer le SHA1 des roms
function TGame.GetCrc32( const aFileName: string ): string;
var
   IdCRC32: TIdHashCRC32;
   FS: TFileStream;
begin
   if FileExists( aFileName ) then begin
      IdCRC32:= TIdHashCRC32.Create;
      FS:= TFileStream.Create( aFileName, fmOpenRead or fmShareDenyWrite );
      try
         Result:= IdCRC32.HashStreamAsHex(FS)
      finally
         FS.Free;
         IdCRC32.Free;
      end;
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
   ClearAllFields;
   Lbx_Games.Items.Clear;
   BuildSystemsList;
   SetCheckBoxes( False );
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
               MessageDlg( Rst_StopES, mtInformation, [mbOK], 0, mbOK );
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
   Chk_Region.Enabled:= aValue;
   Chk_Hidden.Enabled:= aValue;
   Chk_Favorite.Enabled:= aValue;
   Btn_ChangeImage.Enabled:= aValue;
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
   Cbx_Hidden.Enabled:= not aValue;
   Cbx_Favorite.Enabled:= not aValue;
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
   Chk_Region.Checked:= aValue;
   Chk_Hidden.Checked:= aValue;
   Chk_Favorite.Checked:= aValue;
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
   Edt_Region.ReadOnly:= aValue;
   Mmo_Description.ReadOnly:= aValue;
   Cbx_Hidden.Enabled:= not aValue;
   Cbx_Favorite.Enabled:= not aValue;
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
   Btn_SaveChanges.Enabled:= not ( _Game.FName.Equals( Edt_Name.Text ) ) or
                             not ( _Game.FGenre.Equals( Edt_Genre.Text ) ) or
                             not ( _Game.FRating.Equals( Edt_Rating.Text ) ) or
                             not ( _Game.FPlayers.Equals( Edt_NbPlayers.Text ) ) or
                             not ( _Game.FDeveloper.Equals( Edt_Developer.Text ) ) or
                             not ( _Game.FPublisher.Equals( Edt_Publisher.Text ) ) or
                             not ( _Game.FReleaseDate.Equals( Edt_ReleaseDate.Text ) ) or
                             not ( _Game.FDescription.Equals( Mmo_Description.Text ) ) or
                             not ( _Game.FRegion.Equals( Edt_Region.Text ) ) or
                             not ( _Game.FHidden = Cbx_Hidden.ItemIndex ) or
                             not ( _Game.FFavorite = Cbx_Favorite.ItemIndex );
end;

//Chargement de la liste des jeux d'un système dans le listbox des jeux
procedure TFrm_Editor.LoadGamesList( const aSystem: string );

   //permet de récupérer le chemin vers les images (du xml)
   procedure GetImageFolder( aGame: TGame );
   var
      StartPos, EndPos: Integer;
   begin
      StartPos:= Succ( Pos( '/', aGame.FImagePath ) );
      EndPos:= LastDelimiter( '/', aGame.FImagePath );
      FImageFolder:= Copy( aGame.FImagePath, StartPos, ( EndPos - StartPos ) );

      FXmlImageFolderPath:= Copy( aGame.FImagePath, 1, EndPos );
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
         if not ( _TmpGame.FImagePath.IsEmpty ) and
            not _FolderFound then begin
            GetImageFolder( _TmpGame );
            _FolderFound:= True;
         end;

         //Attention usine à gaz booléenne pour gérer les filtres ^^
         if ( _FilterIndex = 0 ) or
            ( ( _FilterIndex = 1 ) and ( CheckIfImageMissing( _TmpGame.FPhysicalImagePath ) ) ) or
            ( ( _FilterIndex = 2 ) and ( _TmpGame.FReleaseDate.IsEmpty ) ) or
            ( ( _FilterIndex = 3 ) and ( _TmpGame.FPlayers.IsEmpty ) ) or
            ( ( _FilterIndex = 4 ) and ( _TmpGame.FRating.IsEmpty ) ) or
            ( ( _FilterIndex = 5 ) and ( _TmpGame.FDeveloper.IsEmpty ) ) or
            ( ( _FilterIndex = 6 ) and ( _TmpGame.FPublisher.IsEmpty ) ) or
            ( ( _FilterIndex = 7 ) and ( _TmpGame.FDescription.IsEmpty ) ) or
            ( ( _FilterIndex = 8 ) and ( _TmpGame.FGenre.IsEmpty ) ) or
            ( ( _FilterIndex = 9 ) and ( _TmpGame.FRegion.IsEmpty ) ) or
            ( ( _FilterIndex = 10 ) and ( _TmpGame.FHidden = 1 ) ) or
            ( ( _FilterIndex = 11 ) and ( _TmpGame.FFavorite = 1 ) ) then begin

            Lbx_Games.Items.AddObject( _TmpGame.FName, _TmpGame );
         end
      end;

      //On indique le nombre de jeux trouvés
      if Cbx_Filter.ItemIndex = 0 then
         Lbl_NbGamesFound.Caption:= IntToStr( _TmpList.Count ) + Rst_GamesFound
      else
         Lbl_NbGamesFound.Caption:= IntToStr( Lbx_Games.Items.Count ) + ' / ' +
                                    IntToStr( _TmpList.Count ) + Rst_GamesFound;

      //On met le focus sur le premier jeu de la liste
      ClearAllFields;
      Lbx_Games.SetFocus;

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
   SetCheckBoxes( False );
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
   Edt_Name.Text:= aGame.FName;
   Edt_Rating.Text:= aGame.FRating;
   Edt_ReleaseDate.Text:= aGame.FReleaseDate;
   Edt_Publisher.Text:= aGame.FPublisher;
   Edt_Developer.Text:= aGame.FDeveloper;
   Edt_NbPlayers.Text:= aGame.FPlayers;
   Edt_Genre.Text:= aGame.FGenre;
   Mmo_Description.Text:= aGame.FDescription;
   Edt_Region.Text:= aGame.FRegion;
   Cbx_Hidden.ItemIndex:= aGame.FHidden;
   Cbx_Favorite.ItemIndex:= aGame.FFavorite;
   Edt_RomPath.Text:= aGame.FRomPath;

   //on remet les évènements sur les champs
   FIsLoading:= False;

   if not ( aGame.FImagePath.IsEmpty ) and
          FileExists( aGame.FPhysicalImagePath ) then begin
      if ( ExtractFileExt( aGame.FPhysicalImagePath ) = '.png' ) then begin
         _Image:= TPngImage.Create;
         try
            _Image.LoadFromFile( aGame.FPhysicalImagePath );
            Img_Game.Picture.Graphic:= _Image;
            Btn_RemovePicture.Enabled:= True;
            //on affiche l'image background que si le jeu n'a pas d'image
            Img_BackGround.Visible:= ( Img_Game.Picture.Graphic = nil );
            Exit;
         finally
            _Image.Free;
         end;
      end else if ( ExtractFileExt( aGame.FPhysicalImagePath ) = '.jpg' ) or
                  ( ExtractFileExt( aGame.FPhysicalImagePath ) = '.jpeg' ) then begin
         _ImageJpg:= TJPEGImage.Create;
         try
            _ImageJpg.LoadFromFile( aGame.FPhysicalImagePath );
            Img_Game.Picture.Graphic:= _ImageJpg;
            Btn_RemovePicture.Enabled:= True;
            //on affiche l'image background que si le jeu n'a pas d'image
            Img_BackGround.Visible:= ( Img_Game.Picture.Graphic = nil );
            Exit;
         finally
            _ImageJpg.Free;
         end;
      end;
   end else
      Btn_RemovePicture.Enabled:= False;
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
                                '\' + aGame.FRomNameWoExt + Cst_ImageSuffixPng );

   //On ouvre le fichier xml
   XMLDoc.LoadFromFile( FRootPath + FCurrentFolder + Cst_GameListFileName );

   //On récupère le premier noeud "game"
   _Node := XMLDoc.DocumentElement.ChildNodes.FindNode( Cst_Game );

   //Et on boucle pour trouver le noeud avec le bon Id
   repeat
      if ( _Node.ChildNodes.Nodes[Cst_Path].Text = aGame.FRomPath ) then Break;
      _Node := _Node.NextSibling;
   until not Assigned( _Node );

   //on écrit le chemin vers l'image
   _ImageLink:= FXmlImageFolderPath + aGame.FRomNameWoExt + Cst_ImageSuffixPng;

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
   aGame.FImagePath:= _ImageLink;
   aGame.FPhysicalImagePath:= FRootPath + FCurrentFolder +
                              IncludeTrailingPathDelimiter( FImageFolder ) +
                              aGame.FRomNameWoExt + Cst_ImageSuffixPng;

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
      if ( _Node.ChildNodes.Nodes[Cst_Path].Text = _Game.FRomPath ) then Break;
         _Node := _Node.NextSibling;
   until not Assigned( _Node );

   //on vire le noeud du fichier xml
   _Node.ChildNodes.FindNode( Cst_ImageLink ).Text:= '';
   XMLDoc.Active:= True;
   XMLDoc.SaveToFile( _GameListPath );
   XMLDoc.Active:= False;

   //On supprime l'image du jeu
   DeleteFile( _Game.FPhysicalImagePath );

   //on vide l'image jeu
   Img_Game.Picture.Graphic:= nil;

   //on update l'objet TGame
   _Game.FImagePath:= '';

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

//Action au click sur bouton "save changes"
procedure TFrm_Editor.Btn_SaveChangesClick(Sender: TObject);
begin
   SaveChangesToGamelist;
   SetCheckBoxes( False );
   SetFieldsReadOnly( True );
   Btn_SaveChanges.Enabled:= False;
   Lbx_Games.SetFocus;
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
      if ( _Node.ChildNodes.Nodes[Cst_Path].Text = _Game.FRomPath ) then Break;
      _Node := _Node.NextSibling;
   until not Assigned( _Node );

   //On peut maintenant mettre les infos à jour dans le xml si besoin
   if not ( _Game.FName.Equals( Edt_Name.Text ) ) then begin
      _Node.ChildNodes.Nodes[Cst_Name].Text:= Edt_Name.Text;
      _Game.FName:= Edt_Name.Text;
      Lbx_Games.Items[Lbx_Games.ItemIndex]:= Edt_Name.Text;
      _NameChanged:= True;
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
   if not ( _Game.FRegion.Equals( Edt_Region.Text ) ) then begin
      if not ( NodeExists( _Node, Cst_Region ) ) then begin
         _Node.AddChild( Cst_Region );
         _NodeAdded:= True;
      end;
      _Node.ChildNodes.Nodes[Cst_Region].Text:= Edt_Region.Text;
      _Game.FRegion:= Edt_Region.Text;
   end;
   if not ( _Game.FHidden = Cbx_Hidden.ItemIndex ) then begin
      if not ( NodeExists( _Node, Cst_Hidden ) ) then begin
         _Node.AddChild( Cst_Hidden );
         _NodeAdded:= True;
      end;
      if ( Cbx_Hidden.ItemIndex = 0 ) then _Node.ChildNodes.Nodes[Cst_Hidden].Text:= Cst_False
      else _Node.ChildNodes.Nodes[Cst_Hidden].Text:= Cst_True;
      _Game.FHidden:= Cbx_Hidden.ItemIndex;
   end;
   if not ( _Game.FFavorite = Cbx_Favorite.ItemIndex ) then begin
      if not ( NodeExists( _Node, Cst_Favorite ) ) then begin
         _Node.AddChild( Cst_Favorite );
         _NodeAdded:= True;
      end;
      if ( Cbx_Favorite.ItemIndex = 0 ) then _Node.ChildNodes.Nodes[Cst_Favorite].Text:= Cst_False
      else _Node.ChildNodes.Nodes[Cst_Favorite].Text:= Cst_True;
      _Game.FFavorite:= Cbx_Favorite.ItemIndex;
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
begin
   if FDelWoPrompt or
      ( MessageDlg( Rst_DeleteWarning, mtInformation,
                    [mbYes, mbNo], 0, mbNo ) = mrYes ) then
      DeleteGame;
   Lbx_Games.SetFocus;
end;

//Supprime un jeu du gamelist et physiquement sur le disque (ou carte SD ou clé...)
procedure TFrm_Editor.DeleteGame;
var
   _Game: TGame;
   _Node: IXMLNode;
   _GameListPath: string;
   _List: TObjectList<TGame>;
begin
   //on récupère le jeu sélectionné
   _Game:= ( Lbx_Games.Items.Objects[Lbx_Games.ItemIndex] as TGame );

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
       if ( _Node.ChildNodes.Nodes[Cst_Path].Text = _Game.FRomPath ) then Break;
       _Node := _Node.NextSibling;
    until not Assigned( _Node );

    //on vire le noeud du fichier xml
    XMLDoc.DocumentElement.ChildNodes.Remove( _Node );
    XMLDoc.Active:= True;
    XMLDoc.SaveToFile( _GameListPath );
    XMLDoc.Active:= False;

    //On supprime l'image du jeu
    DeleteFile( _Game.FPhysicalImagePath );

    //suppression du jeu physiquement
    DeleteFile( _Game.FPhysicalRomPath );

    //Suppression du jeu dans sa liste mère
    _List.Remove( _Game );

    //et mise à jour de l'affichage du listbox pour prendre en compte la suppression
    LoadGamesList( getCurrentFolderName );
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
   case (Sender as TCheckBox).Tag of
      1: Edt_Name.ReadOnly:= not (Sender as TCheckBox).Checked;
      2: Edt_ReleaseDate.ReadOnly:= not (Sender as TCheckBox).Checked;
      3: Edt_NbPlayers.ReadOnly:= not (Sender as TCheckBox).Checked;
      4: Edt_Rating.ReadOnly:= not (Sender as TCheckBox).Checked;
      5: Edt_Publisher.ReadOnly:= not (Sender as TCheckBox).Checked;
      6: Edt_Developer.ReadOnly:= not (Sender as TCheckBox).Checked;
      7: Edt_Genre.ReadOnly:= not (Sender as TCheckBox).Checked;
      8: Mmo_Description.ReadOnly:= not (Sender as TCheckBox).Checked;
      9: Edt_Region.ReadOnly:= not (Sender as TCheckBox).Checked;
      10: Cbx_Hidden.Enabled:= (Sender as TCheckBox).Checked;
      11: Cbx_Favorite.Enabled:= (Sender as TCheckBox).Checked;
   end;
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
      Edt_Name.Text:= aGame.FName;
      Edt_Genre.Text:= aGame.FGenre;
      Edt_Region.Text:= aGame.FRegion;
      Edt_Publisher.Text:= aGame.FPublisher;
      Edt_Developer.Text:= aGame.FDeveloper;
      Mmo_Description.Text:= aGame.FDescription;
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
      if ( _Node.ChildNodes.Nodes[Cst_Path].Text = aGame.FRomPath ) then Break;
         _Node := _Node.NextSibling;
   until not Assigned( _Node );

   //on met à jour le xml et l'objet game
   aGame.FName:= ConvertUpOrLow( _Node, Cst_Name, aUp, aGame.FName );
   aGame.FRegion:= ConvertUpOrLow( _Node, Cst_Region, aUp, aGame.FRegion );
   aGame.FDeveloper:= ConvertUpOrLow( _Node, Cst_Developer, aUp, aGame.FDeveloper );
   aGame.FPublisher:= ConvertUpOrLow( _Node, Cst_Publisher, aUp, aGame.FPublisher );
   aGame.FGenre:= ConvertUpOrLow( _Node, Cst_Genre, aUp, aGame.FGenre );
   aGame.FDescription:= ConvertUpOrLow( _Node, Cst_Description, aUp, aGame.FDescription );

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
   _Infos: TStringList;
   _Game: TGame;
   MoreInfos: TFrm_MoreInfos;
   _PathToRom: string;
begin
   //on crée une liste avec les infos à afficher
   _Infos:= TStringList.Create;
   try
      //on récupère le jeu sélectionné
      _Game:= TGame( Lbx_Games.Items.Objects[Lbx_Games.ItemIndex] );
      _PathToRom:= FRootPath + getCurrentFolderName + '\' + _Game.FRomName;

      //On ajoute les hash si nécessaire.
      if ( ( _Game.FMd5.IsEmpty ) or
           ( _Game.FSha1.IsEmpty ) or
           ( _Game.FCrc32.IsEmpty ) ) then begin
         if FAutoHash or
            ( ( not FAutoHash ) and ( MessageDlg( Rst_HashWarning, mtInformation,
            [mbYes, mbNo], 0, mbNo ) = mrYes ) ) then begin

            _Game.FMd5:= _Game.GetMd5( _PathToRom );
            _Game.FSha1:= _Game.GetSha1( _PathToRom );
            _Game.FCrc32:= _Game.GetCrc32( _PathToRom );
         end;
      end;

      //on remplit la liste avec les infos dont on a besoin
      _Infos.Add( _Game.FPlaycount );
      _Infos.Add( _Game.FLastplayed );
      _Infos.Add( _Game.FCrc32 );
      _Infos.Add( _Game.FMd5 );
      _Infos.Add( _Game.FSha1 );

      //et on affiche la fenêtre
      MoreInfos:= TFrm_MoreInfos.Create( nil );
      try
         MoreInfos.Execute( _Infos );
      finally
         MoreInfos.Free;
      end;
   finally
      //Ensuite on supprime la liste
      _Infos.Free;
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
      _Pos:= Pos( '[', _Game.FName );

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
   _GameListPath: string;
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
      if ( _Node.ChildNodes.Nodes[Cst_Path].Text = aGame.FRomPath ) then Break;
         _Node := _Node.NextSibling;
   until not Assigned( _Node );

   //on repère la position du caractère ]
   _EndPos:= Pos( ']', aGame.FName );

    //On met à jour l'objet TGame
    Delete( aGame.FName, aStartPos,  Succ( _EndPos - aStartPos ) );

   //on change le text dans le xml
   _Node.ChildNodes.FindNode( Cst_Name ).Text:= aGame.FName;

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
         MessageDlg( Rst_RebootRecal, mtInformation, [mbOK], 0, mbOK );
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
         MessageDlg( Rst_RebootRecal, mtInformation, [mbOK], 0, mbOK );
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
