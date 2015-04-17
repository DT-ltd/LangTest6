unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    Bevel1: TBevel;
    Memo1: TMemo;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Bevel2: TBevel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Bevel3: TBevel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Memo2: TMemo;
    Edit3: TEdit;
    Button4: TButton;
    Label1: TLabel;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TFileBuffer=object
    cc:integer;
    unicode:boolean;
    buf:array of byte;
    constructor create;
    procedure read (filename:string);
    procedure readonce (filename:string);
    procedure write (filename:string);
    procedure writeinteger (value:integer);
    procedure writebyte (value:byte);
    procedure writeword (value:word);
    procedure writefloat (value:real);
    procedure writestring (value:string);
    procedure writebool (value:boolean);
    procedure writecolor (value:TColor);
    procedure readinteger (var value:integer);
    procedure readbyte (var value:byte);
    procedure readword (var value:word);
    procedure readfloat (var value:real);
    procedure readstring (var value:string);
    procedure readbool (var value:boolean);
    procedure readcolor (var value:TColor);
    destructor destroy;
    end;

  TLangRec=record
    text, hint:string;
    end;

  TFormLang=record
    lang: array of TLangRec;
    end;

var
  Form1: TForm1;
  ofrmlang, pfrmlang: array of TFormLang;
  ointlang, pintlang: array of string;

  intl, stopchange:boolean;
  frmindex,listindex:integer;

procedure loadolang (filename:string);
procedure loadplang (filename:string);
procedure saveplang (filename:string);
procedure showlist;
procedure showtable;
function createsm (text:string):string;

implementation

uses Unit2;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
  begin
  stopchange:=false;
  StringGrid1.Cells[0,0]:='#';
  StringGrid1.Cells[1,0]:='Source';
  StringGrid1.Cells[2,0]:='Translation';
  SaveDialog1.Filename:='';
end;

procedure loadolang;
var a:TFileBuffer;
    i,j,langver:integer;
    ver:string;
  begin
  a.create;
  a.read (filename);
  a.readstring (ver);

  langver:=0;
  if ver='UnicodeLangFile' then
    begin
    a.readinteger (langver);//1+
    a.unicode:=true;
    end
      else
    a.unicode:=false;

  //Âûõîä äëÿ áîëåå íîâûõ âåðñèé
  if langver>1 then
    begin
    a.destroy;
    exit;
    end;

  a.readinteger (i);
  setlength (ofrmlang,i);
  for i:=0 to high(ofrmlang) do
    begin
    a.readinteger (j);
    setlength (ofrmlang[i].lang,j);
    for j:=0 to high(ofrmlang[i].lang) do
      begin
      a.readstring (ofrmlang[i].lang[j].text);
      a.readstring (ofrmlang[i].lang[j].hint);
      end;
    end;
  a.readinteger (i);
  setlength (ointlang,i);
  for i:=0 to high(ointlang) do
    a.readstring (ointlang[i]);
  a.destroy;
  end;

procedure loadplang;
var a:TFileBuffer;
    i,j,langver:integer;
    ver:string;
  begin
  a.create;
  a.read (filename);
  a.readstring (ver);

  langver:=0;
  if ver='UnicodeLangFile' then
    begin
    a.readinteger (langver);//1+
    a.unicode:=true;
    end
      else
    a.unicode:=false;

  //Âûõîä äëÿ áîëåå íîâûõ âåðñèé
  if langver>1 then
    begin
    a.destroy;
    exit;
    end;

  a.readinteger (i);
  setlength (pfrmlang,i);
  for i:=0 to high(pfrmlang) do
    begin
    a.readinteger (j);
    setlength (pfrmlang[i].lang,j);
    for j:=0 to high(pfrmlang[i].lang) do
      begin
      a.readstring (pfrmlang[i].lang[j].text);
      a.readstring (pfrmlang[i].lang[j].hint);
      end;
    end;
  a.readinteger (i);
  setlength (pintlang,i);
  for i:=0 to high(pintlang) do
    a.readstring (pintlang[i]);
  a.destroy;
  end;

