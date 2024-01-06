#Persistent ; Keep the script running until the user exits it.
Width := 500
Height := 500
ChosenHotkey := "F12"
CircleColor := "ff0000"  ; Default color
Transparency := 100 ; Default transparency

; Load saved settings
LoadSettings(Width, Height, ChosenHotkey, CircleColor, Transparency)

SetTimer, SetupHotkey, 100
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, AuraSettings, ChangeParameters
return

SetupHotkey:
    SetTimer, SetupHotkey, Off
    Hotkey, %ChosenHotkey%, ToggleCircle
    return

ToggleCircle:
    If (hCircleWindow := WinExist("ahk_class AutoHotkeyGUI"))
    {
        Gui, 2:Hide
    }
    else
    {
        ShowCircle(Width, Height, Transparency, CircleColor)
    }
    return

ShowCircle(Width, Height,Transparency, Color)
{
    Gui, 2:+AlwaysOnTop -Caption +LastFound -SysMenu +ToolWindow -DPIScale +E0x20
    WinSet, Transparent, %Transparency%
    Gui, 2:Color, %Color%
    Gui, 2:Show,% "w" Width " h" Height " x" (A_ScreenWidth-Width)//2 " y" (A_ScreenHeight-Height)//2 " NoActivate"
    WinSet, Region, % "0-0 w" Width " h" Height " E"
}

ChangeParameters:
    Gui, Settings:New
    Gui, Settings:+AlwaysOnTop
    Gui, Settings:Margin, 40, 40
    Gui, Settings:Add, Text, x10 y10, Width:
    Gui, Settings:Add, Edit, x60 y10 w100 vNewWidth, %Width%
    Gui, Settings:Add, Text, x10 y40, Height:
    Gui, Settings:Add, Edit, x60 y40 w100 vNewHeight, %Height%
    Gui, Settings:Add, Text, x10 y70, Hotkey:
    Gui, Settings:Add, Hotkey, x60 y70 w100 vNewHotkey, %ChosenHotkey%
    Gui, Settings:Add, Text, x10 y100, Color:
    Gui, Settings:Add, Edit, x60 y100 w100 vNewColor, %CircleColor%
    Gui, Settings:Add, Text, x10 y130, Transparency:
    Gui, Settings:Add, Slider, Range0-255 x60 y130 w100 vNewTransparency, %Transparency%
    Gui, Settings:Add, Button, x10 y160 w80 h30 gApplySettings, Apply
    Gui, Settings:Add, Button, x100 y160 w80 h30 gSettingsCancel, Cancel
    Gui, Settings:Show
    return


ApplySettings:
    Gui, Settings:Submit
    Width := NewWidth
    Height := NewHeight
    CircleColor := NewColor
    Transparency := NewTransparency

    ; Unregister the previous hotkey
    Hotkey, %ChosenHotkey%, Off
    ChosenHotkey := NewHotkey  ; Update ChosenHotkey to the new hotkey

    ; Register the new hotkey
    Hotkey, %ChosenHotkey%, ToggleCircle, On

    ; Save settings
    SaveSettings(Width, Height, ChosenHotkey, CircleColor, Transparency)

    Gui, Settings:Hide
    return

SettingsCancel:
    Gui, Settings:Cancel
    return

LoadSettings(ByRef Width, ByRef Height, ByRef ChosenHotkey, ByRef CircleColor, ByRef Transparency)
{
    ; Load settings from file
    if (FileExist("settings.ini"))
    {
        IniRead, Width, settings.ini, General, Width, %Width%
        IniRead, Height, settings.ini, General, Height, %Height%
        IniRead, ChosenHotkey, settings.ini, General, ChosenHotkey, %ChosenHotkey%
        IniRead, CircleColor, settings.ini, General, CircleColor, %CircleColor%
        IniRead, Transparency, settings.ini, General, Transparency, %Transparency%
    }
}

SaveSettings(Width, Height, ChosenHotkey, CircleColor, Transparency)
{
    ; Save settings to file
    IniWrite, %Width%, settings.ini, General, Width
    IniWrite, %Height%, settings.ini, General, Height
    IniWrite, %ChosenHotkey%, settings.ini, General, ChosenHotkey
    IniWrite, %CircleColor%, settings.ini, General, CircleColor
    IniWrite, %Transparency%, settings.ini, General, Transparency
}
