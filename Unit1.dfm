object Form1: TForm1
  Left = 180
  Top = 254
  Width = 984
  Height = 742
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1089#1087#1077#1082#1090#1088#1072' '#1085#1072' '#1082#1072#1088#1090#1080#1085#1082#1091
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    976
    708)
  PixelsPerInch = 96
  TextHeight = 13
  object BtnBegin: TSpeedButton
    Left = 8
    Top = 528
    Width = 113
    Height = 25
    GroupIndex = 1
    Down = True
    Caption = #1053#1072#1095#1072#1083#1086' '#1087#1086#1083#1086#1089#1099
  end
  object BtnEnd: TSpeedButton
    Left = 8
    Top = 560
    Width = 113
    Height = 25
    GroupIndex = 1
    Caption = #1050#1086#1085#1077#1094' '#1087#1086#1083#1086#1089#1099
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 113
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1072#1088#1090#1080#1085#1082#1091
    TabOrder = 0
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 64
    Width = 121
    Height = 65
    Caption = #1058#1080#1087' '#1087#1086#1083#1086#1089#1099
    TabOrder = 1
    object RadioButton1: TRadioButton
      Left = 8
      Top = 16
      Width = 97
      Height = 17
      Caption = #1057#1087#1077#1082#1090#1088
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 8
      Top = 40
      Width = 105
      Height = 17
      Caption = #1048#1079#1083#1091#1095#1077#1085#1080#1077' '#1040#1063#1058
      TabOrder = 1
      OnClick = RadioButton2Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 128
    Width = 121
    Height = 129
    Caption = #1057#1087#1077#1082#1090#1088
    TabOrder = 2
    object txtLMin: TLabeledEdit
      Left = 8
      Top = 32
      Width = 97
      Height = 21
      EditLabel.Width = 92
      EditLabel.Height = 13
      EditLabel.Caption = #1052#1080#1085'. '#1076#1083#1080#1085#1072' '#1074#1086#1083#1085#1099
      TabOrder = 0
      Text = '400'
    end
    object txtLMax: TLabeledEdit
      Left = 8
      Top = 72
      Width = 97
      Height = 21
      EditLabel.Width = 98
      EditLabel.Height = 13
      EditLabel.Caption = #1052#1072#1082#1089'. '#1076#1083#1080#1085#1072' '#1074#1086#1083#1085#1099
      TabOrder = 1
      Text = '700'
    end
    object chkLLog: TCheckBox
      Left = 8
      Top = 104
      Width = 105
      Height = 17
      Caption = #1051#1086#1075'.'
      TabOrder = 2
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 256
    Width = 121
    Height = 161
    Caption = #1040#1063#1058
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 136
      Width = 105
      Height = 17
      AutoSize = False
    end
    object txtMinT: TLabeledEdit
      Left = 8
      Top = 32
      Width = 105
      Height = 21
      EditLabel.Width = 108
      EditLabel.Height = 13
      EditLabel.Caption = #1052#1080#1085'. '#1090#1077#1084#1087#1077#1088#1072#1090#1091#1088#1072' ('#1050')'
      Enabled = False
      TabOrder = 0
      Text = '1000'
    end
    object txtMaxT: TLabeledEdit
      Left = 8
      Top = 72
      Width = 105
      Height = 21
      EditLabel.Width = 98
      EditLabel.Height = 13
      EditLabel.Caption = #1052#1072#1082#1089'. '#1090#1077#1084#1087#1077#1088#1072#1090#1091#1088#1072
      Enabled = False
      TabOrder = 1
      Text = '10000'
    end
    object chkTLog: TCheckBox
      Left = 8
      Top = 96
      Width = 105
      Height = 17
      Caption = #1051#1086#1075'.'
      Enabled = False
      TabOrder = 2
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 120
      Width = 105
      Height = 17
      Caption = #1048#1079' '#1092#1072#1081#1083#1072'...'
      TabOrder = 3
      OnClick = CheckBox1Click
    end
  end
  object Button2: TButton
    Left = 8
    Top = 616
    Width = 113
    Height = 25
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100
    TabOrder = 4
    OnClick = Button2Click
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 416
    Width = 121
    Height = 105
    Caption = #1085#1086#1088#1084#1080#1088#1086#1074#1082#1072
    TabOrder = 5
    object txtDesat: TLabeledEdit
      Left = 8
      Top = 32
      Width = 105
      Height = 21
      EditLabel.Width = 54
      EditLabel.Height = 13
      EditLabel.Caption = #1079#1072#1073#1077#1083#1077#1085#1080#1077
      TabOrder = 0
      Text = '0'
    end
    object txtSat: TLabeledEdit
      Left = 8
      Top = 72
      Width = 105
      Height = 21
      EditLabel.Width = 78
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1072#1089#1099#1097#1077#1085#1085#1086#1089#1090#1100
      TabOrder = 1
      Text = '1'
    end
  end
  object ScrollBox1: TScrollBox
    Left = 136
    Top = 8
    Width = 835
    Height = 695
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoScroll = False
    TabOrder = 6
    DesignSize = (
      831
      691)
    object Image1: TImage
      Left = 8
      Top = 8
      Width = 819
      Height = 679
      Cursor = crCross
      Anchors = [akLeft, akTop, akRight, akBottom]
      OnMouseDown = Image1MouseDown
    end
  end
  object Button3: TButton
    Left = 8
    Top = 648
    Width = 113
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 7
    OnClick = Button3Click
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 680
    Width = 113
    Height = 25
    Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
    TabOrder = 8
    OnClick = BitBtn1Click
    Kind = bkHelp
  end
  object btnClipBoard: TButton
    Left = 8
    Top = 40
    Width = 113
    Height = 25
    Caption = #1048#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
    Enabled = False
    TabOrder = 9
    OnClick = btnClipBoardClick
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 144
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Data files|*.dat|Text files|*.txt|All files|*.*'
    Left = 232
    Top = 8
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 272
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'bmp'
    Filter = 'BMP file|*.bmp|All files|*.*'
    Left = 192
    Top = 8
  end
end
