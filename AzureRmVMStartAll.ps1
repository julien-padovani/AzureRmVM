<#
.Synopsis
   Start all the VMs in the Azure Subscription
.DESCRIPTION
   All VMs are started in parralel with Powershell Workflows. 
   Enter subscription credentials at prompt.  
   Token is saved in a temp file, used for workflow, its removed at the end. 
.EXAMPLE
   .\AzureRmVMStartAll.ps1
#>

#Variables
$TokenPath = "$env:TEMP\azureprofile.json"

#Functions
workflow StartVMs {
    param($VMs, $TokenPath)
    foreach -parallel ($vm in $VMs){
        Select-AzureRmProfile -Path $TokenPath
        Start-AzureRmVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.name
    }
}

#Main
Login-AzureRmAccount
Save-AzureRmProfile -Path $TokenPath -Force
$VMs = Get-AzureRmVM #get VM list
StartVMs $VMS $TokenPath #Start VMs
Remove-item $TokenPath #clean temp file

