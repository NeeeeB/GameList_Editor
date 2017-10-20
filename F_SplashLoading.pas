unit F_SplashLoading;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
   Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.GIFImg, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
   TFrm_Splash = class(TForm)
      Pnl_Back: TPanel;
       Img_Loading: TImage;
   private
    { Déclarations privées }
   public
    { Déclarations publiques }
   end;

var
   FrmSplash: TFrm_Splash;

implementation

{$R *.dfm}

end.
