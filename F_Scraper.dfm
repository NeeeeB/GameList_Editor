object Frm_Scraper: TFrm_Scraper
  Left = 0
  Top = 0
  Caption = 'Scrape results'
  ClientHeight = 600
  ClientWidth = 900
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
  PixelsPerInch = 96
  TextHeight = 13
  object Pnl_Back: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 600
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 160
    ExplicitTop = 152
    ExplicitWidth = 313
    ExplicitHeight = 193
  end
  object Ind_HTTP: TIdHTTP
    IOHandler = IdSSLIOHandlerSocketOpenSSL
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
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
    Left = 24
    Top = 88
  end
  object IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 104
    Top = 16
  end
  object XMLDoc: TXMLDocument
    Left = 24
    Top = 16
  end
end
