œparam([string]$resourceGroup)

$adminCredential = Get-Credential -Message "Enter username and password"

for ($i = 0; $i -lt 3; $i++) {
    $vmName = "msftlearn-vm" + $i
    Write-Host "Creating VM: " $vmName
    New-AzVm -ResourceGroupName $resourceGroup -Name $vmName -Credential $adminCredential -Image UbuntuLTS -OpenPorts 22
}