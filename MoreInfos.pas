unit MoreInfos;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes, System.DateUtils,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
   gnugettext;

type
   TFrm_MoreInfos = class(TForm)
      Btn_Close: TButton;
      Edt_Playcount: TEdit;
      Edt_LastPlayed: TEdit;
      Edt_Crc32: TEdit;
      Edt_Md5: TEdit;
      Edt_Sha1: TEdit;
      Lbl_Playcount: TLabel;
      Lbl_LastPlayed: TLabel;
      Lbl_Crc32: TLabel;
      Lbl_Md5: TLabel;
      Lbl_Sha1: TLabel;
      procedure Btn_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
   public
      procedure Execute( aInfos: TStringList );
   end;

implementation

{$R *.dfm}

procedure TFrm_MoreInfos.Execute( aInfos: TStringList );
begin
   //on remplit les champs avec les chaines de la stringlist
   Edt_Playcount.Text:= aInfos.Strings[0];
   if not aInfos.Strings[1].IsEmpty then
      Edt_LastPlayed.Text:= FormatDateTime('dd/mm/yyyy hh:mm:ss' , ISO8601ToDate( aInfos.Strings[1] ) )
   else
      Edt_LastPlayed.Text:= '';
   Edt_Crc32.Text:= aInfos.Strings[2];
   Edt_Md5.Text:= aInfos.Strings[3];
   Edt_Sha1.Text:= aInfos.Strings[4];

   //affichage en modal de la fenêtre
   ShowModal;
end;

procedure TFrm_MoreInfos.FormCreate(Sender: TObject);
begin
   TranslateComponent( Self );
end;

procedure TFrm_MoreInfos.Btn_CloseClick(Sender: TObject);
begin
   //Ferme la fenêtre
   Close;
end;

end.