procedure saveplang;
var a:TFileBuffer;
    i,j:integer;
  begin
  a.create;

  //a.writestring ('LangFile 1.22');// - Ñòàðàÿ âåðñèÿ (íå Unicode)
  a.writestring ('UnicodeLangFile');
  a.writeinteger (1);//Âåðñèÿ ôàéëà

  a.unicode:=true;
  a.writeinteger (length(pfrmlang));
  for i:=0 to high(pfrmlang) do
    begin
    a.writeinteger (length(pfrmlang[i].lang));
    for j:=0 to high(pfrmlang[i].lang) do
      begin
      a.writestring (pfrmlang[i].lang[j].text);
      a.writestring (pfrmlang[i].lang[j].hint);
      end;
    end;
  a.writeinteger (length(pintlang));
  for i:=0 to high(pintlang) do
    a.writestring (pintlang[i]);
  a.write (filename);
  a.destroy;
  end;

procedure TForm1.Button1Click(Sender: TObject);
var i:integer;
  begin
  if OpenDialog1.Execute then
    begin
    loadolang (OpenDialog1.Filename);
    setlength (pfrmlang,length(ofrmlang));
    for i:=0 to high(ofrmlang) do
      setlength (pfrmlang[i].lang,length(ofrmlang[i].lang));
    setlength (pintlang,length(ointlang));
    showlist;
    SaveDialog1.Filename:='';
    Form1.Caption:='Translater ['+OpenDialog1.Filename+']';
    Button3.Enabled:=true;
    end;
  end;

procedure showlist;
var i:integer;
  begin
  with Form1 do
    begin
    ComboBox1.Items.Clear;
    for i:=0 to high(ofrmlang) do
      ComboBox1.Items.Add ('Form ['+IntToStr(i)+']');
    ComboBox1.Items.Add ('Messages');
    ComboBox1.Text:='';
    frmindex:=-1;
    listindex:=-1;
    ComboBox1.ItemIndex:=-1;
    intl:=false;
    showtable;
    end;
  end;

procedure showtable;
var i:integer;
  begin
  with Form1 do
    begin
    listindex:=-1;
    Memo1.Lines.Clear;
    Memo2.lines.Clear;
    Edit1.Text:='';
    Edit2.Text:='';
    if frmindex>-1 then
      begin
      StringGrid1.RowCount:=length(ofrmlang[frmindex].lang)+1;
      for i:=0 to high(ofrmlang[frmindex].lang) do
        begin
        StringGrid1.Cells[0,i+1]:=IntToStr(i);
        StringGrid1.Cells[1,i+1]:=ofrmlang[frmindex].lang[i].text+' || '+ofrmlang[frmindex].lang[i].hint;
        StringGrid1.Cells[2,i+1]:=pfrmlang[frmindex].lang[i].text+' || '+pfrmlang[frmindex].lang[i].hint;
        end;
      end
        else
      if intl then
        begin
        StringGrid1.RowCount:=length(ointlang)+1;
        for i:=0 to high(ointlang) do
          begin
          StringGrid1.Cells[0,i+1]:=IntToStr(i);
          StringGrid1.Cells[1,i+1]:=ointlang[i];
          StringGrid1.Cells[2,i+1]:=pintlang[i];
          end;
        end
          else
        begin
        StringGrid1.RowCount:=2;
        StringGrid1.Cells[0,1]:='';
        StringGrid1.Cells[1,1]:='';
        StringGrid1.Cells[2,1]:='';
        end;
    end;
  end;

procedure TForm1.ComboBox1Change(Sender: TObject);
  begin
  frmindex:=-1;
  intl:=false;
  if ComboBox1.ItemIndex<length(ofrmlang) then
    frmindex:=ComboBox1.ItemIndex
      else
    if ComboBox1.ItemIndex=length(ofrmlang) then
      intl:=true;
  showtable;      
  end;

