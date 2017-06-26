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
'Function Name: Public Function AutoWaitForObject(ByVal screenObject)
'
'Description:This function automatically wait for the object to load
'
'Arguments: screenObject-object for which the function should wait for
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function AutoWaitForObject(ByVal screenObject)
On Error Resume Next
Dim waitFlag
waitFlag = False
If gwaitNeeded = False Then
    AutoWaitForObject = pass
    exit function
End If
Select Case LCase(screenObject.GetTOProperty("micclass"))
    Case "webedit", "link", "image","webtable", "webcheckbox", "webradiobutton", "webbutton", "webfile", "webelement"
            If LCase(browserType) = "iexplore.exe" Then
             waitFlag = screenObject.WaitProperty("attribute/readyState", "complete", gsynctime)
         Else
             waitFlag = screenObject.WaitProperty("Visible", True, gsynctime)
         End if
    Case "weblist"
            If LCase(browserType) = "iexplore.exe" Then
             waitFlag = screenObject.WaitProperty("items count", micGreaterThan(1), gsynctime)
         Else
             waitFlag = screenObject.WaitProperty("Visible", True, gsynctime)
         End if
    Case "tewindow"
             waitFlag = screenObject.WaitProperty("emulator status", "Ready", gsynctime)
    Case "tefield","tescreen"
        waitFlag = screenObject.Exist(gExistsynctime)
    Case Else
        waitFlag = screenObject.WaitProperty("Visible", True, gsynctime)
End Select
gsynctime=30000
If waitFlag = False Or Err.Number <> 0 Then
    AutoWaitForObject = Fail
Else
    AutoWaitForObject = pass
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: Public Function GetObjectValue(ByVal Screenobject, ByVal columnName, ByVal propertyName, ByVal rowNumber, ByVal ColumnNumber, ByVal indexValue, ByVal optionValue)
'
'Description:This function is used to get the value from application and store it in datatable column
'
'Arguments: screenObject-object for which value should get from application
'columnName:Datatable column Name to store the value
'propertyName-property name for which the value should be retreived from the application
'rowNumber-Row from which the value should be retreived from the application
'ColumnNumber-column from which the value should be retreived from application
'indexValue-Index value for the object in application
'optionValue-whether the object is optional or not-holds value optional
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function GetObjectValue(ByVal Screenobject, ByVal columnName, ByVal propertyName, ByVal rowNumber, ByVal ColumnNumber, ByVal indexValue, ByVal optionValue)
On Error Resume Next
Dim compareValue, columnFound, rc,rowIteration
columnFound = False
If indexValue <> "" Then Screenobject.SetTOProperty "index", indexValue
If Lcase(propertyName)<>"visible" and  Lcase(propertyName)<>"exist" Then rc = AutoWaitForObject(Screenobject)
If rc = fail And LCase(optionValue) = "optional" Then
    GetObjectValue = pass
    Exit Function
End If
If rc = pass Then
    If propertyName = "" Then
        Select Case LCase(Screenobject.GetTOProperty("micclass"))
                Case "webedit", "webbutton", "oracletextfield", "javamenu"
                    compareValue = Screenobject.GetROProperty("value")
                Case "link", "webelement"
                    compareValue = Screenobject.GetROProperty("innertext")
                Case "browser", "page"
                    compareValue = Screenobject.GetROProperty("title")
                Case "webtable"
                    compareValue = Trim(Screenobject.getcelldata(rowNumber, ColumnNumber))
                Case "flexcheckbox"
                    compareValue = Screenobject.GetROProperty("automationname")
                Case Else
                    compareValue = Screenobject.GetROProperty("text")
        End Select
    ElseIf Lcase(propertyName)="exist" then
        compareValue = Screenobject.Exist(gExistSyncTime)
    Else
        compareValue = Screenobject.GetROProperty(propertyName)
    End If
    If InStr(1, columnName, "[", 1) > 0 Then
     columnName = Replace(Replace(columnName, "[", ""), "]", "")
     For rowiteration = 1 To DataTable.GetSheet(gsheetName).GetParameterCount
        If DataTable.GetSheet(gsheetName).GetParameter(rowiteration).Name = columnName Then
            columnFound = True
            Exit For
        End If
     Next
     If columnFound = True Then
        DataTable.GetSheet(gsheetName).SetCurrentRow growNumber
        DataTable.GetSheet(gsheetName).GetParameter(columnName).Value = compareValue
     Else
        DataTable.GetSheet(gsheetName).addParameter columnName, ""
        DataTable.GetSheet(gsheetName).GetParameter(columnName).ValueByRow(growNumber) = compareValue
    End If
    Else
     columnName = Replace(Replace(columnName, "<", ""), ">", "")
     Execute CStr(columnName & "=" & Chr(34) & compareValue & Chr(34))
    End If
Else
    Err.Raise vbObjectError + 1, "Automation Framework", "window/object not exist"
End If
If Err.Number <> 0 Then
    If gNegative ="False" Then
        GetObjectValue = fail
        columnName = Replace(Replace(columnName, "[", ""), "]", "")
        Reportstep "Perform get operation on <b>" & screenobject.tostring & "</b> object to the columnname " & columnName, "Perform get operation on <b>" & screenobject.tostring & "</b> object to the columnname "&columnname &" should be successful","Perform get operation on <b>" &screenobject.tostring &"</b> object to the columnname "&columnname &" is failed due to "&err.description,fail
    Else
        GetObjectValue = pass
        Reportstep "Perform get operation on <b>" & screenobject.tostring & "</b> object to the columnname " & columnName, "Perform get operation on <b>" & screenobject.tostring & "</b> object to the columnname "&columnname &" should be successful","Perform get operation on <b>" &screenobject.tostring &"</b> object to the columnname "&columnname &" is successful because of negative validation",pass
    End If
Else
    GetObjectValue = pass
    Reportstep "Perform get operation on <b>" & screenobject.tostring & "</b> object to the columnname " & columnName, "Perform get operation on <b>" & screenobject.tostring & "</b> object to the columnname "&columnname &" should be successful","Perform get operation on <b>" &screenobject.tostring &"</b> object to the columnname "&columnname &" is successful. The Value stored is <b>" & compareValue&"</b>",pass
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: SetValueOnObject(ByVal screenobject, ByVal action, ByVal actionValue, ByVal objName, ByVal OptionValue, ByVal indexValue, ByVal errObject)
'
'Description:Enter value on the object in application
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           action-Action to be performed on object
'           actionValue-Value to be entered or select on the application
'           objName-logical name of the object
'           propertyName-property name for which the value should be retreived from the application
'           rowNumber-Row for which the value should be retreived from the application
'           ColumnNumber-column for which the value should be retreived from application
'           indexValue-Index value for the object in application
'           optionValue-whether the object is optional or not-holds value optional
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function SetValueOnObject(ByVal screenobject, ByVal action, ByVal actionValue, ByVal objName, ByVal OptionValue, ByVal indexValue, ByVal errObject)
On Error Resume Next
Dim rc
 If indexValue <> "" Then screenobject.SetTOProperty "index", indexValue
If actionValue<>"" then actionValue=getColumnValues(actionValue)
If actionValue = Fail Then
SetValueOnObject = Fail
Exit Function
End If
rc = AutoWaitForObject(screenobject)
If rc = Fail And LCase(OptionValue) = "optional" Then
     SetValueOnObject = Pass
     Reportstep "Perform set operation on <b>" & objName & "</b> object with value " & actionValue, "Perform set operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform set operation on <b>" &ObjName &"</b> object with value "&actionvalue &" passed due to step is optional",pass
     Exit Function
Elseif rc=pass And Lcase(optionValue)="optional" then
     rc=VerifyOptionValue( ScreenObject)
     If rc=fail Then
         SetValueOnObject = Pass
         Reportstep "Perform set operation on <b>" & objName & "</b> object with value " & actionValue, "Perform set operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform set operation on <b>" &ObjName &"</b> object with value "&actionvalue &" passed due to step is optional",pass
         Exit Function
     End If
Elseif rc=Fail And Lcase(optionValue)<>"optional" then
     SetValueOnObject = Fail
     Reportstep "Perform set operation on <b>" & objName & "</b> object with value " & actionValue, "Perform set operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform set operation on <b>" &ObjName &"</b> object with value "&actionvalue &" failed due to object not found",fail
     Exit Function
End If
 Select Case LCase(screenobject.GetTOProperty("micclass"))
     Case "vbedit", "winedit", "pbedit", "javaedit", "delphiedit", "acxedit", "slvedit"
         If LCase(screenobject.GetTOProperty("TestObjName")) = "password" Then
             screenobject.setsecure actionValue
             actionValue = String(Len(actionValue), "*")
         Else
             screenobject.Set actionValue
         End If
             screenobject.Type mictab
     Case "vbeditor", "activex", "winobject", "delphieditor", "swfeditor"
         screenobject.Type actionValue + mictab
     Case "flextextarea"
             screenobject.Input actionValue
     Case "tefield"
         If LCase(screenobject.GetTOProperty("TestObjName")) = "password" Then
             screenobject.set actionValue
             actionValue = String(Len(actionValue), "*")
         Else
             screenobject.Set actionValue
         End If
     Case "oracletextfield"
         screenobject.Enter actionValue, True
     Case "oraclecalendar"
         screenobject.Enter actionValue
     Case "oraclelogon"
         actionValue = Replace(actionValue, ";", ",")
         screenobject.logon actionValue
     Case "javacalendar", "swfcalender", "acxcalender", "sapguicalendar", "slvcalendar"
         If Len(actionValue) > 8 Then
             screenobject.setdate actionValue
             screenobject.Type mictab
         Else
             screenobject.settime actionValue
             screenobject.Type mictab
         End If
     Case "siebcalculator", "siebrichtext", "siebtext", "siebtextarea", "siebcurrency"
             screenobject.SetText actionValue
     Case "webedit"
         If screenobject.GetROProperty("X") > 0 Then
          If LCase(screenobject.GetTOProperty("TestObjName")) = "password" Then
             screenobject.setsecure actionValue
             actionValue = String(Len(actionValue), "*")
          Else
             screenobject.Set actionValue
             ScreenObject.FireEvent "onblur"
          End If
         Else
             Err.Raise vbObjectError + 1, "Automation Framework", "window/object not exist"
         End If
     Case "sbledit", "sapedit", "sbladvanceedit", "sapguiedit"
         If LCase(screenobject.GetTOProperty("TestObjName")) = "password" Then
             actionValue = String(Len(actionValue), "*")
             screenobject.setsecure actionValue
         Else
             screenobject.Set actionValue
         End If
     Case Else
         screenobject.Set actionValue
 End Select
 If Err.Number <> 0 Then
     SetValueOnObject = Fail
     CaptureScreenshot
     Reportstep "Perform set operation on <b>" & objName & "</b> object with value " & actionValue, "Perform set operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform set operation on <b>" &ObjName &"</b> object with value "&actionvalue &" failed due to "&Err.description,fail
     Err.Clear
 Else
     SetValueOnObject = Pass
     Reportstep "Perform set operation on <b>" & objName & "</b> object with value " & actionValue, "Perform set operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform set operation on <b>" &ObjName &"</b> object with value "&actionvalue &" is successful",pass
     If IsObject(errObject) = True Then
         errValue = HandleErrorObjects(errObject)
         If errValue = Fail Then
             SetValueOnObject = Fail
             CaptureScreenshot
             Reportstep "Perform set operation on " & objName & " object with value " & actionValue, "Perform set operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform set operation on <b>" &ObjName &"</b> object with value "&actionvalue &" failed due to error window exist" ,fail
         End If
     End If
 End If
 End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: ClickonObject(ByVal ScreenObject, ByVal actionValue, ByVal objName, ByVal action, ByVal verifyFlag, ByVal OptionValue, ByVal indexValue, ByVal errObject)
'
'Description:Object for which click operation to be performed
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           action-Action to be performed on object
'           actionValue-Value to be entered or select on the application
'           objName-logical name of the object
'           indexValue-Index value for the object in application
'           optionValue-whether the object is optional or not-holds value optional
'           verifyFlag-This variable holds value true or false,True which verify using strcomp function and false will use instr function
'           errObject-Holds the error object if any
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function ClickonObject(ByVal ScreenObject, ByVal actionValue, ByVal objName, ByVal action, ByVal verifyFlag, ByVal OptionValue, ByVal indexValue, ByVal errObject)
On Error Resume Next
Dim rc, newActionValue,errValue
 If indexValue <> "" Then screenobject.SetTOProperty "index", indexValue
If actionValue<>"" then actionValue=getColumnValues(actionValue)
If actionValue = Fail Then
ClickonObject = Fail
Exit Function
End If
 rc = AutoWaitForObject(screenobject)
