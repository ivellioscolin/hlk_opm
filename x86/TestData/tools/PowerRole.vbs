Dim WshShell, BtnCode
Set WshShell = WScript.CreateObject("WScript.Shell")
Arg0 = Wscript.arguments(0)

'Do Until BtnCode=1
'    Wscript.echo Chr(7)
'    Wscript.echo Chr(7)
    Wscript.echo Chr(7)
    BtnCode = WshShell.Popup(Arg0, 3, "Manual Interaction Required!", vbOkOnly)
'Loop
