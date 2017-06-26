'
'LIBRARY NAME     :LibFrameworkGenericFunction
'DESCRIPTION      :This Library file contains framework related Functions
'INCLUDED FUNCTION:
' Public Function ValidateDecisionValue()
' Public Function GetObjectValues(ByVal inputstr, ByRef action, ByRef objName, ByRef actionValue, ByRef propertyName, ByRef varOptional, ByRef rowNumber, ByRef columnNumber, ByRef indexValue, ByRef Classname, ByRef verifyFlag)
' Public Function AssignTestScriptColumnValuesToGlobalVariable(ByVal RowNumber)
' Public Function CreateReportFile()
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Option Explicit
'
'----------------------------------------------------------------------------------------------------------------------------------------------
'                       Public Varibale Declaration
'None
'----------------------------------------------------------------------------------------------------------------------------------------------
'
'----------------------------------------------------------------------------------------------------------------------------------------------
'                       Private Varibale Declaration
'None
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: Public Function ValidateDecisionValue()
'
'Description:This function used for validating the decision column value in main script
'
'Arguments: None
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:48 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function ValidateDecisionValue()
On Error Resume Next
Dim checkDecision, globalDecisionValue, arrayIteration, newDecisionValue, valueFound, andDecision, orDecision, andIteration, orIteration
If Trim(gDecision) <> "" Then
        If InStr(1, gDecision, " And ", 1) > 0 Then
            andDecision = Split(gDecision, "And", -1, 1)
            For andIteration = 0 To UBound(andDecision)
                If InStr(1, andDecision(andIteration), "=", 1) > 0 Then
                   checkDecision = Split(andDecision(andIteration), "=")
                   valueFound = False
                    globalDecisionValue = GetColumnValues(checkDecision(0))
                    If checkDecision(1) <> "" Then
                            If Lcase(globalDecisionValue) = Lcase(GetColumnValues(Trim(checkDecision(1)))) Then valueFound = True
                    Else
                            If globalDecisionValue = Trim(checkDecision(1)) Then valueFound = True
                    End If
                    If valueFound = False Then Exit For
                Else
                    checkDecision = Split(andDecision(andIteration), "<>")
                   valueFound = False
                    globalDecisionValue = GetColumnValues(checkDecision(0))
                    If checkDecision(1) <> "" Then
                            If Lcase(globalDecisionValue) <> Lcase(GetColumnValues(Trim(checkDecision(1)))) Then valueFound = True
                    Else
                            If globalDecisionValue <> Trim(checkDecision(1)) Then valueFound = True
                    End If
                    If valueFound = False Then Exit For
                End If
            Next
        ElseIf InStr(1, gDecision, " or ", 1) > 0 Then
            orDecision = Split(gDecision, "or", -1, 1)
            For orIteration = 0 To UBound(orDecision)
                If InStr(1, orDecision(orIteration), "=", 1) > 0 Then
                   checkDecision = Split(orDecision(orIteration), "=")
                   valueFound = False
                    globalDecisionValue = GetColumnValues(checkDecision(0))
                    If checkDecision(1) <> "" Then
                            If Lcase(globalDecisionValue) = Lcase(GetColumnValues(Trim(checkDecision(1)))) Then valueFound = True
                    Else
                             If globalDecisionValue <> Trim(checkDecision(1)) Then valueFound = True
                    End If
                    If valueFound = True Then Exit For
                Else
                    checkDecision = Split(orDecision(orIteration), "<>")
                   valueFound = False
                    globalDecisionValue = GetColumnValues(checkDecision(0))
                    If checkDecision(1) <> "" Then
                        If Lcase(globalDecisionValue) <> Lcase(GetColumnValues(Trim(checkDecision(1)))) Then valueFound = True
                    Else
                        If globalDecisionValue <> Trim(checkDecision(1)) Then valueFound = True
                    End If
                    If valueFound = True Then Exit For
                End If
            Next
    ElseIf InStr(1, gDecision, ",", 1) > 0 Then
        If InStr(1, gDecision, "=", 1) > 0 Then
            checkDecision = Split(gDecision, "=")
            valueFound = False
            globalDecisionValue = GetColumnValues(checkDecision(0))
                If checkDecision(1) <> "" Then
                    newDecisionValue = Split(checkDecision(1), ",")
                    For arrayIteration = 0 To UBound(newDecisionValue)
                        If Lcase(globalDecisionValue) = Lcase(GetColumnValues(Trim(newDecisionValue(arrayIteration)))) Then
                            valueFound = True
                            Exit For
                        End If
                    Next
                 Else
                     If globalDecisionValue <> Trim(checkDecision(1)) Then valueFound = True
                End If
            Else
                checkDecision = Split(gDecision, "<>")
                globalDecisionValue = GetColumnValues(checkDecision(0))
                If checkDecision(1) <> "" Then
                    newDecisionValue = Split(checkDecision(1), ",")
                    For arrayIteration = 0 To UBound(newDecisionValue)
                        valueFound = False
                        If Lcase(globalDecisionValue) <> Lcase(GetColumnValues(Trim(newDecisionValue(arrayIteration)))) Then
                            valueFound = True
                              'Exit For
                        End If
                    Next
                 Else
                     If globalDecisionValue <> Trim(checkDecision(1)) Then valueFound = True
                End If
            End If
    ElseIf InStr(1, gDecision, "=", 1) > 0 Then
        checkDecision = Split(gDecision, "=")
        valueFound = False
        globalDecisionValue = GetColumnValues(checkDecision(0))
            If checkDecision(1) <> "" Then
                newDecisionValue = Split(checkDecision(1), ",")
                For arrayIteration = 0 To UBound(newDecisionValue)
                    If Lcase(globalDecisionValue) = Lcase(GetColumnValues(Trim(newDecisionValue(arrayIteration)))) Then
                        valueFound = True
                        Exit For
                    End If
                Next
            Else
             If globalDecisionValue = Trim(checkDecision(1)) Then valueFound = True
            End If
    ElseIf InStr(1, gDecision, "<>", 1) > 0 Then
        checkDecision = Split(gDecision, "<>")
        valueFound = False
        globalDecisionValue = GetColumnValues(checkDecision(0))
            If checkDecision(1) <> "" Then
                newDecisionValue = Split(checkDecision(1), ",")
                For arrayIteration = 0 To UBound(newDecisionValue)
                    If Lcase(globalDecisionValue) <> Lcase(GetColumnValues(Trim(newDecisionValue(arrayIteration)))) Then
                        valueFound = True
                        Exit For
                    End If
                Next
            Else
             If globalDecisionValue <> Trim(checkDecision(1)) Then valueFound = True
            End If
      End If
    Else
        valueFound = True
    End If
