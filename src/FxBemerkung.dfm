object frmBemerkung: TfrmBemerkung
  Left = 480
  Top = 315
  BorderWidth = 3
  Caption = 'frmBemerkung'
  ClientHeight = 373
  ClientWidth = 1137
  Color = clBtnFace
  Constraints.MinHeight = 100
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBemerungLabel: TPanel
    Left = 0
    Top = 0
    Width = 1137
    Height = 26
    Align = alTop
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    DesignSize = (
      1137
      26)
    object lblBemerkung: TLabel
      Left = 8
      Top = 7
      Width = 132
      Height = 13
      Caption = 'Erg'#228'nzungen zum Fach:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSchriftgrad: TLabel
      Left = 1021
      Top = 7
      Width = 53
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Schriftgrad'
    end
    object cmbSchriftgrad: TComboBox
      Left = 1082
      Top = 3
      Width = 51
      Height = 21
      HelpType = htKeyword
      HelpKeyword = 'name'
      Style = csDropDownList
      Anchors = [akTop, akRight]
      TabOrder = 0
      OnChange = cmbSchriftgradChange
      Items.Strings = (
        '8'
        '9'
        '10'
        '11'
        '12'
        '14'
        '16')
    end
  end
  object pnlBemerkungText: TPanel
    Left = 0
    Top = 26
    Width = 1137
    Height = 347
    Align = alClient
    BorderWidth = 3
    Caption = 'pnlBemerkungText'
    TabOrder = 1
    OnResize = pnlBemerkungTextResize
    object reBemerkung: TRichEdit
      Left = 4
      Top = 4
      Width = 1129
      Height = 339
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      PopupMenu = PopupActionBar
      ScrollBars = ssVertical
      TabOrder = 0
      Zoom = 100
      OnChange = reBemerkungChange
    end
  end
  object PopupActionBar: TPopupActionBar
    Left = 816
    Top = 162
    object mitUndo: TMenuItem
      Caption = '&R'#252'ckg'#228'ngig'
      Hint = 'R'#252'ckg'#228'ngig|Letzte Aktion r'#252'ckg'#228'ngig machen'
      ImageIndex = 4
      ShortCut = 16474
    end
    object mitRedo: TMenuItem
      Caption = 'Wiederholen'
      Hint = 'Wiederholen'
      ShortCut = 16473
    end
    object mitCut: TMenuItem
      Caption = '&Ausschneiden'
      Hint = 'Ausschneiden|Auswahl in die Zwischenablage verschieben'
      ImageIndex = 1
      ShortCut = 16472
    end
    object mitCopy: TMenuItem
      Caption = '&Kopieren'
      Hint = 'Kopieren|Auswahl in die Zwischenablage kopieren'
      ImageIndex = 2
      ShortCut = 16451
    end
    object mitPaste: TMenuItem
      Caption = '&Einf'#252'gen'
      Hint = 'Einf'#252'gen|Inhalt der Zwischenablage einf'#252'gen'
      ImageIndex = 3
      ShortCut = 16470
    end
    object mitSelectAll: TMenuItem
      Caption = 'Alles &markieren'
      Hint = 'Alles markieren|Gesamtes Dokument ausw'#228'hlen'
      ShortCut = 16449
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mitAlignLeft: TMenuItem
      AutoCheck = True
      Caption = '&Links ausrichten'
      Hint = 'Links ausrichten|Text linksb'#252'ndig ausrichten'
      ImageIndex = 16
    end
    object mitAlignCenter: TMenuItem
      AutoCheck = True
      Caption = '&Zentrieren'
      Hint = 'Zentrieren|Text zentriert ausrichten'
      ImageIndex = 17
    end
    object mitAlignRight: TMenuItem
      AutoCheck = True
      Caption = '&Rechts ausrichten'
      Hint = 'Rechts ausrichten|Text rechtsb'#252'ndig ausrichten'
      ImageIndex = 18
    end
    object mitAlignBlock: TMenuItem
      Caption = 'Blocksatz'
      ImageIndex = 19
    end
  end
end
