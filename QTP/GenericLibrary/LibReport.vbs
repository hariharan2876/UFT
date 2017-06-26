'
'LIBRARY NAME     :libReport
'DESCRIPTION      :This Library file contains HTML Report related Functions
'INCLUDED FUNCTION:
' Public Sub InitializeReportSummary()
' Private Sub DisplaySummaryHeader()
' Public Sub StartTestSummaryReport()
' Public Function ShowReportSummary()
' Public Sub EndHtmlDetailReporter()
' Private Sub DisplayDetailHeader()
' Public Function InitializedetailedReport()
' Public Sub EndHtmlSummaryReporter()
' Public Sub CaptureScreenshot
' Private Sub DisplaySummarycount()
' Private Sub DisplayTestDuration()
' Public Sub GetTotalTime(Byval Starttime,Byval Endtime)
' Private Sub DisplayDetailTestDuration()
' Public Sub Reportstep(ByVal stepDescription, ByVal Expected, ByVal Actual, ByVal stepStatus)
' Public Function GenerateExcelReport()
'
'-----------------------------------------------------------------------------------------------------------------------
Option Explicit
'
'-----------------------------------------------------------------------------------------------------------------------
'     PUBLIC FUNCTION DECLARATION
'-----------------------------------------------------------------------------------------------------------------------
'
Public htmlreport,detailhtmlreport,ScreenshotName,startDetailReport,newDetailStartNo
'
'-----------------------------------------------------------------------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
'     PRIVATE FUNCTION DECLARATION
'-----------------------------------------------------------------------------------------------------------------------
'
'(NONE)
'
'-----------------------------------------------------------------------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Public Function InitializeReportSummary()
'
'DESCRIPTION: This function will initialize HTMLReporter
'
'PARAMETERS: (None)
'
'RETURN VALUE(S): micpass on Successful Execution
'RETURN VALUE(S): micfail on unSuccessful Execution
'
'AUTHOR: Automation Code Generator
'
'ORGINAL DATE:6/26/2017 6:26:48 PM
'
'----------------------------------------------------------
'REVISION HISTORY:
'
'----------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
Public Function InitializeReportSummary()
On Error Resume Next

Dim FSO
Set FSO = CreateObject("Scripting.FileSystemObject")
If (FSO.FolderExists(gResultPath & gResultFolderName)) Then
 FSO.DeleteFolder gResultPath & gResultFolderName, True
 FSO.CreateFolder(gResultPath & gResultFolderName)
 Set htmlreport=FSO.CreateTextFile(gResultPath & gResultFolderName &"\ResultSummary.html")
 DisplaySummaryHeader()
CreateReportFile
Else
 FSO.CreateFolder(gResultPath & gResultFolderName)
 Set htmlreport=FSO.CreateTextFile(gResultPath & gResultFolderName &"\ResultSummary.html")
 DisplaySummaryHeader()
CreateReportFile
End If

If Err.Number<>0 then
  InitializeReportSummary=micfail
Else
  InitializeReportSummary=micpass
End If
End Function
'-----------------------------------------------------------------------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Private sub DisplaySummaryHeader()
'
'DESCRIPTION: This function will display summary header values
'
'
'AUTHOR: Automation Code Generator
'
'ORGINAL DATE:6/26/2017 6:26:48 PM
'
'----------------------------------------------------------
'REVISION HISTORY:
'
'----------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
Private Sub DisplaySummaryHeader()
 htmlreport.WriteLine("<head>")
 htmlreport.WriteLine("<Style>")
