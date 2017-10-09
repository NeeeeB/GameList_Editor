object Frm_ConfigureSSH: TFrm_ConfigureSSH
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Configure SSH'
  ClientHeight = 284
  ClientWidth = 204
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Lbl_RecalLogin: TLabel
    Left = 24
    Top = 16
    Width = 72
    Height = 13
    Caption = 'Recalbox Login'
  end
  object Lbl_RecalPwd: TLabel
    Left = 24
    Top = 64
    Width = 93
    Height = 13
    Caption = 'Recalbox Password'
  end
  object Lbl_RetroPwd: TLabel
    Left = 24
    Top = 184
    Width = 90
    Height = 13
    Caption = 'Retropie Password'
  end
  object Lbl_RetroLogin: TLabel
    Left = 24
    Top = 136
    Width = 69
    Height = 13
    Caption = 'Retropie Login'
  end
  object Edt_RecalLogin: TEdit
    Left = 24
    Top = 35
    Width = 153
    Height = 21
    TabOrder = 0
  end
  object Edt_RecalPwd: TEdit
    Left = 24
    Top = 83
    Width = 153
    Height = 21
    TabOrder = 1
  end
  object Edt_RetroLogin: TEdit
    Left = 24
    Top = 155
    Width = 153
    Height = 21
    TabOrder = 2
  end
  object Edt_RetroPwd: TEdit
    Left = 24
    Top = 203
    Width = 153
    Height = 21
    TabOrder = 3
  end
  object Btn_Save: TButton
    Left = 16
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Save'
    ModalResult = 1
    TabOrder = 4
  end
  object Btn_Cancel: TButton
    Left = 112
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
end
