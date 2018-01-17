<#
.Synopsis
   Start all the VMs in the Azure Subscription
.DESCRIPTION
   All VMs are started in parralel with Powershell Workflows. 
   Enter subscription credentials at prompt.  
   Token is saved in a temp file, used for workflow, its removed at the end. 

.PARAMETER GetVMsList
    Get and show list of available VMs 

.PARAMETER Selection
	Start only VMs in the selection

.EXAMPLE
   .\AzureRmVMStartAll.ps1
#>

Param(
	[Switch]$GetVMsList,
	[String[]]$Selection #List of VM name
)

#Variables
$TokenPath = "$env:TEMP\azureprofile.json"


#Functions
workflow StartVMs{
    param($VMs, $TokenPath)
    foreach -parallel ($vm in $VMs){
        $null = Select-AzureRmProfile -Path $TokenPath
        Start-AzureRmVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.name
	}
}

#Main
Login-AzureRmAccount | Out-Null
Save-AzureRmProfile -Path $TokenPath -Force

$VMs = Get-AzureRmVM #get VM list

if($GetVMsList){ 
		$VMs.name
		break
}

#Get VM objects from the list for VM in the selection
if($Selection){
	$NewList = @()
	foreach ($VmName in $Selection){
		$i= 0
		do{
			if($VMs[$i].name -match $VmName){
				$NewList+= $VMs[$i]
				break
			}
			$i++
		} until($i -eq ($VMs.Count + 1))
	}
	$VMs = $NewList
}

"VMs to start"
$VMs

StartVMs $VMS $TokenPath #Start VMs 
"Done"
Get-AzureRmVM
Remove-item $TokenPath #clean temp file

