object Frm_Network: TFrm_Network
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Network configuration'
  ClientHeight = 274
  ClientWidth = 338
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
  object Lbl_ScreenScraper: TLabel
    Left = 8
    Top = 8
    Width = 70
    Height = 13
    Caption = 'ScreenScraper'
  end
  object Lbl_ScreenLogin: TLabel
    Left = 10
    Top = 27
    Width = 41
    Height = 13
    Caption = 'Login'
  end
  object Lbl_ScreenPassword: TLabel
    Left = 186
    Top = 27
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object Lbl_ProxyPassword: TLabel
    Left = 186
    Top = 171
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object Lbl_ProxyUser: TLabel
    Left = 10
    Top = 171
    Width = 48
    Height = 13
    Caption = 'Username'
  end
  object Lbl_Host: TLabel
    Left = 10
    Top = 115
    Width = 32
    Height = 13
    Caption = 'Server'
  end
  object Lbl_Port: TLabel
    Left = 186
    Top = 115
    Width = 20
    Height = 13
    Caption = 'Port'
  end
  object Edt_ScreenLogin: TEdit
    Left = 8
    Top = 46
    Width = 145
    Height = 21
    TabOrder = 0
  end
  object Edt_ScreenPwd: TEdit
    Left = 184
    Top = 46
    Width = 145
    Height = 21
    TabOrder = 1
  end
  object Edt_ProxyServer: TEdit
    Left = 8
    Top = 134
    Width = 145
    Height = 21
    TabOrder = 2
  end
  object Edt_ProxyPort: TEdit
    Left = 184
    Top = 134
    Width = 145
    Height = 21
    NumbersOnly = True
    TabOrder = 3
  end
  object Edt_ProxyUser: TEdit
    Left = 8
    Top = 190
    Width = 145
    Height = 21
    TabOrder = 4
  end
  object Edt_ProxyPwd: TEdit
    Left = 184
    Top = 190
    Width = 145
    Height = 21
    TabOrder = 5
  end
  object Chk_Proxy: TCheckBox
    Left = 8
    Top = 92
    Width = 97
    Height = 17
    Caption = 'Use a proxy'
    TabOrder = 6
    OnClick = Chk_ProxyClick
  end
  object Btn_Save: TButton
    Left = 78
    Top = 232
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 7
    OnClick = Btn_SaveClick
  end
  object Btn_Cancel: TButton
    Left = 184
    Top = 232
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 8
    OnClick = Btn_CancelClick
  end
end
