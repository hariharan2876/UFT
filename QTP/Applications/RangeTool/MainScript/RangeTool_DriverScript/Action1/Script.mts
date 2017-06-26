'<-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><->
'
'DRIVERSCRIPT NAME   :  RangeTool_Driver Script
'
'DESCRIPTION         : This Driver Scripts drives all the components in each script
'
'PARAMETERS          : (None)
'
'AUTHOR              : Hariharan
'
'ORGINAL DATE        :6/26/2017 6:26:15 PM
'
'<-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><->
'REVISION HISTORY    :
'
'<-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><->
Option Explicit
On Error Resume Next
Dim rc, Outrecord, testcaseArray, startStepNumber, rowIteration, stepNo, testCaseName, stepCount, testScriptFlag,mapRecord,rowRecord
Dim componentName, testcaseDescription, inputString, expected, actual, negative, stepIteration, actionName, actionType,startIteration
Set Outrecord = CreateObject("Scripting.Dictionary")
Set mapRecord = CreateObject("Scripting.Dictionary")
Set rowRecord = CreateObject("Scripting.Dictionary")
startIteration = 1
rc = InitializeVariables()
If rc = Fail Then
    MsgBox "Variable not initialized properly"
    ExitAction
End If
gNeedWordScreenshot=True
If gNeedWordScreenshot = True Then rc=InitializeWordPath
If rc = Fail Then
    MsgBox "Initialize word path failed"
    ExitAction
End If
     rc = GetTestCaseCount(Outrecord,mapRecord,rowRecord)
If rc = Fail Or Outrecord.Count = 0 Then
    MsgBox "No testcase found to execute"
    ExitAction
End If
If rc = pass Then rc = initializeExcelReport
If rc = Fail Then
    MsgBox "Initialize excel report failed"
    ExitAction
End If
If rc = Pass Then rc = InitializeReportSummary
gStarttime = Now
If rc = Fail Then
    MsgBox "Initialize html reporter failed"
    ExitAction
End If
For rowIteration = 1 To Outrecord.Count
    gcurrentIteration = CStr(rowIteration)
    gLastIteration = CStr(Outrecord.Count)
    rc = ImportTestScript(mapRecord.Item(Outrecord.Item(rowIteration)))
    If rc = Pass Then
        gTestCaseName = Outrecord.Item(rowIteration)
        If gNeedWordScreenshot = True Then rc = Initializewordinstance
        If rc = Fail Then Exit for
            rc = InitializedetailedReport
            If rc = Fail Then Exit for
            gdetailStarttime = Now
        For stepIteration = startIteration To DataTable.GetSheet("Action1").GetRowCount
            DataTable.GetSheet("Action1").SetCurrentRow stepIteration
            rc = AssignTestScriptColumnValuesToGlobalVariable(stepIteration)
            If rc = Pass Then
                rc = ImportTestData()
                If rc = Pass Then
                    gdetailstartno = stepIteration
                    newDetailStartNo=stepIteration
                    startDetailReport=1
                    rc = Eval(gFunctionName)
                    If rc = Fail Then Exit For
                Else
                    Reportstep "Import <b>" &gsheetName &"</b> sheet for execution","Import  <b>" &gsheetName &"</b> sheet for execution should be successful","Import of <b>" &gsheetName&"</b> sheet for execution failed",Fail
                End If
            Else
                 Reportstep "Assign Test Script column Values ","Assign Test Script column Values should be successful","Assign Test Script column Values failed",Fail
            End If
        Next
        gdetailEndtime = Now
        SetTestCaseStatus rowRecord(gTestCaseName), rc
        EndhtmlDetailreporter
        If gNeedWordScreenshot = True then CloseWordInstance
    Else
        Reporter.ReportEvent micFail, "Import Test Script File ", "Import Test script file failed"
    End If
    ExportResultFile
Next
gEndtime = Now
EndhtmlsummaryReporter
GenerateExcelReport
ShowreportSummary