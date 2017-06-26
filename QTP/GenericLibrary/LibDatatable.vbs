'LIBRARY NAME                     :LibDatatable
'DESCRIPTION                      :This Function contains Datatable related Functions
'INCLUDED FUNCTION                :
'         Public Function GetColumnValues(Byval columnName)
'         Public Function GetTestCaseCount(ByRef outRecord,Byref mapRecord)
'         Public Function GetTestcaseRow(Byref outTestcaseRow)
'         Public Function ImportTestData()
'         Public Function ImportTestScript(ByVal TestCaseName)
'         Public Function ExportResultFile
'         Public Function GetTestCaseDescription
'         Public Function SetTestCaseStatus(ByVal rowNumber, ByVal status)
'--------------------------------------------------------------------------------------------
Option Explicit
'
'--------------------------------------------------------------------------------------------
'                       Public Varibale Declaration
'None
'--------------------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------------------
'                       Private Varibale Declaration
'None
'--------------------------------------------------------------------------------------------
'Function Name: Public Function GetColumnValues(Byval columnName)
'
'Description:This function will get the values from datatable or from global variable
'
'Arguments: columnName-Name of the column in datatable or global variable
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:46 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function GetColumnValues(ByVal columnName)
On Error Resume Next
Dim newColumnName, rowIteration, columnValue
newColumnName = Split(columnName, ";")
For rowIteration = 0 To UBound(newColumnName)
If InStr(1, newColumnName(rowIteration), "[", 1) > 0 Then
If rowIteration > 0 Then
columnValue = columnValue & ";" & DataTable.GetSheet(gSheetName).GetParameter(Replace(Replace(Trim(newColumnName(rowIteration)), "[", ""), "]", "")).Value
Else
columnValue = DataTable.GetSheet(gSheetName).GetParameter(Replace(Replace(Trim(newColumnName(rowIteration)), "[", ""), "]", "")).Value
End If
    ElseIf InStr(1, newColumnName(rowIteration), "<", 1) > 0 Then
columnValue = Eval(Replace(Replace(Trim(newColumnName(rowIteration)), "<", ""), ">", ""))
Else
If rowIteration > 0 Then
columnValue = columnValue & ";" & newColumnName(rowIteration)
Else
columnValue = newColumnName(rowIteration)
End If
End If
If Err.Number <> 0 Then
GetColumnValues = Fail
Reportstep "Getting " & columnName & "column values from " & gsheetName, "Getting " & columnName & "column values from " & gsheetName & " should be successful", "Getting " & columnName & "column values from " & gsheetName & " should be failed due to " & Err.Description, fail
gErrDescription = Err.Description
Exit Function
End If
Next
GetColumnValues = columnValue
End Function
'--------------------------------------------------------------------------------------------
'Function Name: Public Function GetTestCaseCount(ByRef outRecord,ByRef mapRecord,Byref rowRecord)
'
'Description:Store all the testcase name to a dictionary object for execution
'
'Arguments: outRecord-object that contan testcases to be executed
'           mapRecord-object that contan orginal testcases to be mapped
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:46 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function GetTestCaseCount(ByRef outRecord,ByRef mapRecord,Byref rowRecord)
On Error Resume Next
Dim rowCount, rowIteration, startNum
startNum = 1
outRecord.RemoveAll()
DataTable.ImportSheet gTestPath & "\MainScript\" & gApplicationName & "_MainScript.xls", "TestCase", "Global"
rowCount = DataTable.GetSheet("Global").GetRowCount
For rowIteration = 1 To rowCount
     DataTable.GetSheet("Global").SetCurrentRow (rowIteration)
     If DataTable("TestCase_Name", "Global") <> Empty And DataTable("Run_Testcase", "Global") = "Y" Then
        Outrecord.Add startNum, DataTable("TestCase_Name", "Global")
        mapRecord.Add DataTable("TestCase_Name", "Global"), DataTable("Map_Testcase", "Global")
        rowRecord.Add DataTable("TestCase_Name", "Global"), rowiteration
        startNum = startNum + 1
     End If
Next
If Err.Number <> Pass Then
     GetTestCaseCount = Fail
     Reporter.ReportEvent micFail, "Getting testcase count", "Getting testcase count failed due to " & Err.Description
    Else
     GetTestCaseCount = Pass
End If
End Function
'--------------------------------------------------------------------------------------------
'Function Name: Public Function GetTestCaseByName(ByRef outRecord,ByRef mapRecord,Byref rowRecord,byval tcName)
'
'Description:Store all the testcase name to a dictionary object for execution
'
'Arguments: outRecord-object that contan testcases to be executed
'           mapRecord-object that contan orginal testcases to be mapped
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:46 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function GetTestCaseByName(ByRef outRecord,ByRef mapRecord,Byref rowRecord,byval tcName)
On Error Resume Next
Dim rowCount, rowIteration, startNum
startNum = 1
outRecord.RemoveAll()
DataTable.ImportSheet gTestPath & "\MainScript\" & gApplicationName & "_MainScript.xls", "TestCase", "Global"
rowCount = DataTable.GetSheet("Global").GetRowCount
For rowIteration = 1 To rowCount
     DataTable.GetSheet("Global").SetCurrentRow (rowIteration)
     If DataTable("TestCase_Name", "Global") <> Empty And Strcomp(DataTable("TestCase_Name", "Global"),tcName,1)=0 Then
        Outrecord.Add startNum, DataTable("TestCase_Name", "Global")
        mapRecord.Add DataTable("TestCase_Name", "Global"), DataTable("Map_Testcase", "Global")
        rowRecord.Add DataTable("TestCase_Name", "Global"), rowiteration
        startNum = startNum + 1
        Exit For
     End If
