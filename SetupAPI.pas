unit SetupAPI;

interface
uses Windows;
const
  CfgMgrDllName = 'cfgmgr32.dll';
  SetupApiModuleName = 'SETUPAPI.DLL';
  CR_NO_SUCH_VALUE            = $00000025;
  DIGCF_PRESENT               = $00000002;
  SPDRP_HARDWAREID            = $00000001;
type
  PSPDevInfoData = ^TSPDevInfoData;
  SP_DEVINFO_DATA = packed record
    cbSize: DWORD;
    ClassGuid: TGUID;
    DevInst: THandle;
    Reserved: DWORD;
  end;
  TSPDevInfoData = SP_DEVINFO_DATA;
function CM_Enumerate_Classes(ulClassIndex: DWORD; var ClassGuid: TGUID;
  ulFlags: DWORD): DWORD; stdcall; external CfgMgrDllName name 'CM_Enumerate_Classes';
function SetupDiGetClassDescription(var ClassGuid: TGUID; ClassDescription: PWideChar;
  ClassDescriptionSize: DWORD; var RequiredSize: DWORD): BOOL; stdcall;
  external SetupApiModuleName name 'SetupDiGetClassDescriptionW';
function SetupDiGetClassDevs(ClassGuid: PGUID; const Enumerator: PWideChar;
   hwndParent: HWND; Flags: DWORD): THandle; stdcall; external SetupApiModuleName
   name 'SetupDiGetClassDevsW';
function SetupDiEnumDeviceInfo(DeviceInfoSet: THandle; MemberIndex: DWORD;
  var DeviceInfoData: TSPDevInfoData): BOOL; stdcall; external SetupApiModuleName name 'SetupDiEnumDeviceInfo';
function SetupDiDestroyDeviceInfoList(DeviceInfoSet: THandle): BOOL; stdcall;
  external SetupApiModuleName name 'SetupDiDestroyDeviceInfoList';
function SetupDiGetDeviceRegistryProperty(DeviceInfoSet: THandle;
  const DeviceInfoData: TSPDevInfoData; Property_: DWORD;
  var PropertyRegDataType: DWORD; PropertyBuffer: PBYTE; PropertyBufferSize: DWORD;
  var RequiredSize: DWORD): BOOL; stdcall; external SetupApiModuleName name 'SetupDiGetDeviceRegistryPropertyW';
implementation
end.
