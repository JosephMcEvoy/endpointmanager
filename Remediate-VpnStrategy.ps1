<#

.SYNOPSIS
    PowerShell script to update the VPN Strategy value in raspshone.pbk for Always On VPN user tunnel connections.

.EXAMPLE
    .\Remediate-VpnStrategy.ps1

.DESCRIPTION
    This PowerShell script is deployed as a remediation script using Proactive Remediations in Microsoft Endpoint Manager/Intune.

.LINK
    https://docs.microsoft.com/en-us/mem/analytics/proactive-remediations

.LINK
    https://directaccess.richardhicks.com/

.NOTES
    Version:        1.0
    Creation Date:  November 2, 2021
    Last Updated:   November 2, 2021
    Author:         Richard Hicks
    Organization:   Richard M. Hicks Consulting, Inc.
    Contact:        rich@richardhicks.com
    Web Site:       https://directaccess.richardhicks.com/

#>

[CmdletBinding()]

Param (

)

$RasphonePath = Join-Path -Path $env:appdata -ChildPath '\Microsoft\Network\Connections\Pbk\rasphone.pbk'
$RasphoneData = Get-Content $RasphonePath

Try {

    Write-Verbose 'Updating VpnStrategy setting in rasphone.pbk...'
    # // 5 = SSTP only, 6 = SSTP first, 7 = IKEv2 only, 8 = IKEv2 first, 14 = IKEv2 first, then SSTP
    $RasphoneData | ForEach-Object { $_ -Replace 'VpnStrategy=.*', 'VpnStrategy=14' } | Set-Content -Path $RasphonePath -Force

}

Catch {

    $ErrorMessage = $_.Exception.Message 
    Write-Warning $ErrorMessage
    Exit 1

}
