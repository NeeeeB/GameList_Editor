unit F_Help;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes, System.IniFiles,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
   U_gnugettext, U_Resources, Vcl.Imaging.GIFImg, Vcl.ExtCtrls;

type
   TFrm_Help = class(TForm)
      Btn_Close: TButton;
      Chk_ShowTips: TCheckBox;
      Red_Help: TRichEdit;
      procedure Btn_CloseClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
   private
      procedure FormatText;
   public
      function Execute( aChecked: Boolean ): Boolean;
   end;

implementation

{$R *.dfm}

function TFrm_Help.Execute( aChecked: Boolean ): Boolean;
begin
   FormatText;
   Chk_ShowTips.Checked:= aChecked;
   ShowModal;
   Result:= not ( Chk_ShowTips.Checked );
end;

//remplit le richedit avec le texte de l'aide en mettant couleur etc..
procedure TFrm_Help.FormatText;
begin
   with Red_Help do begin
      SelStart:= GetTextLen;
      SelText:= sLineBreak;

      SelAttributes.Style:= [fsUnderline,fsBold];
      SelAttributes.Size:= 13;
      SelText:= Rst_Title1;
      SelText:= sLineBreak;
      SelAttributes.Style:= [];
      SelAttributes.Size:= 8;
      SelText:= Rst_Help1;
      SelText:= sLineBreak;
      SelText:= sLineBreak;

      SelAttributes.Style:= [fsUnderline,fsBold];
      SelAttributes.Size:= 13;
      SelText:= Rst_Title2;
      SelText:= sLineBreak;
      SelAttributes.Style:= [];
      SelAttributes.Size:= 8;
      SelText:= Rst_Help2;
      SelText:= sLineBreak;
      SelText:= sLineBreak;

      SelAttributes.Style:= [fsUnderline,fsBold];
      SelAttributes.Size:= 13;
      SelText:= Rst_Title3;
      SelText:= sLineBreak;
      SelAttributes.Style:= [];
      SelAttributes.Size:= 8;
      SelText:= Rst_Help3;
      SelText:= sLineBreak;
      SelText:= sLineBreak;

      SelAttributes.Style:= [fsUnderline,fsBold];
      SelAttributes.Size:= 13;
      SelText:= Rst_Title4;
      SelText:= sLineBreak;
      SelAttributes.Style:= [];
      SelAttributes.Size:= 8;
      SelText:= Rst_Help4;
      SelText:= sLineBreak;
      SelText:= sLineBreak;

      SelAttributes.Style:= [fsUnderline,fsBold];
      SelAttributes.Size:= 13;
      SelText:= Rst_Title5;
      SelText:= sLineBreak;
      SelAttributes.Style:= [];
      SelAttributes.Size:= 8;
      SelText:= Rst_Help5;
      SelText:= sLineBreak;
      SelText:= sLineBreak;

      SelAttributes.Style:= [fsUnderline,fsBold];
      SelAttributes.Size:= 13;
      SelText:= Rst_Title6;
      SelText:= sLineBreak;
      SelAttributes.Style:= [];
      SelAttributes.Size:= 8;
      SelText:= Rst_Help6;
      SelText:= sLineBreak;
      SelText:= sLineBreak;

      SelAttributes.Style:= [fsUnderline,fsBold];
      SelAttributes.Size:= 13;
      SelText:= Rst_Title7;
      SelText:= sLineBreak;
      SelAttributes.Style:= [];
      SelAttributes.Size:= 8;
      SelText:= Rst_Help7;
      SelText:= sLineBreak;
      SelText:= sLineBreak;

      SelAttributes.Style:= [fsUnderline,fsBold];
      SelAttributes.Size:= 13;
      SelText:= Rst_Title13;
      SelText:= sLineBreak;
      SelAttributes.Style:= [];
      SelAttributes.Size:= 8;
      SelText:= Rst_Help13;
      SelText:= sLineBreak;
      SelText:= sLineBreak;

      SelAttributes.Style:= [fsUnderline,fsBold];
      SelAttributes.Size:= 13;
      SelText:= Rst_Title8;
      SelText:= sLineBreak;
      SelAttributes.Style:= [];
      SelAttributes.Size:= 8;
      SelText:= Rst_Help8;
      SelText:= sLineBreak;
      SelText:= sLineBreak;

      SelAttributes.Style:= [fsUnderline,fsBold];
      SelAttributes.Size:= 13;
      SelText:= Rst_Title9;
      SelText:= sLineBreak;
      SelAttributes.Style:= [];
      SelAttributes.Size:= 8;
      SelText:= Rst_Help9;
      SelText:= sLineBreak;
      SelText:= sLineBreak;

      SelAttributes.Style:= [fsUnderline,fsBold];
      SelAttributes.Size:= 13;
      SelText:= Rst_Title10;
      SelText:= sLineBreak;
      SelAttributes.Style:= [];
      SelAttributes.Size:= 8;
      SelText:= Rst_Help10;
      SelText:= sLineBreak;
      SelText:= sLineBreak;

      SelAttributes.Style:= [fsUnderline,fsBold];
      SelAttributes.Size:= 13;
      SelText:= Rst_Title14;
      SelText:= sLineBreak;
      SelAttributes.Style:= [];
      SelAttributes.Size:= 8;
      SelText:= Rst_Help14;
      SelText:= sLineBreak;
      SelText:= sLineBreak;

      SelAttributes.Style:= [fsUnderline,fsBold];
      SelAttributes.Size:= 13;
      SelText:= Rst_Title15;
      SelText:= sLineBreak;
      SelAttributes.Style:= [];
      SelAttributes.Size:= 8;
      SelText:= Rst_Help15;
      SelText:= sLineBreak;
      SelText:= sLineBreak;

      SelAttributes.Style:= [fsUnderline,fsBold];
      SelAttributes.Size:= 13;
      SelText:= Rst_Title11;
      SelText:= sLineBreak;
      SelAttributes.Style:= [];
      SelAttributes.Size:= 8;
      SelText:= Rst_Help11;
      SelText:= sLineBreak;
      SelText:= sLineBreak;

      SelAttributes.Style:= [fsUnderline,fsBold];
      SelAttributes.Size:= 13;
      SelText:= Rst_Title12;
      SelText:= sLineBreak;
      SelAttributes.Style:= [];
      SelAttributes.Size:= 8;
      SelText:= Rst_Help12;
      SelText:= sLineBreak;
      SelText:= sLineBreak;
   end;
end;

procedure TFrm_Help.FormCreate(Sender: TObject);
begin
   TranslateComponent( Self );
end;

//action au click sur le bouton close
procedure TFrm_Help.Btn_CloseClick(Sender: TObject);
begin
   Close;
end;

end.
