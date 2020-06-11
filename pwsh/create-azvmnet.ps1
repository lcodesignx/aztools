# AZURE VIRTUAL NETWORK AUTOMATION SCRIPT

# Create Azure Resource Group
$location = "East US"
New-AzResourceGroup -Name vm-networks -Location $location

# Create subnet and virtual network
$subnet = New-AzVirtualNetworkSubnetConfig -Name default -AddressPrefix 10.0.0.0/24
New-AzVirtualNetwork -Name myVnet -ResourceGroupName vm-networks -Location $location -AddressPrefix 10.0.0.0/16 -Subnet $subnet

# Create two virtual machines
$vmParams = @{
    ResourceGroupName       = 'vm-networks'
    VirtualNetworkName      = 'myVnet'
    SubnetName              = 'default'
    Image                   = 'Win2016Datacenter'
    Size                    = 'Standard_DS2_v2'
}
New-AzVm -Name dataProcStage1 @vmParams
New-AzVM -Name dataProcStage2 @vmParams

# Get new vm public IP address
Get-AzPublicIpAddress -Name dataProcStage1

# Disassociate the public IP address that was created by default for the VM2.
$nic = Get-AzNetworkInterface -Name dataProcStage2 -ResourceGroupName vm-networks
$nic.IpConfigurations.publicipaddress.id = $null
Set-AzNetworkInterface -NetworkInterface $nic