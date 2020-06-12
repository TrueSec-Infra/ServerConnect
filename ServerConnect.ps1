$DLL = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
Add-Type -MemberDefinition $DLL -name NativeMethods -namespace Win32
$Process = (Get-Process PowerShell | Where-Object MainWindowTitle -like '*Server Connect*').MainWindowHandle
# Minimize window
[Win32.NativeMethods]::ShowWindowAsync($Process, 2)

#Get Env:
$RootFolder = $MyInvocation.MyCommand.Path | Split-Path -Parent
#$RootFolder = "c:\serverconnect"
#Get Data
[XML]$XMLData = Get-Content -Path "$RootFolder\serverlist.xml"

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#region begin GUI{ 

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '700,350'
$Form.text                       = "Form"
$Form.TopMost                    = $false

$Button3                         = New-Object system.Windows.Forms.Button
$Button3.text                    = "Connect RDP"
$Button3.width                   = 150
$Button3.height                  = 23
$Button3.location                = New-Object System.Drawing.Point(150,114)
$Button3.Font                    = 'Microsoft Sans Serif,10'

$Button4                         = New-Object system.Windows.Forms.Button
$Button4.text                    = "Restart Windows"
$Button4.width                   = 150
$Button4.height                  = 23
$Button4.location                = New-Object System.Drawing.Point(150,144)
$Button4.Font                    = 'Microsoft Sans Serif,10'

$Button5                         = New-Object system.Windows.Forms.Button
$Button5.text                    = "Shutdown Windows"
$Button5.width                   = 150
$Button5.height                  = 23
$Button5.location                = New-Object System.Drawing.Point(150,174)
$Button5.Font                    = 'Microsoft Sans Serif,10'

$Button6                         = New-Object system.Windows.Forms.Button
$Button6.text                    = "Ping Windows"
$Button6.width                   = 150
$Button6.height                  = 23
$Button6.location                = New-Object System.Drawing.Point(150,204)
$Button6.Font                    = 'Microsoft Sans Serif,10'

$Button7                         = New-Object system.Windows.Forms.Button
$Button7.text                    = "Connect OOB KVM"
$Button7.width                   = 150
$Button7.height                  = 23
$Button7.location                = New-Object System.Drawing.Point(350,24)
$Button7.Font                    = 'Microsoft Sans Serif,10'

$Button8                         = New-Object system.Windows.Forms.Button
$Button8.text                    = "Connect OOB WEB"
$Button8.width                   = 150
$Button8.height                  = 23
$Button8.location                = New-Object System.Drawing.Point(350,54)
$Button8.Font                    = 'Microsoft Sans Serif,10'

$Button9                         = New-Object system.Windows.Forms.Button
$Button9.text                    = "Power off using OOB"
$Button9.width                   = 150
$Button9.height                  = 23
$Button9.location                = New-Object System.Drawing.Point(350,84)
$Button9.Font                    = 'Microsoft Sans Serif,10'

$Button10                         = New-Object system.Windows.Forms.Button
$Button10.text                    = "Power on using OOB"
$Button10.width                   = 150
$Button10.height                  = 23
$Button10.location                = New-Object System.Drawing.Point(350,114)
$Button10.Font                    = 'Microsoft Sans Serif,10'

$Button11                         = New-Object system.Windows.Forms.Button
$Button11.text                    = "Cold boot using OOB"
$Button11.width                   = 150
$Button11.height                  = 23
$Button11.location                = New-Object System.Drawing.Point(350,144)
$Button11.Font                    = 'Microsoft Sans Serif,10'

$Button12                         = New-Object system.Windows.Forms.Button
$Button12.text                    = "Ping OOB"
$Button12.width                   = 150
$Button12.height                  = 23
$Button12.location                = New-Object System.Drawing.Point(350,174)
$Button12.Font                    = 'Microsoft Sans Serif,10'

$Button13                         = New-Object system.Windows.Forms.Button
$Button13.text                    = "Get MDT ODATA"
$Button13.width                   = 150
$Button13.height                  = 23
$Button13.location                = New-Object System.Drawing.Point(350,234)
$Button13.Font                    = 'Microsoft Sans Serif,10'

$ButtonClose                     = New-Object system.Windows.Forms.Button
$ButtonClose.text                = "Close"
$ButtonClose.width               = 150
$ButtonClose.height              = 75
$ButtonClose.location            = New-Object System.Drawing.Point(530,250)
$ButtonClose.Font                = 'Microsoft Sans Serif,10'

$ListBox1                        = New-Object system.Windows.Forms.ListBox
$ListBox1.text                   = "listBox"
$ListBox1.width                  = 120
$ListBox1.height                 = 300
$ListBox1.location               = New-Object System.Drawing.Point(19,24)
$listBox1.font                   = 'Microsoft Sans Serif,10'

$PictureBox1 = New-Object system.Windows.Forms.PictureBox
$PictureBox1.width = 150
$PictureBox1.height  = 130
$PictureBox1.location  = New-Object System.Drawing.Point(530,15)
$PictureBox1.imageLocation  = "$RootFolder\image.png"
$PictureBox1.SizeMode  = [System.Windows.Forms.PictureBoxSizeMode]::zoom

