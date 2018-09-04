$scriptLoc = (Get-Location)
$computersArray = get-content -path $scriptLoc\computers.txt

	[int]$office2010Count = 0
	[int]$office2013Count = 0
	[int]$office2016Count = 0
	$officeVersion = "N/A"
	
	foreach($computer in $computersArray){
		if(test-connection $computer -count 1 -quiet)
		{
			$office201032 = "\\$computer\C$\Program Files\Microsoft Office\Office14\outlook.exe"
			$office201064 = "\\$computer\c$\program files (x86)\Microsoft Office\Office14\outlook.exe"
			$office201332 = "\\$computer\C$\Program Files\Microsoft Office\Office15\outlook.exe"
			$office201364 = "\\$computer\c$\program files (x86)\Microsoft Office\Office15\outlook.exe"
			$office201632 = "\\$computer\C$\Program Files\Microsoft Office\Office16\outlook.exe"
			$office201664 = "\\$computer\c$\program files (x86)\Microsoft Office\Office16\outlook.exe"
			try{
			$userName = get-wmiobject -computername $computer -class Win32_computersystem -erroraction stop | select -expandproperty username
			if($userName -eq $null){
			$userName = "No User logged on"
			}
			}
			catch{
			write-host "Error getting info from:" $computer
			}
			if(test-path $office201032){
			$officever = (get-command $office201032).FileVersionInfo.Fileversion
			$office2010Count++
			$officeVersion = "Microsoft Office 2010"
			write-host $computer "- Microsoft Office 2010 version" $officever
			}
			elseif(test-path $office201064){
			$officever64 = (get-command $office201064).FileVersionInfo.Fileversion
			$office2010Count++
			$officeVersion = "Microsoft Office 2010"
			write-host $computer "- Microsoft Office 2010 version" $officever64
			}
			elseif(test-path $office201332){
			$office2013Count++
			$officeVersion = "Microsoft Office 2013"
			$officever64 = (get-command $office201332).FileVersionInfo.Fileversion
			write-host $computer "- Microsoft Office 2013 version" $officever64
			}
			elseif(test-path $office201364){
			$office2013Count++
			$officeVersion = "Microsoft Office 2013"
			$officever64 = (get-command $office201364).FileVersionInfo.Fileversion
			write-host $computer "- Microsoft Office 2013 version" $officever64
			}
			elseif(test-path $office201632){
			$office2016Count++
			$officeVersion = "Microsoft Office 2016"
			$officever64 = (get-command $office201632).FileVersionInfo.Fileversion
			write-host $computer "- Microsoft Office 2016 version" $officever64
			}
			elseif(test-path $office201664){
			$office2016Count++
			$officeVersion = "Microsoft Office 2016"
			$officever64 = (get-command $office201664).FileVersionInfo.Fileversion
			write-host $computer "- Microsoft Office 2016 version" $officever64
			}
			else
			{
			write-host "$computer - Office is not installed or not installed to the default directory"
			}
		}
		else
		{
		write-host $computer "is not online"
		}
		$wrapper = New-Object PSObject -Property @{ ComputerName = $computer;}
		$wrapper | add-member NoteProperty OfficeVersion $officeVersion
		$wrapper | add-member NoteProperty User $userName
		Export-Csv -InputObject $wrapper -Path $scriptLoc"\OfficeVersions.csv" -NoTypeInformation -Append

}
write-host "Office 2010 Total:"$office2010Count
write-host "Office 2013 Total:"$office2013Count
write-host "Office 2016 Total:"$office2016Count
read-host "wait"
