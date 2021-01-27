object Form2: TForm2
  Left = 672
  Top = 152
  BorderStyle = bsDialog
  Caption = #1053#1072#1083#1072#1096#1090#1091#1074#1072#1085#1085#1103
  ClientHeight = 746
  ClientWidth = 342
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 110
    Top = 712
    Width = 44
    Height = 16
    Caption = #1063#1077#1088#1077#1079':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 200
    Top = 712
    Width = 22
    Height = 16
    Caption = #1089#1077#1082
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 80
    Top = 224
    Width = 66
    Height = 13
    Caption = '0 - '#1082#1086#1087#1110#1102#1074#1072#1090#1080
  end
  object Label5: TLabel
    Left = 80
    Top = 240
    Width = 77
    Height = 13
    Caption = '1 - '#1087#1077#1088#1077#1084#1110#1089#1090#1080#1090#1080
  end
  object Label6: TLabel
    Left = 168
    Top = 224
    Width = 62
    Height = 13
    Caption = '2 - '#1074#1080#1076#1072#1083#1080#1090#1080
  end
  object Label3: TLabel
    Left = 168
    Top = 240
    Width = 160
    Height = 13
    Caption = '3 - '#1074#1080#1076#1072#1083#1080#1090#1080' '#1074#1089#1110' '#1082#1088#1110#1084' '#1074#1082#1072#1079#1072#1085#1086#1075#1086
  end
  object BitBtn1: TBitBtn
    Left = 4
    Top = 708
    Width = 75
    Height = 25
    TabOrder = 0
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 260
    Top = 708
    Width = 75
    Height = 25
    TabOrder = 1
    OnClick = BitBtn2Click
    Kind = bkCancel
  end
  object DriveComboBox1: TDriveComboBox
    Left = 4
    Top = 308
    Width = 145
    Height = 19
    DirList = DirectoryListBox1
    TabOrder = 2
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 4
    Top = 332
    Width = 333
    Height = 137
    ItemHeight = 16
    TabOrder = 3
    OnChange = DirectoryListBox1Change
  end
  object LabeledEdit3: TLabeledEdit
    Left = 4
    Top = 276
    Width = 333
    Height = 21
    EditLabel.Width = 120
    EditLabel.Height = 16
    EditLabel.Caption = #1055#1077#1088#1077#1074#1110#1088#1103#1090#1080' '#1087#1072#1087#1082#1091':'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -13
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    TabOrder = 4
  end
  object Edit1: TEdit
    Left = 158
    Top = 712
    Width = 41
    Height = 21
    TabOrder = 5
    Text = '100'
  end
  object StringGrid1: TStringGrid
    Left = 4
    Top = 8
    Width = 333
    Height = 209
    ColCount = 3
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 6
    OnClick = StringGrid1Click
  end
  object Button1: TButton
    Left = 8
    Top = 224
    Width = 25
    Height = 25
    Caption = '+'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 48
    Top = 224
    Width = 25
    Height = 25
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    OnClick = Button2Click
  end
  object CheckBox1: TCheckBox
    Left = 170
    Top = 310
    Width = 97
    Height = 17
    Caption = #1042#1077#1089#1090#1080' '#1083#1086#1075
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object StringGrid2: TStringGrid
    Left = 4
    Top = 480
    Width = 333
    Height = 161
    ColCount = 2
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 10
    OnClick = StringGrid2Click
  end
  object Button3: TButton
    Left = 16
    Top = 648
    Width = 25
    Height = 25
    Caption = '+'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 56
    Top = 648
    Width = 25
    Height = 25
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
    OnClick = Button4Click
  end
end
