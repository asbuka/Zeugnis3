object frmZusatzFach: TfrmZusatzFach
  Left = 510
  Top = 444
  Caption = 'frmZusatzFach'
  ClientHeight = 38
  ClientWidth = 824
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlFachZusatz: TPanel
    Left = 0
    Top = 0
    Width = 824
    Height = 28
    Align = alTop
    TabOrder = 0
    DesignSize = (
      824
      28)
    object lblFachZusatzText1: TLabel
      Left = 8
      Top = 5
      Width = 121
      Height = 18
      Caption = 'lblFachZusatzText1'
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Comic Sans MS'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lblFachZusatzText2: TLabel
      Left = 682
      Top = 5
      Width = 136
      Height = 18
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'lblFachZusatzText2'
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Comic Sans MS'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object ediFachZusatz: TEdit
      Left = 320
      Top = 4
      Width = 289
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'ediFachZusatz'
      OnChange = ediFachZusatzChange
    end
  end
end
