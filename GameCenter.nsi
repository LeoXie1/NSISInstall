
# ====================== ???? ==============================
!define PRODUCT_NAME           "jϫӎϷ֐" ;ҺƷûӆìжԘЅϢעҡѭ·޶Ӄս
!define EXE_NAME               "testGame.exe" ;ִА΄ܾû вװݡʸה֯ԋАӃս
!define INST_SUBDIR            "test" ;вװ΄ܾعĿ¼û жԘɾӽ΄ܾӃս
!define PRODUCT_VERSION        "1.0.0.0" ;ЦѾڅ
!define PRODUCT_PUBLISHER      "test" ;ҺƷעАɌûӆ ĬȏвװĿ¼Ӄս
!define PRODUCT_LEGAL          "Copyright (C) 1998-2018 test, All Rights Reserved" ;ЦȨЅϢ
!define CONFIGINI_NAME_PRE     "info" ;info0804.ini info0409.ini info0404.ini вװжԘ̡ʾЅϢŤփ΄ܾ
!define LICENSETXT_FILE_PRE       "license" ;license0804.txt license0409.txt license0404.txt Ȩ;ɹ÷
!define SKINFILEXML_PRE           "install" ;install0804.xml install0409.xml install0404.xml вװݧæƤ״΄ܾ
!define SKINFILEXML_UNINST_PRE           "uninstall" ;install0804.xml install0409.xml install0404.xml жԘݧæƤ״΄ܾ
!define PCODE                  "" ;ϮĿڅ жԘЅϢעҡѭ·޶Ӄս
!define TIME_COMPILE_INSTALLER "2018-4-30"

!define WIDTH 600 ;????
!define HEIGHT 340 ;????
!define WIDTH_MORE 600 ;??????????
!define HEIGHT_MORE 440 ;??????????
!define INNER_POS "10,30,590,335" ;ȧ????ǳ
!define INNER_POS_MORE  "10,30,590,435" ;??????ȧ????ǳ

!define UINST_EXE_NAME "uninst.exe" ;ǘ??Ǔ??
!define TEMP_USEDATA_DIR "$LOCALAPPDATA\testGameTMP" ;??????
!define /date PRODUCT_DATE %Y%m%d
;ShowInstDetails show ;??????

# ==================== NSIS?ǥ ================================
;SetCompressor /SOLID LZMA
;SetCompressor zlib

# ===================== ??????? =============================
!include "LogicLib.nsh"
!include "nsDialogs.nsh"
!include "include\common.nsh"
!include "StdUtils.nsh"

# ===================== Ǔ?ǞǸ? =============================
VIProductVersion                    "${PRODUCT_VERSION}"
VIAddVersionKey "ProductVersion"    "${PRODUCT_VERSION}"
VIAddVersionKey "ProductName"       "${PRODUCT_NAME}"
VIAddVersionKey "CompanyName"       "${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileVersion"       "${PRODUCT_VERSION}"
VIAddVersionKey "InternalName"      "${EXE_NAME}"
VIAddVersionKey "FileDescription"   "${PRODUCT_NAME}"
VIAddVersionKey "LegalCopyright"    "${PRODUCT_LEGAL}"

# ===================== ???? ==============================
var vPROMPT_SELECT_INSTALL_DIR
var vDESKTOP_SHORTCUT_NAME
var vSHORTCUTSUBDIR
var vPROGRAM_SHUORTCUT_NAME
var vCTROLPANEL_UNINSTALL_NAME
var vun_exeisrunning

var vLanguageId
var vLangIDPath

!define PRODUCT_UNIST_CONTRL_PATH "${PRODUCT_NAME}${PCODE}"
!define INSTALLNAME "testGame_${PCODE}${PRODUCT_DATE}.exe"



; Ǔ?Ǟ??.
Name "${PRODUCT_NAME}"

# Ǔ??Ǔ???.
OutFile "testGame_${PCODE}${PRODUCT_DATE}.exe"

InstallDir "D:\${PRODUCT_PUBLISHER}"



Section .init

	;IfSilent 0 +2
    ;MessageBox MB_OK|MB_ICONINFORMATION 'This is a "silent" installer'

  # there is no need to use IfSilent for this one because the /SD switch takes care of that
    ;MessageBox MB_OK|MB_ICONINFORMATION "This is not a silent installer"