htmlreport.writeline ".hl1"
htmlreport.writeline "{"
htmlreport.writeline "    COLOR: #669;"
htmlreport.writeline "    FONT-FAMILY: Mic Shell Dlg;"
htmlreport.writeline "    FONT-SIZE: 16pt;"
htmlreport.writeline "    FONT-WEIGHT: bold"
htmlreport.writeline "}"
htmlreport.writeline ".bg_darkblue"
htmlreport.writeline "{"
htmlreport.writeline "    BACKGROUND-COLOR: #669"
htmlreport.writeline "}"
htmlreport.writeline ".bg_midblue"
htmlreport.writeline "{"
htmlreport.writeline "    BACKGROUND-COLOR: #99c"
htmlreport.writeline "}"
htmlreport.writeline ".bg_gray_eee"
htmlreport.writeline "{"
htmlreport.writeline "    BACKGROUND-COLOR: #eee"
htmlreport.writeline "}"
htmlreport.writeline ".text"
htmlreport.writeline "{"
htmlreport.writeline "    FONT-FAMILY: Mic Shell Dlg;"
htmlreport.writeline "    FONT-SIZE: 10pt"
htmlreport.writeline "}"
htmlreport.writeline ".tablehl"
htmlreport.writeline "{"
htmlreport.writeline "    BACKGROUND-COLOR: #eee;"
htmlreport.writeline "    COLOR: #669;"
htmlreport.writeline "    FONT-FAMILY: Mic Shell Dlg;"
htmlreport.writeline "    FONT-SIZE: 10pt;"
htmlreport.writeline "    FONT-WEIGHT: bold;"
htmlreport.writeline "    LINE-HEIGHT: 14pt"
htmlreport.writeline "}"
htmlreport.writeline ".Failed"
htmlreport.writeline "{"
htmlreport.writeline "    COLOR: #f03;"
htmlreport.writeline "    FONT-FAMILY: Mic Shell Dlg;"
htmlreport.writeline "    FONT-SIZE: 10pt;"
htmlreport.writeline "    FONT-WEIGHT: bold"
htmlreport.writeline "}"
htmlreport.writeline ".Passed"
htmlreport.writeline "{"
htmlreport.writeline "    COLOR: #096;"
htmlreport.writeline "    FONT-FAMILY: Mic Shell Dlg;"
htmlreport.writeline "    FONT-SIZE: 10pt;"
htmlreport.writeline "    FONT-WEIGHT: bold"
htmlreport.writeline "}"
 htmlreport.WriteLine("</Style>")
 htmlreport.WriteLine("</head>")
 htmlreport.WriteLine("<Title>Result Summary</Title>")
