# Azure Login
Connect-AzAccount

# Create Resource Group
New-AzResourceGroup -Name TutorialResources -Location eastus

#Create admin credentials for VmId
$cred = Get-Credential
#Create a virtual machine
$vmParams = @{
    ResourceGroupName   = 'TutorialResources'
    Name                = 'TutorialVM1'
    Location            = 'eastus'
    ImageName           = 'Win2016Datacenter'
    PublicIpAddressName = 'tutorialPublicIp'
    Credential          = $cred
    OpenPorts           = 3389
}
$newVM1 = New-AzVM @vmParams

$newVM1

#Get VM information with queries

$newVM1.OSProfile | Select-Object -Property ComputerName, AdminUserName

$newVM1 | Get-AzNetworkInterface |
Select-Object -ExpandProperty IpConfigurations |
Select-Object -Property Name, PrivateIpAddress

$publicIp = Get-AzPublicIpAddress -Name tutorialPublicIp -ResourceGroupName TutorialResources
$publicIp

$publicIp | Select-Object Name, IpAddress, @{label = 'FQDN'; expression = { $_.DnsSettings.Fqdn } }

#Creating a new VM on the existing subnet
$vmParams2 = @{
    ResourceGroupName   = 'TutorialResources'
    Name                = 'TutorialVM2'
    ImageName           = 'Win2016Datacenter'
    SubnetName          = 'TutorialVM1'
    PublicIpAddressName = 'tutorialPublicIp2'
    Credential          = $cred
    OpenPorts           = 3389
}
$newVM2 = New-AzVM @vmParams2

$newVM2

$newVM2.FullyQualifiedDomainName

#Cleanup
$job = Remove-AzResourceGroup -Name TutorialResources -Force -AsJob

$job