SectionEnd
# ??Ǔ?Ƌ?.
;InstallDir "$PROGRAMFILES\${PRODUCT_PUBLISHER}"


# ??Vista?win7 ?UAC?ǡ????.
# RequestExecutionLevel none|user|highest|admin
;RequestExecutionLevel admin

# Ǔ??ǘ??Ǔ??
Icon              "image\logo.ico"
UninstallIcon     "image\unlogo.ico"



# ?????
Page custom DUIPage


# ǘ??Ǔ????
UninstPage custom un.DUIPage

# ======================= DUILIB ????? =========================
Var hInstallDlg

Var sReserveData   #ǘ?????t?? 
Var InstallState   #??Ǔ????Ǔ???  
Var UnInstallValue  #ǘ????  
Var vprocess
Var vSetAsDefaultBrowser ;??????ar vCreateDesktopShortcut ;????????
Var vAddStartShortCut ;???????
Var vAddQuickStart ;????Ȃ??

Var vCallOnce ;???????

Var vInitPath ;?????


Function DUIPage
	InitPluginsDir
	
	
	${Getparameters} $R0  
  #?Ɔ????  
    ${GetOptions} $R0 "-slient=" $R1  
    ;${GetOptions} $R0 "-Path=" $R2  
	
	${if} $R1 == "true"
		
		call installSlient
		return
	${else}
		
	${endif}
	
	${DriveSpace} "D:\" "/D=F /S=M" $R0
	${if} $R0 > 0
		StrCpy $vInitPath "D:\${PRODUCT_PUBLISHER}"
		StrCpy $vInitPath "D:\${PRODUCT_PUBLISHER}"
		nsDui::IsUSBDraver "D:\\"
		Pop $0
		${If} $0 == 0
		;u ȭ
		   StrCpy $vInitPath "$PROGRAMFILES\${PRODUCT_PUBLISHER}"
		${EndIf}
	${else}
		StrCpy $vInitPath "$PROGRAMFILES\${PRODUCT_PUBLISHER}"
	${endif}

	
    
    call LangTransfer
	
    SetOutPath "$TEMP\\skin"
    File /r skin\*.*
	;messagebox mb_ok "${SKINFILEXML_PRE}$vLanguageId.xml"
    nsDui::InitDUISetup "$TEMP\\skin" "${SKINFILEXML_PRE}$vLanguageId.xml" "$vInitPath\${LICENSETXT_FILE_PRE}$vLanguageId.txt" "wizardTab" 0 #?????????0????
    Pop $hInstallDlg
    
    nsDui::SetDirValue "$vInitPath" 
    
    # License??
    nsDui::FindControl "btnClose"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnExitDUISetup
        nsDui::OnControlBindNSISScript "btnClose" $0
    ${EndIf}
    
    nsDui::FindControl "btnLicenseRead"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnbtnLicenseRead
        nsDui::OnControlBindNSISScript "btnLicenseRead" $0
    ${EndIf}
	
	nsDui::FindControl "btnLicentURL"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnbtnLicentURL
        nsDui::OnControlBindNSISScript "btnLicentURL" $0
    ${EndIf}
	
	nsDui::FindControl "btnRegesterURL"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnbtnRegesterURL
        nsDui::OnControlBindNSISScript "btnRegesterURL" $0
    ${EndIf}
	
    
    nsDui::FindControl "chkLicenseAgree"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnChkLicenseAgree
        nsDui::OnControlBindNSISScript "chkLicenseAgree" $0
    ${EndIf}
    
    nsDui::FindControl "btnLicenseNext"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnBtnLicenseNextClick
        nsDui::OnControlBindNSISScript "btnLicenseNext" $0
    ${EndIf}
    
    nsDui::FindControl "btnShowLicense"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnShowLicense
        nsDui::OnControlBindNSISScript "btnShowLicense" $0
    ${EndIf}
    
    nsDui::FindControl "btnHideMore"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnHideMorwe
        nsDui::OnControlBindNSISScript "btnHideMore" $0
    ${EndIf}
    
    nsDui::FindControl "btnShowMore"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnShowMorwe
        nsDui::OnControlBindNSISScript "btnShowMore" $0
    ${EndIf}
    
    nsDui::FindControl "btnSelectDir"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnBtnSelectDir
        nsDui::OnControlBindNSISScript "btnSelectDir" $0
    ${EndIf}

    
    # Ǔ??? ??
    nsDui::FindControl "btnDetailClose2"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnExitDUISetup
        nsDui::OnControlBindNSISScript "btnDetailClose2" $0
    ${EndIf}
    
    nsDui::FindControl "btnDetailMin"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnBtnMin
        nsDui::OnControlBindNSISScript "btnDetailMin" $0
    ${EndIf}

    # Ǔ??? ??
    nsDui::FindControl "btnFinished"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnFinished
        nsDui::OnControlBindNSISScript "btnFinished" $0
    ${EndIf}
    
    ; ?? xxx ?????ǡ??
    GetFunctionAddress $0 OnBtnInstall
    nsDui::ShowPage "" $0 2000