If rc = Fail And LCase(OptionValue) = "optional" Then
     ClickonObject = Pass
     Reportstep "Perform click operation on <b>" & screenobject.tostring &"</b>" , "Perform click operation on <b>" & screenobject.tostring & "</b> should be successful","Perform click operation on <b>" &screenobject.tostring &"</b> passed due to step is optional",pass
     Exit Function
Elseif rc=pass And Lcase(optionValue)="optional" then
 rc=VerifyOptionValue( ScreenObject)
 If rc=fail Then
     ClickonObject = Pass
     Reportstep "Perform click operation on <b>" & screenobject.tostring &"</b>" , "Perform click operation on <b>" & screenobject.tostring & "</b> should be successful","Perform click operation on <b>" &screenobject.tostring &"</b> passed due to step is optional",pass
     Exit Function
 End If
Elseif rc=Fail And Lcase(optionValue)<>"optional" then
 ClickonObject = Fail
 Reportstep "Perform click operation on <b>" & screenobject.tostring &"</b>" , "Perform click operation on <b>" & screenobject.tostring & "</b> should be successful","Perform click operation on <b>" &screenobject.tostring &"</b> failed due to object not found",fail
 Exit Function
End If
 Select Case LCase(ScreenObject.GetTOProperty("micclass"))
     Case "link", "webelement"
         If Trim(actionValue) <> "" Then
             ScreenObject.SetTOProperty "innertext", actionValue
         End If
         ScreenObject.Click micNoCoordinate, micNoCoordinate
     Case "siebbutton"
         ScreenObject.Click
     Case "tefield"
         ScreenObject.setcursorpos
     Case "wintoolbar", "javatoolbar", "vbtoolbar", "swftoolbar"
         rc = ClickOnToolBarObject(ScreenObject, actionValue, objName, verifyFlag)
     Case "sapguitoolbar"
         newActionValue = Split(actionValue, ";")
         If UBound(newActionValue) = 0 Then
             ScreenObject.pressbutton newActionValue(0)
         Else
             ScreenObject.PressContextButton newActionValue(0)
             ScreenObject.SelectMenuItem newActionValue(1)
          End If
     Case "javalink"
         If Trim(actionValue) <> "" Then
             ScreenObject.Click
         Else
             ScreenObject.clicklink actionValue
         End If
     Case Else
         If Trim(actionValue) <> "" Then
             ScreenObject.SetTOProperty "text", actionValue
         End If
         ScreenObject.Click
      End Select
     Wait(2)
 If Err.Number <> 0 or rc=fail Then
        If Err.Description = "" Then Err.Description = gErrDescription
     ClickonObject = Fail
     CaptureScreenshot
     Reportstep "Perform click operation on <b>" & screenobject.tostring &"</b>" , "Perform click operation on <b>" & screenobject.tostring & "</b> should be successful","Perform click operation on <b>" &screenobject.tostring &"</b> failed due to "&Err.description,fail
     Err.Clear
 Else
     ClickonObject = Pass
     Reportstep "Perform click operation on <b>" & screenobject.tostring &"</b>" , "Perform click operation on <b>" & screenobject.tostring & "</b> should be successful","Perform click operation on <b>" &screenobject.tostring &"</b> is successful",pass
     If IsObject(errObject) = True Then
         errValue = HandleErrorObjects(errObject)
         If errValue = Fail Then
             ClickonObject = Fail
             CaptureScreenshot
             Reportstep "Verify exist of <b>" & errObject.tostring &"</b>", "Verify exist of <b>" & errObject.tostring & "</b> should be successful","Verify exist of  <b>" & errObject.tostring &"</b> failed due to invalid error window",fail
         End If
     End If
 End If
 End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: SelectValueonObject(ByVal ScreenObject, ByVal actionValue, ByVal action, ByVal ColumnNumber, ByVal objName, ByVal verifyFlag, ByVal indexValue, ByVal optionValue, ByVal errObject)
'
'Description:select value on the object in application
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           action-Action to be performed on object
'           actionValue-Value to be entered or select on the application
'           objName-logical name of the object
'           propertyName-property name for which the value should be retreived from the application
'           rowNumber-Row for which the value should be retreived from the application
'           ColumnNumber-column for which the value should be retreived from application
'           indexValue-Index value for the object in application
'           optionValue-whether the object is optional or not-holds value optional
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function SelectValueonObject(ByVal ScreenObject, ByVal actionValue, ByVal action, ByVal ColumnNumber, ByVal objName, ByVal verifyFlag, ByVal indexValue, ByVal optionValue, ByVal errObject)
On Error Resume Next
Dim rc,errValue
If indexValue <> "" Then ScreenObject.SetTOProperty "index", indexValue
If actionValue<>"" then actionValue=getColumnValues(actionValue)
If actionValue = Fail Then
SelectValueonObject = Fail
Exit Function
End If
    rc = AutoWaitForObject(ScreenObject)
If rc = Fail And LCase(OptionValue) = "optional" Then
     SelectValueonObject = Pass
     Reportstep "Perform select operation on <b>" & screenobject.tostring & "</b> object with value " & actionValue, "Perform select operation on <b>" & screenobject.tostring & "</b> object with value "&actionvalue &" should be successful","Perform select operation on <b>" & screenobject.tostring &"</b> object with value "&actionvalue &" passed due to step is optional",pass
     Exit Function
Elseif rc=pass And Lcase(optionValue)="optional" then
     rc=VerifyOptionValue( ScreenObject)
     If rc=fail Then
         SelectValueonObject = Pass
         Reportstep "Perform select operation on <b>" & screenobject.tostring & "</b> object with value " & actionValue, "Perform select operation on <b>" & screenobject.tostring & "</b> object with value "&actionvalue &" should be successful","Perform select operation on <b>" & screenobject.tostring &"</b> object with value "&actionvalue &" passed due to step is optional",pass
         Exit Function
     End If
Elseif rc=Fail And Lcase(optionValue)<>"optional" then
     SelectValueonObject = Fail
     Reportstep "Perform select operation on <b>" & screenobject.tostring & "</b> object with value " & actionValue, "Perform select operation on <b>" & screenobject.tostring & "</b> object with value "&actionvalue &" should be successful","Perform select operation on <b>" & screenobject.tostring &"</b> object with value "&actionvalue &" failed due to object not found",fail
     Exit Function
End If
Select Case LCase(ScreenObject.GetTOProperty("micclass"))
    Case "vbradiobutton", "winradiobutton", "delphiradiobutton", "slvradiobutton", "javaradiobutton", "swfradiobutton", "wpfradiobutton"
        ScreenObject.Set
    Case "webradiogroup", "sapradiogroup"
        If IsNumeric(actionValue) Then
            ScreenObject.Select "#" & actionValue
        Else
            ScreenObject.Select actionValue
        End If
    Case "weblist"
        If ScreenObject.GetROProperty("X") > 0 Then
         If LCase(action) = "selectbyindex" Then
            rc = ListSelect(ScreenObject, actionValue, verifyFlag)
         Else
             ScreenObject.Select actionValue
         End If
        Else
            Err.Raise vbObjectError + 1, "Automation Framework", "window/object not exist"
        End If
    Case "vblist", "vbcombobox", "winlist", "pblist", "swflist", "slvlist", "javalist", "slvcombobox"
         If LCase(action) = "selectbyindex" Then
            rc = ListSelect(ScreenObject, actionValue, verifyFlag)
         Else
             ScreenObject.Select actionValue
         End If
    Case "oraclelist"
        ScreenObject.Select actionValue
    Case "vblistview", "pblistview", "swflistview", "delphilistview", "winlistview"
        rc = SelectOrActivateListViewValues(ScreenObject, ColumnNumber, actionValue, action, verifyFlag)
    Case "wintab", "delphitabstrip", "pbtabstrip", "slvtabstrip", "wpftabstrip", "swftab", "javatab"
        rc = clickOrSelectOnTabValue(ScreenObject, actionValue, action, objName, verifyFlag)
    Case "javamenu"
        rc = SelectJavamenu(ScreenObject, actionValue)
    Case "oracleapplications", "oraclecalender"
        ScreenObject.SelectPopupMenu actionValue
    Case Else
        ScreenObject.Select actionValue
End Select
If Err.Number <> 0 Or rc = Fail Then
    If Err.Description = "" Then Err.Description = gErrDescription
    SelectValueonObject = Fail
    CaptureScreenshot
    Reportstep "Perform select operation on <b>" & screenobject.tostring & "</b> object with value " & actionValue, "Perform select operation on <b>" & screenobject.tostring & "</b> object with value "&actionvalue &" should be successful","Perform select operation on <b>" & screenobject.tostring &"</b> object with value "&actionvalue &" failed due to "&Err.description,fail
    Err.Clear
Else
    SelectValueonObject = Pass
    Reportstep "Perform select operation on <b>" & screenobject.tostring & "</b> object with value " & actionValue, "Perform select operation on <b>" & screenobject.tostring & "</b> object with value "&actionvalue &" should be successful","Perform select operation on <b>" & screenobject.tostring &"</b> object with value "&actionvalue &" is successful",pass
    If IsObject(errObject) = True Then
        errValue = HandleErrorObjects(errObject)
        If errValue = Fail Then
            SelectValueonObject = Fail
            CaptureScreenshot
            Reportstep "Perform select operation on <b>" & screenobject.tostring & "</b> object with value " & actionValue, "Perform select operation on <b>" & screenobject.tostring & "</b> object with value "&actionvalue &" should be successful","Perform select operation on <b>" & screenobject.tostring &"</b> object with value "&actionvalue &" failed due to error window exist" ,fail
        End If
    End If
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: ActivateOrDblclickonObject(ScreenObject, actionValue, objName, action, verifyFlag, OptionValue, indexValue, errObject)
'
'Description:Object for which dblclick or activate operation to be performed
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           action-Action to be performed on object
'           actionValue-Value to be entered or select on the application
'           objName-logical name of the object
'           indexValue-Index value for the object in application
'           optionValue-whether the object is optional or not-holds value optional
'           verifyFlag-This variable holds value true or false,True which verify using instr function and false will use strcomp function
'           errObject-Holds the error object if any
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function ActivateOrDblclickonObject(ScreenObject, actionValue, objName, action, verifyFlag, OptionValue, indexValue, errObject)
On Error Resume Next
Dim rc,errValue
If indexValue <> "" Then ScreenObject.SetTOProperty "index", indexValue
If actionValue<>"" then actionValue=getColumnValues(actionValue)
If actionValue = Fail Then
ActivateOrDblclickonObject = Fail
Exit Function
End If
    rc = AutoWaitForObject(ScreenObject)
If rc = Fail And LCase(OptionValue) = "optional" Then
     ActivateOrDblclickonObject = Pass
     Reportstep "Perform activate operation on <b>" & screenobject.tostring & "</b> object with value " & actionValue, "Perform activate operation on <b>" & screenobject.tostring & "</b> object with value "&actionvalue &" should be successful","Perform activate operation on <b>" & screenobject.tostring &"</b> object with value "&actionvalue &" passed due to step is optional",pass
     Exit Function
Elseif rc=pass And Lcase(optionValue)="optional" then
     rc=VerifyOptionValue( ScreenObject)
     If rc=fail Then
         ActivateOrDblclickonObject = Pass
     Reportstep "Perform activate operation on <b>" & screenobject.tostring & "</b> object with value " & actionValue, "Perform activate operation on <b>" & screenobject.tostring & "</b> object with value "&actionvalue &" should be successful","Perform activate operation on <b>" & screenobject.tostring &"</b> object with value "&actionvalue &" passed due to step is optional",pass
         Exit Function
     End If
Elseif rc=Fail And Lcase(optionValue)<>"optional" then
     ActivateOrDblclickonObject = Fail
     Exit Function
End If
   Select Case LCase(action)
        Case "activate"
            Select Case LCase(screenobject.GetTOProperty("micclass"))
                Case "vbwindow", "window", "pbwindow", "swfwindow", "tewindow", "wpfwindow", "dialog"
                    screenobject.Activate
                Case "vblistview", "pblistview", "swflistview", "delphilistview", "winlistview"
                    rc = SelectOrActivateListViewValues(screenobject, ColumnNumber, actionValue, action, verifyFlag)
                Case "oracletextfield"
                    screenobject.OpenDialog
                Case Else
                    screenobject.Activate theValue
            End Select
        Case "dblclick"
            If Trim(actionValue) <> "" Then screenobject.SetTOProperty "text", actionValue
            screenobject.DblClick
   End Select
If Err.Number <> 0 Or rc = Fail Then
    If Err.Description = "" Then Err.Description = gErrDescription
    ActivateOrDblclickonObject = Fail
    CaptureScreenshot
    Reportstep "Perform dblclick or activate operation on " & screenobject.tostring & " object with value " & actionValue, "Perform dblclick or activate operation on " & screenobject.tostring & " object with value "&actionvalue &" should be successful","Perform dblclick or activate operation on " & screenobject.tostring &" object with value "&actionvalue &" failed due to "&Err.description,fail
    Err.Clear
