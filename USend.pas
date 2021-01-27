unit USend;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ImgList, JvComponentBase, JvZlibMultiple,
  crc32, DateUtils, ShellApi, IniFiles, Gauges;

type
  TFormSend = class(TForm)
    lv1: TListView;
    lv2: TListView;
    b1: TBitBtn;
    b2: TBitBtn;
    il1: TImageList;
    ZM1: TJvZlibMultiple;
    chk1: TCheckBox;
    lbl1: TLabel;
    b3: TBitBtn;
    b4: TBitBtn;
    il2: TImageList;
    cb1: TComboBox;
    g1: TGauge;
    function mass(mask: string; pars: boolean = false):string;
    procedure FormCreate(Sender: TObject);
    procedure b2Click(Sender: TObject);
    procedure b1Click(Sender: TObject);
    procedure b3Click(Sender: TObject);
    procedure b4Click(Sender: TObject);
    procedure lv2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSend: TFormSend;

implementation

uses
  unit1;


{$R *.dfm}

function tFormSend.mass(mask: string; pars: boolean = false):string;
type
  newD=record
    d:tDateTime;
    s:String;
  end;

function newDate(d,znak:string;l,t:integer;dt:tDateTime):newD;
var
  j,a:integer;
  s:string;
  dat:tdatetime;
begin
  j:=l+2;
  s:='';
          while d[j] in ['0'..'9'] do  begin
            s:=s+d[j];
            j:=j+1;
          end;
          delete(d,(l+1),(j-l-1));
          a:=strtoint(s);
          if znak='-' then begin
            case t of
            1: dat:=IncDay(dt,-a);
            2: dat:=IncMonth(dt,-a);
            3: dat:=IncYear(dt,-a);
            end;
          end
          else begin
            case t of
            1: dat:=IncDay(dt,+a);
            2: dat:=IncMonth(dt,+a);
            3: dat:=IncYear(dt,+a);
            end;
          end;


        result.d:=dat;//formatdatetime(d,dat);
        result.s:=d;
end;

var
i,l:smallint;
newmask,d:string;
dat:tdatetime;
a:newD;
begin
  i:=1;
  while i<=length(mask) do begin
    if (mask[i]<>'<') then
     newmask:=newmask+mask[i]
    else begin
      d:='';
      inc(i);

      while (mask[i]<>'>') and (i<=length(mask)) do begin
        d:=d+mask[i];
        inc(i);
      end; 

          if (pos('D',AnsiUpperCase(d))>0)or(pos('M',AnsiUpperCase(d))>0)or(pos('Y',AnsiUpperCase(d))>0)
          or(pos('H',AnsiUpperCase(d))>0)or(pos('N',AnsiUpperCase(d))>0)or(pos('S',AnsiUpperCase(d))>0) then begin

            dat:=now;
            l:=pos('D-',AnsiUpperCase(d));
            if l>0 then begin
              a:=newDate(d,'-',l,1,dat);
              d:=a.s;
              dat:=a.d;
            end;
            l:=pos('D+',AnsiUpperCase(d));
            if l>0 then begin
              a:=newDate(d,'+',l,1,dat);
              d:=a.s;
              dat:=a.d;
            end;
            l:=pos('M-',AnsiUpperCase(d));
            if l>0 then begin
              a:=newDate(d,'-',l,2,dat);
              d:=a.s;
              dat:=a.d;
            end;
            l:=pos('M+',AnsiUpperCase(d));
            if l>0 then begin
              a:=newDate(d,'+',l,2,dat);
              d:=a.s;
              dat:=a.d;
            end;
            l:=pos('Y-',AnsiUpperCase(d));
            if l>0 then begin
              a:=newDate(d,'-',l,3,dat);
              d:=a.s;
              dat:=a.d;
            end;
            l:=pos('Y+',AnsiUpperCase(d));
            if l>0 then begin
              a:=newDate(d,'+',l,3,dat);
              d:=a.s;
              dat:=a.d;
            end;

            d:=formatdateTime(d,dat);

            newmask:=newmask+d;
          end;






    end;

  i:=i+1;
  end;

  result:=newmask;

end;


function SendTcp(dir,ip:string;stream:Tstream;ow:boolean):boolean;
var
//  stream: TMemoryStream;
  k,z:integer;
  b:array [1..1280] of Byte;
  //ini:tMemInifile;
  zap:string;