{TFileBuffer}

constructor TFileBuffer.create;
  begin
  setlength (buf,0);
  cc:=-1;
  unicode:=false;
  end;

procedure TFileBuffer.read;
var i,recsize:integer;
    a:file;
    dat:array [0..2047] of byte;
  begin
  cc:=-1;
  AssignFile (a,filename);
  Reset (a,1);
  setlength (buf,0);
  repeat
    BlockRead (a,dat,2048,recsize);
    setlength (buf,length(buf)+recsize);
    for i:=0 to recsize-1 do
      begin
      cc:=cc+1;
      buf[cc]:=dat[i];
      end;
    until recsize=0;
  CloseFile (a);
  cc:=-1;
  end;

procedure TFileBuffer.readonce;
var a:file;
    i,recsize:integer;
    dat: array [0..2047] of byte;
  begin
  cc:=-1;
  AssignFile (a,filename);
  Reset (a,1);
  setlength (buf,0);
  BlockRead (a,dat,2048,recsize);
  setlength (buf,length(buf)+recsize);
  for i:=0 to recsize-1 do
    begin
    cc:=cc+1;
    buf[cc]:=dat[i];
    end;
  CloseFile (a);
  cc:=-1;
  end;  

procedure TFileBuffer.write;
var i,recsize,j:integer;
    a:file;
    dat:array [0..2047] of byte;
  begin
  AssignFile (a,filename);
  Rewrite (a,1);
  i:=-1;
  repeat
    recsize:=2048;
    if i>high(buf)-2048 then
      recsize:=high(buf)-i;
    for j:=0 to recsize-1 do
      begin
      i:=i+1;
      dat[j]:=buf[i];
      end;
    BlockWrite (a,dat,recsize);
    until i>=high(buf);
  CloseFile (a);
  end;

procedure TFileBuffer.writeinteger;
  begin
  value:=value+32768;
  setlength (buf,length(buf)+2);
  buf[high(buf)-1]:=trunc(value/256);
  buf[high(buf)]:=round(frac(value/256)*256);
  end;

procedure TFileBuffer.writebyte;
  begin
  setlength (buf,length(buf)+1);
  buf[high(buf)]:=value;
  end;

procedure TFileBuffer.writeword;
  begin
  setlength (buf,length(buf)+2);
  buf[high(buf)-1]:=value div 256;
  buf[high(buf)]:=value mod 256;
  end;

procedure TFileBuffer.writefloat;
  begin
  setlength (buf,length(buf)+3);
  value:=(value+5000)*1000;
  buf[high(buf)-2]:=trunc(value/65536);
  buf[high(buf)-1]:=trunc(frac(value/65536)*65536/256);
  buf[high(buf)]:=round(frac(value/256)*256);
  end;

procedure TFileBuffer.writestring;
var i,l:integer;
    lw:word;
    ansistr:AnsiString;
  begin
  if unicode then
    begin
    lw:=length(value);
    if lw>65535 then
      lw:=65535;
    writeword (lw);
    for i:=1 to lw do
      writeword(Ord(value[i]));
    end
      else
    begin
    ansistr:=value;
    setlength (buf,length(buf)+1);
    l:=length(ansistr);
    if l>255 then
      l:=255;
    buf[high(buf)]:=l;
    for i:=1 to l do
      begin
      setlength (buf,length(buf)+1);
      buf[high(buf)]:=Ord(ansistr[i]);
      end;
    end;
  end;

procedure TFileBuffer.writebool;
  begin
  setlength (buf,length(buf)+1);
  if value then buf[high(buf)]:=1
           else buf[high(buf)]:=0;
  end;

procedure TFileBuffer.writecolor;
  begin
  setlength (buf,length(buf)+3);
  buf[high(buf)-2]:=getrvalue(value);
  buf[high(buf)-1]:=getgvalue(value);
  buf[high(buf)]:=getbvalue(value);
  end;  

