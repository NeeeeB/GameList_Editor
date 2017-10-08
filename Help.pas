unit Help;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes, System.IniFiles,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls;

resourcestring
   Rst_Title1 = 'Choose your folder :';

   Rst_Help1 = 'Select the folder where your systems folders are stored.' + SlineBreak +
               'It can be on your PC or on your Raspberry Pi.' + SlineBreak + SlineBreak +
               'If you choose a folder on the Pi, you will be prompted with a message explaining ' +
               'that EmulationStation will be stopped in order to save your changes to the gamelist.xml.' + sLineBreak +
               'When you close the application, Recalbox will be rebooted to reflect your changes.' + SlineBreak + SlineBreak +
               'You have to check the box of a field to enable its modification.' + SlineBreak +
               'It is done on purpose, to avoid accidentally changing fields content.';

   Rst_Title2 = 'Enable God Mode:';

   Rst_Help2 = 'Enabling this option will let you delete games directly from the application.' + sLineBreak +
               'A delete button will be added to the GUI.' + sLineBreak +
               'You will be prompted to confirm when you click on the delete button.' + sLineBreak +
               'Deleting a game will remove its entry from the gamelist, delete the matching picture,' +
               'and delete the file from your folder.';

   Rst_Title3 = 'Delete without prompt:';

   Rst_Help3 = 'Enabling this option will disable the prompt to confirm when you delete a game.' + sLineBreak +
               'Use with caution.';

   Rst_Title4 = 'Disable Pi prompts:';

   Rst_Help4 = 'Checking this option will disable all the prompts related' +
               'to the EmulationStation stop and the Recalbox reboot.';

   Rst_Title5 = 'Auto Hash:';

   Rst_Help5 = 'Enabling this option will Auto hash the files when you click on More Infos.' + sLineBreak +
               'Do this if you have a powerful computer or if your systems only contain small roms.' + sLineBreak +
               'Hashing files can be very slow so use it with caution.' + sLineBreak +
               'If you do not enable this option, you will be prompted to hash' +
               'or not the file when you click on More Infos.';

   Rst_Title6 = 'Show tips at start:';

   Rst_Help6 = 'Enabling this option will the show the help windows on application start.' + sLineBreak +
               'You can disable the help window for the next launches, by disabling this' +
               'option or by checking the box "Don''t show again" in the help window, before closing it.';

   Rst_Title7 = 'Use Genesis logo:';

   Rst_Help7 = 'This will let you use the Genesis logo and name instead of Megadrive.';

   Rst_Title8 = 'System - Convert to lowercase:';

   Rst_Help8 = 'Will convert all the text to lowercase for the whole selected system (every game will be converted).';

   Rst_Title9 = 'System - Convert to uppercase:';

   Rst_Help9 = 'Will convert all the text to uppercase for the whole selected system (every game will be converted).';

   Rst_Title10 = 'System - Remove region from games names:';

   Rst_Help10 = 'Will remove the region tag in the name (i.e [xxxx]) for every game of the selected system.';

   Rst_Title11 = 'Game - Convert to lowercase:';

   Rst_Help11 = 'Will convert all the text to lowercase for the selected game.';

   Rst_Title12 = 'Game - Convert to uppercase:';

   Rst_Help12 = 'Will convert all the text to uppercase for the selected game.';

type
   TFrm_Help = class(TForm)
      Btn_Close: TButton;
      Chk_ShowTips: TCheckBox;
      Red_Help: TRichEdit;
      procedure Btn_CloseClick(Sender: TObject);
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

//action au click sur le bouton close
procedure TFrm_Help.Btn_CloseClick(Sender: TObject);
begin
   Close;
end;

end.
