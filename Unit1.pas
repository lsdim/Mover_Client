unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Sockets, StdCtrls,
  ShellApi, ExtCtrls, Menus, Grids,masks, ActnList,inifiles,idGlobal,
  Buttons, FileCtrl, ComCtrls, JvComponentBase, JvTrayIcon;

type
  TForm1 = class(TForm)
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    Timer1: TTimer;
    N3: TMenuItem;
    N2: TMenuItem;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    Button3: TButton;
    Button4: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Bevel1: TBevel;
    Bevel2: TBevel;
    TcpClient1: TTcpClient;
    sg3: TStringGrid;
    Button5: TButton;
    Button6: TButton;
    Memo1: TMemo;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Edit2: TEdit;
    Splitter1: TSplitter;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    BitBtn3: TBitBtn;
    Button11: TButton;
    Button12: TButton;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    CheckBox2: TCheckBox;
    StatusBar1: TStatusBar;
    JvTrayIcon1: TJvTrayIcon;
    btn1: TBitBtn;
    procedure WriteParamsGen;
    procedure ReadParamsGen;
    procedure WriteParams(Name:string);
    procedure ReadParams(Name:string);
    procedure addlog(text:string);
    procedure FormCreate(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid2Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StringGrid1SelectCell(Sender: TObject; Col, Row: Integer;
  var CanSelect: Boolean);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure sg3Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
    procedure WMQueryEndSession(var Message: TWMQueryEndSession); message WM_QUERYENDSESSION;

  public
  const
      vers = '0.1.0';
    { Public declarations }
//    procedure IconCallBackMessage ( var Mess : TMessage ); message WM_USER + 100;
  end;

var
  Form1: TForm1;

implementation

uses
  USend;

var
path,host:string;
i,it,it3:integer;

{$R *.dfm}



function mass(mask: string):string;
var
i:smallint;
newmask,d:string;
begin
i:=1;
  while i<=length(mask) do begin
    if (mask[i]<>'+') then
     newmask:=newmask+mask[i]
    else begin
      d:='';
      inc(i);
      while mask[i]<>'+' do begin
        d:=d+mask[i];
        inc(i);
      end;
      if d='d' then d:=datetostr(date)[1]+datetostr(date)[2];
      if d='d-1' then d:=inttostr(strtoint(datetostr(date)[1]+datetostr(date)[2])-1);
      if d='d-2' then d:=inttostr(strtoint(datetostr(date)[1]+datetostr(date)[2])-2);
      if d='m' then d:=datetostr(date)[4]+datetostr(date)[5];
      if d='m-1' then d:=inttostr(strtoint(datetostr(date)[4]+datetostr(date)[5])-1);
      if d='m-2' then d:=inttostr(strtoint(datetostr(date)[4]+datetostr(date)[5])-2);
      if d='yy' then d:=datetostr(date)[9]+datetostr(date)[10];
      if d='yyyy' then d:=datetostr(date)[7]+datetostr(date)[8]+datetostr(date)[9]+datetostr(date)[10];
      newmask:=newmask+d;
    end;

  i:=i+1;
  end;

  result:=newmask;

end;


procedure tform1.addlog(text:string);
var
  FS:TFileStream;
  fn,LogPath,ev: string;
begin


    try
      logPath:=extractfilepath(application.exename)+'Log\';
      forceDirectories(logPath);

      FN:=logPath+'MoverCL_'+formatdatetime('yyyy"_"mm"_"dd"',now)+'.log';

      if Fileexists(FN) then
        fs:=TFileStream.Create(FN, fmOpenReadWrite+fmShareDenyNone)
      else
        fs:=TFileStream.Create(FN, fmCreate);

      fs.Position:=fs.Size;
      if Form1.CheckBox2.Checked then
        form1.JvTrayIcon1.BalloonHint('MoverCL v.'+vers,text,btInfo);
      text:='['+formatdatetime('dd"."mm"."yyy" "hh":"mm":"ss',now)+']>MoverCL v'+form1.vers+'>'+text+#13#10;
      fs.Write(text[1],length(text));

    finally
      fs.Free;
    end;



end;


procedure TForm1.ReadParamsGen;
Var IniFile:TmemIniFile;
f:integer;
begin
f:=1;
IniFile:=TMemIniFile.Create(Path+'MyParam.ini');
try
  f:=IniFile.Readinteger('MOVER','count',f);
  checkbox2.Checked:=IniFile.ReadBool('LOG','Log',checkbox2.Checked);
  sg3.rowcount:=f+1;
  for i:=1 to f do begin
  sg3.Cells[1,i]:=IniFile.ReadString('NAME','Host Name.'+inttostr(i),sg3.Cells[1,i]);
  sg3.Cells[2,i]:=IniFile.ReadString('ADDRESS','Host.'+inttostr(i),sg3.Cells[2,i]);
  sg3.Cells[3,i]:=IniFile.ReadString('PORT','Port.'+inttostr(i),sg3.Cells[3,i]);

end;
finally
  IniFile.Free;
end;

end;

procedure TForm1.WriteParamsGen;
Var IniFile:TmemIniFile;
begin
IniFile:=TmemIniFile.Create(Path+'MyParam.ini');
try
  for i:=1 to sg3.RowCount-1 do begin
  IniFile.WriteString('ADDRESS','Host.'+inttostr(i),sg3.Cells[2,i]);
  IniFile.WriteString('NAME','Host Name.'+inttostr(i),sg3.Cells[1,i]);
  IniFile.WriteString('PORT','Port.'+inttostr(i),sg3.Cells[3,i]);
  end;
  IniFile.Writeinteger('MOVER','Count',i-1);
  IniFile.WriteBool('LOG','Log',checkbox2.Checked);

  IniFile.UpdateFile;
finally
   IniFile.Free;
end;

end;


procedure TForm1.FormCreate(Sender: TObject);
var nid : TNotifyIconData;
begin
{ with nid do
  begin
    cbSize := SizeOf( TNotifyIconData );
    Wnd := Form1.Handle;
    uID := 1;
    uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
    uCallbackMessage := WM_USER + 100;
    hIcon := Application.Icon.Handle;
    StrPCopy(szTip, 'Mover Client');
  end;
  Shell_NotifyIcon( NIM_ADD, @nid );
  }

  Path:=Application.ExeName;
Path:=ExtractFileDir(Path);
if Path[Length(Path)]<>'\' then Path:=Path+'\';

stringgrid1.Cells[0,0]:='###';
stringgrid1.Cells[3,0]:='Стан';
stringgrid1.Cells[1,0]:='Місце призначення';
stringgrid1.Cells[2,0]:='Маска';
stringgrid1.ColWidths[0]:=30;
stringgrid1.ColWidths[1]:=200;
stringgrid1.ColWidths[2]:=80;
stringgrid1.ColWidths[3]:=30;

stringgrid2.Cells[0,0]:='№';
stringgrid2.Cells[1,0]:='Перевіряти папки';
stringgrid2.ColWidths[0]:=30;
stringgrid2.ColWidths[1]:=310;

sg3.Cells[0,0]:='##';
sg3.Cells[1,0]:='Назва хосту';
sg3.Cells[2,0]:='Адреса хосту';
sg3.Cells[3,0]:='Порт хосту';
sg3.ColWidths[0]:=25;
sg3.ColWidths[1]:=190;
sg3.ColWidths[2]:=150;
sg3.ColWidths[3]:=100;

   ReadParamsGen;

//   form1.timer1.Interval:=strtoint(Form1.Edit1.Text)*1000;
 //  form1.timer1.Enabled:=true;
   form1.addlog('*** Mooover запущено... ***');
 

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var nid : TNotifyIconData;
begin
  with nid do
  begin
    cbSize := SizeOf( TNotifyIconData );
    Wnd := Form1.Handle;
    uID := 1;
    uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
    uCallbackMessage := WM_USER + 100;
    hIcon := Application.Icon.Handle;
    StrPCopy(szTip, 'Mover Client');
  end;
  Shell_NotifyIcon( NIM_DELETE, @nid );
   addlog('*** Mooover зупинено... ***');
end;

procedure TForm1.N1Click(Sender: TObject);
begin
close();
end;

{
procedure TForm1.IconCallBackMessage( var Mess : TMessage );
Var p:tpoint;
begin
GetCursorPos(p); 
  case Mess.lParam of
    WM_RBUTTONDOWN    : Begin
    SetForegroundWindow(Handle);  
    PopupMenu1.Popup(p.X,p.Y);
    PostMessage(Handle,WM_NULL,0,0);
   end;
  end;
end;
 }

procedure TForm1.Timer1Timer(Sender: TObject);
var
Find:TSearchRec;
s:integer;
label m1;
begin
progressbar1.Step:=100 div (StringGrid2.RowCount-1);
progressbar2.Step:=1000 div (StringGrid1.RowCount-1);

     for s:=1 to StringGrid2.RowCount-1 do begin

    progressbar2.Position:=0;
    progressbar1.Position:=progressbar1.Position+progressbar1.Step;

  for i:=1 to StringGrid1.RowCount-1 do begin 

    progressbar2.Position:=progressbar2.Position+progressbar2.Step;

    if (StringGrid1.Cells[0,i]=inttostr(s))and(StringGrid1.Cells[3,i]<>'0') then

        if FindFirst(StringGrid2.Cells[1,s]+mass(StringGrid1.Cells[2,i]), faAnyFile, Find)=0 then begin

          if (Find.Attr and faDirectory)<>Find.Attr then begin

                if StringGrid1.Cells[3,i]='1' then begin
                if copyfile(pansichar(StringGrid2.Cells[1,s]+find.Name),pansichar(StringGrid1.Cells[1,i]+find.Name),false) then
                  addlog(find.Name+' скопійовано з '+StringGrid2.Cells[1,s]+' до '+StringGrid1.Cells[1,i])
                else
                  addlog(find.Name+'  не скопійовано з '+StringGrid2.Cells[1,s]+' до '+StringGrid1.Cells[1,i]+'. Код помилки '+IntToStr(GetLastError));
              end;
              if StringGrid1.Cells[3,i]='2' then begin
                if movefile(pansichar(StringGrid2.Cells[1,s]+find.Name),pansichar(StringGrid1.Cells[1,i]+find.Name)) then
                  addlog(find.Name+' переміщено з '+StringGrid2.Cells[1,s]+' до '+StringGrid1.Cells[1,i])
                else
                  if (GetLastError = 80) or (GetLastError = 183) then begin
                    deletefile(pansichar(StringGrid1.Cells[1,i]+find.Name));
                  if movefile(pansichar(StringGrid2.Cells[1,s]+find.Name),pansichar(StringGrid1.Cells[1,i]+find.Name)) then
                    addlog(find.Name+' переміщено із заміною з '+StringGrid2.Cells[1,s]+' до '+StringGrid1.Cells[1,i])
                  else
                    addlog(find.Name+'  не переміщено з '+StringGrid2.Cells[1,s]+' до '+StringGrid1.Cells[1,i]+'. Код помилки '+IntToStr(GetLastError));
                  end;
                                end;
              if StringGrid1.Cells[3,i]='3' then begin
                if deletefile(pansichar(StringGrid2.Cells[1,s]+find.Name)) then
                  addlog(find.Name+' видалено з '+StringGrid2.Cells[1,s])
                else
                  addlog(find.Name+'  не видалено з '+StringGrid2.Cells[1,s]+'. Код помилки '+IntToStr(GetLastError));
              end;
              if StringGrid1.Cells[3,i]='4' then begin
                  winexec(pansichar(StringGrid1.Cells[1,i]),sw_show);
                if getlasterror = 0  then
                  addlog(find.Name+' знайдено у '+StringGrid2.Cells[1,s]+' і запущено файл '+StringGrid1.Cells[1,i])
                else
                  addlog(find.Name+' знайдено у '+StringGrid2.Cells[1,s]+', але не запущено файл '+StringGrid2.Cells[1,s]+'. Код помилки '+IntToStr(GetLastError));
              end;
              if StringGrid1.Cells[3,i]='5' then begin
                  MessageDlg('В дерикторії - '+StringGrid2.Cells[1,s]+' - знайдено файл - '+#13#10+#13#10+find.Name, mtInformation, [mbOK], 0);
                if getlasterror = 0 then
                  addlog(find.Name+' знайдено у '+StringGrid2.Cells[1,s]+' і показано повідомлення')
                else
                  addlog(find.Name+' знайдено у '+StringGrid2.Cells[1,s]+', але повідомлення не показано. Код помилки '+IntToStr(GetLastError));
              end;

          end;

          while FindNext(Find)=0 do  begin

              if (Find.Attr and faDirectory)<>Find.Attr then begin

                if StringGrid1.Cells[3,i]='1' then begin
                if copyfile(pansichar(StringGrid2.Cells[1,s]+find.Name),pansichar(StringGrid1.Cells[1,i]+find.Name),false) then
                  addlog(find.Name+' скопійовано з '+StringGrid2.Cells[1,s]+' до '+StringGrid1.Cells[1,i])
                else
                  addlog(find.Name+'  не скопійовано з '+StringGrid2.Cells[1,s]+' до '+StringGrid1.Cells[1,i]+'. Код помилки '+IntToStr(GetLastError));
              end;
              if StringGrid1.Cells[3,i]='2' then begin
                if movefile(pansichar(StringGrid2.Cells[1,s]+find.Name),pansichar(StringGrid1.Cells[1,i]+find.Name)) then
                  addlog(find.Name+' переміщено з '+StringGrid2.Cells[1,s]+' до '+StringGrid1.Cells[1,i])
                else
                  if (GetLastError = 80) or (GetLastError = 183) then begin
                    deletefile(pansichar(StringGrid1.Cells[1,i]+find.Name));
                  if movefile(pansichar(StringGrid2.Cells[1,s]+find.Name),pansichar(StringGrid1.Cells[1,i]+find.Name)) then
                    addlog(find.Name+' переміщено із заміною з '+StringGrid2.Cells[1,s]+' до '+StringGrid1.Cells[1,i])
                  else
                    addlog(find.Name+'  не переміщено з '+StringGrid2.Cells[1,s]+' до '+StringGrid1.Cells[1,i]+'. Код помилки '+IntToStr(GetLastError));
                  end;
                                end;
              if StringGrid1.Cells[3,i]='3' then begin
                if deletefile(pansichar(find.Name)) then
                  addlog(find.Name+' видалено з '+StringGrid2.Cells[1,s])
                else
                  addlog(find.Name+'  не видалено з '+StringGrid2.Cells[1,s]+'. Код помилки '+IntToStr(GetLastError));
              end;
              if StringGrid1.Cells[3,i]='4' then begin
                  winexec(pansichar(StringGrid1.Cells[1,i]),sw_show);
                if getlasterror = 0  then
                  addlog(find.Name+' знайдено у '+StringGrid2.Cells[1,s]+' і запущено файл '+StringGrid1.Cells[1,i])
                else
                  addlog(find.Name+' знайдено у '+StringGrid2.Cells[1,s]+', але не запущено файл '+StringGrid2.Cells[1,s]+'. Код помилки '+IntToStr(GetLastError));
              end;
              if StringGrid1.Cells[3,i]='5' then begin
                  MessageDlg('В дерикторії - '+StringGrid2.Cells[1,s]+' - знайдено файл - '+#13#10+#13#10+find.Name, mtInformation, [mbOK], 0);
                if getlasterror = 0 then
                  addlog(find.Name+' знайдено у '+StringGrid2.Cells[1,s]+' і показано повідомлення')
                else
                  addlog(find.Name+' знайдено у '+StringGrid2.Cells[1,s]+', але повідомлення не показано. Код помилки '+IntToStr(GetLastError));
              end;

            end;

          end;

        FindClose(Find);

    end;
  end;

end;
  progressbar1.Position:=0;
  progressbar2.Position:=0;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
timer1.Enabled:=false;
ReadParamsGen;
Form1.Show;
Form1.Activate;
end;


//------------------------------------------------------------------------------


procedure TForm1.WriteParams(Name:string);
Var IniFile:TIniFile;
begin
IniFile:=TIniFile.Create(Path+Name);
IniFile.WriteString('TIME','sek ',edit1.Text);
IniFile.WriteBool('LOG','log ',checkbox1.Checked);

for i:=1 to stringgrid2.RowCount-1 do begin
IniFile.WriteString('DIR','dir.'+inttostr(i),stringgrid2.Cells[1,i]);
end;

IniFile.Writeinteger('MOOOVER','CountDir',i-1);

for i:=1 to stringgrid1.RowCount-1 do begin
IniFile.WriteString('DIRNOM','dirNOM.'+inttostr(i),stringgrid1.Cells[0,i]);
IniFile.WriteString('STAN','Stan.'+inttostr(i),stringgrid1.Cells[3,i]);
IniFile.WriteString('HOSTS','Host.'+inttostr(i),stringgrid1.Cells[1,i]);
IniFile.WriteString('HOSTS_MASK','Host Mask.'+inttostr(i),stringgrid1.Cells[2,i]);
end;

IniFile.Writeinteger('MOOOVER','Count',i-1);


IniFile.Free;
end;

procedure TForm1.ReadParams(Name:string);
Var IniFile:TIniFile;
f:integer;
begin
IniFile:=TIniFile.Create(Path+Name);
edit1.Text:=IniFile.Readstring('TIME','sek',edit1.Text);
checkbox1.Checked:=IniFile.Readbool('LOG','log',checkbox1.Checked);

f:=IniFile.Readinteger('MOOOVER','count',f);
stringgrid1.rowcount:=f+1;
for i:=1 to f do begin
stringgrid1.Cells[0,i]:=IniFile.ReadString('DIRNOM','dirNOM.'+inttostr(i),stringgrid1.Cells[0,i]);
stringgrid1.Cells[1,i]:=IniFile.ReadString('HOSTS','Host.'+inttostr(i),stringgrid1.Cells[1,i]);
stringgrid1.Cells[2,i]:=IniFile.ReadString('HOSTS_MASK','Host Mask.'+inttostr(i),stringgrid1.Cells[2,i]);
stringgrid1.Cells[3,i]:=IniFile.ReadString('STAN','Stan.'+inttostr(i),stringgrid1.Cells[3,i]);
end;

f:=IniFile.Readinteger('MOOOVER','countDir',f);
stringgrid2.rowcount:=f+1;
combobox1.Items.Clear;
for i:=1 to f do begin
stringgrid2.Cells[0,i]:=inttostr(i);
stringgrid2.Cells[1,i]:=IniFile.ReadString('DIR','Dir.'+inttostr(i),stringgrid2.Cells[1,i]);
combobox1.Items.Add(inttostr(i)+' - '+stringgrid2.Cells[1,i]);
end;


IniFile.Free;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
WriteParams('Param_'+sg3.Cells[2,it3]+'.ini');
//form1.Timer1.Interval:=strtoint(edit1.text)*1000;
//form1.Hide;
//form1.Timer1.Enabled:=true;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
stringgrid1.RowCount:=stringgrid1.RowCount+1;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
j:integer;
begin

  for j:=it to stringgrid1.RowCount-1 do begin
    if j<>0 then
    stringgrid1.Rows[j]:=stringgrid1.Rows[j+1];
  end;

  stringgrid1.RowCount:=stringgrid1.RowCount-1;
end;

procedure TForm1.StringGrid1Click(Sender: TObject);
begin
it:=stringgrid1.Row;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
readparams('Param_'+sg3.Cells[2,it3]+'.ini');
//form1.Timer1.Enabled:=true;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
stringgrid2.RowCount:=stringgrid2.RowCount+1;
stringgrid2.Cells[0,stringgrid2.RowCount-1]:=inttostr(stringgrid2.RowCount-1);
combobox1.Items.Add(inttostr(stringgrid2.RowCount-1)+' - ');
end;

procedure TForm1.Button4Click(Sender: TObject);
var
j:integer;
begin

  for j:=it to stringgrid2.RowCount-1 do begin
    if j<>0 then  begin
    stringgrid2.Rows[j]:=stringgrid2.Rows[j+1];
    stringgrid2.Cells[0,j]:=inttostr(j);
    combobox1.Items[j-1]:=inttostr(j)+' - '+stringgrid2.Cells[1,j];
    end;
  end;
  stringgrid2.RowCount:=stringgrid2.RowCount-1;
  combobox1.Items.Delete(combobox1.Items.Count-1);

  for j:=1 to stringgrid1.RowCount-1 do begin
    if strtoint(stringgrid1.Cells[0,j])=it then
      stringgrid1.Cells[0,j]:='0';
    if strtoint(stringgrid1.Cells[0,j])>it then
      stringgrid1.Cells[0,j]:=inttostr(strtoint(stringgrid1.Cells[0,j])-1);
  end;


end;

procedure TForm1.StringGrid2Click(Sender: TObject);
begin
it:=stringgrid2.Row;
end;



//------------------------------------------------------------------------------


procedure TForm1.StringGrid1SelectCell(Sender: TObject; Col, Row: Integer;
  var CanSelect: Boolean);
  var R: TRect;
begin

if (((Col <> 0)or (Col <> 3)) and (Row <> 0)) then   begin
    combobox1.Visible:=false;
    combobox2.Visible:=false;
    end;

if ((Col = 0) and (Row <> 0)) then
  begin
    {Size and position the combo box to fit the cell}
    R := StringGrid1.CellRect(Col, Row);
    R.Left := R.Left + StringGrid1.Left;
    R.Right := R.Right + StringGrid1.Left+200;
    R.Top := R.Top + StringGrid1.Top;
    R.Bottom := R.Bottom + StringGrid1.Top;

    {Show the combobox}
    with ComboBox1 do
    begin
      Left := R.Left + 1;
      Top := R.Top + 1;
      Width := (R.Right + 1) - R.Left;
      Height := (R.Bottom + 1) - R.Top;

      ItemIndex := Items.IndexOf(StringGrid1.Cells[Col, Row]);
      if StringGrid1.Cells[Col, Row]<>'' then
      text:= Items[strtoint(StringGrid1.Cells[Col, Row])-1]
      else
      text:='';
      Visible := True;
      SetFocus;
    end;
  end;

  if ((Col = 3) and (Row <> 0)) then
  begin
    {Size and position the combo box to fit the cell}
    R := StringGrid1.CellRect(Col, Row);
    R.Left := R.Left + StringGrid1.Left-150;
    R.Right := R.Right + StringGrid1.Left;
    R.Top := R.Top + StringGrid1.Top;
    R.Bottom := R.Bottom + StringGrid1.Top;

    {Show the combobox}
    with ComboBox2 do
    begin
      Left := R.Left + 1;
      Top := R.Top + 1;
      Width := (R.Right + 1) - R.Left;
      Height := (R.Bottom + 1) - R.Top;

      ItemIndex := Items.IndexOf(StringGrid1.Cells[Col, Row]);
       if StringGrid1.Cells[Col, Row]<>'' then
       text:= Items[strtoint(StringGrid1.Cells[Col, Row])]
      else
      text:='';Visible := True;
      SetFocus;
    end;
  end;

  CanSelect := True;

end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var intRow: Integer;
begin
  inherited;

  {Get the ComboBox selection and place in the grid}
  with ComboBox1 do
  begin
    intRow := StringGrid1.Row;
    if (StringGrid1.Col = 2) then
      StringGrid1.Cells[2, intRow] := Items[ItemIndex]
    else
      StringGrid1.Cells[StringGrid1.Col, intRow] := inttostr(ItemIndex+1);
    Visible := False;
  end;
  StringGrid1.SetFocus;

end;

procedure TForm1.ComboBox2Change(Sender: TObject);
var intRow: Integer;
begin
  inherited;

  {Get the ComboBox selection and place in the grid}
  with ComboBox2 do
  begin
    intRow := StringGrid1.Row;
    if (StringGrid1.Col = 2) then
      StringGrid1.Cells[2, intRow] := Items[ItemIndex]
    else
      StringGrid1.Cells[StringGrid1.Col, intRow] := inttostr(ItemIndex);
    Visible := False;
  end;
  StringGrid1.SetFocus;

end;

procedure TForm1.WMQueryEndSession(var Message: TWMQueryEndSession);
begin
inherited;
 Form1.Close;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
sg3.RowCount:=sg3.RowCount+1;
sg3.Cells[3,sg3.RowCount-1]:='30000';
end;

procedure TForm1.Button6Click(Sender: TObject);
var
j:integer;
begin

  for j:=it3 to sg3.RowCount-1 do begin
    if j<>0 then
    sg3.Rows[j]:=sg3.Rows[j+1];
  end;

  sg3.RowCount:=sg3.RowCount-1;
end;

procedure TForm1.sg3Click(Sender: TObject);
begin
if button7.Caption='Ще один Лог' then
   button7.Caption:='Преглянути Лог';

it3:=sg3.Row;
  form1.Caption:='Mover Client  підключитись до '+sg3.Cells[2,it3];
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
WriteParamsGen;
end;

procedure TForm1.btn1Click(Sender: TObject);
var
  fsend:TFormSend;
begin
  fsend:=TFormSend.Create(Application);
  try
    fsend.ShowModal;
  finally
    FreeAndNil(fsend);
  end;

end;

procedure TForm1.Button8Click(Sender: TObject);
var
stream: TMemoryStream;
  msg: string;
  sz: integer;
begin

host:= sg3.Cells[2,it3];

    tcpclient1.RemoteHost:=host;
    tcpclient1.RemotePort:=sg3.Cells[3,it3] ;
    tcpclient1.Active:=true;

  if TcpClient1.Connect then
  begin

    TCPClient1.Sendln('4');

    msg := TcpClient1.Receiveln;

if msg='' then begin
 showmessage('Properties.ini на '+host+' не знайдено!');
 addlog('Properties.ini на '+host+' не знайдено!')
end
else begin


    stream := TMemoryStream.Create;
    sz := StrToInt(msg);
    stream.SetSize(sz);
    TcpClient1.Sendln('ok');

    TcpClient1.ReceiveBuf(stream.Memory^, sz);
    stream.SaveToFile('Param_'+host+'.ini');
    stream.Free;
    TcpClient1.Disconnect;
    readparams('Param_'+host+'.ini');
    addlog('Від '+host+' отримано Param_'+host+'.ini');
    end;
  end
  else showmessage('Не вдалось з`єднатись!');
   tcpclient1.Active:=false;
end;

procedure TForm1.Button9Click(Sender: TObject);
var
  stream: TMemoryStream;
  msg: string;
  sz: integer;
begin
host:= sg3.Cells[2,it3];
tcpclient1.RemoteHost:=host;
    tcpclient1.RemotePort:=sg3.Cells[3,it3] ;
    tcpclient1.Active:=true;

 if TcpClient1.Connect then
  begin
     TcpClient1.Sendln('1');
    stream := TMemoryStream.Create; 
    stream.LoadFromFile(path+'Param_'+host+'.ini');
    TcpClient1.Sendln(IntToStr(stream.Size));
    if TcpClient1.Receiveln = 'ok' then
      TcpClient1.SendBuf(stream.Memory^, stream.Size);
      stream.Free;

      addlog(host+' Відправлено Param_'+host+'.ini');

       TcpClient1.Disconnect;
  end
  else showmessage('Не вдалось з`єднатись!');
  tcpclient1.Active:=false;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  stream: TMemoryStream;
  msg,time1,time2,time: string;
  sz: integer;
  fs:TMemoryStream;//tfilestream;
begin
 time1:=timetostr(now)[4]+timetostr(now)[5]+','+timetostr(now)[7]+timetostr(now)[8];


host:= sg3.Cells[2,it3];
tcpclient1.RemoteHost:=host;
    tcpclient1.RemotePort:=sg3.Cells[3,it3] ;
    tcpclient1.Active:=true;

 if TcpClient1.Connect then
  begin

  if button7.Caption='Преглянути Лог' then begin
   button7.Caption:='Ще один Лог';

  TcpClient1.Sendln('2');

msg := TcpClient1.Receiveln;
if msg='' then begin
 showmessage('Mover.log на '+host+' не знайдено!');
 addlog('Mover.log на '+host+' не знайдено!')
end
else begin
    fs := TmemoryStream.Create;
    sz := StrToInt(msg);
    fs.SetSize(sz);
    TcpClient1.Sendln('ok');
    TcpClient1.ReceiveBuf(fs.Memory^, sz);
  //  tcpclient1.ReceiveBuf(fs,sz);
//      if stream.Size=sz then begin
//    stream.SaveToFile('Mover_'+host+'.log');
      fs.SaveToFile('Mover_'+host+'.log');
    TcpClient1.Sendln('end');
    fs.Free;
    TcpClient1.Disconnect;
    memo1.lines.loadfromfile('Mover_'+host+'.log');

    addlog('Від '+host+' Mover_'+host+'.log');
//      end;

    end;
    end
    else begin
   button7.Caption:='Преглянути Лог';
   tcpClient1.Sendln('3');

    msg := TcpClient1.Receiveln;
if msg='' then begin
 showmessage('Mover_old.log на '+host+' не знайдено!');
 addlog('Mover_old.log на '+host+' не знайдено!')
end
else begin

    stream := TMemoryStream.Create;
    sz := StrToInt(msg);
    stream.SetSize(sz);
    TcpClient1.Sendln('ok');

    TcpClient1.ReceiveBuf(stream.Memory^, sz);
    stream.SaveToFile('Mover_old_'+host+'.log');
    stream.Free;
    TcpClient1.Disconnect;
    memo1.lines.loadfromfile('Mover_old_'+host+'.log');

    addlog('Від '+host+' отримано Mover_old_'+host+'.log');
    end;
    end;

    end
  else showmessage('Не вдалось з`єднатись!');
  tcpclient1.Active:=false;

  time2:=timetostr(now)[4]+timetostr(now)[5]+','+timetostr(now)[7]+timetostr(now)[8];
  time:=floattostr(strtofloat(time2)-strtofloat(time1));
  showmessage(time);
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
memo1.Clear;
end;

procedure TForm1.Button10Click(Sender: TObject);
var
  stream: TMemoryStream;
  msg: string;
  sz: integer;
begin
if edit2.Text<>'' then begin
host:= sg3.Cells[2,it3];
tcpclient1.RemoteHost:=host;
    tcpclient1.RemotePort:=sg3.Cells[3,it3] ;
    tcpclient1.Active:=true;

 if TcpClient1.Connect then
  begin
   TcpClient1.Sendln('5');
   msg := TcpClient1.Receiveln;
   if msg = 'ok' then
    TcpClient1.Sendln(edit2.Text);
    addlog(host+' Відправлено повідомлення "'+edit2.Text+'"')

  end
  else showmessage('Не вдалось з`єднатись!');
  tcpclient1.Active:=false;
 end;
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
if button12.Caption='Запустити' then begin
   button12.Caption:='Зупинити';

 Timer1.Interval:=strtoint(edit1.text)*1000;

 Timer1.Enabled:=true;

   end
else  begin
   button12.Caption:='Запустити';
   Timer1.Enabled:=false;

end;


end;

end.