Else
    ActivateOrDblclickonObject = Pass
    Reportstep "Perform dblclick or activate operation on " & screenobject.tostring & " object with value " & actionValue, "Perform dblclick or activate operation on " & screenobject.tostring & " object with value "&actionvalue &" should be successful","Perform dblclick or activate operation on " & screenobject.tostring &" object with value "&actionvalue &" is successful",pass
    If IsObject(errObject) = True Then
        errValue = HandleErrorObjects(errObject)
        If errValue = Fail Then
            ActivateOrDblclickonObject = Fail
            CaptureScreenshot
            Reportstep "Perform dblclick or activate operation on " & screenobject.tostring & " object with value " & actionValue, "Perform dblclick or activate operation on " & screenobject.tostring & " object with value "&actionvalue &" should be successful","Perform dblclick or activate operation on " & screenobject.tostring &" object with value "&actionvalue &" failed due to error window exist" ,fail
        End If
    End If
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: PerformCheckOperationOnObject(screenobject, actionValue, objName, OptionValue, indexValue, errObject)
'
'Description:Perform check operation on object
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           action-Action to be performed on object
'           actionValue-Value to be entered or select on the application
'           objName-logical name of the object
'           indexValue-Index value for the object in application
'           optionValue-whether the object is optional or not-holds value optional
'           errObject-Holds the error object if any
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function PerformCheckOperationOnObject(screenobject, actionValue, objName, OptionValue, indexValue, errObject)
On Error Resume Next
Dim rc,errValue
If indexValue <> "" Then ScreenObject.SetTOProperty "index", indexValue
If actionValue<>"" then actionValue=getColumnValues(actionValue)
If actionValue = Fail Then
PerformCheckOperationOnObject = Fail
Exit Function
End If
    rc = AutoWaitForObject(ScreenObject)
If rc = Fail And LCase(OptionValue) = "optional" Then
     PerformCheckOperationOnObject = Pass
     Reportstep "Perform check operation on <b>" & screenobject.tostring & "</b> object with value " & actionValue, "Perform check operation on <b>" & screenobject.tostring & "</b> object with value "&actionvalue &" should be successful","Perform check operation on <b>" & screenobject.tostring &"</b> object with value "&actionvalue &" passed due to step is optional",pass
     Exit Function
Elseif rc=pass And Lcase(optionValue)="optional" then
     rc=VerifyOptionValue( ScreenObject)
     If rc=fail Then
         PerformCheckOperationOnObject = Pass
         Reportstep "Perform check operation on <b>" & screenobject.tostring & "</b> object with value " & actionValue, "Perform check operation on <b>" & screenobject.tostring & "</b> object with value "&actionvalue &" should be successful","Perform check operation on <b>" & screenobject.tostring &"</b> object with value "&actionvalue &" passed due to step is optional",pass
         Exit Function
     End If
Elseif rc=Fail And Lcase(optionValue)<>"optional" then
     PerformCheckOperationOnObject = Fail
     Reportstep "Perform check operation on <b>" & screenobject.tostring & "</b> object with value " & actionValue, "Perform check operation on <b>" & screenobject.tostring & "</b> object with value "&actionvalue &" should be successful","Perform check operation on <b>" & screenobject.tostring &"</b> object with value "&actionvalue &" failed due to object not found",fail
     Exit Function
End If
Select Case LCase(ScreenObject.GetTOProperty("micclass"))
    Case "siebcheckbox"
        If LCase(actionValue) = "off" Then
            ScreenObject.setoff
        Else
            ScreenObject.seton
        End If
    Case "slvcheckbox"
        If LCase(actionValue) = "off" Then
            ScreenObject.set 0
        Else
            ScreenObject.set 1
        End If
    Case Else
        ScreenObject.set actionValue
End Select
If Err.Number <> 0 Then
    If Err.Description = "" Then Err.Description = gErrDescription
    PerformCheckOperationOnObject = Fail
    CaptureScreenshot
    Reportstep "Perform check operation on <b>" & screenobject.tostring & "</b> object with value " & actionValue, "Perform check operation on <b>" & screenobject.tostring & "</b> object with value "&actionvalue &" should be successful","Perform check operation on <b>" & screenobject.tostring &"</b> object with value "&actionvalue &" failed due to "&Err.description,fail
    Err.Clear
Else
    PerformCheckOperationOnObject = Pass
    Reportstep "Perform check operation on <b>" & screenobject.tostring & "</b> object with value " & actionValue, "Perform check operation on <b>" & screenobject.tostring & "</b> object with value "&actionvalue &" should be successful","Perform check operation on <b>" & screenobject.tostring &"</b> object with value "&actionvalue &" is successful",pass
    If IsObject(errObject) = True Then
        errValue = HandleErrorObjects(errObject)
        If errValue = Fail Then
            PerformCheckOperationOnObject = Fail
            CaptureScreenshot
            Reportstep "Perform check operation on <b>" & screenobject.tostring & "</b> object with value " & actionValue, "Perform check operation on <b>" & screenobject.tostring & "</b> object with value "&actionvalue &" should be successful","Perform check operation on <b>" & screenobject.tostring &"</b> object with value "&actionvalue &" failed due to error window exist" ,fail
        End If
    End If
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: PerformPressOperationonObject(screenobject, actionValue, objName, OptionValue, indexValue, errObject)
'
'Description:Perform press operation on object
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           action-Action to be performed on object
'           actionValue-Value to be entered or select on the application
'           objName-logical name of the object
'           indexValue-Index value for the object in application
'           optionValue-whether the object is optional or not-holds value optional
'           errObject-Holds the error object if any
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function PerformPressOperationonObject(screenobject, actionValue, objName, OptionValue, indexValue, errObject)
On Error Resume Next
Dim rc,errValue
If indexValue <> "" Then ScreenObject.SetTOProperty "index", indexValue
If actionValue<>"" then actionValue=getColumnValues(actionValue)
If actionValue = Fail Then
PerformPressOperationonObject = Fail
Exit Function
End If
    rc = AutoWaitForObject(ScreenObject)
If rc = Fail And LCase(OptionValue) = "optional" Then
     PerformPressOperationonObject = Pass
     Reportstep "Perform press operation on <b>" & objName & "</b> object with value " & actionValue, "Perform press operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform press operation on <b>" &ObjName &"</b> object with value "&actionvalue &" passed due to step is optional",pass
     Exit Function
Elseif rc=pass And Lcase(optionValue)="optional" then
     rc=VerifyOptionValue( ScreenObject)
     If rc=fail Then
         PerformPressOperationonObject = Pass
         Reportstep "Perform press operation on <b>" & objName & "</b> object with value " & actionValue, "Perform press operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform press operation on <b>" &ObjName &"</b> object with value "&actionvalue &" passed due to step is optional",pass
         Exit Function
     End If
Elseif rc=Fail And Lcase(optionValue)<>"optional" then
     PerformPressOperationonObject = Fail
     Reportstep "Perform press operation on <b>" & objName & "</b> object with value " & actionValue, "Perform press operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform press operation on <b>" &ObjName &"</b> object with value "&actionvalue &" failed due to object not found",fail
     Exit Function
End If
   Select Case LCase(screenobject.GetTOProperty("micclass"))
        Case "tetextscreen","tescreen"
            screenobject.press Eval(actionValue)
        Case "oracletextfield", "oraclelist", "oraclecheckbox", "oraclebutton", "oraclecalendar", "oraclelistofvalues", "oracleflexwindow", "oracleformwindow", "oracletree", "oraclenavigator"
            screenobject.InvokeSoftkey actionValue
        Case Else
            screenobject.press actionValue
    End Select
If Err.Number <> 0 Then
    If Err.Description = "" Then Err.Description = gErrDescription
    PerformPressOperationonObject = Fail
    CaptureScreenshot
    Reportstep "Perform press operation on " & objName & " object with value " & actionValue, "Perform press operation on " & objName & " object with value "&actionvalue &" should be successful","Perform press operation on " &ObjName &" object with value "&actionvalue &" failed due to "&Err.description,fail
    Err.Clear
Else
    PerformPressOperationonObject = Pass
    Reportstep "Perform press operation on " & objName & " object with value " & actionValue, "Perform press operation on " & objName & " object with value "&actionvalue &" should be successful","Perform press operation on " &ObjName &" object with value "&actionvalue &" is successful",pass
    If IsObject(errObject) = True Then
        errValue = HandleErrorObjects(errObject)
        If errValue = Fail Then
            PerformPressOperationonObject = Fail
            CaptureScreenshot
            Reportstep "Perform press operation on " & objName & " object with value " & actionValue, "Perform press operation on " & objName & " object with value "&actionvalue &" should be successful","Perform press operation on " &ObjName &" object with value "&actionvalue &" failed due to error window exist" ,fail
        End If
    End If
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: TypeValueonObject(ScreenObject, actionValue, objName, OptionValue, indexValue, errObject)
'
'Description:Perform type operation on object
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           action-Action to be performed on object
'           actionValue-Value to be entered or select on the application
'           objName-logical name of the object
'           indexValue-Index value for the object in application
'           optionValue-whether the object is optional or not-holds value optional
'           errObject-Holds the error object if any
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function TypeValueonObject(ScreenObject, actionValue, objName, OptionValue, indexValue, errObject)
On Error Resume Next
Dim rc,errValue
If indexValue <> "" Then ScreenObject.SetTOProperty "index", indexValue
If actionValue<>"" then actionValue=getColumnValues(actionValue)
If actionValue = Fail Then
TypeValueonObject = Fail
Exit Function
End If
    rc = AutoWaitForObject(ScreenObject)
If rc = Fail And LCase(OptionValue) = "optional" Then
     TypeValueonObject = Pass
     Reportstep "Perform type operation on <b>" & objName & "</b> object with value " & actionValue, "Perform type operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform type operation on <b>" &ObjName &"</b> object with value "&actionvalue &" passed due to step is optional",pass
     Exit Function
Elseif rc=pass And Lcase(optionValue)="optional" then
 rc=VerifyOptionValue( ScreenObject)
 If rc=fail Then
     TypeValueonObject = Pass
     Reportstep "Perform type operation on <b>" & objName & "</b> object with value " & actionValue, "Perform type operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform type operation on <b>" &ObjName &"</b> object with value "&actionvalue &" passed due to step is optional",pass
     Exit Function
 End If
Elseif rc=Fail And Lcase(optionValue)<>"optional" then
     TypeValueonObject = Fail
     Reportstep "Perform type operation on <b>" & objName & "</b> object with value " & actionValue, "Perform type operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform type operation on <b>" &ObjName &"</b> object with value "&actionvalue &" failed due to object not found",fail
     Exit Function
End If
   Select Case LCase(screenobject.GetTOProperty("micclass"))
        Case "vbwindow", "window", "pbwindow", "swfwindow", "javawindow"
            screenobject.Type actionValue
        Case "tescreen", "tetextscreen"
            screenobject.sendkey actionValue
        Case Else
            screenobject.Type actionValue + mictab
    End Select
If Err.Number <> 0 Then
    If Err.Description = "" Then Err.Description = gErrDescription
    TypeValueonObject = Fail
    CaptureScreenshot
    Reportstep "Perform type operation on " & objName & " object with value " & actionValue, "Perform type operation on " & objName & " object with value "&actionvalue &" should be successful","Perform type operation on " &ObjName &" object with value "&actionvalue &" failed due to "&Err.description,fail
    Err.Clear