procedure TFileBuffer.readinteger;
  begin
  cc:=cc+2;
  value:=buf[cc-1]*256+buf[cc];
  value:=value-32768;
  end;

procedure TFileBuffer.readbyte;
  begin
  cc:=cc+1;
  value:=buf[cc];
  end;

procedure TFileBuffer.readword;
  begin
  cc:=cc+2;
  value:=buf[cc-1]*256+buf[cc];
  end;

procedure TFileBuffer.readfloat;
  begin
  cc:=cc+3;
  value:=buf[cc-2]*65536+buf[cc-1]*256+buf[cc];
  value:=value/1000-5000;
  end;

procedure TFileBuffer.readstring;
var i:integer;
    ansistr:AnsiString;
    lw,sym:word;
  begin
  if unicode then
    begin
    readword (lw);
    setlength (value,lw);
    for i:=1 to lw do
      begin
      readword (sym);
      value[i]:=Char(sym);
      end;
    end
      else
    begin
    cc:=cc+1;
    setlength (ansistr,buf[cc]);
    for i:=1 to buf[cc] do
      begin
      cc:=cc+1;
      ansistr[i]:=AnsiChar(buf[cc]);
      end;
    value:=ansistr;
    end;
  end;

procedure TFileBuffer.readbool;
  begin
  cc:=cc+1;
  if buf[cc]=0 then value:=false
               else value:=true;
  end;

procedure TFileBuffer.readcolor;
  begin
  cc:=cc+3;
  value:=RGB(buf[cc-2],buf[cc-1],buf[cc]);
  end;  

destructor TFileBuffer.destroy;
  begin
  setlength (buf,0);
  end;

{/TFileBuffer}  

procedure TForm1.Button2Click(Sender: TObject);
var i:integer;
  begin
  if OpenDialog1.Execute then
    begin
    loadplang (OpenDialog1.Filename);
    setlength (pfrmlang,length(ofrmlang));
    for i:=0 to high(ofrmlang) do
      setlength (pfrmlang[i].lang,length(ofrmlang[i].lang));
    setlength (pintlang,length(ointlang));
    showlist;
    SaveDialog1.Filename:='';
    Button3.Enabled:=true;
    end;
  end;

