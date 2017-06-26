'LIBRARY NAME                     :Libinit
'DESCRIPTION                      :This Function initialize all the variables
'INCLUDED FUNCTION                :
'         Public Function InitializeVariables
Option Explicit
'
'--------------------------------------------------------------------------------------------
'                       Public Varibale Declaration
Public gTestPath, gApplicationName, gProjectName, gResultFolderName, gResultPath,gTestCaseName,geventTriggered,gTcname
Public gExistSyncTime, gLowsyncTime, gMediumSyncTime, gHighsyncTime, gsynctime,gRowIteration,gRowCount,gAction,gwaitNeeded
Public ginputStr, gStepNo, gStepDescription, gExpected, gFunctionName, gNegative, gDecision, gsheetName,gObjname
Public gVerify, gErrDescription, gClickBtnValue,gWordscreenshotPath,gNeedWordScreenshot,growNumber,gtableRow,gtableCol
Public gstartno, gdetailstartno, gPassedcount, gFailedcount,gverifyContinue,gcurrentIteration,gLastIteration,gverifyval
Public gStarttime, gEndtime, gdetailEndtime, gdetailStarttime,gProductDir,gUsername,gfinaltime,gTestcaseStatus,gTestCaseDescription
Public gText, gCompare, gExist,gmid, gEnable, gCheck,gRowIndex,gstepNumber,gexcelResultPath,gConcat,gSplit,gReplace,gExcelSearch
'--------------------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------------------
'                       Private Varibale Declaration
'None
'--------------------------------------------------------------------------------------------
'--------------------------------------------------------------------------------------------
'Function Name: Public Function InitializeVariables
'
'Description:This function will initialize all the variables
'
'Arguments: None
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:46 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function InitializeVariables()
On Error Resume Next
gClickBtnValue = 0
gsynctime = 30000
gExistSyncTime = 10
gPassedcount = 0
gFailedcount = 0
gstartno = 1
gverifyval = False
gExcelSearch=False
gdetailstartno = 1
geventTriggered = False
gNeedWordScreenshot=False
gwaitNeeded=True
gTestPath = Mid(Environment("TestDir"), 1, InStrRev(Mid(Environment("TestDir"), 1, InStrRev(Environment("TestDir"), "\") - 1), "\", -1) - 1)
gApplicationName = Mid(gTestPath, InStrRev(gTestPath, "\") +1)
gProjectName = gApplicationName
gproductDir = Environment("ProductDir")
    gResultFolderName = Mid(Environment("ResultDir"), InStrRev(Environment("ResultDir"), "\") + 1)
gResultPath= gTestPath&"\Results\HTMLResults\"
gWordscreenshotPath= gTestPath&"\Results\WordScreenshots\"
gexcelResultPath= gTestPath&"\Results\ExcelResults\"
guserName = Environment("UserName")
gTcname = Split(Mid(Environment("TestDir"), InStrRev(Environment("TestDir"),"\") + 1), "_")
If Err.Number <> 0 Then
    InitializeVariables = Fail
Else
    InitializeVariables = Pass
End If
End Function
