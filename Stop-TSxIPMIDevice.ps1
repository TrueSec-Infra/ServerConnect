#Stop IPMI Device
Param(
    $OOBIP,
    $OOBUserName,
    $OOBPassword
)

$cred = New-Object System.Management.Automation.PSCredential ($OOBUserName, (ConvertTo-SecureString $OOBPassword -AsPlainText -Force))
Get-PcsvDevice -TargetAddress $OOBIP -Credential $Cred -ManagementProtocol IPMI -SkipRevocationCheck -TimeoutSec 5
Stop-PcsvDevice -TargetAddress $OOBIP -Credential $Cred -ManagementProtocol IPMI -SkipRevocationCheck -TimeoutSec 5 -Confirm:$false