$Form.controls.AddRange(@($Button3,$Button4,$Button5,$Button6,$Button7,$Button8,$Button9,$Button10,$Button11,$Button12,$Button13,$ButtonClose,$ListBox1,$PictureBox1))

#region gui events {
$Button3.Add_Click({ Connect3 })
$Button4.Add_Click({ Connect4 })
$Button5.Add_Click({ Connect5 })
$Button6.Add_Click({ Connect6 })
$Button7.Add_Click({ Connect7 })
$Button8.Add_Click({ Connect8 })
$Button9.Add_Click({ Connect9 })
$Button10.Add_Click({ Connect10 })
$Button11.Add_Click({ Connect11 })
$Button12.Add_Click({ Connect12 })
$Button13.Add_Click({ Connect13 })
$ButtonClose.Add_Click({ Close })
#endregion events }

#endregion GUI }


#Write your logic code here
Function Close{
    $Form.Close()
}

#Connect using RDP
Function Connect3{
    $Selection1 = $ListBox1.SelectedItem
    $Server = $XMLdata.Settings.Servers.Server | Where-Object Name -EQ $Selection1
    Start mstsc.exe -ArgumentList "/v:$($Server.Name)"
}

#Restart Windows
Function Connect4{
    $Selection1 = $ListBox1.SelectedItem
    $Server = $XMLdata.Settings.Servers.Server | Where-Object Name -EQ $Selection1
    Start PowerShell -ArgumentList "Restart-Computer -ComputerName $($Server.Name) -Force"
}

#Shutdown Windows
Function Connect5{
    $Selection1 = $ListBox1.SelectedItem
    $Server = $XMLdata.Settings.Servers.Server | Where-Object Name -EQ $Selection1
    Start PowerShell -ArgumentList "Stop-Computer -ComputerName $($Server.Name) -Force"
}

#Ping Windows
Function Connect6{
    $Selection1 = $ListBox1.SelectedItem
    $Server = $XMLdata.Settings.Servers.Server | Where-Object Name -EQ $Selection1
    Start PowerShell -ArgumentList "Ping $($Server.Name)"
}

#Connect OOB KVM
Function Connect7{
    $Selection1 = $ListBox1.SelectedItem
    $Server = $XMLdata.Settings.Servers.Server | Where-Object Name -EQ $Selection1
    & 'C:\Program Files (x86)\Hewlett Packard Enterprise\HPE iLO Integrated Remote Console\HPLOCONS.exe' -addr $Server.OOBIP -name $server.OOBUserName -password $server.OOBPassword
}

#Connect OOB web
Function Connect8{
    $Selection1 = $ListBox1.SelectedItem
    $Server = $XMLdata.Settings.Servers.Server | Where-Object Name -EQ $Selection1
    start http://$($Server.OOBIP)
}

#Power off OOB
Function Connect9{
    $Selection1 = $ListBox1.SelectedItem
    $Server = $XMLdata.Settings.Servers.Server | Where-Object Name -EQ $Selection1
    Start PowerShell -ArgumentList "$RootFolder\Stop-TSxIPMIDevice.ps1 -OOBIP $($Server.OOBIP) -OOBUsername $($Server.OOBUsername) -OOBPassword $($Server.OOBPassword)"

}

#Power on OOB
Function Connect10{
    $Selection1 = $ListBox1.SelectedItem
    $Server = $XMLdata.Settings.Servers.Server | Where-Object Name -EQ $Selection1
    Start PowerShell -ArgumentList "$RootFolder\Start-TSxIPMIDevice.ps1 -OOBIP $($Server.OOBIP) -OOBUsername $($Server.OOBUsername) -OOBPassword $($Server.OOBPassword)"
}

#Cold restart OOB
Function Connect11{
    $Selection1 = $ListBox1.SelectedItem
    $Server = $XMLdata.Settings.Servers.Server | Where-Object Name -EQ $Selection1
    Start PowerShell -ArgumentList "$RootFolder\Stop-TSxIPMIDevice.ps1 -OOBIP $($Server.OOBIP) -OOBUsername $($Server.OOBUsername) -OOBPassword $($Server.OOBPassword)"
    Start-Sleep -Seconds 5
    Start PowerShell -ArgumentList "$RootFolder\Start-TSxIPMIDevice.ps1 -OOBIP $($Server.OOBIP) -OOBUsername $($Server.OOBUsername) -OOBPassword $($Server.OOBPassword)"
}

#Ping OOB
Function Connect12{
    $Selection1 = $ListBox1.SelectedItem
    $Server = $XMLdata.Settings.Servers.Server | Where-Object Name -EQ $Selection1
    Start PowerShell -ArgumentList "Ping $($Server.OOBIP)"
}

#GetMDTOdata
Function Connect13{
    $Selection1 = $ListBox1.SelectedItem
    Import-Module -Name GetMDTOdataModule -Force
    $Server = $XMLdata.Settings.Servers.Server | Where-Object Name -EQ $Selection1
    Start PowerShell -ArgumentList "Get-MDTOData -MDTMonitorServer SRVMDT01 | Where-Object Name -EQ $($Server.Name);'Press ENTER...';Read-Host"
}

foreach($item in $($XMLdata.Settings.Servers).server.name){
    [void] $ListBox1.Items.Add($item)
}

[void]$Form.ShowDialog()

#