Else
    TypeValueonObject = Pass
    Reportstep "Perform type operation on " & objName & " object with value " & actionValue, "Perform type operation on " & objName & " object with value "&actionvalue &" should be successful","Perform type operation on " &ObjName &" object with value "&actionvalue &" is successful",pass
    If IsObject(errObject) = True Then
        errValue = HandleErrorObjects(errObject)
        If errValue = Fail Then
            TypeValueonObject = Fail
            CaptureScreenshot
            Reportstep "Perform type operation on " & objName & " object with value " & actionValue, "Perform type operation on " & objName & " object with value "&actionvalue &" should be successful","Perform type operation on " &ObjName &" object with value "&actionvalue &" failed due to error window exist" ,fail
        End If
    End If
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: PerformAction(ByVal screenobject, ByVal action, ByVal actionValue, ByVal errObject, ByVal indexValue, ByVal OptionValue, ByVal ColumnNumber, ByVal objName, ByVal verifyFlag)
'
'Description:This function is common function which will call the respective function to perform the action
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           action-Action to be performed on object
'           actionValue-Value to be entered or select on the application
'           objName-logical name of the object
'           indexValue-Index value for the object in application
'           optionValue-whether the object is optional or not-holds value optional
'           errObject-Holds the error object if any
'           rowNumber-rownumber of the webtable
'           columnNumber-column number of the webtable
'           compareType-This variable holds value true or false,True which verify using instr function and false will use strcomp function
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function PerformAction(ByVal screenobject, ByVal action, ByVal actionValue, ByVal errObject, ByVal indexValue, ByVal OptionValue, ByVal ColumnNumber, ByVal objName, ByVal verifyFlag)
On Error Resume Next
Dim rc
  Select Case LCase(action)
    Case "set"
        rc = SetValueOnObject(screenobject,action, actionValue, objName, OptionValue, indexValue, errObject)
    Case "click"
        rc = ClickonObject(screenobject, actionValue, objName, action, verifyFlag, OptionValue, indexValue, errObject)
    Case "activate", "dblclick"
                rc = ActivateOrDblclickonObject(screenobject, actionValue,objName, action, verifyFlag, OptionValue, indexValue, errObject)
    Case "type"
        rc = TypeValueonObject(screenobject, actionValue, objName, OptionValue, indexValue, errObject)
    Case "select","setitemstate","selectbyindex"
        rc = SelectValueonObject(screenobject, actionValue, action, ColumnNumber, objName, verifyFlag, indexValue, OptionValue, errObject)
    Case "press"
        rc = PerformPressOperationonObject(screenobject, actionValue, objName, OptionValue, indexValue, errObject)
    Case "check"
        rc = PerformCheckOperationOnObject(screenobject, actionValue, objName, OptionValue, indexValue, errObject)
    Case "save", "close", "submit", "approve", "cancel"
        rc = PerformSaveOrCloseOperation(screenobject, action, objName, OptionValue, indexValue, errObject)
End Select
If Err.Number <> 0 Or rc = fail Then
    PerformAction = fail
    Err.Clear
Else
    PerformAction = pass
End If
End Function
'--------------------------------------------------------------------------------------------
'--------------------------------------------------------------------------------------------
'Function Name: PerformActionOnWebtable(ByVal screenObject, ByVal action, ByVal actionValue, ByVal rowNumber, ByVal columnNumber, ByVal indexValue, ByVal propertyName, ByVal errObject, ByVal objName, ByVal className,Byval verifyFlag,byval varOptional)
'
'Description:This function will initialize all the variables
'
'Arguments: None
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function PerformActionOnWebtable(ByVal screenObject, ByVal action, ByVal actionValue, ByVal rowNumber, ByVal columnNumber, ByVal indexValue, ByVal propertyName, ByVal errObject, ByVal objName, ByVal className,Byval VerifyFlag,Byval varOptional)
   On Error Resume Next
   Dim newRowNumber, newColumnNumber, objFound, winObj, rc, newindexValue, linkIteration
   objFound = False
If Trim(indexValue) = "" or Trim(Lcase(indexValue))="first" Then
    newindexValue = 0
Elseif Trim(Lcase(indexValue))="last" Then
 newindexValue = Trim(LCase(indexValue))
Else
    newindexValue = CInt(indexValue)
End If
If isnumeric(rowNumber)=false Then
 newRowNumber = GetRowOrColumnNumber(screenObject, rowNumber, "row",verifyFlag)
 If newRowNumber = "Fail" Then
        PerformActionOnWebtable = Fail
        Exit Function
 End If
Else
 newRowNumber =RowNumber
End If
gtableRow = newRowNumber
If isnumeric(rowNumber)=false Then
 newColumnNumber = GetRowOrColumnNumber(screenObject, columnNumber, "column",verifyFlag)
 If newColumnNumber = "Fail" Then
        PerformActionOnWebtable = Fail
        Exit Function
 End If
Else
newColumnNumber =columnNumber
End If
gtableCol=newColumnNumber
If Trim(className) <> "" Then
        If screenObject.childitemcount(newRowNumber, newColumnNumber, className) > 0 Then
        newindexValue = getChilditemIndex(screenObject, newRowNumber, newColumnNumber, className, actionValue)
        If newindexValue <> False Then actionValue = ""
    If Trim(LCase(indexValue)) = "last" Then newindexValue = screenObject.childitemcount(newRowNumber, newColumnNumber, ClassName)
        Set winObj = screenObject.childitem(newRowNumber, newColumnNumber, className, newindexValue)
        objFound = True
    End If
ElseIf screenObject.childitemcount(newRowNumber, newColumnNumber, "Webedit") > 0 Then
    objFound = True
    If Trim(LCase(indexValue)) = "last" Then newindexValue = screenObject.childitemcount(newRowNumber, newColumnNumber, "Webedit") - 1
    Set winObj = screenObject.childitem(newRowNumber, newColumnNumber, "Webedit", newindexValue)
ElseIf screenObject.childitemcount(newRowNumber, newColumnNumber, "Weblist") > 0 Then
    objFound = True
    If Trim(LCase(indexValue)) = "last" Then newindexValue = screenObject.childitemcount(newRowNumber, newColumnNumber, "Weblist") - 1
    Set winObj = screenObject.childitem(newRowNumber, newColumnNumber, "Weblist", newindexValue)
ElseIf screenObject.childitemcount(newRowNumber, newColumnNumber, "Image") > 0 Then
    If Trim(LCase(indexValue)) = "last" Then newindexValue = screenObject.childitemcount(newRowNumber, newColumnNumber, "Image") - 1
    objFound = True
    Set winObj = screenObject.childitem(newRowNumber, newColumnNumber, "Image", newindexValue)
ElseIf screenObject.childitemcount(newRowNumber, newColumnNumber, "webradiogroup") > 0 Then
    If Trim(LCase(indexValue)) = "last" Then newindexValue = screenObject.childitemcount(newRowNumber, newColumnNumber, "webradiogroup") - 1
    Set winObj = screenObject.childitem(newRowNumber, newColumnNumber, "webradiogroup", newindexValue)
    objFound = True
    If actionValue = "" Then actionValue = "#" & (newRowNumber - 2)
ElseIf screenObject.childitemcount(newRowNumber, newColumnNumber, "webcheckbox") > 0 Then
    If Trim(LCase(indexValue)) = "last" Then newindexValue = screenObject.childitemcount(newRowNumber, newColumnNumber, "webcheckbox") - 1
    Set winObj = screenObject.childitem(newRowNumber, newColumnNumber, "webcheckbox", newindexValue)
    objFound = True
ElseIf screenObject.childitemcount(newRowNumber, newColumnNumber, "link") > 0 Then
    newindexValue = getChilditemIndex(screenObject, newRowNumber, newColumnNumber, "link", actionValue)
    If LCase(action) <> "get" And LCase(action) <> "verify" And newindexValue <> False Then actionValue = ""
    If Trim(LCase(indexValue)) = "last" Then newindexValue = screenObject.childitemcount(newRowNumber, newColumnNumber, "link") - 1
    Set winObj = screenObject.childitem(newRowNumber, newColumnNumber, "link", newindexValue)
    objFound = True
ElseIf screenObject.childitemcount(newRowNumber, newColumnNumber, "WebElement") > 0 Then
    newindexValue = getChilditemIndex(screenObject, newRowNumber, newColumnNumber, "WebElement", actionValue)
    If LCase(action) <> "get" And LCase(action) <> "verify" And newindexValue <> False Then actionValue = ""
    If Trim(LCase(indexValue)) = "last" Then newindexValue = screenObject.childitemcount(newRowNumber, newColumnNumber, "WebElement") - 1
    Set winObj = screenObject.childitem(newRowNumber, newColumnNumber, "WebElement", newindexValue)
    objFound = True
ElseIf screenObject.childitemcount(newRowNumber, newColumnNumber, "webbutton") > 0 Then
    newindexValue = getChilditemIndex(screenObject, newRowNumber, newColumnNumber, "webbutton", actionValue)
    If LCase(action) <> "get" And LCase(action) <> "verify" And newindexValue <> False Then actionValue = ""
    If Trim(LCase(indexValue)) = "last" Then newindexValue = screenObject.childitemcount(newRowNumber, newColumnNumber, "WebButton") - 1
    Set winObj = screenObject.childitem(newRowNumber, newColumnNumber, "webbutton", newindexValue)
    objFound = True
Else
    If LCase(action) = "get" Or LCase(action) = "verify" Or LCase(action) = "clickonwebtablecell" Then
        Set winObj = screenObject
        objFound = True
    End If
End If
gwaitNeeded = False
If objFound = False Or Err.Number <> 0 Then
    ReportStep "Perform " & action & " operation on " & screenObject.ToString,"perform " & action & " operation on " & screenObject.ToString &" should be successful","perform " & action & " operation on " & screenObject.ToString &" failed due to object not found."
    PerformActionOnWebtable = Fail
Else
    If LCase(action) = "get" Then
        rc = GetObjectValue(winObj, actionValue, propertyName, newRowNumber, newColumnNumber, "",varOptional )
    ElseIf LCase(action) = "verify" Then
        rc = VerifyProperty(winObj, "verify", propertyName, actionValue, newRowNumber, newColumnNumber, "", gverifyval, varOptional, objName)
    ElseIf LCase(action) = "verifyandcontinue" Then
        rc = VerifyPropertyandcontinue(winObj, "verifyandcontinue", propertyName, actionValue, newRowNumber, newColumnNumber, "", gverifyval, varOptional, objName)
    ElseIf LCase(action) = "clickonwebtablecell" Then
        screenObject.object.rows(cint(newRowNumber)-1).cells(cint(newColumnNumber)-1).click
    ElseIf LCase(action) = "dblclickonwebtablecell" Then
         screenobject.WebElement("innertext:="&actionvalue).fireevent "ondblClick"
    Else
        rc = PerformAction(winObj, action, actionValue, errObject,"" ,varOptional, columnNumber,objName, gverifyval)
    End If
    gverifyval=False
    If rc = Fail Then
        PerformActionOnWebtable = Fail
    Else
        PerformActionOnWebtable = Pass
    End If
End If
End Function
'--------------------------------------------------------------------------------------------
'--------------------------------------------------------------------------------------------
'Function Name: Public Function GetRowOrColumnNumber(ByVal screenObject, ByVal searchValue, ByVal searchType,Byval verifyFlag)
'
'Description:get the row and column number based on columnname and row value
'
'Arguments: None
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function GetRowOrColumnNumber(ByVal screenObject, ByVal searchValue, ByVal searchType,Byval verifyFlag)
On Error Resume Next
Dim newRowNumber, newColumnNumber, startIteration, colFound, splitIteration, rowiteration, coliteration, colCount, splitRowValue,tableValue
colFound = False
If Trim(searchValue) <> "" then
     searchValue = GetColumnValues(searchValue)
End If
If Trim(searchValue) = "" Or Trim(LCase(searchValue)) = "first" Then
    GetRowOrColumnNumber = 1
    Exit Function
End If
If Trim(LCase(searchValue)) = "Last" Then
    If LCase(searchType) = "row" Then
        GetRowOrColumnNumber = screenObject.rowCount
        Exit Function
    Else
        GetRowOrColumnNumber = screenObject.columnCount(1)
        Exit Function
    End If
End If
For rowiteration = 1 To screenObject.rowCount
    startIteration = 0
    colCount = screenObject.columnCount(rowiteration)
    splitRowValue = Split(searchValue, ";")
    For splitIteration = startIteration To UBound(splitRowValue)
        For coliteration = 1 To colCount
         If LCase(searchType) = "row" Then
             If screenObject.childitemcount(rowiteration, coliteration, "Webedit") > 0 Then
                 Set winObj = screenObject.childitem(rowiteration, coliteration, "Webedit", 0)
                 tableValue=winObj.Getroproperty("text")
             ElseIf screenObject.childitemcount(rowiteration, coliteration, "Weblist") > 0 Then
                 Set winObj = screenObject.childitem(rowiteration, coliteration, "Weblist", 0)
                 tableValue=winObj.Getroproperty("text")
             Else
                 tableValue=Trim(screenObject.getcelldata(rowiteration, coliteration))
             End if
         Else
             tableValue=trim(screenObject.getcelldata(rowiteration, coliteration))
         End if
          If VerifyFlag="False" Then
                If StrComp(tableValue, GetColumnValues(splitRowValue(startIteration)), 1) = 0 Then
                    If startIteration = UBound(splitRowValue) Then
                        colFound = True
                        If LCase(searchType) = "row" Then
                            GetRowOrColumnNumber = rowiteration
                        Else
                            GetRowOrColumnNumber = coliteration
                        End If
                        Exit For
                    End If
                    startIteration = startIteration + 1
                End If
          Else
                If Instr(1,tableValue, GetColumnValues(splitRowValue(startIteration)), 1) > 0 Then
                    If startIteration = UBound(splitRowValue) Then
                        colFound = True
                        If LCase(searchType) = "row" Then
                            GetRowOrColumnNumber = rowiteration
                        Else
                            GetRowOrColumnNumber = coliteration
                        End If
                        Exit For
                    End If
                    startIteration = startIteration + 1
                End If
          End If
        Next
        If coliteration >= colCount Or colFound = True Then Exit For
    Next
    If colFound = True Then Exit For
