'LIBRARY NAME     :libWordScreenshot
'DESCRIPTION      :This Library file contains Word Screenshot related Functions
'INCLUDED FUNCTION:
' Public Sub Initializewordinstance()
' Public Sub CloseWordInstance()
' Public Sub CaptureWordScreenshot()
' Public Function InitializeWordPath()
'
'-----------------------------------------------------------------------------------------------------------------------
Option Explicit
'
'-----------------------------------------------------------------------------------------------------------------------
'     PUBLIC FUNCTION DECLARATION
'-----------------------------------------------------------------------------------------------------------------------
'
Public WordObj
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
'FUNCTION NAME: Public Function InitializeWordPath()
'
'DESCRIPTION: This function will initialize Wordpath
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
Public Function InitializeWordPath()
On Error Resume Next

Dim FSO
Set FSO = CreateObject("Scripting.FileSystemObject")
If (FSO.FolderExists(gwordscreenshotpath & gResultFolderName)) Then
 FSO.DeleteFolder gwordscreenshotpath & gResultFolderName, True
 FSO.CreateFolder(gwordscreenshotpath & gResultFolderName)
Else
 FSO.CreateFolder(gwordscreenshotpath & gResultFolderName)
End If

If Err.Number<>0 then
  InitializeWordPath=micfail
Else
  InitializeWordPath=micpass
End If
End Function
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Public Sub Initializewordinstance()
'
'DESCRIPTION: This procedure will initialize wordinstance
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
Public Sub Initializewordinstance()
On Error Resume Next

Set WordObj = CreateObject("Word.Application")
WordObj.Documents.Add
End Sub
'-----------------------------------------------------------------------------------------------------------------------
'FUNCTION NAME: Public Sub CloseWordInstance()
'
'DESCRIPTION: This procedure will Closes wordinstance
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
Public Sub CloseWordInstance()
On Error Resume Next

WordObj.ActiveDocument.SaveAs gwordscreenshotpath &gResultFolderName & "\" &gTestCaseName &".doc"
WordObj.Quit
Set WordObj = Nothing
End Sub
'-----------------------------------------------------------------------------------------------------------------------
Public Sub CaptureWordScreenshot()
On Error Resume Next
If gNeedWordScreenshot = True then 
    Const wdStory = 6
    Const wdMove = 0
    Desktop.capturebitmap gwordscreenshotpath &gResultFolderName  & "\Screenshot.png", True
    WordObj.Selection.TypeParagraph()
    WordObj.Selection.Text="Step No:" &gstepno
    WordObj.Selection.EndKey wdStory, wdMove
    WordObj.Selection.TypeParagraph()
    WordObj.Selection.InlineShapes.AddPicture gwordscreenshotpath &gResultFolderName &  "\Screenshot.png",False,True
    WordObj.Selection.InsertBreak
    Reportstep "Capture screenshot fo the current window to word document", "Capture screenshot of current window should be successful to a word document", "Capture screenshot of current window to word document is successful", pass
Else
    Reportstep "Capture screenshot fo the current window to word document", "Capture screenshot of current window should be successful to a word document", "Capture screenshot of current window to word document skipped", pass
End if
End Sub
'-----------------------------------------------------------------------------------------------------------------------