htmlreport.writeline("<hr class=" & "bg_midblue" &">")
htmlreport.writeline("<div align="& "center"& "><span class=" & "hl1" & " Localizable_1=" & "True" & ">" & gApplicationName& " Results Summary</span></div>")
htmlreport.writeline("<hr class=" & "bg_darkblue" & ">")
htmlreport.writeline("<table border=" & "0" & "cellpadding=" & "3" & " cellspacing=" & "1" & " width=" & "100%" & " bgcolor=" & "#666699" & ">")
htmlreport.writeline("<tr><td bgcolor=" & "white" & ">")
htmlreport.writeline("<table border=" & "0" & " cellpadding=" & "3" & " cellspacing=" & "0" & " width=" & "100%" & ">")
htmlreport.writeline("<tr>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "tablehl" & "> <span class=" & "tablehl" & ">Result Name</span></td>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "tablehl" & "> <span class=" & "tablehl" & ">Execution Date</span></td>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "tablehl" & "> <span class=" & "tablehl" & ">Region</span></td>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "tablehl" & "> <span class=" & "tablehl" & ">UserName</span></td>")
htmlreport.writeline("</tr>")
htmlreport.writeline("<tr>")
htmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("</tr><tr>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">"& gResultFolderName &"</span></td>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">"& Now &"</span></td>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">"& gRegion &"</span></td>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">"& gUserName &"</span></td>")
htmlreport.writeline("</tr>")
htmlreport.writeline("<tr>")
htmlreport.writeline("<td height=" & "1" & " class=" & "bg_gray_eee" & "></td>")
htmlreport.writeline("<td height=" & "1" & " class=" & "bg_gray_eee" & "></td>")
htmlreport.writeline("<td height=" & "1" & " class=" & "bg_gray_eee" & "></td>")
htmlreport.writeline("<td height=" & "1" & " class=" & "bg_gray_eee" & "></td>")
htmlreport.writeline("</tr>")
htmlreport.writeline("</table> ")
htmlreport.writeline("</td></tr>")
htmlreport.writeline("</table> ")
htmlreport.writeline("<br>")
htmlreport.writeline("<table border=" & "0" & "cellpadding=" & "3" & " cellspacing=" & "1" & " width=" & "100%" & " bgcolor=" & "#666699" & ">")
htmlreport.writeline("<tr><td bgcolor="&"white"&">")
htmlreport.writeline("<table border="&"0"&" cellpadding="&"3"&" cellspacing="&"0" &" width="&"100%"&">")
htmlreport.writeline("<tr>")
htmlreport.writeline("<td valign="&"middle" &" align="&"center" &" class="&"tablehl"&"> <span class="&"tablehl"&">S.No</span></td>")
htmlreport.writeline("<td valign="&"middle" &" align="&"center" &" class="&"tablehl"&"> <span class="&"tablehl"&">Test Case Name</span></td>")
htmlreport.writeline("<td valign="&"middle" &" align="&"center" &" class="&"tablehl"&"> <span class="&"tablehl"&">Test Case Description</span></td>")
htmlreport.writeline("<td valign="&"middle" &" align="&"center" &" class="&"tablehl"&"> <span class="&"tablehl"&">Expected</span></td>")
htmlreport.writeline("<td valign="&"middle" &" align="&"center" &" class="&"tablehl"&"> <span class="&"tablehl"&">Actual</span></td>")
htmlreport.writeline("</tr>")
End Sub
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Public Sub StartTestSummaryReport()
'
'DESCRIPTION: This function will start Testsummary reporting
'
'
'AUTHOR: Automation Code Generator
'
'ORGINAL DATE:6/26/2017 6:26:48 PM
'
'----------------------------------------------------------
'REVISION HISTORY:
'
'----------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
Public Sub StartTestSummaryReport()
gdetailstartno=1
htmlreport.writeline("<tr>")
htmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("</tr></tr>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">" & gstartno & "</span></td>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><a href=""" & gTestCaseName &"-ResultSummary.html""><span class=" & "text" & ">" & gTestCaseName & "</span></a></td>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">" & gTestCaseDescription & "</span></td>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">" & gExpected & "</span></td>")
If gTestcaseStatus=micpass and gverifyContinue=pass then
 htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "passed" & ">Passed</span></td>")
 gPassedcount=gPassedcount+1
Else
 htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "failed" & ">Failed</span></td>")
 gFailedcount=gFailedcount+1
End If
htmlreport.writeline("<tr>")
gstartno = gstartno + 1
End Sub
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Public Sub ShowReportSummary()
'
'DESCRIPTION: This function will show final report
'
'
'AUTHOR: Automation Code Generator
'
'ORGINAL DATE:6/26/2017 6:26:48 PM
'
'----------------------------------------------------------
'REVISION HISTORY:
'
'----------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
Public Sub ShowReportSummary()
systemutil.run gResultPath & gResultFolderName &"\ResultSummary.html"
End sub
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Public Function InitializedetailedReport()
'
'DESCRIPTION: This function will initialize detailed HTMLReporter
'
'PARAMETERS: (None)
'
'RETURN VALUE(S): micpass on Successful Execution
'RETURN VALUE(S): micfail on unSuccessful Execution
'
'AUTHOR: Automation Code Generator
'
'ORGINAL DATE:6/26/2017 6:26:48 PM
'
'----------------------------------------------------------
'REVISION HISTORY:
'
'----------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
Public Function InitializedetailedReport()
On Error Resume Next

Dim FSO
Set FSO = CreateObject("Scripting.FileSystemObject")
 Set detailhtmlreport=FSO.CreateTextFile(gResultPath & gResultFolderName &"\"& gTestCaseName&"-ResultSummary.html")
 DisplayDetailHeader()
newDetailStartNo = 1

If Err.Number<>0 then
  InitializedetailedReport=micfail
Else
  InitializedetailedReport=micpass
End If
End Function
'-----------------------------------------------------------------------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Private sub DisplayDetailHeader()
'
'DESCRIPTION: This function will display detail header values
'
'
'AUTHOR: Automation Code Generator
'
'ORGINAL DATE:6/26/2017 6:26:48 PM
'
'----------------------------------------------------------
'REVISION HISTORY:
'
'----------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
Private Sub DisplayDetailHeader()
gverifyContinue = pass
 detailhtmlreport.WriteLine("<head>")
 detailhtmlreport.WriteLine("<Style>")
detailhtmlreport.writeline ".hl1"
detailhtmlreport.writeline "{"
detailhtmlreport.writeline "    COLOR: #669;"
detailhtmlreport.writeline "    FONT-FAMILY: Mic Shell Dlg;"
detailhtmlreport.writeline "    FONT-SIZE: 16pt;"
detailhtmlreport.writeline "    FONT-WEIGHT: bold"
detailhtmlreport.writeline "}"
detailhtmlreport.writeline ".bg_darkblue"
detailhtmlreport.writeline "{"
detailhtmlreport.writeline "    BACKGROUND-COLOR: #669"
detailhtmlreport.writeline "}"
detailhtmlreport.writeline ".bg_midblue"
detailhtmlreport.writeline "{"
detailhtmlreport.writeline "    BACKGROUND-COLOR: #99c"
detailhtmlreport.writeline "}"
detailhtmlreport.writeline ".bg_gray_eee"
detailhtmlreport.writeline "{"
detailhtmlreport.writeline "    BACKGROUND-COLOR: #eee"
detailhtmlreport.writeline "}"
detailhtmlreport.writeline ".text"
detailhtmlreport.writeline "{"
detailhtmlreport.writeline "    FONT-FAMILY: Mic Shell Dlg;"
detailhtmlreport.writeline "    FONT-SIZE: 10pt"
detailhtmlreport.writeline "}"
detailhtmlreport.writeline ".tablehl"
detailhtmlreport.writeline "{"
detailhtmlreport.writeline "    BACKGROUND-COLOR: #eee;"
detailhtmlreport.writeline "    COLOR: #669;"
detailhtmlreport.writeline "    FONT-FAMILY: Mic Shell Dlg;"
detailhtmlreport.writeline "    FONT-SIZE: 10pt;"
detailhtmlreport.writeline "    FONT-WEIGHT: bold;"
detailhtmlreport.writeline "    LINE-HEIGHT: 14pt"
detailhtmlreport.writeline "}"
detailhtmlreport.writeline ".Failed"
detailhtmlreport.writeline "{"
detailhtmlreport.writeline "    COLOR: #f03;"
detailhtmlreport.writeline "    FONT-FAMILY: Mic Shell Dlg;"
detailhtmlreport.writeline "    FONT-SIZE: 10pt;"
detailhtmlreport.writeline "    FONT-WEIGHT: bold"
detailhtmlreport.writeline "}"
detailhtmlreport.writeline ".Passed"
detailhtmlreport.writeline "{"
detailhtmlreport.writeline "    COLOR: #096;"
detailhtmlreport.writeline "    FONT-FAMILY: Mic Shell Dlg;"
detailhtmlreport.writeline "    FONT-SIZE: 10pt;"
detailhtmlreport.writeline "    FONT-WEIGHT: bold"
detailhtmlreport.writeline "}"
 detailhtmlreport.WriteLine("</Style>")
 detailhtmlreport.WriteLine("</head>")
detailhtmlreport.writeline("<Title>Detail Report</Title>")
detailhtmlreport.writeline("<hr class=" & "bg_midblue" &">")
detailhtmlreport.writeline("<div align="& "center"& "><span class=" & "hl1" & " Localizable_1=" & "True" & ">" & gApplicationName& " Detail Results </span></div>")
detailhtmlreport.writeline("<hr class=" & "bg_darkblue" & ">")
detailhtmlreport.writeline("<table border=" & "0" & "cellpadding=" & "3" & " cellspacing=" & "1" & " width=" & "100%" & " bgcolor=" & "#666699" & ">")
detailhtmlreport.writeline("<tr><td bgcolor=" & "white" & ">")
detailhtmlreport.writeline("<table border=" & "0" & " cellpadding=" & "3" & " cellspacing=" & "0" & " width=" & "100%" & ">")
detailhtmlreport.writeline("<tr>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "tablehl" & "> <span class=" & "tablehl" & ">Test Case Name</span></td>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "tablehl" & "> <span class=" & "tablehl" & ">Execution Date</span></td>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "tablehl" & "> <span class=" & "tablehl" & ">Region</span></td>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "tablehl" & "> <span class=" & "tablehl" & ">UserName</span></td>")
detailhtmlreport.writeline("</tr>")
detailhtmlreport.writeline("<tr>")
detailhtmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
detailhtmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
detailhtmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
detailhtmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
detailhtmlreport.writeline("</tr><tr>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><a href=""" &"ResultSummary.html""><span class=" & "text" & ">" & gTestCaseName & "</span></a></td>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">"& Now &"</span></td>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">"& gRegion &"</span></td>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">"& gUserName &"</span></td>")
detailhtmlreport.writeline("</tr>")
detailhtmlreport.writeline("<tr>")
detailhtmlreport.writeline("<td height=" & "1" & " class=" & "bg_gray_eee" & "></td>")
detailhtmlreport.writeline("<td height=" & "1" & " class=" & "bg_gray_eee" & "></td>")
detailhtmlreport.writeline("<td height=" & "1" & " class=" & "bg_gray_eee" & "></td>")
detailhtmlreport.writeline("<td height=" & "1" & " class=" & "bg_gray_eee" & "></td>")
detailhtmlreport.writeline("</tr>")
detailhtmlreport.writeline("</table> ")
detailhtmlreport.writeline("</td></tr>")
detailhtmlreport.writeline("</table> ")
detailhtmlreport.writeline("<br>")
detailhtmlreport.writeline("<table border=" & "0" & "cellpadding=" & "3" & " cellspacing=" & "1" & " width=" & "100%" & " bgcolor=" & "#666699" & ">")
detailhtmlreport.writeline("<tr><td bgcolor="&"white"&">")
detailhtmlreport.writeline("<table border="&"0"&" cellpadding="&"3"&" cellspacing="&"0" &" width="&"100%"&">")
detailhtmlreport.writeline("<tr>")
detailhtmlreport.writeline("<td valign="&"middle" &" align="&"center" &" class="&"tablehl"&"> <span class="&"tablehl"&">Step No</span></td>")
detailhtmlreport.writeline("<td valign="&"middle" &" align="&"center" &" class="&"tablehl"&"> <span class="&"tablehl"&">Step Description</span></td>")
detailhtmlreport.writeline("<td valign="&"middle" &" align="&"center" &" class="&"tablehl"&"> <span class="&"tablehl"&">Expected</span></td>")
detailhtmlreport.writeline("<td valign="&"middle" &" align="&"center" &" class="&"tablehl"&"> <span class="&"tablehl"&">Actual</span></td>")
detailhtmlreport.writeline("<td valign="&"middle" &" align="&"center" &" class="&"tablehl"&"> <span class="&"tablehl"&">Status</span></td>")
detailhtmlreport.writeline("<td valign="&"middle" &" align="&"center" &" class="&"tablehl"&"> <span class="&"tablehl"&">Screenshot</span></td>")
detailhtmlreport.writeline("</tr>")
End Sub
'-----------------------------------------------------------------------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Public sub EndHtmlDetailReporter()
'
'DESCRIPTION: This function will closes the detail HTML reporting
'
'
'AUTHOR: Automation Code Generator
'
'ORGINAL DATE:6/26/2017 6:26:48 PM
'
'----------------------------------------------------------
'REVISION HISTORY:
'
'----------------------------------------------------------
Public Sub EndHtmlDetailReporter()
DisplayDetailTestDuration()
detailhtmlreport.close
Set detailhtmlreport=nothing
GetTestCaseDescription
StartTestSummaryReport
End Sub
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Public sub EndHtmlSummaryReporter()
'
'DESCRIPTION: This function will closes the Summary HTML reporting
'
'
'AUTHOR: Automation Code Generator
'
'ORGINAL DATE:6/26/2017 6:26:48 PM
'
'----------------------------------------------------------
'REVISION HISTORY:
'
'----------------------------------------------------------
Public Sub EndHtmlSummaryReporter()
DisplaySummarycount()
DisplayTestDuration()
htmlreport.close
Set htmlreport=nothing
End Sub
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Public sub CaptureScreenshot()
'
'DESCRIPTION: This function will capture the screenshot when necessary
'
'
'AUTHOR: Automation Code Generator
'
'ORGINAL DATE:6/26/2017 6:26:48 PM
'
'----------------------------------------------------------
'REVISION HISTORY:
'
'----------------------------------------------------------
Public Sub CaptureScreenshot()
If ScreenshotName<>"" then Exit Sub
ScreenShotName=gTestCaseName & "_" & Hour(Time) & "_" & Minute(Time) & "_" & Second(Time) & ".png"
 Desktop.CaptureBitmap gResultPath & gResultFolderName &"\"  & ScreenShotName, True
End Sub
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Private sub DisplaySummarycount()
'
'DESCRIPTION: This function will display Passed and failed testcases
'
'
'AUTHOR: Automation Code Generator
'
'ORGINAL DATE:6/26/2017 6:26:48 PM
'
'----------------------------------------------------------
'REVISION HISTORY:
'
'----------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
Private Sub DisplaySummarycount()
htmlreport.writeline("</table>")
htmlreport.writeline("</table>")
htmlreport.writeline("</br>")
htmlreport.writeline("<table border=" & "0" & "cellpadding=" & "3" & " align=" & "left" & " cellspacing=" & "1" & " width=" & "48%" & " bgcolor=" & "#666699" & ">")
htmlreport.writeline("<tr><td bgcolor=" & "white" & ">")
htmlreport.writeline("<table border=" & "0" & " cellpadding=" & "3" & " cellspacing=" & "0" & " width=" & "100%" & ">")
htmlreport.writeline("<tr>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "tablehl" & "> <span class=" & "tablehl" & ">Status</span></td>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "tablehl" & "> <span class=" & "tablehl" & ">Times</span></td>")
htmlreport.writeline("</tr>")
htmlreport.writeline("<tr>")
htmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("</tr><tr>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "text" & "> <span class=" & "passed" & ">Passed</span></td>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">"& gPassedcount &"</span></td>")
htmlreport.writeline("</tr>")
htmlreport.writeline("<tr>")
htmlreport.writeline("<td height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("<td height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("</tr>")
htmlreport.writeline("<tr>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "text" & "> <span class=" & "failed" & ">Failed</span></td>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">"& gFailedcount &"</span></td>")
htmlreport.writeline("</tr>")
htmlreport.writeline("</table> ")
htmlreport.writeline("</td></tr>")
htmlreport.writeline("</table> ")
End Sub
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Private sub DisplayTestDuration()
'
'DESCRIPTION: This function will display Total test Duration
'
'
'AUTHOR: Automation Code Generator
'
'ORGINAL DATE:6/26/2017 6:26:48 PM
'
'----------------------------------------------------------
'REVISION HISTORY:
'
'----------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
Private Sub DisplayTestDuration()
htmlreport.writeline("</table>")
htmlreport.writeline("</table>")
htmlreport.writeline("<table border=" & "0" & "cellpadding=" & "3" & " align=" & "right" & " cellspacing=" & "1" & " width=" & "50%" & " bgcolor=" & "#666699" & ">")
htmlreport.writeline("<tr><td bgcolor=" & "white" & ">")
htmlreport.writeline("<table border=" & "0" & " cellpadding=" & "3" & " cellspacing=" & "0" & " width=" & "100%" & ">")
htmlreport.writeline("<tr>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "tablehl" & "> <span class=" & "tablehl" & ">Status</span></td>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "tablehl" & "> <span class=" & "tablehl" & ">Duration</span></td>")
htmlreport.writeline("</tr>")
htmlreport.writeline("<tr>")
htmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("</tr><tr>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "text" & "> <span class=" & "text" & ">Run Started</span></td>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">"& gStarttime &"</span></td>")
htmlreport.writeline("</tr>")
htmlreport.writeline("<tr>")
htmlreport.writeline("<td height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("<td height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("</tr>")
htmlreport.writeline("<tr>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "text" & "> <span class=" & "text" & ">Run ended</span></td>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">"& gEndtime &"</span></td>")
htmlreport.writeline("</tr>")
htmlreport.writeline("<tr>")
htmlreport.writeline("<td height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("<td height=" & "1" & " class=" & "bg_darkblue" & "></td>")
htmlreport.writeline("</tr>")
htmlreport.writeline("<tr>")
GetTotalTime gStarttime,gEndtime
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "text" & "> <span class=" & "text" & ">Total Duration</span></td>")
htmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">"& gFinalTime &"</span></td>")
htmlreport.writeline("</tr>")
htmlreport.writeline("</table> ")
htmlreport.writeline("</td></tr>")
htmlreport.writeline("</table> ")
End Sub
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Private sub DisplayDetailTestDuration()
'
'DESCRIPTION: This function will display Total test Duration for each testcase
'
'
'AUTHOR: Automation Code Generator
'
'ORGINAL DATE:6/26/2017 6:26:48 PM
'
'----------------------------------------------------------
'REVISION HISTORY:
'
'----------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
Private Sub DisplayDetailTestDuration()
detailhtmlreport.writeline("</table>")
detailhtmlreport.writeline("</table>")
detailhtmlreport.writeline("</br>")
detailhtmlreport.writeline("<table border=" & "0" & "cellpadding=" & "3" & " cellspacing=" & "1" & " width=" & "100%" & " bgcolor=" & "#666699" & ">")
detailhtmlreport.writeline("<tr><td bgcolor=" & "white" & ">")
detailhtmlreport.writeline("<table border=" & "0" & " cellpadding=" & "3" & " cellspacing=" & "0" & " width=" & "100%" & ">")
detailhtmlreport.writeline("<tr>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "tablehl" & "> <span class=" & "tablehl" & ">Status</span></td>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "tablehl" & "> <span class=" & "tablehl" & ">Duration</span></td>")
detailhtmlreport.writeline("</tr>")
detailhtmlreport.writeline("<tr>")
detailhtmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
detailhtmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
detailhtmlreport.writeline("</tr><tr>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "text" & "> <span class=" & "text" & ">Run Started</span></td>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">"& gdetailStarttime &"</span></td>")
detailhtmlreport.writeline("</tr>")
detailhtmlreport.writeline("<tr>")
detailhtmlreport.writeline("<td height=" & "1" & " class=" & "bg_darkblue" & "></td>")
detailhtmlreport.writeline("<td height=" & "1" & " class=" & "bg_darkblue" & "></td>")
detailhtmlreport.writeline("</tr>")
detailhtmlreport.writeline("<tr>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "text" & "> <span class=" & "text" & ">Run ended</span></td>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">"& gdetailEndtime &"</span></td>")
detailhtmlreport.writeline("</tr>")
detailhtmlreport.writeline("<tr>")
detailhtmlreport.writeline("<td height=" & "1" & " class=" & "bg_darkblue" & "></td>")
detailhtmlreport.writeline("<td height=" & "1" & " class=" & "bg_darkblue" & "></td>")
detailhtmlreport.writeline("</tr>")
detailhtmlreport.writeline("<tr>")
GetTotalTime gdetailStarttime,gdetailEndtime
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " class=" & "text" & "> <span class=" & "text" & ">Total Duration</span></td>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">"& gfinaltime &"</span></td>")
detailhtmlreport.writeline("</tr>")
detailhtmlreport.writeline("</table> ")
detailhtmlreport.writeline("</td></tr>")
detailhtmlreport.writeline("</table> ")
End Sub
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Public sub GetTotalTime(Byval Startime,Byval endtime)
'
'DESCRIPTION: This function will get the time duration for total script execution
'
'
'AUTHOR: Automation Code Generator
'
'ORGINAL DATE:6/26/2017 6:26:48 PM
'
'----------------------------------------------------------
'REVISION HISTORY:
'
'----------------------------------------------------------
Public Sub GetTotalTime(Byval Starttime,Byval Endtime)
On Error Resume Next
Dim TotalTransaction
TotalTransaction=datediff("s",Starttime,Endtime)
gfinaltime=(TotalTransaction\3600) &" hrs " & (TotalTransaction mod 3600)\60 &" min " &(TotalTransaction mod (3600)\60) &" Sec"
End Sub
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Public sub Reportstep(Byval stepDescription,Byval Expected,Byval Actual,Byval stepStatus)
'
'DESCRIPTION: This function will report the particular step
'
'
'AUTHOR: Automation Code Generator
'
'ORGINAL DATE:6/26/2017 6:26:48 PM
'
'----------------------------------------------------------
'REVISION HISTORY:
'
'----------------------------------------------------------
Public function Reportstep(Byval stepDescription,Byval Expected,Byval Actual,Byval stepStatus)
On Error Resume Next
Dim Screenshotdesc
If geventTriggered = True Then
     Setting.WebPackage("ReplayType") = 1
     geventTriggered = False
End If
detailhtmlreport.writeline("<tr>")
detailhtmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
detailhtmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
detailhtmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
detailhtmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
detailhtmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
detailhtmlreport.writeline("<td  height=" & "1" & " class=" & "bg_darkblue" & "></td>")
detailhtmlreport.writeline("</tr></tr>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "text" & ">" & newDetailStartNo & "</span></td>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "left" & " height=" & "20" & "><span class=" & "text" & ">" & stepDescription & "</span></td>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "left" & " height=" & "20" & "><span class=" & "text" & ">" & Expected & "</span></td>")
detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "left" & " height=" & "20" & "><span class=" & "text" & ">" & Actual & "</span></td>")
If stepstatus=micpass then
 detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "passed" & ">Passed</span></td>")
 gTestcaseStatus=micpass
 If ScreenShotName<>"" Then
  Screenshotdesc=gResultPath & gResultFolderName &"/" & ScreenShotName
  detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><a target="& "_blank href=" &chr(34) & Screenshotdesc & chr(34) &"><IMG SRC="""&gProductdir &"\dat\logo.png ""HEIGHT=15></a></td>")
  ScreenShotName=""
 End if
Else
 detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><span class=" & "failed" & ">Failed</span></td>")
 gTestcaseStatus=micfail
 Screenshotdesc=gResultPath & gResultFolderName &"/" & ScreenShotName
 If ScreenShotName<>"" Then
  detailhtmlreport.writeline("<td valign=" & "middle" & " align=" & "center" & " height=" & "20" & "><a target="& "_blank href=" &chr(34) & Screenshotdesc &chr(34) &"><IMG SRC="""&gProductdir &"\dat\logo.png ""HEIGHT=15></a></td>")
  ScreenShotName=""
 End if
 End if
