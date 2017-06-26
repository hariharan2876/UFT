Option Explicit
'-----------------------------------------------------------------------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Public Function Rangetool()
'
'DESCRIPTION:perform action on rangetool
'
'AUTHOR: Automation Code Generator
'
'ORGINAL DATE: 6/26/2017 6:38:06 PM
'
'----------------------------------------------------------
'REVISION HISTORY:
'
'----------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
Public Function Rangetool()
On Error Resume Next
 Dim inputStr , rowIteration, stepIteration, objName, vAction, winObj, actionValue, propertyName, rowNumber, rc,ErrObject,errObj
Dim indexValue, verifyType, decisionFlag, testCaseRowIteration, columnNumber, className, verifyFlag, objValue, varOptional, outTestcaseRow, totalIteration
Set outTestcaseRow = CreateObject("Scripting.dictionary")
gwaitNeeded = False
If Trim(ginputStr) <> "" Then
    inputStr = Split(ginputStr, "|")
    If gSheetName <> "" Then

'Gets the testcase row to be be executed 
        rc = GetTestcaseRow(outTestcaseRow)
        If rc = fail Then
            Reportstep "Get testcase rows for execution","Get testcase rows for execution should be successful","Get testcase rows for execution failed due to no data entries found in data sheet",fail
            Rangetool= fail
            Exit Function
        Else
            If outTestcaseRow.Count = 0 Then
                totalIteration = 1
            Else
                totalIteration = outTestcaseRow.Count
            End If
        End If
    Else
        totalIteration = 1
    End If

'Iterates across the rows in data sheet 
    For testCaseRowIteration = 1 To totalIteration
        indexValue = 0
        gRowIteration = cstr(testCaseRowIteration)
        gRowCount = cstr(totalIteration)
        If outTestcaseRow.Count > 0 Then
            DataTable.GetSheet(gSheetName).SetCurrentRow outTestcaseRow.Item(testCaseRowIteration)
            growNumber = outTestcaseRow.Item(testCaseRowIteration)
            gRowIndex = testCaseRowIteration - 1
        End If
    For rowIteration = 0 To UBound(inputStr)
        gstepNumber = cstr(rowIteration)

            GetObjectValues inputStr(rowIteration), vAction, objName, actionValue, propertyName, varOptional, rowNumber, columnNumber, indexValue, className, verifyFlag
            gObjName=objName:gAction=vAction
'Validates decision if any in main script sheet, if the return value is true the script will continue 
        decisionFlag = ValidateDecisionValue
        If decisionFlag = True Then
            ErrObject = "": objValue = "": errObj = "": verifyType = False
            If LCase(indexValue) = "growindex" Then indexValue = Eval(growindex)
            Select Case LCase(objName)
                Case "txtmin","txtmax","txtlower","txtupper"
                    set winObj=VbWindow("frmMain").VbEdit(objname)
                Case "lststyle"
                    set winObj=VbWindow("frmMain").VbComboBox(objname)
                Case "upper locked","upper visible","lower visible","lower locked","enabled"
                    set winObj=VbWindow("frmMain").VbCheckBox(objname)
                 Case Else
                    If LCase(vaction) <> "capture" And LCase(vaction) <> "capture2word" And LCase(vaction) <> "openapp" And LCase(vaction) <> "assignvalue" And LCase(vaction) <> "concatvalue" And LCase(vaction) <> "splitvalue" And LCase(vaction) <> "replacevalue" And LCase(vaction) <> "getpartvalue" Then
                        Reportstep "Perform action on object","Perform action on objects should be successful","Perform action on objects failed due to object not implemented",fail
                        Rangetool= fail
                        Exit Function
                    End if
                End Select

              Select Case LCase(objName)
                  Case "objName"
                  Case Else
                    rc = performOperationOnObject(winobj, vAction, actionValue, rowNumber, columnNumber, indexValue, propertyName, errObj, objName, className,varOptional, verifyFlag)
               End Select
                If Err.Number <> 0 Or rc = fail Then
                    Reportstep  "Perform " & vAction & " operation on " & winObj.ToString, "Perform operation on " & winObj.ToString & "  should be successful","Perform operation on " & winObj.ToString & "  failed",fail
                    Rangetool= fail
                    Exit Function
                Else
                    Rangetool= Pass
                End If
        Else
            Reportstep "Execution of step <b>[" & inputstr(rowIteration) & "]</b> with decision flag", "Execution of step <b>[" & inputstr(rowIteration) & "]</b> with decision flag should be successful", "Execution of step <b>[" & inputstr(rowIteration) & "]</b> with decision flag skipped due to decision flag: False", pass
            Rangetool= pass
            Exit For
        End If
        Next
     Next
Else
  Reportstep "Perform action on object with given inputstr","Perform action on objects should be successful","Perform action on objects failed due to inputstr is null",fail
  Rangetool= fail
  Exit Function
End If
End Function
