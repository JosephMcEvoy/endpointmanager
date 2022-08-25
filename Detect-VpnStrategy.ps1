<#

.SYNOPSIS
    PowerShell script to detect the VpnStrategy value in raspshone.pbk for Always On VPN user tunnel connections.

.EXAMPLE
    .\Detect-VpnStrategy.ps1

.DESCRIPTION
    This PowerShell script is deployed as a detection script using Proactive Remediations in Microsoft Endpoint Manager/Intune.

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

Try {

    If ((Test-Path $RasphonePath) -eq $False) {

        Write-Warning 'Rasphone.pbk not found.'
        Exit 0

    }

    $RasphoneData = (Get-Content $RasphonePath | Select-String VpnStrategy) | ConvertFrom-StringData

    # // 5 = SSTP only, 6 = SSTP first, 7 = IKEv2 only, 8 = IKEv2 first, 14 = IKEv2 first, then SSTP
    If ($RasphoneData.VpnStrategy -ne '14') {

        Write-Verbose 'VpnStrategy is incorrect. Remediation required.'
        Exit 1

    }
    
    Else { 

        Write-Verbose 'VpnStrategy is correct. No remediation required.'
        Exit 0
        
    }

}

Catch {

    $ErrorMessage = $_.Exception.Message 
    Write-Warning $ErrorMessage
    Exit 1

}