FunctionEnd

Function installSlient
	;messagebox mb_ok "slient install"
	
	${DriveSpace} "D:\" "/D=F /S=M" $R0
	${if} $R0 > 0
		StrCpy $vInitPath "D:\${PRODUCT_PUBLISHER}"
		nsDui::IsUSBDraver "D:\\"
		Pop $0
		${If} $0 == 0
		;u ȭ
		   StrCpy $vInitPath "$PROGRAMFILES\${PRODUCT_PUBLISHER}"
		${EndIf}
	${else}
		StrCpy $vInitPath "$PROGRAMFILES\${PRODUCT_PUBLISHER}"
	${endif}
	
	
	
	;messagebox mb_ok "slient install $vInitPath"
	;GetFunctionAddress $0 ExtractFunc
    ;BgWorker::CallAndWait
	;call 
    # ????????Ȭ???????
    ;CopyFiles /SILENT "$TEMP\qq_file_translate\gf-config.xml" "$vInitPath"
    ;RMDir /r "$TEMP\qq_file_translate"
	SetOutPath $vInitPath
	File "app\testGame.7z"
	;GetFunctionAddress $R9 ExtractCallback
	;Nsis7z::ExtractWithCallback "$vInitPath\testGame.7z" $R9
    Nsis7z::Extract "$vInitPath\testGame.7z"
    Call CreateShortcut
    Call CreateUninstall
	Delete "$vInitPath\testGame.7z"


FunctionEnd


#ǘ???
Function un.DUIPage
    StrCpy $InstallState "0"
    InitPluginsDir
    call un.LangTransfer
	;messagebox mb_ok $PLUGINSDIR
    SetOutPath "$TEMP\\unskin"
    File /r skin\*.*
    nsDui::InitDUISetup "$TEMP\\unskin" "${SKINFILEXML_UNINST_PRE}$vLanguageId.xml" ""
    Pop $hInstallDlg
    Call un.BindUnInstUIControls
    nsDui::ShowPage
FunctionEnd

Function un.BindUnInstUIControls
    nsDui::FindControl "btnUnInstall"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 un.onUninstall
        nsDui::OnControlBindNSISScript "btnUnInstall" $0
    ${EndIf}
    
    nsDui::FindControl "btnUninstallClose"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 un.ExitDUISetup
        nsDui::OnControlBindNSISScript "btnUninstallClose" $0
    ${EndIf}
    
    nsDui::FindControl "btnUninstallCancel"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 un.ExitDUISetup
        nsDui::OnControlBindNSISScript "btnUninstallCancel" $0
    ${EndIf}
    
    nsDui::FindControl "btnUninstallFinished"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 un.ExitDUISetup
        nsDui::OnControlBindNSISScript "btnUninstallFinished" $0
    ${EndIf}
FunctionEnd

Function un.ExitDUISetup
	nsDui::ExitDUISetup
FunctionEnd

#?ǡ???ǘ? 
Function un.onUninstall
	#??????????Ǔ???ǡȬ?????ǡȬ??Ɨǘ??Ǔ? 
	nsProcess::_FindProcess "${EXE_NAME}"
	Pop $R0
	
	${If} $R0 == 0
        MessageBox MB_ICONINFORMATION|MB_OK "$vun_exeisrunning" /SD IDOK
		goto InstallAbort
    ${EndIf}
	nsDui::NextPage "wizardTab"
	nsDui::EnableButton "btnClose" "false"
	nsDui::SetSliderRange "slrProgress" 0 100
	IntOp $UnInstallValue 0 + 1
    
    nsDui::GetCheckboxStatus "chkReserveData"
    Pop $0
	${If} $0 == 0
        RMDir /r "${TEMP_USEDATA_DIR}"
    ${EndIf}
    IntOp $UnInstallValue $UnInstallValue + 8
    nsDui::SetSliderValue "slrProgress" "progressLabel" $UnInstallValue
	
	Call un.DelShortcutContrlPanel	
	
	IntOp $UnInstallValue $UnInstallValue + 8
    nsDui::SetSliderValue "slrProgress" "progressLabel" $UnInstallValue
    
	#???? 
	GetFunctionAddress $0 un.RemoveFiles
    BgWorker::CallAndWait
	
	InstallAbort:
