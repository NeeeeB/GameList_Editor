unit About;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
   gnugettext;

resourcestring
   Rst_Text = sLineBreak + 'GameList Editor is a tool to manage your Gamelist.xml' + sLineBreak +
              'from a Recalbox or Retropie installation:' + sLineBreak +
              'https://www.recalbox.com/' + sLineBreak +
              'https://retropie.org.uk/' + sLineBreak + sLineBreak +
              'It is written in Delphi (Tokyo 10.2.1) by NeeeeB' + sLineBreak +
              'Its source code is fully available at:' + sLineBreak +
              'https://github.com/NeeeeB/GameList_Editor' + sLineBreak + sLineBreak +
              'Your Gamelist.xml should have been created' + sLineBreak +
              'by Universal XML Scraper by Screech:' + sLineBreak +
              'https://github.com/Universal-Rom-Tools/Universal-XML-Scraper' + sLineBreak + sLineBreak +
              'Translators (Thx to them !!):' + sLineBreak +
              'German = Gmgman and Lackyluuk' + sLineBreak +
              'Spanish = Uzanto';

type
   TRichEdit = class(Vcl.ComCtrls.TRichEdit)
   private
      procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
   protected
      procedure CreateWnd; override;
   end;

type
   TFrm_About = class(TForm)
      Btn_Close: TButton;
      Red_About: TRichEdit;

      procedure Btn_CloseClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
   private
      { Déclarations privées }
   public
      procedure Execute;
   end;

implementation

{$R *.dfm}

uses
   Winapi.ShellAPI, Winapi.RichEdit;

const
   AURL_ENABLEURL = 1;
   AURL_ENABLEEAURLS = 8;


procedure TRichEdit.CreateWnd;
var
   mask: LResult;
begin
   inherited;
   mask := SendMessage(Handle, EM_GETEVENTMASK, 0, 0);
   SendMessage(Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
   SendMessage(Handle, EM_AUTOURLDETECT, AURL_ENABLEURL, 0);
end;

procedure TRichEdit.CNNotify(var Message: TWMNotify);
type
   PENLink = ^TENLink;
var
   p: PENLink;
   tr: TEXTRANGE;
   url: array of Char;
begin
   if (Message.NMHdr.code = EN_LINK) then begin
      p := PENLink(Message.NMHdr);
      if (p.Msg = WM_LBUTTONDOWN) then begin
         { optionally, enable this:
         if CheckWin32Version(6, 2) then begin
         // on Windows 8+, returning EN_LINK_DO_DEFAULT directs
         // the RichEdit to perform the default action...
         Message.Result :=  EN_LINK_DO_DEFAULT;
         Exit;
         end;
         }
         try
            SetLength(url, p.chrg.cpMax - p.chrg.cpMin + 1);
            tr.chrg := p.chrg;
            tr.lpstrText := PChar(url);
            SendMessage(Handle, EM_GETTEXTRANGE, 0, LPARAM(@tr));
            ShellExecute(Handle, nil, PChar(url), nil, nil, SW_SHOWNORMAL);
         except
            {ignore}
         end;
         Exit;
      end;
   end;
   inherited;
end;

//au create on ajoute le texte au RichEdit
procedure TFrm_About.FormCreate(Sender: TObject);
begin
   TranslateComponent( Self );
   Red_About.Lines.Add( Rst_Text );
end;

//Execute l'affichage de la fenêtre
procedure TFrm_About.Execute;
begin
   ShowModal;
end;

//Action au click sur le bouton close
procedure TFrm_About.Btn_CloseClick(Sender: TObject);
begin
   //Ferme la fenêtre
   Close;
end;

end.
