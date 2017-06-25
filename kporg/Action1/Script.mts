device("DUT").Open
wait 5
Device("DUT").Applications.Start "name=KP"
wait 7
Device("DUT").MNativeElement("userid").Set "testing"
Device("DUT").MNativeElement("password").Set "password7"
Device("DUT").MNativeElement("signon").Click
wait 7
Device("DUT").PressKey "HOME"
wait 3
Device("DUT").Applications.Close "name=KP"
wait 2
device("DUT").Close


'Device("DUT").MNativeElement("MNativeElement").Set "hari"