FunctionEnd

#????????Ȭ??????Ȭǘ?????????? 
Function un.RemoveFiles
	;messagebox mb_ok "$INSTDIR\${INST_SUBDIR}"
	${Locate} "$INSTDIR\${INST_SUBDIR}" "/G=1 /M=*.*" "un.onDeleteFileFound"
    Delete "$INSTDIR\${UINST_EXE_NAME}"
	StrCpy $InstallState "1"
	nsDui::SetSliderValue "slrProgress" 100
    SetOutPath "$INSTDIR"

    ; ??Ǔ????
    ;Delete "$vInitPath\${INST_SUBDIR}\*.*"
    
    RMDir /r "$INSTDIR\${INST_SUBDIR}"

    SetOutPath "$DESKTOP"
    ;RMDir /r "$vInitPath"
    RMDir "$INSTDIR"
  
    SetAutoClose true
	nsDui::NextPage "wizardTab"
	nsDui::EnableButton "btnClose" "true";
FunctionEnd


#ǘ??Ǔ??????w?Ȭ???Ǻ??????Ȭ???????  
Function un.onDeleteFileFound
    ; $R9    "path\name"
    ; $R8    "path"
    ; $R7    "name"
    ; $R6    "size"  ($R6 = "" if directory, $R6 = "0" if file with /S=)
    
	
	#??????  
			
	Delete "$R9"
	RMDir /r "$R9"
    RMDir "$R9"
	
	IntOp $UnInstallValue $UnInstallValue + 2
	${If} $UnInstallValue > 100
		IntOp $UnInstallValue 100 + 0
		nsDui::SetSliderValue "slrProgress" "progressLabel" 100
	${Else}
		nsDui::SetSliderValue "slrProgress" "progressLabel" $UnInstallValue
		Sleep 100
	${EndIf}	
	undelete:
	Push "LocateNext"	
FunctionEnd

Function GetCurrLangID
System::Call "Kernel32::GetUserDefaultUILanguage(v ..) i .s"
Pop $0
IntOp $0 $0 & 0xFFFF

${if} $0 == 2052
	StrCpy $vLanguageId 0804
${elseif} $0 == 1028
	StrCpy $vLanguageId 0404
${elseif} $0 == 3076
	StrCpy $vLanguageId 0404
${elseif} $0 == 4100
	StrCpy $vLanguageId 0404
${elseif} $0 == 5124
	StrCpy $vLanguageId 0404
;default use english
${else}
	StrCpy $vLanguageId 0409
${EndIf}
	System::Free $0
FunctionEnd

Function un.GetCurrLangID
System::Call "Kernel32::GetUserDefaultUILanguage(v ..) i .s"
Pop $0
IntOp $0 $0 & 0xFFFF

${if} $0 == 2052
	StrCpy $vLanguageId 0804
${elseif} $0 == 1028
	StrCpy $vLanguageId 0404
${elseif} $0 == 3076
	StrCpy $vLanguageId 0404
${elseif} $0 == 4100
	StrCpy $vLanguageId 0404
${elseif} $0 == 5124
	StrCpy $vLanguageId 0404
;default use english
${else}
	StrCpy $vLanguageId 0409
${EndIf}
	System::Free $0
FunctionEnd