detailhtmlreport.writeline("<tr>")
newDetailStartNo = gdetailstartno & "." & startDetailReport
startDetailReport = startDetailReport + 1
End Function
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Public function GenerateExcelReport()
'
'DESCRIPTION: This function will generate the excel report
'
'
'AUTHOR: Automation Code Generator
'
'ORGINAL DATE:6/26/2017 6:26:48 PM
'
'----------------------------------------------------------
'REVISION HISTORY:
'
'----------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
Public Function GenerateExcelReport()
   On Error Resume Next
     Dim FSO,excelObj,excelObj1,excelwb,excelwb1,excelsheet,excelsheet1
    Set FSO = CreateObject("Scripting.FileSystemObject")
    If FSO.FileExists(gTestPath&"\Results\" &gApplicationName &"_Metrics.xls")=True Then
        FSO.CopyFile gTestPath&"\Results\" &gApplicationName &"_Metrics.xls",gexcelResultPath & gResultFolderName &"\"
        Set excelObj = CreateObject("excel.application")
        Set excelObj1 = CreateObject("excel.application")
        excelObj1.DisplayAlerts = False
        excelObj.DisplayAlerts = False
        set excelwb=excelObj.Workbooks.Open (gexcelResultPath & gResultFolderName &"\" &gApplicationName &"_Export.xls")
        Set excelsheet = excelwb.Sheets("Global")
        excelsheet.Activate
        excelObj.Range("A1:F1000").Select
        excelObj.Selection.Copy
        Set excelwb1 = excelObj.Workbooks.Open(gexcelResultPath & gResultFolderName & "\" & gApplicationName & "_Metrics.xls")
        Set excelsheet1 = excelwb1.Sheets("Testcase")
        excelsheet1.Paste
        excelwb1.Save
        excelwb1.Close
        excelwb.Close
        excelObj1.DisplayAlerts = True
        excelObj.DisplayAlerts = True
    End If
    Set FSO = Nothing
    Set excelwb1 = Nothing
    Set excelwb = Nothing
    Set excelObj = Nothing
    Set excelObj1 = Nothing
If Err.Number <> 0 Then
    Reporter.ReportEvent micFail, "Generating Excel report", "Generating excel report failed due to " & Err.Description
End If
End Function
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Public function initializeExcelReport()
'
'DESCRIPTION: This function will initialize the excel report
'
'
'AUTHOR: Automation Code Generator
'
'ORGINAL DATE:6/26/2017 6:26:48 PM
'
'----------------------------------------------------------
'REVISION HISTORY:
'
'----------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------
Public Function initializeExcelReport()
On Error Resume Next
    Dim FSO
    Set FSO = CreateObject("Scripting.FileSystemObject")
    If (FSO.FolderExists(gexcelResultPath & gResultFolderName)) Then
        FSO.DeleteFolder gexcelResultPath & gResultFolderName, True
        FSO.CreateFolder (gexcelResultPath & gResultFolderName)
    Else
        FSO.CreateFolder (gexcelResultPath & gResultFolderName)
    End If
    Set FSO = Nothing
If Err.Number <> 0 Then
    initializeExcelReport = Fail
Else
    initializeExcelReport = Pass
End If
End Function
