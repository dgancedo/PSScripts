Simple Exchange 2 Exchange Migration Tool

- Export.ps1 #Expor script
- Import.ps1 #Import script
- userlist.txt #Filename containing the usernames to be exported.

Usage:

Modify serverpath and fwdomain on export to acomodate to your needs
The export script recurse the userlist.txt using, this data modify the mailbox adding a forward to the new domain and generate the export requuest on exchange, the pst files are written in the path indicated in the serverpath variable, the script keep monitoring the requiests until they have been completed or failed and generate a file in the same path using the username and the extension ok for completed, okw for completed with warnings, and failed.

The Import script use the same variable serverpaht and search for the files ok an okw, then enable the exchange mailbox for the user and generate the import request, and keep looping waiting that import have finished, then rename the .ok and .okw files for .imported or .importedw in the case the import process have finished with warnings.

Use the dbnames variable on Import to adjust to your db nammes syntax