Next
If Err.Number <> Pass Then
     GetTestCaseByName = Fail
     Reporter.ReportEvent micFail, "Getting testcase count", "Getting testcase count failed due to " & Err.Description
    Else
     GetTestCaseByName = Pass
End If
End Function
'--------------------------------------------------------------------------------------------
'Function Name: Public Function GetTestcaseRow(Byref outTestcaseRow)
'
'Description:get the testcase rows to be executed
'
'Arguments: outTestcaseRow-Varibale that contan testcases rows to be executed
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:46 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function GetTestcaseRow(Byref outTestcaseRow)
On Error Resume Next
Dim rowIteration, rowsCount, currTestCase, startRow,rowFound,splitTestCase,splitIteration,excelobj,excelwb,excelws,rowValue
outTestcaseRow.RemoveAll
startRow = 1
rowValue = 1
rowFound = False
If gsheetName = "" Then
    GetTestcaseRow = Pass
    Exit Function
End If
If gExcelSearch = True Then
Set excelobj = CreateObject("Excel.application")
Set excelwb=excelobj.Workbooks.Open (gTestPath &"\TestData\"&gApplicationName&"_TestData.xls")
Set excelws = excelwb.Sheets(gsheetName)
rowValue = excelws.Range("a2:a" & excelws.UsedRange.Rows.Count).Find(gTestCaseName).Row - 1
excelwb.Close
Set excelobj = Nothing
End If
If Err.Number = 0 Then
rowsCount = DataTable.GetSheet(gsheetName).GetRowCount
For rowIteration = 1 To rowsCount
    DataTable.GetSheet(gsheetName).SetCurrentRow (rowIteration)
    currTestCase = DataTable.Value("TestCase_ID", gsheetName)
    splitTestCase = Split(currTestCase, ",")
    For splitIteration = 0 To UBound(splitTestCase)
        If StrComp(splitTestCase(splitIteration), gTestCaseName, 1) = 0 Then
            outTestcaseRow.Add startRow, rowIteration
            startRow = startRow + 1
            rowFound = True
        End If
    Next
Next
End If
If Err.Number <> 0 or rowFound=False Then
GetTestcaseRow = Fail
Else
GetTestcaseRow = Pass
End If
End Function
'--------------------------------------------------------------------------------------------
'Function Name: Public Function ImportTestData
'
'Description:Function will import the testdata
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
Public Function ImportTestData()
On Error Resume Next
Dim rowiteration, sheetFound
sheetFound = False
If gsheetName <> "" Then
    For rowiteration = 1 To DataTable.GetSheetCount
        If DataTable.GetSheet(rowiteration).Name = gsheetName Then
            sheetFound = True
            Exit For
        End If
    Next
    If sheetFound = False Then
        DataTable.AddSheet gsheetName
        Datatable.ImportSheet gTestPath &"\TestData\"&gApplicationName&"_TestData.xls",gsheetName,gsheetName
    End If
End If
If Err.Number <> 0 Then
    ImportTestData = Fail
Else
    ImportTestData = Pass
End If
End Function
'--------------------------------------------------------------------------------------------
'Function Name: Public Function ImportTestScript(ByVal TestCaseName)
'
'Description:Function will import the main script
'
'Arguments: TestCaseName-Name of the testcase to be executed will be imported
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:46 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function ImportTestScript(ByVal TestCaseName)
On Error Resume Next
Datatable.ImportSheet gTestPath &"\MainScript\"&gApplicationName&"_MainScript.xls",TestCaseName,"Action1"
If Err.Number <> 0 Then
    ImportTestScript = Fail
Else
    ImportTestScript = Pass
End If
End Function
'--------------------------------------------------------------------------------------------
'Function Name: Public Function ExportResultFile
'
'Description:Function will export the result file to result folder
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
Public Function ExportResultFile()
On Error Resume Next
Datatable.Export gexcelResultPath & gResultFolderName &"\"&gApplicationName&"_Export.xls"
If Err.Number <> 0 Then
    ExportResultFile = Fail
Else
    ExportResultFile = Pass
End If
End Function
'--------------------------------------------------------------------------------------------
'Function Name: Public Function GetTestCaseDescription
'
'Description:Get testcase description for report
'
'Arguments: None
'
'Return Value: None
'
'Orginal Date: 6/26/2017 6:26:46 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function GetTestCaseDescription()
On Error Resume Next
Dim rowCount, rowIteration
If LCase(frameworkType) = "testcasedriven" Then
rowCount = DataTable.GetSheet("Global").GetRowCount
For rowIteration = 1 To rowCount
     DataTable.GetSheet("Global").SetCurrentRow (rowIteration)
     If DataTable("TestCase_Name", "Global") = gTestCaseName Then
        gTestCaseDescription = DataTable("Description", dtglobalsheet)
        gExpected = DataTable("Expected", dtglobalsheet)
        Exit For
     End If
Next
End if
End Function
'--------------------------------------------------------------------------------------------
'Function Name: SetTestCaseStatus(ByVal rowNumber, ByVal status)
'
'Description:set the status of testcase as pass or fail
'
'Arguments: None
'
'Return Value: None
'
'Orginal Date: 6/26/2017 6:26:46 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function SetTestCaseStatus(ByVal rowNumber, ByVal status)
DataTable.GlobalSheet.SetCurrentRow rowNumber
If status = 0 Then
    DataTable("Result", dtGlobalsheet) = "Passed"
Else
    DataTable("Result", dtGlobalsheet) = "Failed"
End If
End Function
