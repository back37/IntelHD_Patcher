object Form1: TForm1
  Left = 610
  Top = 184
  BorderStyle = bsToolWindow
  Caption = 'IntelHD Driver Universal Patcher'
  ClientHeight = 107
  ClientWidth = 388
  Color = clBackground
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object CheckBox1: TCheckBox
    Left = 296
    Top = 12
    Width = 97
    Height = 17
    Caption = 'Device list'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = cl3DLight
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Visible = False
    OnClick = CheckBox1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 40
    Width = 369
    Height = 21
    ReadOnly = True
    TabOrder = 1
    Text = 'Edit1'
    Visible = False
  end
  object Edit2: TEdit
    Left = 8
    Top = 72
    Width = 369
    Height = 21
    TabOrder = 2
    Text = 'Edit2'
    Visible = False
  end
  object Button4: TButton
    Left = 8
    Top = 8
    Width = 153
    Height = 25
    Caption = 'Choose and Patch'
    TabOrder = 3
    OnClick = Button4Click
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Inf File|*.inf'
    Title = 'Choose IntelHD Graphics .Inf to Patch'
  end
end
