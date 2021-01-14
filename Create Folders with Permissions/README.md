# Create.ps1
The intention of this script is to simplify the creation on big amount of folders on file share and create groups for their permitions following the microsoft recomendations

The script create the folder on the share and two groups for the read only and read write permisions, also remove the BUILTIN\Users permission for the folder and grant te created groups with the correspondig permissions.

your need to set the base DN for the group creation and can specify a prefix for the groups.

The script must be run with elevated permissions.