!macro languagetrans
ReadINIStr $vPROMPT_SELECT_INSTALL_DIR $vLangIDPath Installation PROMPT_SELECT_INSTALL_DIR
ReadINIStr $vSHORTCUTSUBDIR $vLangIDPath Installation SHORTCUTSUBDIR
ReadINIStr $vDESKTOP_SHORTCUT_NAME $vLangIDPath Installation DESKTOP_SHORTCUT_NAME
ReadINIStr $vPROGRAM_SHUORTCUT_NAME $vLangIDPath Installation PROGRAM_SHUORTCUT_NAME
ReadINIStr $vCTROLPANEL_UNINSTALL_NAME $vLangIDPath Installation CTROLPANEL_UNINSTALL_NAME
ReadINIStr $vun_exeisrunning $vLangIDPath Installation un_exeisrunning
!macroend
;??????? ?ǽ????
Function LangTransfer
    call GetCurrLangID
    StrCpy $vLangIDPath $vInitPath\${CONFIGINI_NAME_PRE}$vLanguageId.ini
    SetOutPath $vInitPath
    SetOverwrite on
    File /r info\*.*
    !insertmacro languagetrans
FunctionEnd

Function un.LangTransfer
    call un.GetCurrLangID
    StrCpy $vLangIDPath $vInitPath\${CONFIGINI_NAME_PRE}$vLanguageId.ini
    SetOutPath $vInitPath
    SetOverwrite on
    File /r info\*.*
    !insertmacro languagetrans
FunctionEnd

Function OnBtnLicenseNextClick
    nsDui::GetCheckboxStatus "chkLicenseAgree"
    Pop $0
    ${If} $0 == "1"
        call OnBtnInstall
    ${EndIf}
FunctionEnd

Function OnChkLicenseAgree
    nsDui::ItemEnabledByCheckbox "btnLicenseNext" "chkLicenseAgree"
FunctionEnd

Function OnShowLicense
    nsDui::SetControlAttribute "ctrlbtnLicenseNext" "visible" "false"
    nsDui::SetControlAttribute "ctrlLicense" "visible" "true"
    
    nsDui::IsControlVisible "moreconfiginfo"
	Pop $0
	${If} $0 = 0        
		;pos="10,30,530,400"
		nsDui::SetControlAttribute "ctrlLicense" "pos" ${INNER_POS}		
	${Else}
		nsDui::SetControlAttribute "ctrlLicense" "pos" ${INNER_POS_MORE}
        nsDui::SetControlAttribute "moreconfiginfo" "visible" "false"
    ${EndIf}
FunctionEnd

Function OnbtnLicenseRead
    nsDui::SetControlAttribute "ctrlLicense" "visible" "false"
    nsDui::SetControlAttribute "ctrlbtnLicenseNext" "visible" "true"
    nsDui::IsControlVisible "btnHideMore"
	Pop $0
	${If} $0 = 1
        nsDui::SetControlAttribute "moreconfiginfo" "visible" "true"
    ${EndIf}
FunctionEnd

Function OnbtnLicentURL
	ExecShell open "https://guanjia.test.com.cn/license.html"
FunctionEnd

Function OnbtnRegesterURL
	ExecShell open "https://www.test.com.cn/public/cookies.html"
FunctionEnd

Function StepHeightSizeAsc
${ForEach} $R0 ${HEIGHT} ${HEIGHT_MORE} + 10
  nsDui::SetWindowSize $hInstallDlg ${WIDTH} $R0
  Sleep 20
${Next}
FunctionEnd

Function StepHeightSizeDsc
${ForEach} $R0 ${HEIGHT_MORE} ${HEIGHT} - 10
  nsDui::SetWindowSize $hInstallDlg ${WIDTH} $R0
  Sleep 20
${Next}
FunctionEnd

Function OnShowMorwe
    nsDui::SetControlAttribute "moreconfiginfo" "visible" "true"
    nsDui::SetControlAttribute "btnShowMore" "visible" "false"
    nsDui::SetControlAttribute "btnHideMore" "visible" "true"
    ;?????? ??ǹ???Ȭ????
	;GetFunctionAddress $0 StepHeightSizeAsc
    ;BgWorker::CallAndWait
	
	nsDui::SetWindowSize $hInstallDlg ${WIDTH_MORE} ${HEIGHT_MORE}
FunctionEnd

Function OnHideMorwe
    nsDui::SetControlAttribute "moreconfiginfo" "visible" "false"
    nsDui::SetControlAttribute "btnShowMore" "visible" "true"
    nsDui::SetControlAttribute "btnHideMore" "visible" "false"
    ;?????? ??ǹ???Ȭ????
	;GetFunctionAddress $0 StepHeightSizeDsc
    ;BgWorker::CallAndWait
	nsDui::SetWindowSize $hInstallDlg ${WIDTH} ${HEIGHT}