begin
try
  result:=false;

  if ow=false then
    zap:='two'
  else
    zap:='one';

  form1.TcpClient1.RemoteHost:=ip;
  form1.TcpClient1.RemotePort:='30000';


  if form1.TcpClient1.Connect then begin
    form1.TcpClient1.Sendln('SendFileAdm');
    //Form1.addlog('SendFileAdmin');
    if form1.TcpClient1.Receiveln='ok' then begin
      //Form1.addlog('ok, send 1');
       form1.TcpClient1.Sendln('1');
       if form1.TcpClient1.Receiveln='ok' then begin
        //Form1.addlog('ok, send dir');

          form1.TcpClient1.Sendln(FormSend.mass(dir));

          if form1.TcpClient1.Receiveln='ok' then begin
           //Form1.addlog('ok, send name');
            form1.TcpClient1.Sendln(FormatDateTime('YYYMMDDhhnnsszz',now));
            if form1.TcpClient1.Receiveln='ok' then begin
              //Form1.addlog('ok, send one|two');
              form1.TcpClient1.Sendln(zap);
              ip:=form1.TcpClient1.Receiveln;
              //Form1.addlog('rezultat - '+ip);
              if ip='ok' then begin
              try
                 form1.TcpClient1.Sendln(inttostr(stream.Size));
                 //Form1.addlog('розмір  '+inttostr(stream.Size));
                 //-------------------------------------------------------------

                 if form1.TcpClient1.Receiveln='ok' then begin
                  //Form1.addlog('розмір ok ');
                  form1.TcpClient1.Sendln(inttostr(StreamCRC32(stream)));
                  //Form1.addlog('vsdpravka - CRC - ');
                  //if form1.TcpClient1.Receiveln='ok' then begin
                  z:=0;
                   repeat

                    stream.Position:=0;

                    //Form1.addlog('kilkist 4astyn - '+IntToStr(stream.Size div 1280));
                    
                    for k := 0 to stream.Size div 1280 do begin
                      //Form1.addlog('vidpravka - '+inttostr(k));
                      if (form1.TcpClient1.Receiveln='ok')or(form1.TcpClient1.Receiveln='err') then begin
                        if k=stream.Size div 1280 then begin
                          stream.ReadBuffer(b,stream.Size mod 1280);
                          form1.TcpClient1.SendBuf(b,stream.Size mod 1280);
                        // FormSend.g1.Progress:=FormSend.g1.MaxValue;

                        end
                        else begin
                          stream.ReadBuffer(b,1280);
                          form1.TcpClient1.SendBuf(b,1280);
                         // FormSend.g1.Progress:=k+1;
                        end;
                      end;
                    end;

                    ip:=form1.TcpClient1.Receiveln ;
                    if ip='ok' then begin

                      result:=true;
                      break;
                    end
                    else begin
                      result:=False;
                      break;
                    end;

                    z:=z+1;

                   until z>5;
                  //end;
                 end;


               finally
                //stream.Free;
               end;

              end else begin
              form1.TcpClient1.Disconnect;
              form1.addlog(ip);
              end;
            end else
              form1.TcpClient1.Disconnect; 
          end else
              form1.TcpClient1.Disconnect; 
       end else begin
        form1.TcpClient1.Disconnect;
        form1.addlog('Якась помилка ');

       end;

     end else
      form1.TcpClient1.Disconnect;

  end
  else begin
    form1.TcpClient1.Disconnect;
    form1.addlog('Невдалось з''єднатись з '+ip);
  end;


finally
//  stream.Free;
end;

end;

procedure TFormSend.b1Click(Sender: TObject);
var
  I: Integer;
  ip,dir:string;
  fn:TStringList;
  j: Integer;
  str:TStream;
  ini:TMemIniFile;