Next
If colFound = False Then
    GetRowOrColumnNumber = "Fail"
End If
End Function
'--------------------------------------------------------------------------------------------
'--------------------------------------------------------------------------------------------
'Function Name: Public Function getChilditemIndex(ByVal tableObject, ByVal rowNumber, ByVal columnNumber, ByVal className, ByVal actionValue)
'
'Description:get the row and column number based on columnname and row value
'
'Arguments: None
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function getChilditemIndex(ByVal tableObject, ByVal rowNumber, ByVal columnNumber, ByVal className, ByVal actionValue)
   On Error Resume Next
   Dim rowIteration, winobj, propertyName, objectFound
   objectFound = False
   If tableObject.childitemcount(rowNumber, columnNumber, className) > 1 Then
         If actionValue<>"" then actionValue=getColumnValues(actionValue)
         If actionValue=fail Then
             getChilditemIndex = "0"
             Exit Function
         End If
        For rowIteration = 0 To tableObject.childitemcount(rowNumber, columnNumber, className) - 1
            Set winobj = tableObject.childitem(rowNumber, columnNumber, className, rowIteration)
            Select Case LCase(className)
                Case "webbutton"
                    propertyName = "name"
                Case "webelement"
                    propertyName = "innertext"
                Case Else
                    propertyName = "text"
            End Select
            If StrComp(winobj.GetROProperty(propertyName), actionValue, 1) = 0 Then
                getChilditemIndex = rowIteration
                objectFound = True
                Exit For
            End If
        Next
    Else
        getChilditemIndex = "0"
        objectFound = True
    End If
    If Err.Number <> 0 Or objectFound = False Then
        getChilditemIndex = False
    End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: SelectJavamenu(ByVal screenobject, ByVal actionValue)
'
'Description:This function perform action on java menu objects
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           actionValue-Value to be entered or select on the application
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function SelectJavamenu(ByVal screenobject, ByVal actionValue)
   On Error Resume Next
   Dim rowiteration, menuObject, newActionValue
If actionValue<>"" then actionValue=getColumnValues(actionValue)
If actionValue = Fail Then
SelectJavamenu = Fail
Exit Function
End If
   If actionValue = "" Then
        SelectJavamenu = Fail
        Exit Function
   End If
    newActionValue = Split(actionVale, ";")
    For rowiteration = 0 To UBound(newActionValue)
        If rowiteration = 0 Then
            Set menuObject = screenobject.Javamenu("label:=" & newActionValue(rowiteration))
        Else
            Set menuObject = menuObject.Javamenu("label:=" & newActionValue(rowiteration))
        End If
    Next
        menuObject.Select
        If Err.Number <> 0 Then
            SelectJavamenu = Fail
            gErrDescription = Err.Description
        Else
            SelectJavamenu = Pass
        End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: WaitForObject(ByVal screenObject, ByVal propertyName, ByVal propertyValue)
'
'Description:This function perform wait operation on objects
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           PropertyName-Name of property to wait
'           PropertyValue-value of property to wait
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function WaitForObject(ByVal screenObject, ByVal propertyName, ByVal propertyValue)
    On Error Resume Next
    Dim waitFlag
    waitFlag = False
    If propertyValue<>"" then propertyValue=getColumnValues(propertyValue)
    If propertyValue = Fail Then
  WaitForObject = Fail
  Exit Function
 End If
 Wait (2)
    Select Case LCase(PropertyName)
     Case "text", "value", "innertext", "regexpwndtitle"
        PropertyValue =".*"&propertyValue&".*"
        waitFlag = screenObject.WaitProperty(PropertyName, micRegExpMatch(PropertyValue), gsynctime)
     Case "items count", "cols", "rows"
        waitFlag = screenObject.WaitProperty(propertyName, micGreaterThan(CInt(propertyValue)), gsynctime)
     Case "all items"
        PropertyValue =".*"&propertyValue&".*"
        waitFlag = screenObject.WaitProperty(PropertyName, micRegExpMatch(PropertyValue), gsynctime)
     Case "exist"
        waitFlag = screenObject.Exist(gsynctime)
        If LCase(CStr(waitFlag)) <> LCase(CStr(PropertyValue)) Then
         waitFlag = False
        Else
         waitFlag = True
        End If
     Case Else
        waitFlag = screenObject.WaitProperty(PropertyName, PropertyValue, gsynctime)
    End Select
    gsynctime=30000
    If waitFlag = False Or Err.Number <> 0 Then
        WaitForObject = Fail
        Reportstep "Wait for  <b>" & screenobject.tostring & "</b> to load", "Wait for  <b>" & screenobject.tostring & "</b> to load should be successful", "Wait for  <b>" & screenobject.tostring & "</b> to load failed due to " & Err.Description, fail
    Else
        WaitForObject = pass
        Reportstep "Wait for  <b>" & screenobject.tostring & "</b> to load", "Wait for  <b>" & screenobject.tostring & "</b> to load should be successful", "Wait for  <b>" & screenobject.tostring & "</b> to load is successful",pass
    End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: PerformSaveOrCloseOperation(screenobject, action, objName, OptionValue, indexValue, errObject)
'
'Description:This function perform save or close operation on objects
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           action-Action to be performed on object
'           indexValue-Index value for the object in application
'           optionValue-whether the object is optional or not-holds value optional
'           errObject-Holds the error object if any
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function PerformSaveOrCloseOperation(screenobject, action, objName, OptionValue, indexValue, errObject)
On Error Resume Next
Dim rc
If indexValue <> "" Then ScreenObject.SetTOProperty "index", indexValue
    rc = AutoWaitForObject(ScreenObject)
    If rc = Fail And LCase(optionValue) = "optional" Then
        PerformSaveOrCloseOperation = Pass
        Exit Function
    End If
Select Case LCase(action)
Case "close"
    Select Case LCase(screenobject.GetTOProperty("micclass"))
        Case "oracleformwindow", "oraclenavigator"
            screenobject.closeform
        Case "oracleapplications"
            screenobject.Exit
        Case Else
            screenobject.Close
    End Select
Case "save"
    screenobject.Save
Case "submit"
    screenobject.submit
Case "approve"
    screenobject.approve
Case "cancel"
    screenobject.cancel
End Select
If Err.Number <> 0 Then
    If Err.Description = "" Then Err.Description = gErrDescription
    PerformSaveOrCloseOperation = Fail
    CaptureScreenshot
    Reportstep "Perform "&action &" operation on " & objName , "Perform "&action &" operation on " & objName & " should be successful","Perform "&action &" operation on " &ObjName &" failed due to "&Err.description,fail
    Err.Clear
Else
    PerformSaveOrCloseOperation = Pass
    Reportstep "Perform "&action &" operation on " & objName , "Perform "&action &" operation on " & objName & " should be successful","Perform "&action &" operation on " &ObjName &" is successful ",pass
    If IsObject(errObject) = True Then
        errValue = HandleErrorObjects(errObject)
        If errValue = Fail Then
            PerformSaveOrCloseOperation = Fail
            CaptureScreenshot
            Reportstep "Perform "&action &" operation on " & objName , "Perform "&action &" operation on " & objName & " should be successful","Perform "&action &" operation on " &ObjName &" is successful",fail
        End If
    End If
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: Public Function HandleErrorObjects(ByVal errObject)
'
'Description:This function is used to handle error objects
'
'Arguments: errObject-Error object to be verified in the screen
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function HandleErrorObjects(ByVal errObject)
   On Error Resume Next
Dim errValue
If errObject.Exist(gExistSyncTime) Then
    Select Case LCase(errObject.GetROProperty("micclass"))
        Case "dialog"
            errValue = errObject.Static("micclass:=static", "index:=2").GetROProperty("text")
        Case "webelement", "webtable", "link"
            If errObject.GetROProperty("X") > 0 Then
                errValue = errObject.GetROProperty("innertext")
            End If
        Case "javamenu"
                errValue = errObject.GetROProperty("value")
        Case "swfCalender", "swfcheckbox", "swfcombobox", "swfedit", "swfeditor", "swflabel", "swflist", "swflistview", "swfobject", "swfradiobutton"
                errValue = errObject.GetErrorProviderText
        Case Else
            errValue = errObject.GetROProperty("text")
    End Select
    If Err.Number <> 0 Then
        HandleErrorObjects = Fail
    Else
        HandleErrorObjects = errValue
        If errValue = "" And LCase(gNegative) = "true" Then
            HandleErrorObjects = Fail
            Err.Clear
        ElseIf errValue <> "" And LCase(gNegative) = "true" Then
            HandleErrorObjects = Pass
        Else
            HandleErrorObjects = Fail
            Err.Clear
        End If
    End If
Else
If LCase(gNegative) = "true" Then
    HandleErrorObjects = Fail
End If
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: Public Function SetTestObjectProperty(ByVal screenObject, ByVal PropertyName, ByVal PropertyValue)
'
'Description:This function is used to set the current property value to test object
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           PropertyName-Property Name for which the value to be set.
'           PropertyValue-Value of the property to be set on propertyName
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function SetTestObjectProperty(ByVal screenObject, ByVal PropertyName, ByVal PropertyValue)
   On Error Resume Next
If propertyValue<>"" then propertyValue=getColumnValues(propertyValue)
If propertyValue = Fail Then
SetTestObjectProperty = Fail
Exit Function
End If
   screenObject.SetTOProperty PropertyName, PropertyValue
   If Err.Number <> 0 Then
        SetTestObjectProperty = Fail
         Reportstep "Perform settoproperty operation on " & screenObject.ToString, "Perform settoproperty operation on " & screenObject.ToString & " should be successful", "perform settoproperty operation on " & screenObject.tosring & " failed due to " & Err.Description, fail
    Else
        SetTestObjectProperty = Pass
         Reportstep "Perform settoproperty operation on " & screenObject.ToString, "Perform settoproperty operation on " & screenObject.ToString & " should be successful", "perform settoproperty operation on " & screenObject.tosring & " is successful", pass
   End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: Public Function AssignValueToVariable(ByVal variableName, ByVal actionValue)
'
'Description:This function is used to set the current value to variable
'
'Arguments: variableName-Name of variable to which value to be assigned
'           actionValue-Value to be set on variable
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function AssignValueToVariable(ByVal variableName, ByVal actionValue)
On Error Resume Next
     Execute CStr(variableName & "=" & Chr(34) & actionValue & Chr(34))
If Err.Number <> 0 Then
    Err.Clear
End If
Reportstep "Assign variable("&variableName&") with value "&actionvalue  ,"Assign variable("&variableName&") with value "&actionvalue &" should be successful","Assign variable("&variableName&") with value "&actionvalue &" is successful",pass
AssignValueToVariable = Pass
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: VerifyPropertyAndContinue(ByVal screenobject, ByVal action, ByVal propertyName, ByVal propertyValue, ByVal rowNumber, ByVal ColumnNumber, ByVal indexValue, ByVal compareType, ByVal OptionValue, ByVal objName)
'
'Description:Perform verify operation on object
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           action-Action to be performed on object
'           propertyValue-Value to be compared against application
'           objName-logical name of the object
'           rowNumber-rownumber of the webtable
'           columnNumber-column number of the webtable
'           indexValue-Index value for the object in application
'           optionValue-whether the object is optional or not-holds value optional
'           compareType-This variable holds value true or false,True which verify using instr function and false will use strcomp function
'           errObject-Holds the error object if any
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution and continue execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function VerifyPropertyAndContinue(ByVal screenobject, ByVal action, ByVal propertyName, ByVal propertyValue, ByVal rowNumber, ByVal ColumnNumber, ByVal indexValue, ByVal compareType, ByVal OptionValue, ByVal objName)
   On Error Resume Next
   Dim compareValue, verifyFlag
   verifyFlag = fail
   If indexValue <> "" Then screenobject.SetTOProperty "index", indexValue
   If propertyValue<>"" then propertyValue=getColumnValues(propertyValue)
If propertyValue = Fail Then
VerifyPropertyAndContinue = Fail
Exit Function
End If
If Lcase(propertyName)<>"exist" then
 rc = AutoWaitForObject(screenobject)
 If rc = Fail And LCase(OptionValue) = "optional" Then
     VerifyPropertyAndContinue = Pass
     Reportstep "Perform verify operation on <b>" & objName & "</b> object with value " & actionValue, "Perform verify operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform verify operation on <b>" &ObjName &"</b> object with value "&actionvalue &" passed due to step is optional",pass
     Exit Function
 Elseif rc=pass And Lcase(optionValue)="optional" then
     rc=VerifyOptionValue( ScreenObject)
     If rc=fail Then
         VerifyPropertyAndContinue = Pass
         Reportstep "Perform verify operation on <b>" & objName & "</b> object with value " & actionValue, "Perform verify operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform verify operation on <b>" &ObjName &"</b> object with value "&actionvalue &" passed due to step is optional",pass
         Exit Function
      End If
 Elseif rc=Fail And Lcase(optionValue)<>"optional" then
     VerifyPropertyAndContinue = Fail
     Reportstep "Perform verify operation on <b>" & objName & "</b> object with value " & actionValue, "Perform verify operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform verify operation on <b>" &ObjName &"</b> object with value "&actionvalue &" failed due to object not found",fail
     Exit Function
 End If
