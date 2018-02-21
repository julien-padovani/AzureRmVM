# AzureRmVMStartAll.ps1

   Start all the VMs in a ressource group

   All VMs are started in parrelel with Powershell Workflows. 
   Enter subscription credentials at prompt. 
   Token is saved in a temp file, used for workflow (parralal tasks), its removed at the end.
