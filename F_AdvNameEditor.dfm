object Frm_AdvNameEditor: TFrm_AdvNameEditor
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Advanced Name Editor'
  ClientHeight = 320
  ClientWidth = 442
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Lbl_Characters: TLabel
    Left = 55
    Top = 34
    Width = 136
    Height = 13
    Caption = 'characters at the beginning.'
    Enabled = False
  end
  object Lbl_EndChars: TLabel
    Left = 55
    Top = 61
    Width = 108
    Height = 13
    Caption = 'characters at the end.'
    Enabled = False
  end
  object Lbl_Beginning: TLabel
    Left = 343
    Top = 34
    Width = 82
    Height = 13
    Caption = 'at the beginning.'
    Enabled = False
  end
  object Lbl_End: TLabel
    Left = 343
    Top = 61
    Width = 54
    Height = 13
    Caption = 'at the end.'
    Enabled = False
  end
  object Lbl_Preview: TLabel
    Left = 33
    Top = 227
    Width = 38
    Height = 13
    Alignment = taCenter
    Caption = 'Preview'
  end
  object Btn_Apply: TButton
    Left = 130
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Apply'
    ModalResult = 1
    TabOrder = 0
  end
  object Btn_Cancel: TButton
    Left = 226
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Chk_DeleteChars: TCheckBox
    Left = 8
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Delete'
    TabOrder = 2
    OnClick = Chk_DeleteCharsClick
  end
  object Edt_NbChars: TEdit
    Left = 8
    Top = 31
    Width = 41
    Height = 21
    Enabled = False
    NumbersOnly = True
    TabOrder = 3
    OnChange = Edt_NbCharsChange
  end
  object Edt_NbCharsEnd: TEdit
    Left = 8
    Top = 58
    Width = 41
    Height = 21
    Enabled = False
    NumbersOnly = True
    TabOrder = 4
    OnChange = Edt_NbCharsEndChange
  end
  object Chk_Add: TCheckBox
    Left = 232
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Add'
    TabOrder = 5
    OnClick = Chk_AddClick
  end
  object Edt_StartString: TEdit
    Left = 232
    Top = 31
    Width = 105
    Height = 21
    Enabled = False
    TabOrder = 6
    OnChange = Edt_StartStringChange
  end
  object Edt_EndString: TEdit
    Left = 232
    Top = 58
    Width = 105
    Height = 21
    Enabled = False
    TabOrder = 7
    OnChange = Edt_EndStringChange
  end
  object Edt_Preview: TEdit
    Left = 33
    Top = 246
    Width = 365
    Height = 21
    Alignment = taCenter
    Enabled = False
    TabOrder = 8
  end
  object Rdg_Case: TRadioGroup
    Left = 8
    Top = 102
    Width = 416
    Height = 105
    Caption = '     Case'
    Enabled = False
    Items.Strings = (
      'Capitalize the first character'
      'Convert to Uppercase'
      'Convert to Lowercase')
    TabOrder = 9
    OnClick = Rdg_CaseClick
  end
  object Chk_Case: TCheckBox
    Left = 14
    Top = 101
    Width = 17
    Height = 17
    TabOrder = 10
    OnClick = Chk_CaseClick
  end
end
