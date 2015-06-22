unit Unit1;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, SetupAPI, ShellApi, IniFiles;
type
  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    OpenDialog1: TOpenDialog;
    Button4: TButton;
    procedure CheckBox1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  Form1: TForm1; temp: ShortString;
implementation

uses Unit2;
{$R *.dfm}
function GetDeviceHardwareID(DeviceHandle: THandle;
  const DeviceData: TSPDevInfoData): WideString;
const
  BUFFER_SIZE = 256;
var
  Buffer: PWideChar;
  RequiredSize: DWORD;
begin
  Result := '';
  RequiredSize := BUFFER_SIZE;
  GetMem(Buffer, RequiredSize);
  try
    repeat
      ReallocMem(Buffer, RequiredSize);
      if SetupDiGetDeviceRegistryProperty(DeviceHandle, DeviceData, SPDRP_HARDWAREID,
        PDWORD(Nil)^, PByte(Buffer), RequiredSize, RequiredSize) then
      begin
        Result := Buffer;
        Break;
      end;
    until GetLastError <> ERROR_INSUFFICIENT_BUFFER;
  finally
    FreeMem(Buffer);
  end;
end;
procedure EnumDevices(DeviceGUID: PGUID; ANode: TTreeNode);
var
  I: DWORD;
  DeviceHandle: THandle;
  DeviceData: TSPDevInfoData;
  HardwareID: WideString;
  s: integer;
  lpDisplayDevice: TDisplayDevice;
begin
  s:=0;
  DeviceHandle := SetupDiGetClassDevs(DeviceGUID, Nil, 0, DIGCF_PRESENT);
  if DeviceHandle <> INVALID_HANDLE_VALUE then
  try
    I := 0;
    DeviceData.cbSize := SizeOf(TSPDevInfoData);
    repeat
      if not SetupDiEnumDeviceInfo(DeviceHandle, I, DeviceData) then
        Break;
      HardwareID := GetDeviceHardwareID(DeviceHandle, DeviceData);
      if HardwareID <> '' then
        Form2.TreeView1.Items.AddChild(ANode, HardwareID);
        if ((ANode.Text = 'Видеоадаптеры') or (ANode.Text = 'Display adapters')) and (s = 0) then
          begin Inc(s); lpDisplayDevice.cb := sizeof(lpDisplayDevice); EnumDisplayDevices(nil, 0, lpDisplayDevice , 0); Form1.Edit1.Text := lpDisplayDevice.DeviceString; temp:= HardwareID; temp[0]:=Chr(Length(temp)-7); Form1.Edit2.Text:= temp end;
      Inc(I);
    until False;
  finally
    SetupDiDestroyDeviceInfoList(DeviceHandle);
  end;
end;
procedure ListDevices;
const
  LINE_LEN = 256;
var
  I: ULONG;
  Res: DWORD;
  Node: TTreeNode;
  GUID: TGUID;
  Buffer: array [0..LINE_LEN - 1] of WideChar;
begin
  I := 0;
  repeat
    Res := CM_Enumerate_Classes(I, GUID, 0);
    if Res <> CR_NO_SUCH_VALUE then
    begin
      if SetupDiGetClassDescription(GUID, @Buffer[0],
        LINE_LEN, PDWORD(Nil)^) then
      begin
        Node := Form2.TreeView1.Items.AddChild(Nil, Buffer);
        Application.ProcessMessages;
        EnumDevices(@GUID, Node);
      end;
    end;
    Inc(I);
  until RES = CR_NO_SUCH_VALUE;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
if CheckBox1.Checked = true then
   Form2.Show
else Form2.Close;
end;

procedure TForm1.Button4Click(Sender: TObject);
var IniFile:TIniFile; st: TstringList; i,j:integer; s, t:ShortString;
begin
st:=TStringList.Create;
t:=Edit2.Text;
t[0]:= Chr(Length(t)-16);
if OpenDialog1.Execute then
  if FileExists(OpenDialog1.FileName) then
   begin
   IniFile:=TInifile.Create(OpenDialog1.FileName);
   IniFile.ReadSection('IntelGfx.NTx86.6.3', st);
   If st.Count < 1 then
      IniFile.ReadSection('IntelGfx.NTamd64.6.3', st);
   for i:=0 to st.Count-1 do
   begin
   s:= IniFile.ReadString('IntelGfx.NTx86.6.3', st.Strings[i], IniFile.ReadString('IntelGfx.NTamd64.6.3', st.Strings[i], 'iVLV2M_w81, PCI\VEN_8086&DEV_0F31'));
   j:= AnsiPos(',',s);
   delete(s,1,j+1);

   if s = t then
      begin
      t:=Edit2.Text;
      j:= AnsiPos('&',t);
      delete(t,1,j);
      j:= AnsiPos('&',t);
      delete(t,1,j-1);
      s:= IniFile.ReadString('IntelGfx.NTx86.6.3', st.Strings[i], IniFile.ReadString('IntelGfx.NTamd64.6.3', st.Strings[i], 'iVLV2M_w81, PCI\VEN_8086&DEV_0F31'));
      IniFile.WriteString('IntelGfx.NTx86.6.3',st.Strings[i],' ' + s + t);
      IniFile.WriteString('IntelGfx.NTx86.6.4',st.Strings[i],' ' + s + t);
      IniFile.WriteString('IntelGfx.NTamd64.6.3',st.Strings[i],' ' + s + t);
      IniFile.WriteString('IntelGfx.NTamd64.6.4',st.Strings[i],' ' + s + t);

      MessageBox(handle,PChar('Inf patched succesfully!'), PChar('Success'), MB_OK+MB_ICONINFORMATION);
      Close;
      end
   else if s = Edit2.Text then begin MessageBox(handle,PChar('Inf already patched!'), PChar('Attention'), MB_OK+MB_ICONINFORMATION); Close; end
        else
        begin
        s[0]:= Chr(Length(s)-16);
        j:= AnsiPos(',',s);
        delete(s,1,j);
        t:=Edit2.Text;
        t[0]:= Chr(Length(t)-16);
        if s = t then
          begin
          t:=Edit2.Text;
          j:= AnsiPos('&',t);
          delete(t,1,j);
          j:= AnsiPos('&',t);
          delete(t,1,j-1);
          s:= IniFile.ReadString('IntelGfx.NTx86.6.3', st.Strings[i], IniFile.ReadString('IntelGfx.NTamd64.6.3', st.Strings[i], 'iVLV2M_w81, PCI\VEN_8086&DEV_0F31'));
          s[0]:= Chr(Length(s)-16);
          IniFile.WriteString('IntelGfx.NTx86.6.3',st.Strings[i],' ' + s + t);
          IniFile.WriteString('IntelGfx.NTx86.6.4',st.Strings[i],' ' + s + t);
          IniFile.WriteString('IntelGfx.NTamd64.6.3',st.Strings[i],' ' + s + t);
          IniFile.WriteString('IntelGfx.NTamd64.6.4',st.Strings[i],' ' + s + t);

          MessageBox(handle,PChar('Inf patched succesfully!'), PChar('Success'), MB_OK+MB_ICONINFORMATION);
          Close;
        end
   end;
   end;
   end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
CheckBox1.Visible:=true;
  Edit1.Visible:=true;
  Edit2.Visible:=true;
  ListDevices;
end;

end.

