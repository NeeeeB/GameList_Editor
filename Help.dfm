object Frm_Help: TFrm_Help
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Help'
  ClientHeight = 516
  ClientWidth = 869
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Btn_Close: TButton
    Left = 368
    Top = 483
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 0
    OnClick = Btn_CloseClick
  end
  object Mmo_Help: TMemo
    Left = 8
    Top = 8
    Width = 853
    Height = 469
    TabOrder = 1
  end
end
