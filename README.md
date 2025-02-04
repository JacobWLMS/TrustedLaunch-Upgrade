# TrustedLaunch-Upgrade

PowerShell script to enable Trusted Launch security features on Azure VMs.

## Prerequisites

- Azure PowerShell module installed
- Appropriate Azure permissions
- VMs must be in a stopped state during the upgrade

## Usage

1. Single VM:
```powershell
$resourceGroup = "your-resource-group"
$vmName = "your-vm-name"
```

2. All VMs in resource group (uncomment relevant sections):
```powershell
$resourceGroup = "your-resource-group"
$vms = Get-AzVM -ResourceGroupName $resourceGroup
```

## Features

- Enables Trusted Launch security type
- Configures Secure Boot
- Enables vTPM
- Validates security settings post-upgrade
- Handles VM stop/start automatically

## Note

Ensure your VMs meet the requirements for Trusted Launch before running the script.