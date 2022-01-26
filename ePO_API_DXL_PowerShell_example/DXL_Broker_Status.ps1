# Options to Include username and password 
# The ePO permission needed depends on which API is being utilized. 
# It is highly recommended to utilize Least Privilege principle
#
$c_username = "<user>"  
$c_password = "<password>"  
$c_password_base64 = ConvertTo-SecureString $c_password -AsPlainText -Force  
$c_creds = New-Object System.Management.Automation.PSCredential ($c_username, $c_password_base64) 

# Point to your ePO server - the default console port is 8443
$l_epo_address = "https://epo003:50443"  

$g_working_dir = $PSScriptRoot

# Prompt for username and password if there has not been added a specific ePO Script User account in the script
if ($c_username -eq "<user>") {
    Write-Output ("Provide ePO user account")
    $c_creds = Get-Credential
    #$c_username = $c_creds.GetNetworkCredential().username
    #$c_password = $c_creds.GetNetworkCredential().password  
}

# Next function allows to work with self-signed certificates
# Bypass the certificate check
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12, [Net.SecurityProtocolType]::Ssl3
[Net.ServicePointManager]::SecurityProtocol = "Tls, Tls11, Tls12, Ssl3"

# ePO API call
# Add &:output=json - For json output from the API
# Add &:output=xml - For XML output from the API
# Add &:output=terse - For terse output from the API (Default)
# Add &:output=verbose - For verbose output from the API 

# Simple test to get all the Tags listed
#$l_rest_api    = "/remote/system.findTag"  

# Example of running a query directly in the API
#$l_rest_api    = "/remote/core.executeQuery?target=EPOLeafNode&select=(select EPOLeafNode.AutoID EPOLeafNode.NodeName EPOBranchNode.NodeTextPath2 %20EPOComputerProperties.IPV6%20EPOLeafNode.LastUpdate%20AM_CustomProps.bOASEnabled AM_CustomProps.OASbComplianceStatus AM_CustomProps.APbComplianceStatus AM_CustomProps.bAPEnabled AM_CustomProps.bBOEnabled AM_CustomProps.BObComplianceStatus AM_CustomProps.ExploitPreventionContentVersion AM_CustomProps.ExploitPreventionContentCreated FW_CustomProps.FWStatus FW_CustomProps.FWMode FW_CustomProps.ServiceRunning WP_CustomProps.bWPEnabled WP_CustomProps.WCStatus WP_CustomProps.WPbComplianceStatus AM_CustomProps.ManifestVersion AM_CustomProps.AMCoreContentDate)&:output=json&order=(order(asc%20EPOLeafNode.NodeName))"


# Check specific DXL Broker
# $l_rest_api    = "/remote/DxlClient.queryRegisteredBroker?brokerGuid=54962a86-9d43-11eb-1e6a-000c29d1a25d"
# List all DXL Brokers
$l_rest_api    = "/remote/DxlClient.queryRegisteredBroker?brokerGuid=&:output=json"

$l_url = $l_epo_address + $l_rest_api 

$l_headers = @{"X-Requested-With"="powershell"}  
$l_body= @{}
$l_OutFileName = $g_working_dir+"\response.json"
$l_OutFileName_tmp = $l_OutFileName+".tmp"
rm $l_OutFileName -ErrorAction Ignore
rm $l_OutFileName_tmp -ErrorAction Ignore

#Invoke-RestMethod -Uri $l_url -Body $l_body -Method Post -Credential $c_creds -OutFile $l_OutFileName -Verbose
# Write results directly to file where the OK: - the first line will be removed 
Invoke-RestMethod -Uri $l_url -Body $l_body -Method Post -Credential $c_creds -OutFile $l_OutFileName_tmp 
# Remove the first line where the OK: is located
get-content $l_OutFileName_tmp | select-object -skip 1 | Out-File $l_OutFileName

# Other option is to get the results into a variable and then remove the OK: before writting the results to a file
#$Result=Invoke-RestMethod -Uri $l_url -Body $l_body -Method Post -Credential $c_creds  
#$Short = $Result.Replace('OK:','')
#$Short | out-file -filepath ($l_OutFileName)

#rm $l_OutFileName_tmp -ErrorAction Ignore
if (Test-Path $l_OutFileName) 
{  Get-Content $l_OutFileName }