FunctionEnd



# ??Ǔ?
Function OnBtnInstall
    ${If} $vCallOnce == 1
        goto InstallAbort
    ${EndIf}
    IntOp $vCallOnce 1 + 0
    nsDui::GetDirValue
    Pop $0
    StrCmp $0 "" InstallAbort 0
    StrCpy $vInitPath "$0"
    
	;IntOp $vCreateDesktopShortcut 1 + 0 
	;IntOp $vAddStartShortCut 1 + 0
	
    ;nsDui::SetWindowSize $hInstallDlg ${WIDTH} ${HEIGHT}
    nsDui::NextPage "wizardTab"
	nsDui::EnableButton "btnClose" "false";
    nsDui::SetSliderRange "slrProgress" 0 100
    nsDui::SetSliderValue "slrProgress" "progressLabel" 0
    
    # ??Ǔ??Ȭ????????
    # ??ǻ?????Y???
    ;CreateDirectory "$TEMP\qq_file_translate"
    ;CopyFiles /SILENT "$vInitPath\gf-config.xml" "$TEMP\qq_file_translate"
    
    #??????Ɨ??????
    GetFunctionAddress $0 ExtractFunc
    BgWorker::CallAndWait
    
    # ????????Ȭ???????
    ;CopyFiles /SILENT "$TEMP\qq_file_translate\gf-config.xml" "$vInitPath"
    ;RMDir /r "$TEMP\qq_file_translate"
    
    Call CreateShortcut
    Call CreateUninstall
InstallAbort:
FunctionEnd

Function ExtractFunc
	;;messagebox mb_ok $vInitPath
    SetOutPath $vInitPath
    nsDui::SetSliderProcessTimeValue "slrProgress" "progressLabel" 0 20 50
    File "app\testGame.7z"
	;messagebox mb_ok "file secess"
    nsDui::KillSliderProcessTimeValue
    nsDui::SetSliderValue "slrProgress" "progressLabel" 20
    ;nsDui::SetBgImage "vrlDetail" "install_s3.png"
    GetFunctionAddress $R9 ExtractCallback
    Nsis7z::ExtractWithCallback "$vInitPath\testGame.7z" $R9
    nsDui::NextPage "wizardTab"
	nsDui::EnableButton "btnClose" "true";
    Delete "$vInitPath\testGame.7z"
FunctionEnd


Function ExtractCallback
    Pop $1
    Pop $2
    System::Int64Op $1 * 100
    Pop $3
    System::Int64Op $3 * 8
    Pop $4
    System::Int64Op $4 / 10
    Pop $3
    
    System::Int64Op $2 * 20
    Pop $5
    
    System::Int64Op $3 + $5
    Pop $3
    System::Int64Op $3 / $2
    Pop $0
    
    nsDui::SetSliderValue "slrProgress" "progressLabel" $0
FunctionEnd


Function OnExitDUISetup
    nsDui::ExitDUISetup
FunctionEnd

Function OnBtnMin
    SendMessage $hInstallDlg ${WM_SYSCOMMAND} 0xF020 0
FunctionEnd

Function un.OnBtnMin
    SendMessage $hInstallDlg ${WM_SYSCOMMAND} 0xF020 0
FunctionEnd

Function OnBtnCancel
FunctionEnd

Function OnFinished
    ;ExecShell "open" "http://www.baidu.com"
    Exec "$vInitPath\${INST_SUBDIR}\${EXE_NAME}"
    Call OnExitDUISetup
FunctionEnd

Function OnBtnSelectDir
    nsDui::SelectInstallDir $vPROMPT_SELECT_INSTALL_DIR
    Pop $0
FunctionEnd

Function OnBtnDirPre
    nsDui::PrePage "wizardTab"
FunctionEnd


# ========================= Ǔ??? ===============================

