object frmTextFach: TfrmTextFach
  Left = 480
  Top = 318
  BorderWidth = 3
  Caption = 'frmTextFach'
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
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTextLabel: TPanel
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
  object pnlTextFach: TPanel
    Left = 0
    Top = 26
    Width = 1137
    Height = 347
    Align = alClient
    BorderWidth = 3
    Caption = 'pnlTextFach'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    object reTextFach: TRichEdit
      Left = 4
      Top = 4
      Width = 876
      Height = 339
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      HideScrollBars = False
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      Zoom = 100
      OnChange = reTextFachChange
      OnDblClick = reTextFachDblClick
      OnMouseMove = reTextFachMouseMove
    end
    object pnlDebug: TPanel
      Left = 880
      Top = 4
      Width = 253
      Height = 339
      Align = alRight
      TabOrder = 1
      object Label1: TLabel
        Left = 9
        Top = 7
        Width = 31
        Height = 13
        Caption = 'Label1'
      end
      object Label2: TLabel
        Left = 9
        Top = 27
        Width = 31
        Height = 13
        Caption = 'Label2'
      end
      object Label3: TLabel
        Left = 9
        Top = 47
        Width = 31
        Height = 13
        Caption = 'Label3'
      end
      object Label4: TLabel
        Left = 9
        Top = 133
        Width = 31
        Height = 13
        Caption = 'Label4'
      end
      object Label5: TLabel
        Left = 9
        Top = 153
        Width = 31
        Height = 13
        Caption = 'Label5'
      end
      object Label6: TLabel
        Left = 9
        Top = 93
        Width = 31
        Height = 13
        Caption = 'Label6'
      end
      object Label7: TLabel
        Left = 9
        Top = 113
        Width = 31
        Height = 13
        Caption = 'Label7'
      end
      object Shape1: TShape
        Left = 200
        Top = 47
        Width = 25
        Height = 17
        Shape = stCircle
      end
    end
  end
  object PHTortenMenu: TPopupMenu
    OnPopup = PHTortenMenuPopup
    Left = 696
    Top = 40
  end
end
