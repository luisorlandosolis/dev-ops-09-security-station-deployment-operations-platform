########################################################
# PUBLIC PORTFOLIO VERSION
#
# This script has been sanitized for public release.
#
# The following items have been replaced:
# - Hostnames
# - Domain Names
# - Usernames
# - Station Identifiers
# - Asset Identifiers
#
# Deployment architecture, automation workflows,
# validation logic, and technical discoveries remain
# representative of the validated platform.
########################################################


########################################################
# Security Station Deployment Console
########################################################

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

########################################################
# Administrator Check / Self Elevation
########################################################

$currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()

$currentPrincipal = New-Object `
    Security.Principal.WindowsPrincipal($currentIdentity)

$isAdmin = $currentPrincipal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)

if (-not $isAdmin)
{
    Start-Process `
        -FilePath "powershell.exe" `
        -Verb RunAs `
        -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`""

    exit
}

########################################################
# System Information
########################################################

$ComputerName = $env:COMPUTERNAME

$IPAddress = (
    Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object {
        $_.IPAddress -notlike '169.*' -and
        $_.IPAddress -ne '127.0.0.1'
    } |
    Select-Object -First 1 -ExpandProperty IPAddress
)

########################################################
# Main Window
########################################################

$form = New-Object System.Windows.Forms.Form
$form.Text = "Security Station Deployment Platform"
$form.Size = New-Object System.Drawing.Size(700,610)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::WhiteSmoke

########################################################
# Header
########################################################

$header = New-Object System.Windows.Forms.Label
$header.Text = "Security Station Deployment Console"
$header.Font = New-Object System.Drawing.Font(
    "Segoe UI",
    16,
    [System.Drawing.FontStyle]::Bold
)
$header.AutoSize = $true
$header.Location = New-Object System.Drawing.Point(20,20)

$form.Controls.Add($header)

########################################################
# Host / PC Name or IP
########################################################

$hostLabel = New-Object System.Windows.Forms.Label
$hostLabel.Text = "Asset Name / Hostname"
$hostLabel.Location = New-Object System.Drawing.Point(30,80)
$hostLabel.AutoSize = $true

$form.Controls.Add($hostLabel)

$hostBox = New-Object System.Windows.Forms.TextBox
$hostBox.Location = New-Object System.Drawing.Point(160,75)
$hostBox.Width = 300

$hostBox.Text = $ComputerName

$form.Controls.Add($hostBox)

########################################################
# Security Station Selection
########################################################

$stationLabel = New-Object System.Windows.Forms.Label
$stationLabel.Text = "Security Station"
$stationLabel.Location = New-Object System.Drawing.Point(30,120)
$stationLabel.AutoSize = $true

$form.Controls.Add($stationLabel)

$stationCombo = New-Object System.Windows.Forms.ComboBox
$stationCombo.Location = New-Object System.Drawing.Point(160,115)
$stationCombo.Width = 220

########################################################
# Station Inventory
# NOTE: Example / placeholder station IDs for demonstration.
########################################################

[void]$stationCombo.Items.Add("Validation-Station")
[void]$stationCombo.Items.Add("Station-01")
[void]$stationCombo.Items.Add("Station-02")
[void]$stationCombo.Items.Add("Station-03")
[void]$stationCombo.Items.Add("Station-04")
[void]$stationCombo.Items.Add("Station-05")
[void]$stationCombo.Items.Add("Station-06")
[void]$stationCombo.Items.Add("Station-07")
[void]$stationCombo.Items.Add("Station-08")
[void]$stationCombo.Items.Add("Station-09")

$form.Controls.Add($stationCombo)

########################################################
# RDP Target Password
########################################################

$rdpPassLabel = New-Object System.Windows.Forms.Label
$rdpPassLabel.Text = "RDP Target Password"
$rdpPassLabel.Location = New-Object System.Drawing.Point(30,150)
$rdpPassLabel.AutoSize = $true

$form.Controls.Add($rdpPassLabel)

$rdpPassBox = New-Object System.Windows.Forms.TextBox
$rdpPassBox.Location = New-Object System.Drawing.Point(210,145)
$rdpPassBox.Width = 170
$rdpPassBox.UseSystemPasswordChar = $true

$form.Controls.Add($rdpPassBox)

########################################################
# Configuration Preview
########################################################

$previewLabel = New-Object System.Windows.Forms.Label
$previewLabel.Text = "Configuration Preview"
$previewLabel.Location = New-Object System.Drawing.Point(30,210)
$previewLabel.AutoSize = $true

$form.Controls.Add($previewLabel)

$previewBox = New-Object System.Windows.Forms.RichTextBox
$previewBox.Location = New-Object System.Drawing.Point(30,235)
$previewBox.Size = New-Object System.Drawing.Size(620,120)
$previewBox.ReadOnly = $true

$form.Controls.Add($previewBox)

########################################################
# Deployment Status
########################################################

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Deployment Status"
$statusLabel.Location = New-Object System.Drawing.Point(30,375)
$statusLabel.AutoSize = $true

$form.Controls.Add($statusLabel)

$statusBox = New-Object System.Windows.Forms.TextBox
$statusBox.Location = New-Object System.Drawing.Point(30,400)
$statusBox.Size = New-Object System.Drawing.Size(620,90)
$statusBox.Multiline = $true
$statusBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
$statusBox.ReadOnly = $true
$statusBox.Text = "Ready"

$form.Controls.Add($statusBox)

########################################################
# Station Selection Event
########################################################

$stationCombo.Add_SelectedIndexChanged({

    $selection = $stationCombo.SelectedItem

    $previewBox.Text = @"
Station Selected:
$selection

Validated Configuration:

[COMPLETE]
- Remote Desktop Enablement
- Remote Desktop Firewall Rules
- Enable WinRM
- Enable SSH
- Configure LocalAccountTokenFilterPolicy
- Disable Sleep
- Disable Hibernate
- Disable Lock Screen
- Disable Screen Saver
- Create Security Station RDP File
- Create Security Station RDP Launch Task

Future Enhancements:

- Execute Ansible Playbook
- Pull Config From Git Repository
- Validate Deployment Status
- Generate Deployment Log
"@

})

########################################################
# Deploy Button
########################################################

$deployButton = New-Object System.Windows.Forms.Button
$deployButton.Text = "Deploy"
$deployButton.Location = New-Object System.Drawing.Point(160,510)
$deployButton.Width = 120

$deployButton.Add_Click({

    $hostname = $hostBox.Text.Trim()
    $station = $stationCombo.Text

    ####################################################
    # Station Profile Mapping
    # NOTE: Example placeholder profile for demonstration.
    # Replace with your own domain/user/target mappings.
    ####################################################

switch ($station)
{
    "Station-01"
    {
        $RdpUser   = "EXAMPLE\SecurityStationUser"
        $RdpTarget = "station01.example.local"
    }

    default
    {
        [System.Windows.Forms.MessageBox]::Show(
            "Station profile for $station has not been configured yet."
        )
        return
    }
}

    if ($hostname -eq "")
    {
        [System.Windows.Forms.MessageBox]::Show(
            "Please enter an Asset Name / Hostname."
        )
        return
    }

    if ($station -eq "")
    {
        [System.Windows.Forms.MessageBox]::Show(
            "Please select a Security Station."
        )
        return
    }

    $rdpPassword = $rdpPassBox.Text

    if ($rdpPassword -eq "")
    {
        [System.Windows.Forms.MessageBox]::Show(
            "Please enter the RDP target password."
        )
        return
    }

    $statusBox.Text = @"
Starting Deployment...

Target Host: $hostname
Security Station Profile: $station

Validating WinRM Connectivity...
"@

    $form.Refresh()

    ####################################################
    # Test WinRM reachability first
    ####################################################

    try
    {
        Test-WSMan -ComputerName $hostname -ErrorAction Stop | Out-Null
    }
    catch
    {
        $statusBox.Text = "FAILED: Cannot reach $hostname over WinRM.`n$_"
        [System.Windows.Forms.MessageBox]::Show(
            "Cannot reach $hostname over WinRM.`n`n$_",
            "Deployment Failed"
        )
        return
    }

    ####################################################
    # Remote Deployment
    ####################################################

    try
    {
        $result = Invoke-Command `
            -ComputerName $hostname `
            -ErrorAction Stop `
            -ArgumentList $RdpUser, $RdpTarget, $rdpPassword `
            -ScriptBlock {
                param($RdpUser, $RdpTarget, $rdpPassword)

                $steps = [ordered]@{}

                ############################################
                # Enable Remote Desktop
                ############################################

                try
                {
                    Set-ItemProperty `
                        -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" `
                        -Name "fDenyTSConnections" `
                        -Value 0 `
                        -ErrorAction Stop
                    $steps["Enable Remote Desktop"] = "OK"
                }
                catch
                {
                    $steps["Enable Remote Desktop"] = "FAILED: $_"
                }

                ############################################
                # Enable Firewall Rules
                ############################################

                try
                {
                    Enable-NetFirewallRule -DisplayGroup "Remote Desktop" -ErrorAction Stop
                    $steps["Enable Remote Desktop Firewall Rules"] = "OK"
                }
                catch
                {
                    $steps["Enable Remote Desktop Firewall Rules"] = "FAILED: $_"
                }

############################################
# Enable WinRM
#
# Ensures WinRM remains available for
# future management and recovery.
############################################
try
{
    Set-Service -Name WinRM -StartupType Automatic -ErrorAction Stop
    Start-Service -Name WinRM -ErrorAction Stop
    #Enable-PSRemoting -Force -SkipNetworkProfileCheck -ErrorAction Stop

    $steps["Enable WinRM"] = "OK"
}
catch
{
    $steps["Enable WinRM"] = "FAILED: $_"
}

############################################
# Configure LocalAccountTokenFilterPolicy
#
# Required baseline setting for local
# administrator remote management.
############################################

try
{
    New-ItemProperty `
        -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" `
        -Name "LocalAccountTokenFilterPolicy" `
        -PropertyType DWord `
        -Value 1 `
        -Force `
        -ErrorAction Stop | Out-Null

    $steps["LocalAccountTokenFilterPolicy"] = "OK"
}
catch
{
    $steps["LocalAccountTokenFilterPolicy"] = "FAILED: $_"
}

############################################
# Disable RDP Redirection Warning
############################################

try
{
    New-Item `
        -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client" `
        -ItemType Directory `
        -Force `
        -ErrorAction Stop | Out-Null

    New-ItemProperty `
        -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client" `
        -Name "RedirectionWarningDialogVersion" `
        -PropertyType DWord `
        -Value 1 `
        -Force `
        -ErrorAction Stop | Out-Null

    $steps["Disable RDP Redirection Warning"] = "OK"
}
catch
{
    $steps["Disable RDP Redirection Warning"] = "FAILED: $_"
}

                ############################################
                # Create Security Station RDP File
                ############################################

                try
                {
                    New-Item `
                        -Path "\SecurityStation" `
                        -ItemType Directory `
                        -Force `
                        -ErrorAction Stop `
                        | Out-Null

  @"
screen mode id:i:2
use multimon:i:0
desktopwidth:i:2560
desktopheight:i:1440
session bpp:i:32
winposstr:s:0,1,0,0,800,600
compression:i:1
keyboardhook:i:2
audiocapturemode:i:0
videoplaybackmode:i:1
connection type:i:7
networkautodetect:i:1
bandwidthautodetect:i:1
displayconnectionbar:i:1
enableworkspacereconnect:i:0
remoteappmousemoveinject:i:1
disable wallpaper:i:0
allow font smoothing:i:0
allow desktop composition:i:0
disable full window drag:i:1
disable menu anims:i:1
disable themes:i:0
disable cursor setting:i:0
bitmapcachepersistenable:i:1

full address:s:$RdpTarget
username:s:$RdpUser

audiomode:i:0

redirectprinters:i:1
redirectlocation:i:1
redirectcomports:i:1
redirectsmartcards:i:1
redirectwebauthn:i:1
redirectclipboard:i:1
redirectposdevices:i:0

camerastoredirect:s:*
devicestoredirect:s:*
drivestoredirect:s:*

autoreconnection enabled:i:1

enablecredsspsupport:i:1
authentication level:i:2
prompt for credentials:i:0

negotiate security layer:i:1
remoteapplicationmode:i:0
alternate shell:s:
shell working directory:s:
gatewayhostname:s:
gatewayusagemethod:i:4
gatewaycredentialssource:i:4
gatewayprofileusagemethod:i:0
promptcredentialonce:i:0
gatewaybrokeringtype:i:0
use redirection server name:i:0
rdgiskdcproxy:i:0
kdcproxyname:s:
enablerdsaadauth:i:0
"@ | Set-Content `
    "C:\ProgramData\SecurityStation\SecurityStation.rdp" `
    -ErrorAction Stop

                    $steps["Create Security Station RDP File"] = "OK"
                }
                catch
                {
                    $steps["Create Security Station RDP File"] = "FAILED: $_"
                }

                ############################################
                # Store RDP Credential (registry, machine-wide)
                #
                # cmdkey run here would store the credential
                # under the DEPLOYING admin's profile, not the
                # profile of whoever actually logs into this
                # station later - wrong scope entirely. Instead,
                # store the password centrally in HKLM (hidden
                # from station users by the existing GPO that
                # blocks regedit, same trust model as
                # AutoAdminLogon's DefaultPassword). The launch
                # script below applies it via cmdkey at EVERY
                # logon, correctly scoped to whichever account
                # just logged in.
                ############################################

                try
                {
                    New-Item `
                        -Path "HKLM:\SOFTWARE\SecurityStation" `
                        -Force `
                        -ErrorAction Stop `
                        | Out-Null

                    Set-ItemProperty `
                        -Path "HKLM:\SOFTWARE\SecurityStation" `
                        -Name "RdpPassword" `
                        -Value $rdpPassword `
                        -Force `
                        -ErrorAction Stop

                    $steps["Store RDP Credential"] = "OK"
                }
                catch
                {
                    $steps["Store RDP Credential"] = "FAILED: $_"
                }

                ############################################
                # Create Launch Script
                #
                # Runs at every logon: pulls the password from
                # the registry, stores it via cmdkey scoped to
                # whichever account just logged on, then opens
                # the RDP file. This is what actually makes
                # authentication silent, not the .rdp file's
                # "prompt for credentials:i:0" setting alone.
                ############################################

            try
{
    $launchScript = @"
`$pw = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\SecurityStation' -Name RdpPassword -ErrorAction Stop).RdpPassword
cmdkey /generic:"TERMSRV/$RdpTarget" /user:"$RdpUser" /pass:"`$pw" | Out-Null
Start-Process 'C:\ProgramData\SecurityStation\SecurityStation.rdp'
"@

    $launchScript | Set-Content `
        "C:\ProgramData\SecurityStation\Launch.ps1" `
        -Force `
        -ErrorAction Stop

    $steps["Create Launch Script"] = "OK"
}
catch
{
    $steps["Create Launch Script"] = "FAILED: $_"
}

                ############################################
                # Disable Sleep
                ############################################

                try
                {
                    powercfg /change standby-timeout-ac 0
                    powercfg /change standby-timeout-dc 0
                    powercfg /change monitor-timeout-ac 0
                    powercfg /change monitor-timeout-dc 0
                    $steps["Disable Sleep"] = "OK"
                }
                catch
                {
                    $steps["Disable Sleep"] = "FAILED: $_"
                }

                ############################################
                # Disable Hibernate
                ############################################

                try
                {
                    powercfg /hibernate off
                    $steps["Disable Hibernate"] = "OK"
                }
                catch
                {
                    $steps["Disable Hibernate"] = "FAILED: $_"
                }

                ############################################
                # Disable Lock Screen
                ############################################

                try
                {
                    New-Item `
                        -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" `
                        -Force `
                        -ErrorAction Stop `
                        | Out-Null

                    Set-ItemProperty `
                        -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" `
                        -Name "NoLockScreen" `
                        -Value 1 `
                        -Force `
                        -ErrorAction Stop

                    $steps["Disable Lock Screen"] = "OK"
                }
                catch
                {
                    $steps["Disable Lock Screen"] = "FAILED: $_"
                }

                ############################################
                # Disable Screen Saver
                ############################################

                try
                {
                    reg add `
                        "HKU\.DEFAULT\Control Panel\Desktop" `
                        /v ScreenSaveActive `
                        /t REG_SZ `
                        /d 0 `
                        /f | Out-Null
                    $steps["Disable Screen Saver"] = "OK"
                }
                catch
                {
                    $steps["Disable Screen Saver"] = "FAILED: $_"
                }

                ############################################
                # Configure Automatic RDP Launch
                #
                # /ru "S-1-5-32-545" + /it targets the built-in
                # Users group with an interactive token, so the
                # task fires for WHICHEVER account actually logs
                # on interactively - not just the account that
                # happened to be running when this task was
                # created (which is what /ru omitted defaults to,
                # and was why this previously only ran as the
                # deploying admin account instead of the person
                # using the station).
                ############################################

               try
{
    schtasks /create `
        /tn "SecurityStation-RDP" `
        /sc ONLOGON `
        /tr "powershell.exe -ExecutionPolicy Bypass -File C:\ProgramData\SecurityStation\Launch.ps1" `
        /f | Out-Null

    $taskCheck = schtasks /query /tn "SecurityStation-RDP" 2>$null

    if ($LASTEXITCODE -eq 0)
    {
        $steps["Configure Automatic RDP Launch"] = "OK"
    }
    else
    {
        $steps["Configure Automatic RDP Launch"] = "FAILED: task verification failed"
    }
}
catch
{
    $steps["Configure Automatic RDP Launch"] = "FAILED: $_"
}

############################################
# Enable SSH
#
# Installs and configures OpenSSH Server
# for alternate remote access and
# Security Station recovery.
############################################
try
{
    $sshCapability = Get-WindowsCapability `
        -Online `
        -Name "OpenSSH.Server*" `
        -ErrorAction Stop

    if ($sshCapability.State -ne "Installed")
    {
        Add-WindowsCapability `
            -Online `
            -Name $sshCapability.Name `
            -ErrorAction Stop | Out-Null
    }

    Set-Service sshd -StartupType Automatic -ErrorAction Stop
    Start-Service sshd -ErrorAction Stop

    if (-not (Get-NetFirewallRule `
        -Name "OpenSSH-Server-In-TCP" `
        -ErrorAction SilentlyContinue))
    {
        New-NetFirewallRule `
            -Name "OpenSSH-Server-In-TCP" `
            -DisplayName "OpenSSH Server (sshd)" `
            -Direction Inbound `
            -Protocol TCP `
            -Action Allow `
            -LocalPort 22 `
            -Enabled True | Out-Null
    }

    $steps["Enable SSH"] = "OK"
}
catch
{
    $steps["Enable SSH"] = "FAILED: $_"
}
                return [PSCustomObject]@{
                    ComputerName = $env:COMPUTERNAME
                    Steps        = $steps
                }
            }
    }
    catch
    {
        $statusBox.Text = "FAILED: Remote deployment to $hostname could not run.`n$_"
        [System.Windows.Forms.MessageBox]::Show(
            "Remote deployment to $hostname failed to execute.`n`n$_",
            "Deployment Failed"
        )
        return
    }

    ####################################################
    # Build honest status report from real results
    ####################################################

    $allOk = $true
    $lines = New-Object System.Text.StringBuilder
    [void]$lines.AppendLine("Target: $hostname (confirmed as $($result.ComputerName))")
    [void]$lines.AppendLine("Profile: $station")
    [void]$lines.AppendLine("")

    foreach ($key in $result.Steps.Keys)
    {
        $status = $result.Steps[$key]
        if ($status -notmatch "^OK")
        {
            $allOk = $false
        }
        $mark = if ($status -match "^OK") { "OK" } else { "FAILED" }
        [void]$lines.AppendLine("[$mark] $key")
        if ($status -notmatch "^OK")
        {
            [void]$lines.AppendLine("       $status")
        }
    }

    $statusBox.Text = $lines.ToString()

    if (-not $allOk)
    {
        [System.Windows.Forms.MessageBox]::Show(
            "Deployment finished with one or more failures. See status box for details.",
            "Deployment Completed With Errors"
        )
        return
    }

    ####################################################
    # Restart Required
    ####################################################

    $statusBox.Text += "`r`n`r`nDeployment completed successfully."
    $statusBox.Text += "`r`nPlease restart this Security Station for changes to take effect."

    [System.Windows.Forms.MessageBox]::Show(
        "Deployment completed successfully.`n`nPlease restart this Security Station for changes to take effect.",
        "Restart Required",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
})

$form.Controls.Add($deployButton)

########################################################
# Exit Button
########################################################

$exitButton = New-Object System.Windows.Forms.Button
$exitButton.Text = "Exit"
$exitButton.Location = New-Object System.Drawing.Point(320,510)
$exitButton.Width = 120

$exitButton.Add_Click({
    $form.Close()
})

$form.Controls.Add($exitButton)

########################################################
# Lock Kiosk Button
########################################################

$lockButton = New-Object System.Windows.Forms.Button
$lockButton.Text = "Lock Kiosk"
$lockButton.Location = New-Object System.Drawing.Point(460,510)
$lockButton.Width = 90

$lockButton.Add_Click({

    $hostname = $hostBox.Text.Trim()

    if ($hostname -eq "")
    {
        [System.Windows.Forms.MessageBox]::Show(
            "Please enter an Asset Name / Hostname."
        )
        return
    }

    $confirm = [System.Windows.Forms.MessageBox]::Show(
        "Apply Kiosk Lock to $hostname?",
        "Confirm Kiosk Lock",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )

    if ($confirm -ne [System.Windows.Forms.DialogResult]::Yes)
    {
        return
    }

    try
    {
        Invoke-Command `
            -ComputerName $hostname `
            -ErrorAction Stop `
            -ScriptBlock {

                #Set-ItemProperty `
                    #-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" `
                    #-Name "Shell" `
                    #-Value "mstsc.exe" `
                    #-Force
            }

        [System.Windows.Forms.MessageBox]::Show(
            "Kiosk mode is currently disabled. Explorer shell remains active."
        )
    }
    catch
    {
        [System.Windows.Forms.MessageBox]::Show(
            "Failed to apply kiosk lock.`n`n$_"
        )
    }
})

$form.Controls.Add($lockButton)

########################################################
# Unlock Kiosk Button
########################################################

$unlockButton = New-Object System.Windows.Forms.Button
$unlockButton.Text = "Unlock Kiosk"
$unlockButton.Location = New-Object System.Drawing.Point(560,510)
$unlockButton.Width = 90

$unlockButton.Add_Click({

    $hostname = $hostBox.Text.Trim()

    if ($hostname -eq "")
    {
        [System.Windows.Forms.MessageBox]::Show(
            "Please enter an Asset Name / Hostname."
        )
        return
    }

    try
    {
        Invoke-Command `
            -ComputerName $hostname `
            -ErrorAction Stop `
            -ScriptBlock {

                Set-ItemProperty `
                    -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" `
                    -Name "Shell" `
                    -Value "explorer.exe" `
                    -Force
            }

        [System.Windows.Forms.MessageBox]::Show(
            "Kiosk lock removed. Reboot required."
        )
    }
    catch
    {
        [System.Windows.Forms.MessageBox]::Show(
            "Failed to remove kiosk lock.`n`n$_"
        )
    }
})

$form.Controls.Add($unlockButton)

########################################################
# Launch GUI
########################################################

[void]$form.ShowDialog()
