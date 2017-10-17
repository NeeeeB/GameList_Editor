unit F_Scraper;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes, System.NetEncoding,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
   IdHTTP, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
   Xml.XMLDoc, Xml.XMLIntf,
   U_Resources, U_Game, U_gnugettext;

type
   TFrm_Scraper = class(TForm)
      Ind_HTTP: TIdHTTP;

   private
      procedure GetGameInfos( const aSysId, aRomName, aCrc, aSize: string );

   public
      procedure Execute( const aSysId, aRomName, aCrc, aSize: string );
   end;

implementation

{$R *.dfm}

procedure TFrm_Scraper.Execute( const aSysId, aRomName, aCrc, aSize: string );
begin
   GetGameInfos( aSysId, aRomName, aCrc, aSize );
   ShowModal;
end;

//Requête GET pour récupérer le XML des infos du jeu.
procedure TFrm_Scraper.GetGameInfos( const aSysId, aRomName, aCrc, aSize: string );
var
   Query: String;
   Buffer: String;
   Doc: IXMLDocument;
   Node: IXMLNode;
begin
   Query:= Cst_ScraperAddress + Cst_Category + Cst_ScrapeLogin + Cst_ScrapePwd +
           Cst_DevSoftName + Cst_Output + Cst_Crc + aCrc + Cst_SystemId + aSysId +
           Cst_RomName + TNetEncoding.URL.Encode( aRomName ) + Cst_RomSize + aSize;

   Buffer:= Ind_HTTP.Get( Query );
   // Create XML document
   Doc:= TXMLDocument.Create(nil);

   // Build XML document from HTTP response
   Doc.LoadFromXML(Buffer);

   // Get main node
   Node:= Doc.ChildNodes.FindNode('media_boxs2d');
end;

end.