End If
       Select Case LCase(propertyName)
        Case "text"
                Select Case LCase(screenobject.GetTOProperty("micclass"))
                    Case "webedit", "webbutton", "oracletextfield"
                        compareValue = screenobject.GetROProperty("value")
                    Case "link", "webelement"
                        compareValue = screenobject.GetROProperty("innertext")
                        gText = compareValue
                    Case "webtable"
                        compareValue = Trim(screenobject.getcelldata(rowNumber, ColumnNumber))
                    Case "browser", "page"
                        compareValue = screenobject.GetROProperty("title")
                    Case "tefield"
                        compareValue = screenobject.Text
                    Case Else
                        compareValue = screenobject.GetROProperty("text")
                End Select
        Case "enabled"
                Select Case LCase(screenobject.GetTOProperty("micclass"))
                    Case "webedit", "webbutton", "webelement", "image", "webcheckbox", "webradiobutton"
                        compareValue = screenobject.GetROProperty("disabled")
                            If compareValue = 0 Then
                                compareValue = True
                            Else
                                compareValue = False
                            End If
                    Case Else
                        compareValue = screenobject.GetROProperty("Enabled")
                End Select
        Case "checked"
                Select Case LCase(screenobject.GetTOProperty("micclass"))
                    Case "webcheckbox"
                        compareValue = CBool(screenobject.GetROProperty("checked"))
                    Case "javacheckbox"
                        compareValue = screenobject.GetROProperty("value")
                    Case "flexcheckbox"
                        compareValue = screenobject.GetROProperty("selected")
                    Case Else
                        compareValue = screenobject.GetROProperty("checked")
                End Select
        Case "exist"
                compareValue = screenobject.Exist(gExistSyncTime)
        Case Else
                compareValue = screenobject.GetROProperty(propertyName)
        End Select
        If compareType = True Then
            If InStr(1, compareValue, propertyValue, 1) > 0 Then
                verifyFlag = pass
                gVerify = compareValue
            End If
        Else
            If StrComp(compareValue, propertyValue, 1) = 0 Then
                verifyFlag = pass
                gVerify = compareValue
            End If
        End If
    If Err.Number <> 0 Or verifyFlag = fail Then
        If lcase(gNegative) ="false" Then
            VerifyPropertyAndContinue = pass
            gverifyContinue = Fail
            If IsEmpty(compareValue) = True Then compareValue = Err.Description
            Reportstep "Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value " & propertyValue, "Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value <b>" & propertyValue &"</b> should be successful","Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value <b>" & propertyValue &"</b> failed due to Expected:"&propertyvalue &" <> Actual: "&comparevalue,fail
        Else
            VerifyPropertyAndContinue = pass
            Reportstep "Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value " & propertyValue, "Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value <b>" & propertyValue &"</b> should be successful","Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value <b>" & propertyValue &"</b> passed due to negative flag is true Expected:"&propertyvalue &" = Actual: "&comparevalue,pass
        End If
    Else
        VerifyPropertyAndContinue = pass
        Reportstep "Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value " & propertyValue, "Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value <b>" & propertyValue &"</b> should be successful","Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value <b>" & propertyValue &"</b> passed Expected:"&propertyvalue &" = Actual: "&comparevalue,pass
    End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: FireEventOnObject(ByVal Screenobject, ByVal eventName)
'
'Description:This function trigger the respective event on object
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           eventName-Event to be triggered on object
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function FireEventOnObject(ByVal Screenobject, ByVal eventName)
   On Error Resume Next
   Dim rc
   rc = AutoWaitForObject(Screenobject)
   If rc = Fail Then
        FireEventOnObject = Fail
        Exit Function
   End If
   If LCase(eventName) = "mouse" Then
        Setting.WebPackage("ReplayType") = 2
        geventTriggered = True
    Else
         Screenobject.fireevent eventName
    End if
    FireEventOnObject = Pass
         Reportstep "Perform fireevent operation on " & screenObject.ToString, "Perform fireevent operation on " & screenObject.ToString & " should be successful", "perform fireevent operation on " & screenObject.tosring & " is successful", pass
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: VerifyOptionValue(ByVal ScreenObject)
'
'Description:This function verify whether the object is visible
'
'Arguments: Screenobject-Object for which the respective action to be performed
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function VerifyOptionValue(ByVal ScreenObject)
If ScreenObject.Exist(0) Then
    If ScreenObject.GetROProperty("x") > 0 Then
        VerifyOptionValue = pass
    Else
    VerifyOptionValue = fail
    End If
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: clickOrSelectOnTabValue(ByVal Screenobject, ByVal actionValue, ByVal Action, ByVal objName, ByVal verifyFlag)
'
'Description:This function perform action on Tab objects
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           action-Action to be performed on object
'           actionValue-Value to be entered or select on the application
'           verifyflag-This variable holds value true or false,True which verify using instr function and false will use strcomp function
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function clickOrSelectOnTabValue(ByVal Screenobject, ByVal actionValue, ByVal Action, ByVal objName, ByVal verifyFlag)
   On Error Resume Next
   Dim rowIteration, RowsCount, valueFound, itemValue, searchValue
   valueFound = False
   If actionValue = "" Then
        searchValue = objName
    Else
        searchValue = actionValue
   End If
   If IsNumeric(searchValue) Then
        If LCase(Screenobject.GetTOProperty("micclass")) = "javatab" Or LCase(Screenobject.GetTOProperty("micclass")) = "sapguitabstrip" Or LCase(Screenobject.GetTOProperty("micclass")) = "saptabstrip" Then
            rowIteration = "#" & searchValue
        Else
            rowIteration = CInt(searchValue)
        End If
       valueFound = True
    Else
        If LCase(Screenobject.GetTOProperty("micclass")) <> "javatab" Or LCase(Screenobject.GetTOProperty("micclass")) <> "sapguitabstrip" Or LCase(Screenobject.GetTOProperty("micclass")) <> "saptabstrip" Or LCase(Screenobject.GetTOProperty("micclass")) <> "sbltabstrip" Then
            For rowIteration = 0 To Screenobject.GetItemsCount - 1
               itemValue = Replace(Trim(Screenobject.getitem(rowIteration)), "&", "")
               If verifyFlag = "True" Then
                    If InStr(1, itemValue, searchValue, 1) > 0 Then
                        valueFound = True
                        Exit For
                    End If
                Else
                   If StrComp(itemValue, searchValue, 1) = 0 Then
                        valueFound = True
                        Exit For
                   End If
               End If
             Next
        Else
            valueFound = True
        End If
   End If
   If valueFound = True Then
        Select Case LCase(Action)
            Case "select"
                If LCase(Screenobject.GetTOProperty("micclass")) = "javatab" Or LCase(Screenobject.GetTOProperty("micclass")) = "sapguitabstrip" Then
                    Screenobject.Select searchValue
                Else
                    Screenobject.Select rowIteration
                End If
        End Select
   End If
   If Err.Number <> 0 Or valueFound = False Then
        clickOrSelectOnTabValue = Fail
        If valueFound = False And Err.Description = "" Then
         gErrDescription = "Value not Found."
        Else
         gErrDescription = Err.Description
        End If
    Else
        clickOrSelectOnTabValue = Pass
   End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'--------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: SelectOrActivateListViewValues(ByVal ScreenObject, ByVal columnName, ByVal ActionValue, ByVal Action, ByVal verifyFlag)
'
'Description:This function perform action on list view objects
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           action-Action to be performed on object
'           actionValue-Value to be entered or select on the application
'           columnName-column name of the listview
'           verifyflag-This variable holds value true or false,True which verify using instr function and false will use strcomp function
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function SelectOrActivateListViewValues(ByVal ScreenObject, ByVal columnName, ByVal ActionValue, ByVal Action, ByVal verifyFlag)
   On Error Resume Next
   Dim rowIteration, objColHeader, columnIteration, columnCount, columnStart, className, ValueFound, currentColumn, columnFound, ActionValues, actionValueIteration, columnNames, columarrayIteration
   columnFound = False
   ActionValues = Split(ActionValue, ";")
   columnNames = Split(columnName, ";")
   className = LCase(ScreenObject.GetROProperty("micclass"))
   If className = "vblistview" Then
        Set objColHeader = ScreenObject.Object.columnHeaders
        columnCount = objColHeader.Count
        columnStart = 1
    Else
        columnCount = ScreenObject.columnCount
        columnStart = 0
   End If
   For columarrayIteration = 0 To UBound(columnNames)
       columnFound = False
       For columnIteration = columnStart To columnCount
           If className = "vblistview" Then
                If StrComp(objColHeader(columnIteration), columnName(columarrayIteration), 1) = 0 Then
                    columnFound = True
                    currentColumn = columnIteration - 1
                    Exit For
                End If
            Else
                If StrComp(ScreenObject.GetColumnHeader(columnIteration), columnName, 1) = 0 Then
                    columnFound = True
                    currentColumn = columnIteration
                    Exit For
                End If
            End If
       Next
       If columnFound = False Then Exit For
   Next
    If columnFound = True Then
        For rowIteration = 0 To ScreenObject.GetItemsCount - 1
            If StrComp(ScreenObject.getsubItem(rowIteration, columnNames(UBound(columnNames))), ActionValues(UBound(ActionValues)), 1) = 0 Then
                If UBound(ActionValues) > 0 Then
                    For actionValueIteration = 0 To UBound(ActionValues) - 1
                        If StrComp(ScreenObject.getsubItem(rowIteration, columnNames(actionValueIteration)), ActionValues(actionValueIteration), 1) <> 0 Then
                            ValueFound = False
                            Exit For
                        End If
                        ValueFound = True
                    Next
                Else
                    ValueFound = True
                End If
            End If
        Next
    End If
    If ValueFound = True Then
        Select Case LCase(Action)
            Case "select"
                ScreenObject.Select rowIteration
            Case "activate"
                ScreenObject.Activate rowIteration
            Case "setitemstate"
                ScreenObject.SetItemState rowIteration,micChecked
        End Select
    End If
    If Err.Number <> 0 Or ValueFound = False Or columnFound = False Then
        SelectOrActivateListViewValues = Fail
        If valueFound = False And Err.Description = "" Then
         gErrDescription = "Value not Found."
        ElseIf columnFound = False And Err.Description =""  Then
         gErrDescription = "Column not Found."
        Else
         gErrDescription = Err.Description
        End If
    Else
        SelectOrActivateListViewValues = Pass
    End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: ClickOnToolBarObject(ByVal Screenobject, ByVal actionValue, ByVal objName, ByVal verifyFlag)
'
'Description:Perform click operation on toolbar object
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           actionValue-Value to be entered or select on the application
'           compareType-This variable holds value true or false,True which verify using instr function and false will use strcomp function
'           objName-logical name of the object
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function ClickOnToolBarObject(ByVal Screenobject, ByVal actionValue, ByVal objName, ByVal verifyFlag)
On Error Resume Next
Dim rowIteration, ValueFound, itemValue, newActionValue, arrayIteration, newContextMenuValue
If actionValue = "" Then
    ValueFound = False
    For rowIteration = 1 To Screenobject.GetItemsCount
            itemValue = Replace(Trim(Screenobject.getitem(rowIteration)), "&", "")
            If verifyFlag = True Then
                If InStr(1, itemValue, objName, 1) > 0 Then
                    ValueFound = True
                    Exit For
                End If
                Else
                If StrComp(itemValue, objName, 1) = 0 Then
                    ValueFound = True
                    Exit For
                End If
            End If
    Next
    If ValueFound = True Then
        Screenobject.press rowIteration
    End If
Else
    newActionValue = Split(actionValue, ";")
    If UBound(newActionValue) > 0 Then
        For arrayIteration = 1 To UBound(newActionValue)
            If arrayIteration = 1 Then
                If IsNumeric(newActionValue(arrayIteration)) Then
                    newContextMenuValue = "<Item " & newActionValue(arrayIteration) & ">"
                Else
                    newContextMenuValue = newActionValue(arrayIteration)
                End If
            Else
                If IsNumeric(newActionValue(arrayIteration)) Then
                    newContextMenuValue = newContextMenuValue & ";" & "<Item " & newActionValue(arrayIteration) & ">"
                Else
                    newContextMenuValue = newContextMenuValue & ";" & newActionValue(arrayIteration)
                End If
            End If
        Next
    End If
    ValueFound = False
    If IsNumeric(newActionValue(0)) = True Then
        If CInt(newActionValue(0)) <= Screenobject.GetItemsCount Then
            ValueFound = True
            rowIteration = CInt(newActionValue(0))
        End If
    Else
        For rowIteration = 1 To Screenobject.GetItemsCount
            itemValue = Replace(Trim(Screenobject.getitem(rowIteration)), "&", "")
            If StrComp(itemValue, newActionValue(0), 1) = 0 Then
                ValueFound = True
                Exit For
            End If
        Next
    End If
