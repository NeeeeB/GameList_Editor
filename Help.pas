unit Help;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
   TFrm_Help = class(TForm)
      Btn_Close: TButton;
      Mmo_Help: TMemo;
      procedure Btn_CloseClick(Sender: TObject);
   private
      { Déclarations privées }
   public
      procedure Execute;
   end;

implementation

{$R *.dfm}

procedure TFrm_Help.Execute;
begin
   ShowModal;
end;

//action au click sur le bouton close
procedure TFrm_Help.Btn_CloseClick(Sender: TObject);
begin
   Close;
end;

end.
