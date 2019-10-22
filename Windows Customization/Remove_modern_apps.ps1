$AppsList = "Microsoft.MicrosoftOfficeHub", # Get Office
    "Microsoft.SkypeApp", # Get Skype
    "microsoft.windowscommunicationsapps", # Mail & Calendar
    "Microsoft.People", # People
    "Microsoft.CommsPhone", # Phone
    "Microsoft.WindowsPhone", # Phone Companion
    "Microsoft.XboxApp", # Xbox
    "Microsoft.Messaging", # Messaging & Skype
    "Microsoft.MicrosoftSolitaireCollection", # Microsoft Solitaire Collection
    "Microsoft.Microsoft3DViewer",
    "Microsoft.BingWeather",
    "Microsoft.GetHelp",
    "Microsoft.GetStarted",
    "Microsoft.Office.OneNote",
    "Microsoft.WindowsMaps",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.StorePurchaseApp",
    "Microsoft.BingNews",
    "Microsoft.Office.Sway",
    "Microsoft.WindowsStore",
    "D5EA27B7.Duolingo-LearnLanguagesforFree",
    "Microsoft.BingTranslator",
    "Microsoft.NetworkSpeedtest",
    "Microsoft.RemoteDesktop",
    "46928bounde.EclipseManager",
    "Microsoft.WindowsFeedbackHub"
    
    ForEach ($App in $AppsList)
    {
        $Packages = Get-AppxPackage | Where-Object {$_.Name -eq $App}
        if ($Packages -ne $null)
        {
            "Removing Appx Package: $App"
            foreach ($Package in $Packages) { Remove-AppxPackage -package $Package.PackageFullName }
        }
        else { "Unable to find package: $App" }
    
        $ProvisionedPackage = Get-AppxProvisionedPackage -online | Where-Object {$_.displayName -eq $App}
        if ($ProvisionedPackage -ne $null)
        {
            "Removing Appx Provisioned Package: $App"
            remove-AppxProvisionedPackage -online -packagename $ProvisionedPackage.PackageName
        }
        else { "Unable to find provisioned package: $App" }
    }