If ValueFound = True Then
    If UBound(newActionValue) > 0 Then
        Screenobject.ShowDropdown rowIteration
        Wait 1
        Screenobject.GetTOProperty("Parent").winmenu("menuobjtype:=3").Select newContextMenuValue
    Else
        Screenobject.press rowIteration
    End If
End If
End If
If Err.Number <> 0 Or ValueFound = False Then
 If Err.Description <> "" Then
   gErrDescription = Err.Description
 Else
   gErrDescription = "Value not found"
 End If
    ClickOnToolBarObject = Fail
Else
    ClickOnToolBarObject = Pass
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: ListSelect(ByVal screenobject, ByVal actionValue, ByVal verifyFlag)
'
'Description:Perform select operation on object
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           actionValue-Value to be entered or select on the application
'           compareType-This variable holds value true or false,True which verify using instr function and false will use strcomp function
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function ListSelect(ByVal screenobject, ByVal actionValue, ByVal verifyFlag)
On Error Resume Next
Dim SelectionFlag, ListCount, CountVal, valCount, rowIteration, countStart, className
countStart = 0
className = LCase(screenobject.GetTOProperty("micclass"))
If className = "weblist" Then countStart = 1
valCount = Split(actionValue, ";")
For rowIteration = 0 To UBound(valCount)
    SelectionFlag = False
     ListCount = screenobject.GetROProperty("items count")
     If Classname = "weblist" Then
         ListCount = ListCount
     Else
         ListCount = ListCount - 1
     End If
     For CountVal = countStart To ListCount
         If verifyFlag = "True" Then
             If InStr(1, Trim(screenobject.GetItem(CountVal)), Trim(valCount(rowIteration)), 1) > 0 Then
                 SelectionFlag = True
                Exit For
             End If
        Else
            If StrComp(Trim(screenobject.GetItem(CountVal)), Trim(valCount(rowIteration)), 1) = 0 Then
                SelectionFlag = True
                Exit For
            End If
         End If
    Next
    If SelectionFlag = True Then
        If rowIteration = 0 Then
            If className = "weblist" Then
                screenobject.Select CountVal - 1
            Else
                screenobject.Select CountVal
            End If
        Else
            If className = "weblist" Then
                screenobject.ExtendSelect CountVal - 1
            Else
                screenobject.ExtendSelect CountVal
            End If
        End If
    End If
Next
If Err.Number <> 0 Or SelectionFlag = False Then
    If Err.Description = "" Then
        gErrDescription = "value not found"
    Else
        gErrDescription = Err.Description
    End If
    ListSelect = Fail
Else
    ListSelect = Pass
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: performOperationOnObject(winobj, vAction, actionValue, rowNumber, columnNumber, indexValue, propertyName, ErrObject, objName, className,varOptional, verifyFlag)
'
'Description:Perform general operation on object
'
'Arguments: Screenobject-Object for which the respective action to be performed
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function performOperationOnObject(Byval winobj, Byval vAction, Byval actionValue, Byval rowNumber, Byval columnNumber, Byval indexValue, Byval propertyName, Byval ErrObject, Byval objName, Byval className,Byval varOptional, Byval verifyFlag)
On Error Resume Next
Dim rc
Select Case LCase(vAction)
            Case "capture"
                captureScreenshot
                Reportstep "Capture screenshot fo the current window", "Capture screenshot of current window should be successful", "Capture screenshot of current window is successful", pass
            Case "capture2word"
                capturewordscreenshot
            Case "openapp"
                rc=OpenApplication
            Case "assignvalue"
                 rc = AssignValueToVariable(PropertyName, actionValue)
            Case "concatvalue"
                 rc = ConcatValues(actionValue)
            Case "splitvalue"
                 rc = SplitValues(actionValue)
            Case "replacevalue"
                 rc = ReplaceValues(actionValue)
            Case "getpartvalue"
                 rc = GetPartvalue(actionValue)
            Case "fireevent"
                 rc = FireEventOnObject(winobj, actionValue)
            Case "sendkeys"
                 SendKeys(actionValue)
            Case "verifyandcontinue"
                 rc = VerifyPropertyandcontinue(winObj, vAction, propertyName, actionValue, rowNumber, columnNumber, indexValue, verifyFlag, varOptional, objName)
            Case "wait"
                 rc = WaitForObject(winobj, PropertyName, actionValue)
            Case "setprop"
                  rc = SetTestObjectProperty(winobj, PropertyName, actionValue)
            Case "assignvalue"
                  rc = AssignValueToVariable(PropertyName, actionValue)
            Case Else
              Select Case LCase(winobj.GetTOProperty("micclass"))
                  Case "webtable"
                    rc = PerformActionOnWebtable(winobj, vAction, actionValue, rowNumber, columnNumber, indexValue, propertyName, ErrObject, objName, className,verifyFlag,varOptional)
                  Case Else
                    Select Case LCase(vAction)
                        Case "set", "click", "activate", "dblclick", "selectbyindex", "select", "check", "type", "press", "save", "close", "submit", "approve", "cancel", "setitemstate"
                            rc = PerformAction(winObj, vAction, actionValue, ErrObject, indexValue, varOptional, columnNumber, objName, verifyFlag)
                        Case "verify"
                            rc = VerifyProperty(winObj, vAction, propertyName, actionValue, rowNumber, columnNumber, indexValue, verifyFlag, varOptional, objName)
                        Case "get"
                            rc = GetObjectValue(winObj, actionValue, propertyName, rowNumber, columnNumber, indexValue, varOptional)
                        Case Else
                             ReportStep "Perform " & vAction & " operation on " & winObj.ToString,"perform " & vAction & " operation on " & winObj.ToString &" should be successful","perform " & vAction & " operation on " & winObj.ToString &" failed due to invalid action type."
                            performOperationOnObject=Fail
                     End Select
                End Select
              End Select
If Err.Number <> 0 Or rc = fail Then
    performOperationOnObject= fail
    Err.Clear
Else
    performOperationOnObject= pass
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: VerifyProperty(ByVal screenobject, ByVal action, ByVal propertyName, ByVal propertyValue, ByVal rowNumber, ByVal ColumnNumber, ByVal indexValue, ByVal compareType, ByVal OptionValue, ByVal objName)
'
'Description:Perform verify operation on object
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           action-Action to be performed on object
'           propertyValue-Value to be compared against application
'           objName-logical name of the object
'           rowNumber-rownumber of the webtable
'           columnNumber-column number of the webtable
'           indexValue-Index value for the object in application
'           optionValue-whether the object is optional or not-holds value optional
'           compareType-This variable holds value true or false,True which verify using instr function and false will use strcomp function
'           errObject-Holds the error object if any
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'----------------------------------------------------------------------------------------------------------------------------------------------
Public Function VerifyProperty(ByVal screenobject, ByVal action, ByVal propertyName, ByVal propertyValue, ByVal rowNumber, ByVal ColumnNumber, ByVal indexValue, ByVal compareType, ByVal OptionValue, ByVal objName)
   On Error Resume Next
   Dim compareValue, verifyFlag
   verifyFlag = fail
   If indexValue <> "" Then screenobject.SetTOProperty "index", indexValue
   If propertyValue<>"" then propertyValue=getColumnValues(propertyValue)
If propertyValue = Fail Then
VerifyProperty = Fail
Exit Function
End If
If Lcase(propertyName)<>"exist" then
 rc = AutoWaitForObject(screenobject)
 If rc = Fail And LCase(OptionValue) = "optional" Then
     VerifyProperty = Pass
     Reportstep "Perform verify operation on <b>" & objName & "</b> object with value " & actionValue, "Perform verify operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform verify operation on <b>" &ObjName &"</b> object with value "&actionvalue &" passed due to step is optional",pass
     Exit Function
 Elseif rc=pass And Lcase(optionValue)="optional" then
     rc=VerifyOptionValue( ScreenObject)
     If rc=fail Then
         VerifyProperty = Pass
         Reportstep "Perform verify operation on <b>" & objName & "</b> object with value " & actionValue, "Perform verify operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform verify operation on <b>" &ObjName &"</b> object with value "&actionvalue &" passed due to step is optional",pass
         Exit Function
     End If
 Elseif rc=Fail And Lcase(optionValue)<>"optional" then
     VerifyProperty = Fail
     Reportstep "Perform verify operation on <b>" & objName & "</b> object with value " & actionValue, "Perform verify operation on <b>" & objName & "</b> object with value "&actionvalue &" should be successful","Perform verify operation on <b>" &ObjName &"</b> object with value "&actionvalue &" failed due to object not found",fail
     Exit Function
 End If
End If
       Select Case LCase(propertyName)
        Case "text"
                Select Case LCase(screenobject.GetTOProperty("micclass"))
                    Case "webedit", "webbutton", "oracletextfield"
                        compareValue = screenobject.GetROProperty("value")
                        gText = compareValue
                    Case "link", "webelement"
                        compareValue = screenobject.GetROProperty("innertext")
                        gText = compareValue
                    Case "webtable"
                        compareValue = Trim(screenobject.getcelldata(rowNumber, ColumnNumber))
                        gText = compareValue
                    Case "browser", "page"
                        compareValue = screenobject.GetROProperty("title")
                        gText = compareValue
                    Case "tefield"
                        compareValue = screenobject.Text
                        gText = compareValue
                    Case Else
                        compareValue = screenobject.GetROProperty("text")
                        gText = compareValue
                End Select
        Case "enabled"
                Select Case LCase(screenobject.GetTOProperty("micclass"))
                    Case "webedit", "webbutton", "webelement", "image", "webcheckbox", "webradiobutton"
                        compareValue = screenobject.GetROProperty("disabled")
                        gEnable = compareValue
                            If compareValue = 0 Then
                                compareValue = True
                            Else
                                compareValue = False
                            End If
                    Case Else
                        compareValue = screenobject.GetROProperty("Enabled")
                        gEnable = compareValue
                End Select
        Case "checked"
                Select Case LCase(screenobject.GetTOProperty("micclass"))
                    Case "webcheckbox"
                        compareValue = CBool(screenobject.GetROProperty("checked"))
                        gCheck = compareValue
                    Case "javacheckbox"
                        compareValue = screenobject.GetROProperty("value")
                        gCheck = compareValue
                    Case "flexcheckbox"
                        compareValue = screenobject.GetROProperty("selected")
                        gCheck = compareValue
                    Case Else
                        compareValue = screenobject.GetROProperty("checked")
                        gCheck = compareValue
                End Select
        Case "exist"
                compareValue = screenobject.Exist(gExistSyncTime)
                gExist = compareValue
        Case "value"
             Select Case Lcase(Screenobject.gettoproperty("micclass"))
                 Case "weblist", "vblist", "swflist", "pblist", "winlist", "wpflist", "slvlist", "wincombobox"
                     verifyFlag = VerifyListValue(ScreenObject, PropertyValue, compareType)
                     Err.Description = gErrDescription
                     compareValue = gCompare
             End Select
        Case Else
                compareValue = screenobject.GetROProperty(propertyName)
                gCompare = compareValue
        End Select
       If LCase(propertyName) <> "value" Then
        If compareType = True Then
            If InStr(1, compareValue, propertyValue, 1) > 0 Then
                verifyFlag = pass
                gVerify = compareValue
            End If
        Else
            If StrComp(compareValue, propertyValue, 1) = 0 Then
                verifyFlag = pass
                gVerify = compareValue
            End If
        End If
       End If
    If Err.Number <> 0 Or verifyFlag = fail Then
        If lcase(gNegative) = "false" Then
            VerifyProperty = fail
            If IsEmpty(compareValue) = True Then compareValue = Err.Description
            Reportstep "Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value " & propertyValue, "Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value <b>" & propertyValue &"</b> should be successful","Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value <b>" & propertyValue &"</b> failed due to Expected:"&propertyvalue &" <> Actual: "&comparevalue,fail
        Else
            VerifyProperty = pass
            Reportstep "Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value " & propertyValue, "Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value <b>" & propertyValue &"</b> should be successful","Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value <b>" & propertyValue &"</b> passed due to negative flag is true Expected:"&propertyvalue &" = Actual: "&comparevalue,pass
        End If
    Else
        VerifyProperty = pass
        Reportstep "Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value " & propertyValue, "Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value <b>" & propertyValue &"</b> should be successful","Perform verify operation on <b>" & objName & "</b> for <b>" &propertyName &"</b> with value <b>" & propertyValue &"</b> passed Expected:"&propertyvalue &" = Actual: "&comparevalue,pass
    End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: VerifyListValue(ByVal screenobject, ByVal actionValue, ByVal verifyFlag)
