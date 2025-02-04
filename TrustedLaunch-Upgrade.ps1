# Resource Group name
$resourceGroup = "rg-test-applications-uks"

# Uncomment for single VM
$vmName = "vm-az-versatest"

# Uncomment for all VMs in resource group
#$vms = Get-AzVM -ResourceGroupName $resourceGroup

function Enable-TrustedLaunchForVM {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ResourceGroupName,
        [Parameter(Mandatory=$true)]
        [string]$VMName
    )
    
    Write-Host "Starting upgrade for $VMName..."
    Write-Host "Getting VM details..."
    $vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName
    $securityProfile = (Get-AzVM -ResourceGroupName $ResourceGroupName -VMName $VMName | 
        Select-Object -Property SecurityProfile -ExpandProperty SecurityProfile).SecurityProfile
    Write-Host "Security Type: $($securityProfile.SecurityType)"
    
    Write-Host "Stopping $VMName..."
    Stop-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Force
    
    Write-Host "Updating security type to TrustedLaunch..."
    Get-AzVM -ResourceGroupName $ResourceGroupName -VMName $VMName | 
        Update-AzVM -SecurityType TrustedLaunch -EnableSecureBoot $true -EnableVtpm $true
    
    Write-Host "Validating security settings..."
    $securityProfile = (Get-AzVM -ResourceGroupName $ResourceGroupName -VMName $VMName | 
        Select-Object -Property SecurityProfile -ExpandProperty SecurityProfile).SecurityProfile
    Write-Host "Security Type: $($securityProfile.SecurityType)"
    Write-Host "UEFI Settings: $($securityProfile.UefiSettings)"
    
    Write-Host "Starting $VMName..."
    Start-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName
    Write-Host "$VMName upgrade completed"
}

# Single VM execution
Enable-TrustedLaunchForVM -ResourceGroupName $resourceGroup -VMName $vmName

# Uncomment for multiple VMs
#foreach ($vm in $vms) {
#    Enable-TrustedLaunchForVM -ResourceGroupName $resourceGroup -VMName $vm.Name
#}