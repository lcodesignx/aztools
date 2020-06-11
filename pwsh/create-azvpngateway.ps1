# CREATE AN AZURE VPN GATEWAY TO CONNECT CLIENT MACHINES TO AZURE

# VPN Variables
$VNetName  = "VNetData"
$FESubName = "FrontEnd"
$BESubName = "Backend"
$GWSubName = "GatewaySubnet"
$VNetPrefix1 = "192.168.0.0/16"
$VNetPrefix2 = "10.254.0.0/16"
$FESubPrefix = "192.168.1.0/24"
$BESubPrefix = "10.254.1.0/24"
$GWSubPrefix = "192.168.200.0/26"
$VPNClientAddressPool = "172.16.201.0/24"
$ResourceGroup = "VpnGatewayDemo"
$Location = "East US"
$GWName = "VNetDataGW"
$GWIPName = "VNetDataGWPIP"
$GWIPconfName = "gwipconf"

# Create resource group to place the azure vpn
New-AzResourceGroup -Name $ResourceGroup -Location $Location

# Subnet configurations
$fesub = New-AzVirtualNetworkSubnetConfig -Name $FESubName -AddressPrefix $FESubPrefix
$besub = New-AzVirtualNetworkSubnetConfig -Name $BESubName -AddressPrefix $BESubPrefix
$gwsub = New-AzVirtualNetworkSubnetConfig -Name $GWSubName -AddressPrefix $GWSubPrefix

# Create azure virtual network using preceding subnet values and a static DNS server
$vnetParams = @{
    Name                = $VNetName
    ResourceGroupName   = $ResourceGroup
    Location            = $Location
    AddressPrefix       = $VNetPrefix1, $VNetPrefix2
    Subnet              = $fesub, $besub, $gwsub
    DnsServer           = 10.2.1.3
}
New-AzVirtualNetwork @vnetParams

# Specify variables for network
$vnet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroup
$subnet = Get-AzVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet

# Request dynamically assigned IP addresses
$pip = New-AzPublicIpAddress -Name $GWIPName -ResourceGroupName $ResourceGroup -Location $Location -AllocationMethod Dynamic
$ipconf = New-AzVirtualNetworkGatewayIpConfig -Name $GWIPconfName -Subnet $subnet -PublicIpAddress $pip

# Create the VPN Gateway
$vpnGatewayParams = @{
    Name                = $GWName
    ResourceGroupName   = $ResourceGroup
    Location            = $Location
    IpConfigurations    = $ipconf
    GatewayType         = 'Vpn'
    VpnType             = 'RouteBased'
    EnableBgp           = $false
    GatewaySku          = 'VpnGw1'
    VpnClientProtocol   = "IKEv2"
}
New-AzVirtualNetworkGateway @vpnGatewayParams

# Add the VPN client address pool
$gateway = Get-AzVirtualNetworkGateway -ResourceGroupName $ResourceGroup -Name $GWName
Set-AzVirtualNetworkGateway -VirtualNetworkGateway $gateway -VpnClientAddressPool $VPNClientAddressPool

# Generate client certificate
# Root certficate
$rootCertParams = @{
    Type = 'Custom'
    KeySpec = 'Signature'
    Subject = 'CN=P2SRootCert'
    KeyExportPolicy = 'Exportable'
    HashAlgorithm = 'sha256'
    KeyLength = 2048
    CertStoreLocation = 'Cert:\CurrentUser\My'
    KeyUsageProperty = 'Sign'
    KeyUsage = 'CertSign'
}
$cert = New-SelfSignedCertificate @rootCertParams

# Client certificate
$clientCertParams = @{
    Type = 'Custom'
    DnsName = 'P2SChildCert'
    KeySpec = 'Signature'
    Subject = 'CN=P2SChildCert'
    KeyExportPolicy = 'Exportable'
    HashAlgorithm = 'sha256'
    KeyLength = 2048
    CertStoreLocation = 'Cert:\CurrentUser\My'
    Signer = $cert
    TextExtension = @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")
}
New-SelfSignedCertificate @clientCertParams

# Upload the root certificate public key information
$P2SRootCertName = "P2SRootCert.cer"

$filePathForCert = "<cert-path>\P2SRootCert.cer"
$cert = new-object System.Security.Cryptography.X509Certificates.X509Certificate2($filePathForCert)
$CertBase64 = [system.convert]::ToBase64String($cert.RawData)
$p2srootcert = New-AzVpnClientRootCertificate -Name $P2SRootCertName -PublicCertData $CertBase64

$vpnClientRootCertParams = @{
    VpnClientRootCertificateName = $P2SRootCertName
    VirtualNetworkGatewayName = $GWName
    ResourceGroupName = $ResourceGroup
    PublicCertData = $CertBase64
}
Add-AzVpnClientRootCertificate @vpnClientRootCertParams

# Configure the native VPN client
$profile = New-AzVpnClientConfiguration -ResourceGroupName $ResourceGroup -Name $GWName -AuthenticationMethod "EapTls"
$profile.VPNProfileSASUrl

