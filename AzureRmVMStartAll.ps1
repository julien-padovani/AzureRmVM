<#
 .Synopsis
   Start all the VMs in a ressource group

.DESCRIPTION
   All VMs are started in parralel with Powershell Workflows. 
   Enter subscription credentials at prompt. 
   Token is saved in a temp file, used for workflow (parrelal tasks), its removed at the end. 

 .PARAMETER ResourceGroupName
    Specify the resource group of VM to start

 .PARAMETER subscriptionId

 .EXAMPLE
   .\AzureRmVMStartAll.ps1 -ResourceGroupName
#>

param
(
 [Parameter(Mandatory=$True)]
 [string]
 $SubscriptionId,

 [Parameter(Mandatory=$True)]
 [string]
 $ResourceGroupName
)

$credentialsPath = "$env:TEMP\azureprofile.json"

Login-AzureRmAccount
Write-Host "Selecting subscription '$subscriptionId'";
Select-AzureRmSubscription -SubscriptionID $subscriptionId;
Save-AzureRmProfile -Path $credentialsPath -Force

workflow StartVMs 
{
    param($VMs, $credentialsPath)
    foreach -parallel ($vm in $VMs)
    {
        Select-AzureRmProfile -Path $credentialsPath
        Start-AzureRmVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.name
    }
}

#get VM list
$VMs = Get-AzureRmVM -ResourceGroupName $ResourceGroupName

#Start VMs
StartVMs $VMS $credentialsPath

#clean temp file
Remove-item $credentialsPath