'
'Description:verify list value is available in the object
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           actionValue-Value to be entered or select on the application
'           compareType-This variable holds value true or false,True which verify using instr function and false will use strcomp function
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function VerifyListValue(ByVal screenobject, ByVal actionValue, ByVal verifyFlag)
On Error Resume Next
Dim SelectionFlag, ListCount, CountVal, valCount, rowIteration, countStart, className
countStart = 0
className = LCase(screenobject.GetTOProperty("micclass"))
If className = "weblist" Then countStart = 1
valCount = Split(actionValue, ";")
For rowIteration = 0 To UBound(valCount)
    SelectionFlag = False
     ListCount = screenobject.GetROProperty("items count")
     If Classname = "weblist" Then
         ListCount = ListCount
     Else
         ListCount = ListCount - 1
     End If
     For CountVal = countStart To ListCount
         If verifyFlag = "True" Then
             If InStr(1, Trim(screenobject.GetItem(CountVal)), Trim(valCount(rowIteration)), 1) > 0 Then
                 SelectionFlag = True
                Exit For
             End If
        Else
            If StrComp(Trim(screenobject.GetItem(CountVal)), Trim(valCount(rowIteration)), 1) = 0 Then
                SelectionFlag = True
                Exit For
            End If
         End If
    Next
Next
If Err.Number <> 0 Or SelectionFlag = False Then
    If Err.Description = "" Then
        gErrDescription = "value not found"
    Else
        gErrDescription = Err.Description
    End If
    VerifyListValue= Fail
Else
    VerifyListValue= Pass
    gErrDescription = ""
    gCompare = Trim(ScreenObject.GetItem(CountVal))
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: WebTableCellClick(ByVal screenobject, ByVal actionValue, ByVal verifyFlag)
'
'Description:Perform click operation on object
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           actionValue-Value to be entered or select on the application
'           compareType-This variable holds value true or false,True which verify using instr function and false will use strcomp function
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function WebTableCellClick(Byval screenobject,Byval actionValue,Byval verifyFlag)
Dim rowCount,rowIteration,colIteration,cellValue,valueFound
On Error Resume Next
If actionValue <> "" Then actionValue = GetColumnValues(actionValue)
If actionValue = Fail Then
 WebTableCellClick = Fail
 Exit Function
End If
rowCount=screenobject.rowcount
valueFound=False
For rowIteration=1 to rowCount
 For colIteration=1 to screenobject.columncount(rowiteration)
     cellValue=Trim(screenobject.Getcelldata(rowIteration,colIteration))
     If verifyFlag="False" Then
         If Strcomp(cellValue,actionValue,1)=0 Then
             valueFound=True
             Exit For
         End If
     Else
         If Instr(1,cellValue,actionValue,1)>0 Then
             valueFound=True
             Exit For
         End If
     End If
 Next
If ValueFound=True Then
  screenobject.object.rows(rowIteration-1).cells(colIteration-1).click
    Exit For
End If
Next
If Err.Number<>0 or valueFound=False Then
 If  Err.Description="" Then Err.Description= "Value not Found"
            Reportstep "Perform click operation on " & screenobject.tostring , "Perform click operation on " & screenobject.tostring & " should be successful","Perform click operation on " &screenobject.tostring &" failed due to "&Err.description,fail
             WebTableCellClick=Fail
Else
             WebTableCellClick=pass
            Reportstep "Perform click operation on " & screenobject.tostring , "Perform click operation on " & screenobject.tostring & " should be successful","Perform click operation on " &screenobject.tostring &" is successful",pass
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: WebTableCelldblClick(ByVal screenobject, ByVal actionValue, ByVal verifyFlag)
'
'Description:Perform click operation on object
'
'Arguments: Screenobject-Object for which the respective action to be performed
'           actionValue-Value to be entered or select on the application
'           compareType-This variable holds value true or false,True which verify using instr function and false will use strcomp function
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function WebTableCelldblClick(Byval screenobject,Byval actionValue,Byval verifyFlag)
Dim rowCount,rowIteration,colIteration,cellValue,valueFound
On Error Resume Next
If actionValue <> "" Then actionValue = GetColumnValues(actionValue)
If actionValue = Fail Then
 WebTableCelldblClick = Fail
 Exit Function
End If
rowCount=screenobject.rowcount
valueFound=False
For rowIteration=1 to rowCount
 For colIteration=1 to screenobject.columncount(rowiteration)
     cellValue=Trim(screenobject.Getcelldata(rowIteration,colIteration))
     If verifyFlag="False" Then
         If Strcomp(cellValue,actionValue,1)=0 Then
             valueFound=True
             Exit For
         End If
     Else
         If Instr(1,cellValue,actionValue,1)>0 Then
             valueFound=True
             Exit For
         End If
     End If
 Next
If ValueFound=True Then
  screenobject.WebElement("innertext:="&actionvalue).fireevent "ondblClick"
    Exit For
End If
Next
If Err.Number<>0 or valueFound=False Then
 If  Err.Description="" Then Err.Description= "Value not Found"
            Reportstep "Perform double click operation on " & screenobject.tostring , "Perform double click operation on " & screenobject.tostring & " should be successful","Perform double click operation on " &screenobject.tostring &" failed due to "&Err.description,fail
             WebTableCelldblClick=Fail
Else
             WebTableCelldblClick=pass
            Reportstep "Perform double click operation on " & screenobject.tostring , "Perform double click operation on " & screenobject.tostring & " should be successful","Perform double click operation on " &screenobject.tostring &" is successful",pass
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: OpenApplication
'
'Description:open the web or standalone application
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function OpenApplication()
   On Error Resume Next
   Select Case LCase(applicationType)
        Case "standalone"
                systemutil.CloseDescendentProcesses
                SystemUtil.Run gurl
        Case Else
            Select Case LCase(browserType)
                Case "firefox"
                    systemutil.CloseDescendentProcesses
                    SystemUtil.Run "firefox.exe", gurl
                Case "netscape"
                    systemutil.CloseDescendentProcesses
                    SystemUtil.Run "netscape.exe", gurl
                Case Else
                    systemutil.CloseDescendentProcesses
                    SystemUtil.Run "iexplore.exe", gurl
            End Select
   End Select
   If Err.Number <> 0 Then
        OpenApplication = Fail
        Reportstep "Open the application", "Open the application should be successful", "Opening the application failed", fail
    Else
        OpenApplication = Pass
        Reportstep "Open the application", "Open the application should be successful", "Opening the application is successful", pass
   End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: GetAllErrors(ByVal screenObject, ByVal propertyName, ByVal propertyValue, ByVal className, ByVal displayProperty)
'
'Description:Get all the errors
'
'Return Value: Pass on successful execution or Fail on unsuccessful execution
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function GetAllErrors(ByVal screenObject, ByVal propertyName, ByVal propertyValue, ByVal className, ByVal displayProperty)
   Dim odesc, nPropertyName, npropertyValue, rowiteration1, rowIteration, nObject, childobjectFound, errMessage
   childobjectFound = False
   Set odesc = Description.Create
   nPropertyName = Split(propertyName, ";")
   npropertyValue = Split(propertyValue, ";")
   For rowIteration = 0 To UBound(nPropertyName)
        odesc(nPropertyName(rowIteration)).Value = ".*" & npropertyValue(rowIteration) & ".*"
   Next
    odesc("micclass").Value = className
    Set nObject = screenObject.ChildObjects(odesc)
    For rowiteration1 = 0 To nObject.Count - 1
        If nObject(rowiteration1).GetROProperty(displayProperty) <> Empty Then
            If rowiteration1 = 0 Then
                errMessage = nObject(rowiteration1).GetROProperty(displayProperty)
            Else
                errMessage = errMessage & "," & nObject(rowiteration1).GetROProperty(displayProperty)
            End If
            childobjectFound = True
        End If
    Next
If Err.Number <> 0 Or errMessage <> Empty Then
   GetAllErrors = fail
   Reportstep "Get all the errors from " & screenobject.tostring , "Get all the errors from " & screenobject.tostring & " should be successful","Perform all the error from " &screenobject.tostring &" are "&errMessage,fail
Else
   GetAllErrors = Pass
End If
End Function
'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: SendKeys(ByVal keyName)
'
'Description:Send the respective keyname on the active object
'
'Return Value: None
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function SendKeys(Byval keyname)
Createobject("wscript.shell").SendKeys keyName
Reportstep "Perform send key(" & keyname & ") operation", "Perform send key operation should be successful", "Perform send key operation is successful", pass
End Function
'--------------------------------------------------------------------------------------------
'--------------------------------------------------------------------------------------------
'Function Name: ConcatValues(ByVal actionValue)
'
'Description:concat multiple values and store it in global variable
'
'Return Value: None
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function ConcatValues(ByVal actionValue)
On Error Resume Next
Dim splitConcat, rowIteration, concatvalue
splitConcat = Split(actionValue, ";")
For rowIteration = 0 To UBound(splitConcat)
 If rowIteration = 0 Then
    concatvalue = GetColumnValues(splitConcat(rowIteration))
 Else
    concatvalue = concatvalue & GetColumnValues(splitConcat(rowIteration))
 End If
Next
gConcat = concatvalue
If Err.Number <> 0 Then
 ConcatValues = Fail
Reportstep "Perform concat(" & concatvalue & ") operation", "Perform concat operation should be successful", "Perform concat operation failed", fail
Else
 ConcatValues = Pass
Reportstep "Perform concat(" & concatvalue & ") operation", "Perform concat operation should be successful", "Perform concat operation is successful", pass
End If
End Function
'--------------------------------------------------------------------------------------------
'Function Name: SplitValues(ByVal actionValue)
'
'Description:split values and store it in global variable
'
'Return Value: None
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function SplitValues(ByVal actionValue)
On Error Resume Next
Dim splitValue
splitValue = Split(actionValue, ";")
gsplit = Split(GetColumnValues(splitValue(0)), splitValue(1))
Reportstep "Perform split(" & actionValue & ") operation", "Perform split operation should be successful", "Perform split operation is successful", pass
End Function
'--------------------------------------------------------------------------------------------
'Function Name: ReplaceValues(ByVal actionValue)
'
'Description:Replace values and store it in global variable
'
'Return Value: None
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function ReplaceValues(ByVal actionValue)
On Error Resume Next
Dim splitValue
splitValue = Split(actionValue, ";")
gReplace = Replace(GetColumnValues(splitValue(0)), splitValue(1),splitValue(2))
Reportstep "Perform Replace(" & actionValue & ") operation", "Perform replace operation should be successful", "Perform replace operation is successful", pass
End Function
'--------------------------------------------------------------------------------------------
'Function Name: GetPartvalue(ByVal actionValue)
'
'Description:get part value and store it in global variable
'
'Return Value: None
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
Public Function GetPartvalue(ByVal actionValue)
On Error Resume Next
Dim splitValue
splitValue = Split(actionValue, ";")
gMid = mid(splitValue(0), splitValue(1),splitValue(2))
Reportstep "Perform mid(" & actionValue & ") operation", "Perform mid operation should be successful", "Perform mid operation is successful", pass
End Function
'--------------------------------------------------------------------------------------------
'Function Name: StoreValueToDatatable(Byval actionValue,ByVal ColumnName)
'
'Description:Store the value to datatable
'
'Return Value: pass or fail
'
'Orginal Date: 6/26/2017 6:26:47 PM
'
'Revision Date:                    Description:                                
'
'--------------------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------------------
Public Function StoreValueToDatatable(Byval actionValue,ByVal ColumnName)
On Error Resume Next
Dim rowiteration,columnFound
    If InStr(1, columnName, "[", 1) > 0 Then
     columnName = Replace(Replace(columnName, "[", ""), "]", "")
     For rowiteration = 1 To DataTable.GetSheet(gsheetName).GetParameterCount
        If DataTable.GetSheet(gsheetName).GetParameter(rowiteration).Name = columnName Then
            columnFound = True
            Exit For
        End If
     Next
     If columnFound = True Then
        DataTable.GetSheet(gsheetName).SetCurrentRow growNumber
        DataTable.GetSheet(gsheetName).GetParameter(columnName).Value = Eval(Replace(Replace(Trim(actionValue), "<", ""), ">", ""))
     Else
        DataTable.GetSheet(gsheetName).addParameter columnName, ""
        DataTable.GetSheet(gsheetName).GetParameter(columnName).ValueByRow(growNumber) = Eval(Replace(Replace(Trim(actionValue), "<", ""), ">", ""))
     End If
    End If
If Err.Number <> 0 Then
 StoreValueToDatatable = Fail
Else
 StoreValueToDatatable = pass
End If
End Function