Function CreateShortcut
  SetShellVarContext all
  
  CreateShortCut "$DESKTOP\$vDESKTOP_SHORTCUT_NAME.lnk" "$vInitPath\${EXE_NAME}" "" "$vInitPath\Icon.ico"
  CreateDirectory "$SMPROGRAMS\$vSHORTCUTSUBDIR"
  CreateShortCut "$SMPROGRAMS\$vSHORTCUTSUBDIR\$vPROGRAM_SHUORTCUT_NAME.lnk" "$vInitPath\${EXE_NAME}"
  CreateShortCut "$SMPROGRAMS\$vSHORTCUTSUBDIR\$vCTROLPANEL_UNINSTALL_NAME.lnk" "$vInitPath\uninst.exe"
  ;Ǖ???
  WriteRegStr HKLM "SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\testGame" "testGame" "$vInitPath\${EXE_NAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\App Paths\testGame" "testGame" "$vInitPath\${EXE_NAME}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\App Paths\testGame" "testGame" "$vInitPath\${EXE_NAME}"
  Exec "$vInitPath\BoxInstall.exe"
  ;SetShellVarContext current
    ;${If} $vAddQuickStart == "1"
    ;    ${StdUtils.InvokeShellVerb} $0 "$vInitPath\${INST_SUBDIR}" "${EXE_NAME}" ${StdUtils.Const.ShellVerb.PinToTaskbar}
    ;${EndIf}
 ; ${If} $vSetAsDefaultBrowser == "1"
      ;!insertmacro Trace "vSetAsDefaultBrowser is 1"
  ;${EndIf}
FunctionEnd



Function CreateUninstall

	# ??ǘ??Ǔ
	WriteUninstaller "$vInitPath\${UINST_EXE_NAME}"
	
	# ??ǘ???????Ƿ
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_UNIST_CONTRL_PATH}" "DisplayName" "$vCTROLPANEL_UNINSTALL_NAME"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_UNIST_CONTRL_PATH}" "UninstallString" "$vInitPath\uninst.exe"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_UNIST_CONTRL_PATH}" "DisplayIcon" "$vInitPath\${INST_SUBDIR}\${EXE_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_UNIST_CONTRL_PATH}" "Publisher" "$vInitPath\${PRODUCT_PUBLISHER}"
FunctionEnd

# ??????SectionȬ???????
Section "None"
SectionEnd

Function un.DelShortcutContrlPanel
    SetShellVarContext all
    Delete "$DESKTOP\$vDESKTOP_SHORTCUT_NAME.lnk"
    ${StdUtils.InvokeShellVerb} $0 "$vInitPath\${INST_SUBDIR}" "${EXE_NAME}" ${StdUtils.Const.ShellVerb.UnpinFromTaskbar}
    Delete "$SMPROGRAMS\$vSHORTCUTSUBDIR\$vPROGRAM_SHUORTCUT_NAME.lnk"
    Delete "$SMPROGRAMS\$vSHORTCUTSUBDIR\$vCTROLPANEL_UNINSTALL_NAME.lnk"
    RMDir "$SMPROGRAMS\$vSHORTCUTSUBDIR\"
    
    SetShellVarContext current
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_UNIST_CONTRL_PATH}"
	DeleteRegKey HKLM "SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\testGame"
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\App Paths\testGame"
	DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\App Paths\testGame"
	
FunctionEnd


# ============================== ???? ====================================

# ????p.q????ǵ???????t.
# ????pun.q???????????ǘ??Ǔ/Ȭ??Ȭ??Ǔ??????????ǘ???Ȭ?ǘ????ǘ????????????c

Function .onInit
	InitPluginsDir
	System::Call 'kernel32::CreateMutexA(i 0, i 0, t "WinSnap_installer") i .r1 ?e'
	Pop $R0
	StrCmp $R0 0 +2
    ;MessageBox MB_OK|MB_ICONEXCLAMATION "??? WinSnap Ǔ??????ǡȢ"
    Abort
FunctionEnd


# Ǔ?????.
Function .onInstSuccess

FunctionEnd

# ?Ǔ??Ǯ?????p??qǕ?????.
Function .onInstFailed
    MessageBox MB_ICONQUESTION|MB_YESNO "Ǔ???Ȣ" /SD IDYES IDYES +2 IDNO +1
FunctionEnd


# ??????Ǔ?d???????????????.
Function .onVerifyInstDir

FunctionEnd

# ǘ??????.
Function un.onInit
    ;MessageBox MB_ICONQUESTION|MB_YESNO "????ǘ?${PRODUCT_NAME}c?" /SD IDYES IDYES +2 IDNO +1
    ;Abort
FunctionEnd

# ǘ?????.
Function un.onUninstSuccess

FunctionEnd


