object frmFormularDlg: TfrmFormularDlg
  Left = 758
  Top = 321
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'W'#228'hlen Sie das Formular'
  ClientHeight = 134
  ClientWidth = 417
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 330
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 330
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 2
  end
  object pnlEingabe: TPanel
    Left = 8
    Top = 8
    Width = 308
    Height = 118
    TabOrder = 0
    DesignSize = (
      308
      118)
    object lblFormular: TLabel
      Left = 12
      Top = 67
      Width = 42
      Height = 13
      Caption = 'Formular'
    end
    object chkStandard: TCheckBox
      Left = 12
      Top = 13
      Width = 67
      Height = 17
      Caption = 'Standard'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = chkStandardClick
    end
    object chkFSP: TCheckBox
      Left = 126
      Top = 13
      Width = 40
      Height = 17
      Caption = 'FSP'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = chkFSPClick
    end
    object chkSchwimmen: TCheckBox
      Left = 219
      Top = 13
      Width = 78
      Height = 17
      Caption = 'Schwimmen'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = chkSchwimmenClick
    end
    object cmbFormular: TComboBox
      Left = 12
      Top = 85
      Width = 285
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 5
      OnClick = cmbFormularClick
      Items.Strings = (
        'Zeugnis Klasse 1 (2 Halbjahr)'
        'Zeugnis Klasse 1 (2 Halbjahr) mit FSP'
        'Zeugnis Klasse 2 (1 Halbjahr)'
        'Zeugnis Klasse 2 (1 Halbjahr) mit FSP'
        'Zeugnis Klasse 2 (2 Halbjahr)'
        'Zeugnis Klasse 2 (2 Halbjahr) mit FSP'
        'Zeugnis Klasse 3 (1 Halbjahr)'
        'Zeugnis Klasse 3 (1 Halbjahr) mit FSP'
        'Zeugnis Klasse 3 (1 Halbjahr) mit Schwimmen'
        'Zeugnis Klasse 3 (1 Halbjahr) mit Schwimmen (FSP)'
        'Zeugnis Klasse 3 (2 Halbjahr)'
        'Zeugnis Klasse 3 (2 Halbjahr) mit FSP'
        'Zeugnis Klasse 3 (2 Halbjahr) mit Schwimmen'
        'Zeugnis Klasse 3 (2 Halbjahr) mit Schwimmen (FSP)'
        'Zeugnis Klasse 4 (1 Halbjahr)'
        'Zeugnis Klasse 4 (1 Halbjahr) mit FSP'
        'Zeugnis Klasse 4 (2 Halbjahr)'
        'Zeugnis Klasse 4 (2 Halbjahr) mit FSP')
    end
    object chkBericht: TCheckBox
      Left = 12
      Top = 38
      Width = 57
      Height = 17
      Caption = 'Bericht'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = chkBerichtClick
    end
    object chkGesprGrdl: TCheckBox
      Left = 126
      Top = 38
      Width = 119
      Height = 17
      Caption = 'Gespr'#228'chsgrundlage'
      Checked = True
      State = cbChecked
      TabOrder = 4
      Visible = False
      OnClick = chkBerichtClick
    end
  end
end
