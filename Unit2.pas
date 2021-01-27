unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, FileCtrl,inifiles, Grids;

type
  TForm2 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    LabeledEdit3: TLabeledEdit;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    StringGrid1: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    StringGrid2: TStringGrid;
    Button3: TButton;
    Button4: TButton;
    procedure WriteParams;
    procedure ReadParams;
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure StringGrid2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;
var
path:string;
it,i:integer;

{$R *.dfm}

procedure TForm2.WriteParams;
Var IniFile:TIniFile;
begin
IniFile:=TIniFile.Create(Path+'Properties.ini');
IniFile.WriteString('MOOOVER','dir ',labelededit3.Text);
IniFile.WriteString('TIME','sek ',edit1.Text);
IniFile.WriteBool('LOG','log ',checkbox1.Checked);

for i:=1 to stringgrid2.RowCount-1 do begin
IniFile.WriteString('DIR','dirNOM.'+inttostr(i),stringgrid2.Cells[0,i]);
IniFile.WriteString('DIR','dir.'+inttostr(i),stringgrid2.Cells[1,i]);
end;

IniFile.Writeinteger('MOOOVER','CountDir',i-1);

for i:=1 to stringgrid1.RowCount-1 do begin
IniFile.WriteString('STAN','Stan.'+inttostr(i),stringgrid1.Cells[0,i]);
IniFile.WriteString('HOSTS','Host.'+inttostr(i),stringgrid1.Cells[1,i]);
IniFile.WriteString('HOSTS','Host Name.'+inttostr(i),stringgrid1.Cells[2,i]);
end;

IniFile.Writeinteger('MOOOVER','Count',i-1);


IniFile.Free;
end;

procedure TForm2.ReadParams;
Var IniFile:TIniFile;
f:integer;
begin
IniFile:=TIniFile.Create(Path+'Properties.ini');
//labelededit1.Text:=IniFile.Readstring('MOOOVER','file',labelededit1.Text);
//labelededit2.Text:=IniFile.Readstring('MOOOVER','address',labelededit2.Text);
labelededit3.Text:=IniFile.Readstring('MOOOVER','dir',labelededit3.Text);
edit1.Text:=IniFile.Readstring('TIME','sek',edit1.Text);
checkbox1.Checked:=IniFile.Readbool('LOG','log',checkbox1.Checked);
directorylistbox1.Directory:=IniFile.Readstring('MOOOVER','dir',directorylistbox1.Directory);

f:=IniFile.Readinteger('MOOOVER','count',f);
stringgrid1.rowcount:=f+1;
for i:=1 to f do begin
stringgrid1.Cells[2,i]:=IniFile.ReadString('HOSTS','Host Name.'+inttostr(i),stringgrid1.Cells[2,i]);
stringgrid1.Cells[1,i]:=IniFile.ReadString('HOSTS','Host.'+inttostr(i),stringgrid1.Cells[1,i]);
stringgrid1.Cells[0,i]:=IniFile.ReadString('STAN','Stan.'+inttostr(i),stringgrid1.Cells[0,i]);
end;

f:=IniFile.Readinteger('MOOOVER','countDir',f);
stringgrid2.rowcount:=f+1;
for i:=1 to f do begin
stringgrid2.Cells[0,i]:=IniFile.ReadString('DIR','dirNOM.'+inttostr(i),stringgrid2.Cells[0,i]);
stringgrid2.Cells[1,i]:=IniFile.ReadString('DIR','Dir.'+inttostr(i),stringgrid2.Cells[1,i]);

end;


IniFile.Free;
end;

procedure TForm2.DirectoryListBox1Change(Sender: TObject);
begin
labelededit3.Text:=directorylistbox1.Directory;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
Path:=Application.ExeName;
Path:=ExtractFileDir(Path);
if Path[Length(Path)]<>'\' then Path:=Path+'\';
//labelededit3.ReadOnly:=true;

stringgrid1.Cells[0,0]:='Стан';
stringgrid1.Cells[1,0]:='Адреса куди';
stringgrid1.Cells[2,0]:='Маска';
stringgrid1.ColWidths[0]:=30;
stringgrid1.ColWidths[1]:=200;
stringgrid1.ColWidths[2]:=80;

stringgrid2.Cells[0,0]:='№ п/п';
stringgrid2.Cells[1,0]:='Перевіряти';
stringgrid2.ColWidths[0]:=30;
stringgrid2.ColWidths[1]:=280;

   ReadParams;

   form1.timer1.Interval:=strtoint(form2.Edit1.Text)*1000;
   form1.timer1.Enabled:=true;
   form1.addlog('*** Moover запущено... ***');
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
WriteParams;
form1.Timer1.Interval:=strtoint(edit1.text)*1000;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
stringgrid1.RowCount:=stringgrid1.RowCount+1;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
j:integer;
begin

  for j:=it to stringgrid1.RowCount-1 do begin
    if j<>0 then
    stringgrid1.Rows[j]:=stringgrid1.Rows[j+1];
  end;

  stringgrid1.RowCount:=stringgrid1.RowCount-1;

end;

procedure TForm2.StringGrid1Click(Sender: TObject);
begin
it:=stringgrid1.Row;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
form1.Timer1.Enabled:=true;
end;

procedure TForm2.BitBtn2Click(Sender: TObject);
begin
form2.Close;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
stringgrid2.RowCount:=stringgrid2.RowCount+1;
stringgrid2.Cells[0,stringgrid2.RowCount-1]:=inttostr(stringgrid2.RowCount-1);
end;

procedure TForm2.Button4Click(Sender: TObject);
var
j:integer;
begin

  for j:=it to stringgrid2.RowCount-1 do begin
    if j<>0 then
    stringgrid2.Rows[j]:=stringgrid2.Rows[j+1];
    stringgrid2.Cells[0,j]:=inttostr(j);
  end;   
  stringgrid2.RowCount:=stringgrid2.RowCount-1;

end;

procedure TForm2.StringGrid2Click(Sender: TObject);
begin
it:=stringgrid2.Row;
end;

end.