begin
  ini:=TmemIniFile.Create(ExtractFilePath(Application.ExeName)+'MyParam.ini');
  fn:=TStringList.Create;
 // str:=TStream.Create;
  try

    if cb1.ItemIndex<>-1 then begin
      ini.WriteInteger('SDIR','count',cb1.Items.Count);
    end
    else  begin
      if cb1.Items[0]<>cb1.Text then begin
        ini.WriteINteger('SDIR','count',cb1.Items.Count+1);
        cb1.Items.Insert(0,cb1.Text);
      end;
    end;
    for I := 1 to cb1.Items.Count do begin
      ini.WriteString('SDIR','dir_'+inttostr(i),cb1.Items[i-1]);
    end;

    ini.UpdateFile;


    b1.Enabled:=false;
    if (cb1.Text<>'')and(lv2.Items.Count<>0) then begin
     {
      for j := 0 to lv2.Items.Count - 1 do
          if lv2.Items[j].Caption <>'' then
           fn.Add(lv2.Items[j].Caption);

      str:=ZM1.CompressFiles(fn);

      g1.MaxValue:= (str.Size div 1280) +1;
        }


    for I := 0 to lv1.Items.Count - 1 do begin
      if lv1.Items.Item[i].Checked then begin
         str:=TStream.Create;
         try
          for j := 0 to lv2.Items.Count - 1 do
          if lv2.Items[j].Caption <>'' then
           fn.Add(lv2.Items[j].Caption);
            
            str:=ZM1.CompressFiles(fn);
          g1.MaxValue:= (str.Size div 1280) +1;

            if i>=lv1.VisibleRowCount then
              lv1.Items.Item[i].MakeVisible(true);


            lv1.Items[i].ImageIndex:=1;
            lv1.Update;
            ip:=lv1.Items.Item[i].SubItems[0];
            dir:=cb1.Text;
            fn.Clear;



            form1.addlog('Підготовлено файл(и) для копіювання до "' +lv1.Items[i].Caption+'" ('+lv1.Items[i].SubItems[0]+')');
            for j := 0 to lv2.Items.Count - 1 do begin
              form1.addlog(lv2.Items[j].Caption);
            end;
            g1.Progress:=0;
            if sendtcp(dir,ip,str,chk1.Checked) then begin
              form1.addlog('Файл(и) скопійовано до ' +lv1.Items[i].Caption);
              lv1.Items[i].ImageIndex:=2;
            end
            else begin
              form1.addlog('Файл(и) НЕ скопійовано до ' +lv1.Items[i].Caption+' ('+lv1.Items[i].SubItems[0]+')');
              lv1.Items[i].ImageIndex:=3;
            end;

            g1.Progress:=g1.MaxValue;
         finally
           FreeAndNil(str);
         end;
      end;

    end
    end
    else
      Application.MessageBox('Невказано шлях або не обрано файли!','Увага',MB_ICONWARNING+mb_ok)

  finally
    ini.Free;
  // FreeAndNil(str);
   FreeAndNil(fn);
   b1.Enabled:=True;
  end;

end;

procedure TFormSend.b2Click(Sender: TObject);
var
  op:TOpenDialog;
  item:TListItem;
  I: Integer;
  ic : TIcon;
  ext:string;
  fi: TSHFileInfo;
begin
  op:=TOpenDialog.Create(nil);
  try
    op.Options:=op.Options+[ofAllowMultiSelect];
    if op.Execute then begin
      lv2.Items.Clear;
      lv2.SmallImages.Clear;
      for I := 0 to op.Files.Count - 1 do begin
        item:=lv2.Items.Add;
        item.Caption:=op.Files[i];
        ic := TIcon.Create;
      try
        ext := LowerCase(ExtractFileExt(item.Caption));
        SHGetFileInfo(PChar('*' + ext),
                      FILE_ATTRIBUTE_NORMAL,
                      fi,
                      SizeOf(fi),
                      SHGFI_ICON or SHGFI_SMALLICON or
                      SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES
                      );
        ic.Handle := fi.hIcon;
        lv2.SmallImages.AddIcon(ic);
        item.ImageIndex := lv2.SmallImages.Count - 1;
      finally
        ic.Free;
      end;
      end;







    end;




  finally
    FreeAndNil(op);
  end;

end;

procedure TFormSend.b3Click(Sender: TObject);
var
  i:Integer;
begin
for I := 0 to lv1.Items.Count - 1 do
       lv1.Items.Item[i].Checked:=True;
end;

procedure TFormSend.b4Click(Sender: TObject);
var
  i:Integer;
begin
for I := 0 to lv1.Items.Count - 1 do
       lv1.Items.Item[i].Checked:=False;
end;

procedure TFormSend.FormCreate(Sender: TObject);
var
  item:TListItem;
  i:integer;
  ini:TMemIniFile;
begin
  ini:=TmemIniFile.Create(ExtractFilePath(Application.ExeName)+'MyParam.ini');
  try
    lv1.Items.Clear;
    lv2.Items.Clear;
    for I := 1 to form1.sg3.RowCount - 1 do begin
      item:=lv1.Items.Add();
      item.Caption:=form1.sg3.Cells[1,i];
      item.SubItems.Add(form1.sg3.Cells[2,i]);
     // item.Checked:=True;
    end;

    cb1.Items.Clear;
    for I := 1 to ini.ReadInteger('SDIR','count',0) do begin
      cb1.Items.Add(ini.ReadString('SDIR','dir_'+inttostr(i),''));
    end;


  finally
    ini.Free;

  end;


end;

procedure TFormSend.lv2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
  if Key=VK_DELETE then
    lv2.Selected.Delete;
  except
  end;
end;

end.
