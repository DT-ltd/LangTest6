object Form2: TForm2
  Left = 242
  Top = 213
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Результаты поиска'
  ClientHeight = 345
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 377
    Height = 9
    Shape = bsTopLine
  end
  object Bevel2: TBevel
    Left = 0
    Top = 336
    Width = 377
    Height = 9
    Shape = bsTopLine
  end
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 361
    Height = 321
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 13
    ParentFont = False
    TabOrder = 0
  end
end
