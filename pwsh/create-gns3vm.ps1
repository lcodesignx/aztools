# Generate new credentials
$username = Read-Host -Prompt "enter username"
$credential = Get-Credential $username

# Create network resource group
New-AzResourceGroup -Name lco_network -Location 'East US 2' -Tag @{ department='Network Lab'}

# Create network security group
$location = Get-AzResourceGroup -Name lco_network | Select-Object -ExpandProperty Location
New-AzNetworkSecurityGroup -Name netsec -ResourceGroupName lco_network -Location $location

# Create security rule configuration and add it to security group
$nsg = Get-AzNetworkSecurityGroup -Name netsec -ResourceGroupName lco_network
$ruleConfigParams = @{
    Name                        = 'allow_all'
    Description                 = 'temporarily allow all network traffic'
    Access                      = 'Allow'
    Protocol                    = '*'
    Direction                   = 'Inbound'
    Priority                    = 100
    SourceAddressPrefix         = '*'
    SourcePortRange             = '*'
    DestinationAddressPrefix    = '*'
    DestinationPortRange        = '*'
}
$nsg | Add-AzNetworkSecurityRuleConfig @ruleConfigParams | Set-AzNetworkSecurityGroup

# Create gns3 vm
$secGroup = $nsg | Select-Object -ExpandProperty Name
$vmParams = @{
    Name                = 'gns3'
    ResourceGroupName   = 'lco_network'
    Location            = $location
    Image               = 'UbuntuLTS'
    Size                = 'Standard_D4s_v3'
    SecurityGroupName   = $secGroup
    Credential          = $credential
    DomainNameLabel     = 'lcogns3'
}
New-AzVM @vmParams