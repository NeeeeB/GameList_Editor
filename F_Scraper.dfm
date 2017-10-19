object Frm_Scraper: TFrm_Scraper
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Scrape results'
  ClientHeight = 460
  ClientWidth = 960
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  PixelsPerInch = 96
  TextHeight = 13
  object Pnl_Back: TPanel
    Left = 0
    Top = 50
    Width = 960
    Height = 360
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 88
    ExplicitWidth = 900
    ExplicitHeight = 273
    object Scl_Games: TScrollBox
      Left = 0
      Top = 0
      Width = 960
      Height = 360
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      TabOrder = 0
      ExplicitWidth = 950
      ExplicitHeight = 350
    end
  end
  object Pnl_Top: TPanel
    Left = 0
    Top = 0
    Width = 960
    Height = 50
    Align = alTop
    TabOrder = 1
    ExplicitLeft = 320
    ExplicitTop = 8
    ExplicitWidth = 185
    object Lbl_Instructions: TLabel
      Left = 307
      Top = 18
      Width = 347
      Height = 16
      Caption = 'Double click on a picture to set it as the game picture'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Pnl_Bottom: TPanel
    Left = 0
    Top = 410
    Width = 960
    Height = 50
    Align = alBottom
    TabOrder = 2
    ExplicitLeft = 336
    ExplicitTop = 536
    ExplicitWidth = 185
    object Btn_Close: TButton
      Left = 424
      Top = 16
      Width = 113
      Height = 25
      Caption = 'Close'
      TabOrder = 0
      OnClick = Btn_CloseClick
    end
  end
  object Ind_HTTP: TIdHTTP
    IOHandler = IdSSLIOHandlerSocketOpenSSL
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 3128
    ProxyParams.ProxyServer = '192.168.1.1'
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 16
    Top = 400
  end
  object IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 168
    Top = 400
  end
  object XMLDoc: TXMLDocument
    Left = 72
    Top = 400
  end
end