procedure TForm1.Button3Click(Sender: TObject);
var mr:TModalResult;
  begin
  if SaveDialog1.Filename='' then
    begin
    if SaveDialog1.Execute then
      begin
      if FileExists(SaveDialog1.Filename) then
        begin
        mr:=MessageDlg('This file is already exist. Do you want to replace?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
        if mr=mrNo then
          begin
          Button3Click (Sender);
          exit;
          end;
        if mr=mrCancel then
          exit;
        end;
      saveplang (SaveDialog1.Filename);
      Button3.Enabled:=false;
      end;
    end
  else if FileExists(SaveDialog1.Filename) then
    begin
    saveplang (SaveDialog1.Filename);
    Button3.Enabled:=false;
    end
  else
    begin
    SaveDialog1.Filename:='';
    Button3Click (Sender);
    end;
  end;

procedure TForm1.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
  begin
  if (frmindex>-1)or intl then
    begin
    listindex:=ARow-1;
    Memo1.Lines.Clear;
    Memo2.Lines.Clear;
    stopchange:=true;
    if frmindex>-1 then
      begin
      Memo1.Lines.Add (ofrmlang[frmindex].lang[listindex].text);
      Memo2.Lines.Add (ofrmlang[frmindex].lang[listindex].hint);
      if ofrmlang[frmindex].lang[listindex].text='' then
        Edit1.Enabled:=false
          else
        Edit1.Enabled:=true;
      if ofrmlang[frmindex].lang[listindex].hint='' then
        Edit2.Enabled:=false
          else
        Edit2.Enabled:=true;
      Edit1.Text:=pfrmlang[frmindex].lang[listindex].text;
      Edit2.Text:=pfrmlang[frmindex].lang[listindex].hint;
      end
        else
      begin
      Memo1.Lines.Add (ointlang[listindex]);
      Edit1.Text:=pintlang[listindex];
      Edit1.Enabled:=true;
      Edit2.Enabled:=false;
      end;
    stopchange:=false;
    end;
  end;

procedure TForm1.Edit1Change(Sender: TObject);
  begin
  if stopchange or (listindex=-1) then
    exit;
  {if length(Edit1.Text)>255 then
    begin
    Label1.Caption:='Length error. 255 characters max. Now: '+IntToStr(length(Edit1.Text));
    Label1.Font.Color:=clRed;
    Edit1.Font.Color:=clRed;
    exit;
    end
      else
    begin}
    Label1.Caption:='Characters: '+IntToStr(length(Edit1.Text));
    if Edit1.Font.Color<>clBlack then
      begin
      Label1.Font.Color:=clBlack;
      Edit1.Font.Color:=clBlack;
      end;
    //end;
  if frmindex>-1 then
    begin
    pfrmlang[frmindex].lang[listindex].text:=Edit1.Text;
    StringGrid1.Cells[2,listindex+1]:=pfrmlang[frmindex].lang[listindex].text+' || '+pfrmlang[frmindex].lang[listindex].hint;
    Button3.Enabled:=true;
    end;
  if intl then
    begin
    pintlang[listindex]:=Edit1.Text;
    StringGrid1.Cells[2,listindex+1]:=Edit1.Text;
    Button3.Enabled:=true;
    end;
  end;

procedure TForm1.Edit2Change(Sender: TObject);
  begin
  if stopchange or (listindex=-1) then
    exit;
  {if length(Edit2.Text)>255 then
    begin
    Label1.Caption:='Length error. 255 characters max. Now: '+IntToStr(length(Edit2.Text));
    Label1.Font.Color:=clRed;
    Edit2.Font.Color:=clRed;
    exit;
    end
      else
    begin}
    Label1.Caption:='Characters: '+IntToStr(length(Edit2.Text));
    if Edit2.Font.Color<>clBlack then
      begin
      Label1.Font.Color:=clBlack;
      Edit2.Font.Color:=clBlack;
      end;
    //end;
  if frmindex>-1 then
    begin
    pfrmlang[frmindex].lang[listindex].hint:=Edit2.Text;
    StringGrid1.Cells[2,listindex+1]:=pfrmlang[frmindex].lang[listindex].text+' || '+pfrmlang[frmindex].lang[listindex].hint;
    Button3.Enabled:=true;
    end;
  end;

procedure TForm1.Button4Click(Sender: TObject);
var i,j,k,ii:integer;
    ad:boolean;
    text,txat:string;
  begin
  Form2.ListBox1.Items.Clear;
  text:=createsm(Edit3.Text);

  //Search Original
  for i:=0 to high(ofrmlang) do
    for j:=0 to high(ofrmlang[i].lang) do
      with ofrmlang[i] do
        if text<>'' then
          begin
          txat:=createsm(lang[j].text);
          ad:=false;
          for k:=1 to length(txat)-length(text)+1 do
            begin
            ad:=true;
            for ii:=0 to length(text)-1 do
              if text[ii+1]<>txat[k+ii] then
                begin
                ad:=false;
                break;
                end;
            if ad then
              begin
              Form2.ListBox1.Items.Add ('Original: Form['+IntToStr(i)+'], Line['+IntToStr(j)+']');
              break;
              end;
            end;
          txat:=createsm(lang[j].hint);
          if not ad then
            for k:=1 to length(txat)-length(text)+1 do
              begin
              ad:=true;
              for ii:=0 to length(text)-1 do
                if text[ii+1]<>txat[k+ii] then
                  begin
                  ad:=false;
                  break;
                  end;
              if ad then
                begin
                Form2.ListBox1.Items.Add ('Original: Form['+IntToStr(i)+'], Line['+IntToStr(j)+']');
                break;
                end;
            end;
          end;
  for j:=0 to high(ointlang) do
    begin
    if text<>'' then
      begin
      txat:=createsm(ointlang[j]);
      for k:=1 to length(txat)-length(text)+1 do
        begin
        ad:=true;
        for ii:=0 to length(text)-1 do
          if text[ii+1]<>txat[k+ii] then
            begin
            ad:=false;
            break;
            end;
        if ad then
          begin
          Form2.ListBox1.Items.Add ('Original: Message['+IntToStr(j)+']');
          break;
          end;
        end;
      end;
    end;

  //Search Translated
  for i:=0 to high(pfrmlang) do
    for j:=0 to high(pfrmlang[i].lang) do
      with pfrmlang[i] do
        if text<>'' then
          begin
          txat:=createsm(lang[j].text);
          ad:=false;
          for k:=1 to length(txat)-length(text)+1 do
            begin
            ad:=true;
            for ii:=0 to length(text)-1 do
              if text[ii+1]<>txat[k+ii] then
                begin
                ad:=false;
                break;
                end;
            if ad then
              begin
              Form2.ListBox1.Items.Add ('Translated: Form['+IntToStr(i)+'], Line['+IntToStr(j)+']');
              break;
              end;
            end;
          txat:=createsm(lang[j].hint);
          if not ad then
            for k:=1 to length(txat)-length(text)+1 do
              begin
              ad:=true;
              for ii:=0 to length(text)-1 do
                if text[ii+1]<>txat[k+ii] then
                  begin
                  ad:=false;
                  break;
                  end;
              if ad then
                begin
                Form2.ListBox1.Items.Add ('Translated: Form['+IntToStr(i)+'], Line['+IntToStr(j)+']');
                break;
                end;
            end;
          end
        else if (lang[j].text='')and(lang[j].hint='') then
          Form2.ListBox1.Items.Add ('Translated: Form['+IntToStr(i)+'], Line['+IntToStr(j)+']');
  for j:=0 to high(pintlang) do
    begin
    if text<>'' then
      begin
      txat:=createsm(pintlang[j]);
      for k:=1 to length(txat)-length(text)+1 do
        begin
        ad:=true;
        for ii:=0 to length(text)-1 do
          if text[ii+1]<>txat[k+ii] then
            begin
            ad:=false;
            break;
            end;
        if ad then
          begin
          Form2.ListBox1.Items.Add ('Translated: Message['+IntToStr(j)+']');
          break;
          end;
        end;
      end
    else if pintlang[j]='' then
      Form2.ListBox1.Items.Add ('Translated: Message['+IntToStr(j)+']');
    end;

  Form2.Show;
  end;

procedure TForm1.Button5Click(Sender: TObject);
  begin
<<<<<<< HEAD
  ShowMessage('Новая 1024');
=======
<<<<<<< HEAD
<<<<<<< HEAD
  ShowMessage('Новая 1242');
=======
  ShowMessage('Новая 1310');
>>>>>>> New_in_test
=======
  ShowMessage('Новая 1310');
>>>>>>> a2040fc1b6206d73bffb3d97cd322c9514c65e7b
>>>>>>> origin/Test_branch_1
  end;

procedure TForm1.Button7Click(Sender: TObject);
  begin
  showmessage('Новая фигня');
  //и коммент к этой фигне
  end;

function createsm;
var i:integer;
    txt:string;
  begin
  txt:=text;
  for i:=1 to length(text) do
    begin
    if (Ord(txt[i])>64)and(Ord(txt[i])<91) then txt[i]:=Chr(Ord(txt[i])+32);
    if (Ord(txt[i])>191)and(Ord(txt[i])<224) then txt[i]:=Chr(Ord(txt[i])+32);
    end;
  createsm:=txt;
  end;

end.
