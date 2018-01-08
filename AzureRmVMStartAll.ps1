<#
.Synopsis
   Start all the VMs in the Azure Subscription
.DESCRIPTION
   All VMs are started in parrelel with Powershell Workflows. 
   Enter subscription credentials at prompt. 
   Token is saved in a temp file, used for workflow (parrelal tasks), its removed at the end. 
.EXAMPLE
   .\AzureRmVMStartAll.ps1
#>

$credentialsPath = "$env:TEMP\azureprofile.json"

Login-AzureRmAccount
Save-AzureRmProfile -Path $credentialsPath -Force

workflow StartVMs {
    param($VMs, $credentialsPath)
    foreach -parallel ($vm in $VMs){
        Select-AzureRmProfile -Path $credentialsPath
        Start-AzureRmVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.name
    }
}

#get VM list
$VMs = Get-AzureRmVM 

#Start VMs
StartVMs $VMS $credentialsPath

#clean temp file
Remove-item $credentialsPath

