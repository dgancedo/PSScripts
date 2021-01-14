#Description: Script to create a distribution list to be used as an alias, that grant the send as option missing in O365
#Author: Diego S. Gancedo <dgancedo@trans.com.ar>
#Version: 1.0
#Date: 22/07/2020

$Credentials = Get-Credential # Ask user for credentials to connecto to O365
#
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionURI https://ps.outlook.com/powershell/ -Credential $Credentials -Authentication Basic -AllowRedirection
Import-PSSession $Session

$global:ErrorActionPreference = 'Stop'

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

$continue = 'YES'

while ($continue -eq 'YES') {

    $userok = $false

    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Input UserName'
    $form.Size = New-Object System.Drawing.Size(300, 200)
    $form.StartPosition = 'CenterScreen'

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(75, 120)
    $okButton.Size = New-Object System.Drawing.Size(75, 23)
    $okButton.Text = 'OK'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(150, 120)
    $cancelButton.Size = New-Object System.Drawing.Size(75, 23)
    $cancelButton.Text = 'Cancel'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $label.Size = New-Object System.Drawing.Size(280, 20)
    $label.Text = 'Please enter the Username for the alias:'
    $form.Controls.Add($label)

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10, 40)
    $textBox.Size = New-Object System.Drawing.Size(260, 20)
    $form.Controls.Add($textBox)

    $form.Topmost = $true
    $form.Add_Shown( { $textBox.Select() })

    while ($userok -eq $false) {
        $result = $form.ShowDialog()
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $username = $textBox.Text
            try {
                $userdata = Get-Mailbox $username
                $displayname = $userdata.Name
                $currentemail = $userdata.UserPrincipalName
                $userok = $true

            }
            catch {
                [System.Windows.MessageBox]::Show("Username: $username not found", 'Error', 'OK', 'Error')
            }
    
        }
        else {
            break
        }
    }

    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Select Domain'
    $form.Size = New-Object System.Drawing.Size(300, 200)
    $form.StartPosition = 'CenterScreen'

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(75, 120)
    $okButton.Size = New-Object System.Drawing.Size(75, 23)
    $okButton.Text = 'OK'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(150, 120)
    $cancelButton.Size = New-Object System.Drawing.Size(75, 23)
    $cancelButton.Text = 'Cancel'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $label.Size = New-Object System.Drawing.Size(280, 20)
    $label.Text = 'Select the domain for the alias.:'
    $form.Controls.Add($label)

    $listBox = New-Object System.Windows.Forms.ListBox
    $listBox.Location = New-Object System.Drawing.Point(10, 40)
    $listBox.Size = New-Object System.Drawing.Size(260, 20)
    $listBox.Height = 80

    (get-accepteddomain).DomainName | foreach {
        if ($_ -notmatch "onmicrosoft") {
            [void] $listBox.Items.Add("$_")
        }
    }

    $form.Controls.Add($listBox)
    $form.Topmost = $true
    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $domain = $listBox.SelectedItem
        switch ($domain) {
            'trans.com.ar' {
                $description = "TRANS Industrias Electronicas S.A."
            }
            'trans-iesa.com.ar' {
                $description = "TRANS IESA"
            }
            'trans-comunicaciones.cl' {
                $description = "TRANS Comunicaciones LTDA"
            }
            'transadvanced.tech' {
                $description = "TRANS Advanced Technologies"
            }
        }
    }
    else {
        break
    }

    $msgbox = [System.Windows.MessageBox]::Show("Do you want to create an alias on the domain: $domain for the username: $username ?", 'Confirmation', 'YesNo', 'Question')

    if ($msgbox -eq ' YES' ) {
        $email = $username + "@" + $domain
        $fullname = $displayname + " - " + $description
        try {
            New-DistributionGroup -name $email -type Distribution -DisplayName $fullname -Alias $username -PrimarySmtpAddress $email -Members $currentemail -RequireSenderAuthenticationEnabled $false 
            Add-RecipientPermission $email -AccessRights SendAs -Trustee $currentemail -Confirm:$false
            [System.Windows.MessageBox]::Show("the distribution list $email for $username  was created sucessfully", 'Sucess', 'OK', 'Information')
        }
        catch {
            [System.Windows.MessageBox]::Show("There was an error creating the distribution list", 'Error', 'OK', 'Error')
        }
    }
    else {
        break
    }

    $continue = [System.Windows.MessageBox]::Show("Do you want to create another alias?", 'Confirmation', 'YesNo', 'Question')
}
Remove-PSSession $Session 
