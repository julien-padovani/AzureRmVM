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

$TokenPath = "$env:TEMP\azureprofile.json"

Login-AzureRmAccount
Save-AzureRmProfile -Path $TokenPath -Force

workflow StartVMs {
    param($VMs, $TokenPath)
    foreach -parallel ($vm in $VMs){
        Select-AzureRmProfile -Path $TokenPath
        Start-AzureRmVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.name
    }
}

#get VM list
$VMs = Get-AzureRmVM 

#Start VMs
StartVMs $VMS $TokenPath

#clean temp file
Remove-item $TokenPath

