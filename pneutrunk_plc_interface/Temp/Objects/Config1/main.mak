SHELL := cmd.exe
CYGWIN=nontsec
export PATH := C:\Program Files\Common Files\Oracle\Java\javapath;C:\ProgramData\Oracle\Java\javapath;C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\Program Files\MATLAB\R2023b\runtime\win64;C:\Program Files\MATLAB\R2023b\bin;C:\Program Files\MATLAB\R2023a\runtime\win64;C:\Program Files\MATLAB\R2023a\bin;C:\Program Files (x86)\Windows Kits\8.1\Windows Performance Toolkit\;C:\Program Files\Git\cmd;C:\apache-maven-3.8.8\bin;C:\Program Files\Java\jdk1.8.0_111\bin;C:\Users\km\AppData\Local\Microsoft\WindowsApps;C:\Program Files (x86)\Common Files\Hilscher GmbH\TLRDecode;C:\Users\km\AppData\Local\Microsoft\WindowsApps;C:\Program Files (x86)\Common Files\Hilscher GmbH\TLRDecode;C:\BRAutomation\AS412\bin-en\4.12;C:\BRAutomation\AS412\bin-en\4.11;C:\BRAutomation\AS412\bin-en\4.10;C:\BRAutomation\AS412\bin-en\4.9;C:\BRAutomation\AS412\bin-en\4.8;C:\BRAutomation\AS412\bin-en\4.7;C:\BRAutomation\AS412\bin-en\4.6;C:\BRAutomation\AS412\bin-en\4.5;C:\BRAutomation\AS412\bin-en\4.4;C:\BRAutomation\AS412\bin-en\4.3;C:\BRAutomation\AS412\bin-en\4.2;C:\BRAutomation\AS412\bin-en\4.1;C:\BRAutomation\AS412\bin-en\4.0;C:\BRAutomation\AS412\bin-en
export AS_BUILD_MODE := Build
export AS_VERSION := 4.12.2.93
export AS_WORKINGVERSION := 4.12
export AS_COMPANY_NAME :=  
export AS_USER_NAME := km
export AS_PATH := C:/BRAutomation/AS412
export AS_BIN_PATH := C:/BRAutomation/AS412/bin-en
export AS_PROJECT_PATH := C:/PneuTrunk/pneutrunk_plc_experiments
export AS_PROJECT_NAME := pneutrunk_V2
export AS_SYSTEM_PATH := C:/BRAutomation/AS/System
export AS_VC_PATH := C:/BRAutomation/AS412/AS/VC
export AS_TEMP_PATH := C:/PneuTrunk/pneutrunk_plc_experiments/Temp
export AS_CONFIGURATION := Config1
export AS_BINARIES_PATH := C:/PneuTrunk/pneutrunk_plc_experiments/Binaries
export AS_GNU_INST_PATH := C:/BRAutomation/AS412/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH := C:/BRAutomation/AS412/AS/GnuInst/V4.1.2/4.9/bin
export AS_GNU_INST_PATH_SUB_MAKE := C:/BRAutomation/AS412/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH_SUB_MAKE := C:/BRAutomation/AS412/AS/GnuInst/V4.1.2/4.9/bin
export AS_INSTALL_PATH := C:/BRAutomation/AS412
export WIN32_AS_PATH := "C:\BRAutomation\AS412"
export WIN32_AS_BIN_PATH := "C:\BRAutomation\AS412\bin-en"
export WIN32_AS_PROJECT_PATH := "C:\PneuTrunk\pneutrunk_plc_experiments"
export WIN32_AS_SYSTEM_PATH := "C:\BRAutomation\AS\System"
export WIN32_AS_VC_PATH := "C:\BRAutomation\AS412\AS\VC"
export WIN32_AS_TEMP_PATH := "C:\PneuTrunk\pneutrunk_plc_experiments\Temp"
export WIN32_AS_BINARIES_PATH := "C:\PneuTrunk\pneutrunk_plc_experiments\Binaries"
export WIN32_AS_GNU_INST_PATH := "C:\BRAutomation\AS412\AS\GnuInst\V4.1.2"
export WIN32_AS_GNU_BIN_PATH := "C:\BRAutomation\AS412\AS\GnuInst\V4.1.2\bin"
export WIN32_AS_INSTALL_PATH := "C:\BRAutomation\AS412"

.suffixes:

ProjectMakeFile:

	@'$(AS_BIN_PATH)/4.9/BR.AS.AnalyseProject.exe' '$(AS_PROJECT_PATH)/pneutrunk_V2.apj' -t '$(AS_TEMP_PATH)' -c '$(AS_CONFIGURATION)' -o '$(AS_BINARIES_PATH)'   -sfas -buildMode 'Build'   