If Err.Number <> 0 Or valueFound = False Then
    ValidateDecisionValue = False
Else
    ValidateDecisionValue = True
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: Public Function GetObjectValues(ByVal inputstr, ByRef action, ByRef objName, ByRef actionValue, ByRef propertyName, ByRef varOptional, ByRef rowNumber, ByRef columnNumber, ByRef indexValue, ByRef Classname, ByRef verifyFlag)
'
'Description:This function used for getting inputstr argument values
'
'Arguments: None
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:48 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function GetObjectValues(ByVal inputstr, ByRef action, ByRef objName, ByRef actionValue, ByRef propertyName, ByRef varOptional, ByRef rowNumber, ByRef columnNumber, ByRef indexValue, ByRef Classname, ByRef verifyFlag)
   Dim stepStr
    verifyFlag = False:varOptional="":indexValue="":Classname="":rownumber="":columnNumber="":actionValue=""
        stepStr = Split(inputstr, ":")
        If UBound(stepStr) = 0 Then
         action = stepStr(0)
         objName = ""
         Exit Function
        End If
       action = stepStr(0)
       objName = GetColumnValues(stepStr(1))
        If UBound(stepStr) = 2 Then
            If LCase(stepStr(2)) = "optional" Then
			  varOptional = stepStr(2)
           ElseIf InStr(1, stepStr(2), "i(", 1) > 0 Then
			  indexValue = Replace(Replace(stepStr(2), "i(", "", 1, -1, 1), ")", "")
		  ElseIf InStr(1, stepStr(2), "v(", 1) > 0 Then
             verifyFlag = Replace(Replace(stepStr(2), "v(", "", 1, -1, 1), ")", "")
          ElseIf InStr(1, stepStr(2), "c(", 1) > 0 Then
            Classname = Replace(Replace(stepStr(2), "c(", "", 1, -1, 1), ")", "")
		  Else
                actionValue = stepStr(2)
		End If
        ElseIf UBound(stepStr) = 3 Then
            actionValue = stepStr(2)
            
            If LCase(stepStr(2)) = "optional" Then
                varOptional = stepStr(2)
            ElseIf InStr(1, stepStr(2), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(2), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(2), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(2), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(2), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(2), "c(", "", 1, -1, 1), ")", "")
            Else
                actionValue = stepStr(2)
            End If
            If LCase(stepStr(3)) = "optional" Then
               
                varOptional = stepStr(3)
                
            ElseIf InStr(1, stepStr(3), "i(", 1) > 0 Then
                
                indexValue = Replace(Replace(stepStr(3), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(3), "v(", 1) > 0 Then
                
                verifyFlag = Replace(Replace(stepStr(3), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(3), "c(", 1) > 0 Then
               
                Classname = Replace(Replace(stepStr(3), "c(", "", 1, -1, 1), ")", "")
                
            Else
                propertyName = stepStr(3)
                
            End If
        ElseIf UBound(stepStr) = 4 Then
            
            If LCase(stepStr(2)) = "optional" Then
                varOptional = stepStr(2)
            ElseIf InStr(1, stepStr(2), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(2), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(2), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(2), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(2), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(2), "c(", "", 1, -1, 1), ")", "")
            Else
                actionValue = stepStr(2)
            End If
            If LCase(stepStr(3)) = "optional" Then
                varOptional = stepStr(3)
            ElseIf InStr(1, stepStr(3), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(3), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(3), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(3), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(3), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(3), "c(", "", 1, -1, 1), ")", "")
            Else
                actionValue = stepStr(2)
                propertyName = stepStr(3)
            End If
            If LCase(stepStr(4)) = "optional" Then
                propertyName = stepStr(3)
                varOptional = stepStr(4)
                
            ElseIf InStr(1, stepStr(4), "i(", 1) > 0 Then
                propertyName = stepStr(3)
                
                indexValue = Replace(Replace(stepStr(4), "i(", "", 1, -1, 1), ")", "")
                
                
            ElseIf InStr(1, stepStr(4), "v(", 1) > 0 Then
                propertyName = stepStr(3)
               
                verifyFlag = Replace(Replace(stepStr(4), "v(", "", 1, -1, 1), ")", "")
               
            ElseIf InStr(1, stepStr(4), "c(", 1) > 0 Then
                propertyName = stepStr(3)
               
                Classname = Replace(Replace(stepStr(4), "c(", "", 1, -1, 1), ")", "")
              
            Else
                If Lcase(stepStr(0))<>"verify"  and Lcase(stepStr(0))<>"get"  Then
				
					rowNumber = stepStr(3)
					columnNumber = stepStr(4)
				Else
					rowNumber = stepStr(4)
				End If
            End If
        ElseIf UBound(stepStr) = 5 Then
           
            If LCase(stepStr(2)) = "optional" Then
                varOptional = stepStr(2)
            ElseIf InStr(1, stepStr(2), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(2), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(2), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(2), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(2), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(2), "c(", "", 1, -1, 1), ")", "")
            Else
                actionValue = stepStr(2)
            End If
            If LCase(stepStr(3)) = "optional" Then
                varOptional = stepStr(3)
            ElseIf InStr(1, stepStr(3), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(3), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(3), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(3), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(3), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(3), "c(", "", 1, -1, 1), ")", "")
            Else
                actionValue = stepStr(2)
                propertyName = stepStr(3)
            End If
            If LCase(stepStr(4)) = "optional" Then
                varOptional = stepStr(4)
            ElseIf InStr(1, stepStr(4), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(4), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(4), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(4), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(4), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(4), "c(", "", 1, -1, 1), ")", "")
            Else
				If Lcase(stepStr(0))<>"verify"  and Lcase(stepStr(0))<>"get"  Then
				
					rowNumber = stepStr(3)
					columnNumber = stepStr(4)
				Else
					rowNumber = stepStr(4)
				End If
            End If
            If LCase(stepStr(5)) = "optional" Then
                varOptional = stepStr(5)
               
			ElseIf InStr(1, stepStr(5), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(5), "i(", "", 1, -1, 1), ")", "")
				
            ElseIf InStr(1, stepStr(5), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(5), "c(", "", 1, -1, 1), ")", "")
              
            ElseIf InStr(1, stepStr(5), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(5), "v(", "", 1, -1, 1), ")", "")
               
            Else
                If Lcase(stepStr(0))<>"verify"  and Lcase(stepStr(0))<>"get"  Then
				
					rowNumber = stepStr(4)
					columnNumber = stepStr(5)
				Else
					columnNumber = stepStr(5)
				End If
            End If
        ElseIf UBound(stepStr) = 6 Then
          
            If LCase(stepStr(2)) = "optional" Then
                varOptional = stepStr(2)
            ElseIf InStr(1, stepStr(2), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(2), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(2), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(2), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(2), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(2), "c(", "", 1, -1, 1), ")", "")
            Else
                actionValue = stepStr(2)
            End If
            If LCase(stepStr(3)) = "optional" Then
                varOptional = stepStr(3)
            ElseIf InStr(1, stepStr(3), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(3), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(3), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(3), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(3), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(3), "c(", "", 1, -1, 1), ")", "")
            Else
                actionValue = stepStr(2)
                propertyName = stepStr(3)
            End If
            If LCase(stepStr(4)) = "optional" Then
                varOptional = stepStr(4)
            ElseIf InStr(1, stepStr(4), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(4), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(4), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(4), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(4), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(4), "c(", "", 1, -1, 1), ")", "")
            Else
	
              If Lcase(stepStr(0))<>"verify"  and Lcase(stepStr(0))<>"get"  Then
				
					rowNumber = stepStr(3)
					columnNumber = stepStr(4)
				Else
					rowNumber = stepStr(4)
				End If
            End If
            If LCase(stepStr(5)) = "optional" Then
                varOptional = stepStr(5)
            ElseIf InStr(1, stepStr(5), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(5), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(5), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(5), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(5), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(5), "c(", "", 1, -1, 1), ")", "")
            Else
				columnNumber = stepStr(5)
			End if
            If InStr(1, stepStr(6), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(6), "i(", "", 1, -1, 1), ")", "")
              
            ElseIf InStr(1, stepStr(6), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(6), "v(", "", 1, -1, 1), ")", "")
                
            Else
                Classname = Replace(Replace(stepStr(6), "c(", "", 1, -1, 1), ")", "")
               
            End If
        ElseIf UBound(stepStr) = 7 Then
            
            If LCase(stepStr(2)) = "optional" Then
                varOptional = stepStr(2)
            ElseIf InStr(1, stepStr(2), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(2), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(2), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(2), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(2), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(2), "c(", "", 1, -1, 1), ")", "")
            Else
                actionValue = stepStr(2)
            End If
            If LCase(stepStr(3)) = "optional" Then
                varOptional = stepStr(3)
            ElseIf InStr(1, stepStr(3), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(3), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(3), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(3), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(3), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(3), "c(", "", 1, -1, 1), ")", "")
            Else
                actionValue = stepStr(2)
                propertyName = stepStr(3)
            End If
            If LCase(stepStr(4)) = "optional" Then
                varOptional = stepStr(4)
            ElseIf InStr(1, stepStr(4), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(4), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(4), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(4), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(4), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(4), "c(", "", 1, -1, 1), ")", "")
            Else
                If Lcase(stepStr(0))<>"verify"  and Lcase(stepStr(0))<>"get"  Then
				
					rowNumber = stepStr(3)
					columnNumber = stepStr(4)
				Else
					rowNumber = stepStr(4)
				End If
            End If
            If LCase(stepStr(5)) = "optional" Then
                varOptional = stepStr(5)
            ElseIf InStr(1, stepStr(5), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(5), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(5), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(5), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(5), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(5), "c(", "", 1, -1, 1), ")", "")
            Else
             columnNumber = stepStr(5)
             End If
            If LCase(stepStr(6)) = "optional" Then
                varOptional = stepStr(6)
            ElseIf InStr(1, stepStr(6), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(6), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(6), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(6), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(6), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(6), "c(", "", 1, -1, 1), ")", "")
            End If
            If InStr(1, stepStr(7), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(7), "c(", "", 1, -1, 1), ")", "")
               
			ElseIf InStr(1, stepStr(7), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(7), "i(", "", 1, -1, 1), ")", "")
            Else
                verifyFlag = Replace(Replace(stepStr(7), "v(", "", 1, -1, 1), ")", "")
               
            End If
        ElseIf UBound(stepStr) = 8 Then
            actionValue = stepStr(2)
            propertyName = stepStr(3)
            rowNumber = stepStr(4)
            columnNumber = stepStr(5)
			If LCase(stepStr(6)) = "optional" Then
                varOptional = stepStr(6)
			
            ElseIf InStr(1, stepStr(6), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(6), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(6), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(6), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(6), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(6), "c(", "", 1, -1, 1), ")", "")
           End if
		   If LCase(stepStr(7)) = "optional" Then
                varOptional = stepStr(7)
			
            ElseIf InStr(1, stepStr(7), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(7), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(7), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(7), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(7), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(7), "c(", "", 1, -1, 1), ")", "")
           End if
		  If LCase(stepStr(8)) = "optional" Then
                varOptional = stepStr(8)
			
            ElseIf InStr(1, stepStr(8), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(8), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(8), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(8), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(8), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(8), "c(", "", 1, -1, 1), ")", "")
           End if
		   ElseIf UBound(stepStr) = 9 Then
            actionValue = stepStr(2)
            propertyName = stepStr(3)
            rowNumber = stepStr(4)
            columnNumber = stepStr(5)
			If LCase(stepStr(6)) = "optional" Then
                varOptional = stepStr(6)
			
            ElseIf InStr(1, stepStr(6), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(6), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(6), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(6), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(6), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(6), "c(", "", 1, -1, 1), ")", "")
           End if
		   If LCase(stepStr(7)) = "optional" Then
                varOptional = stepStr(7)
			
            ElseIf InStr(1, stepStr(7), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(7), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(7), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(7), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(7), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(7), "c(", "", 1, -1, 1), ")", "")
           End if
		  If LCase(stepStr(8)) = "optional" Then
                varOptional = stepStr(8)
			
            ElseIf InStr(1, stepStr(8), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(8), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(8), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(8), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(8), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(8), "c(", "", 1, -1, 1), ")", "")
           End if
		   If LCase(stepStr(9)) = "optional" Then
                varOptional = stepStr(9)
			
            ElseIf InStr(1, stepStr(9), "i(", 1) > 0 Then
                indexValue = Replace(Replace(stepStr(8), "i(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(9), "v(", 1) > 0 Then
                verifyFlag = Replace(Replace(stepStr(9), "v(", "", 1, -1, 1), ")", "")
            ElseIf InStr(1, stepStr(9), "c(", 1) > 0 Then
                Classname = Replace(Replace(stepStr(9), "c(", "", 1, -1, 1), ")", "")
           End if
        Else
                actionValue = ""
                propertyName = ""
                varOptional = ""
                rowNumber = ""
                columnNumber = ""
                indexValue = ""
                Classname = ""
                verifyFlag = False
        End If
 End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: Public Function AssignTestScriptColumnValuesToGlobalVariable(ByVal RowNumber)
'
'Description:get the value from the datatable and store it in global variable
'
'Arguments: RowNumber-row from which the value should be get
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:48 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function AssignTestScriptColumnValuesToGlobalVariable(ByVal RowNumber)
On Error Resume Next
DataTable.GetSheet("Action1").SetCurrentRow RowNumber
gsheetName = DataTable("Sheet_Name","Action1")
gNegative = DataTable("Negative","Action1")
ginputStr = DataTable("Input_String","Action1")
gStepNo = DataTable("Step_No","Action1")
gStepDescription = DataTable("Step_Description","Action1")
gExpected = DataTable("Expected","Action1")
gFunctionName = DataTable("Function_Name","Action1")
gDecision = DataTable("Decision","Action1")
If Err.Number <> 0 Then
    AssignTestScriptColumnValuesToGlobalVariable = Fail
Else
    AssignTestScriptColumnValuesToGlobalVariable = Pass
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: Public Function CreateReportFile()
'
'Description:Create a CSS file for report
'
'Arguments: None
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:48 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function CreateReportFile()
Dim reportFile,reportFile1
set reportFile=Createobject("Scripting.filesystemobject")
Set reportfile1 = reportfile.createtextfile(gResultPath & gResultFolderName & "\Report.css")
reportfile1.writeline ".hl1"
reportfile1.writeline "{"
reportfile1.writeline "    COLOR: #669;"
reportfile1.writeline "    FONT-FAMILY: Mic Shell Dlg;"
reportfile1.writeline "    FONT-SIZE: 16pt;"
reportfile1.writeline "    FONT-WEIGHT: bold"
reportfile1.writeline "}"
reportfile1.writeline ".bg_darkblue"
reportfile1.writeline "{"
reportfile1.writeline "    BACKGROUND-COLOR: #669"
reportfile1.writeline "}"
reportfile1.writeline ".bg_midblue"
reportfile1.writeline "{"
reportfile1.writeline "    BACKGROUND-COLOR: #99c"
reportfile1.writeline "}"
reportfile1.writeline ".bg_gray_eee"
reportfile1.writeline "{"
reportfile1.writeline "    BACKGROUND-COLOR: #eee"
reportfile1.writeline "}"
reportfile1.writeline ".text"
reportfile1.writeline "{"
reportfile1.writeline "    FONT-FAMILY: Mic Shell Dlg;"
reportfile1.writeline "    FONT-SIZE: 10pt"
reportfile1.writeline "}"
reportfile1.writeline ".tablehl"
reportfile1.writeline "{"
reportfile1.writeline "    BACKGROUND-COLOR: #eee;"
reportfile1.writeline "    COLOR: #669;"
reportfile1.writeline "    FONT-FAMILY: Mic Shell Dlg;"
reportfile1.writeline "    FONT-SIZE: 10pt;"
reportfile1.writeline "    FONT-WEIGHT: bold;"
reportfile1.writeline "    LINE-HEIGHT: 14pt"
reportfile1.writeline "}"
reportfile1.writeline ".Failed"
reportfile1.writeline "{"
reportfile1.writeline "    COLOR: #f03;"
reportfile1.writeline "    FONT-FAMILY: Mic Shell Dlg;"
reportfile1.writeline "    FONT-SIZE: 10pt;"
reportfile1.writeline "    FONT-WEIGHT: bold"
reportfile1.writeline "}"
reportfile1.writeline ".Passed"
reportfile1.writeline "{"
reportfile1.writeline "    COLOR: #096;"
reportfile1.writeline "    FONT-FAMILY: Mic Shell Dlg;"
reportfile1.writeline "    FONT-SIZE: 10pt;"
reportfile1.writeline "    FONT-WEIGHT: bold"
reportfile1.writeline "}"
Set reportfile = Nothing
Set reportfile1 = Nothing
End Function
