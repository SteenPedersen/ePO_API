# Options to Include username and password 
# The ePO permission needed depends on which API is being utilized. 
# It is highly recommended to utilize Least Privilege principle
# Will propmt for ePO username and password if they are not included in the code
#
$c_username = "<user>"  
$c_password = "<password>"  
$c_password_base64 = ConvertTo-SecureString $c_password -AsPlainText -Force  
$c_creds = New-Object System.Management.Automation.PSCredential ($c_username, $c_password_base64) 

# Point to your ePO server - the default console port is 8443
$l_epo_address = "https://<epo>:8443"  
 
$g_working_dir = $PSScriptRoot

# Prompt for username and password if there has not been added a specific ePO Script User account in the script
if ($c_username -eq "<user>") {
    Write-Output (" #### Provide ePO user account for: $l_epo_address ####")
    Write-Output (" ")
    
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

# Here is a list of different inforamtion which can be extracted from ePO using API
#
# List all tables available from ePO - this can be usefull to 
$l_rest_api    = "/remote/core.listTables"

# List all ePO API  
$l_rest_api    = "/remote/core.help"

# Example of running a query directly in the API
$l_rest_api    = "/remote/core.executeQuery?target=EPOLeafNode&select=(select EPOLeafNode.AutoID EPOLeafNode.NodeName EPOBranchNode.NodeTextPath2  EPOComputerProperties.IPV6 EPOLeafNode.LastUpdate AM_CustomProps.bOASEnabled AM_CustomProps.OASbComplianceStatus AM_CustomProps.APbComplianceStatus AM_CustomProps.bAPEnabled AM_CustomProps.bBOEnabled AM_CustomProps.BObComplianceStatus AM_CustomProps.ExploitPreventionContentVersion AM_CustomProps.ExploitPreventionContentCreated FW_CustomProps.FWStatus FW_CustomProps.FWMode FW_CustomProps.ServiceRunning WP_CustomProps.bWPEnabled WP_CustomProps.WCStatus WP_CustomProps.WPbComplianceStatus AM_CustomProps.ManifestVersion AM_CustomProps.AMCoreContentDate)&:output=json&order=(order(asc EPOLeafNode.NodeName))"
$l_rest_api    = "/remote/core.executeQuery?target=EPOLeafNode&select=(select EPOLeafNode.AutoID EPOLeafNode.NodeName EPOBranchNode.NodeTextPath2 EPOComputerProperties.UserProperty1 EPOComputerProperties.UserProperty2 EPOComputerProperties.UserProperty3 EPOComputerProperties.UserProperty4 EPOComputerProperties.UserProperty5 EPOComputerProperties.UserProperty6 EPOComputerProperties.UserProperty7 EPOComputerProperties.UserProperty8 EPOComputerProperties.IPAddress EPOComputerProperties.SystemBootTime EPOLeafNode.LastUpdate AM_CustomProps.bOASEnabled AM_CustomProps.OASbComplianceStatus AM_CustomProps.APbComplianceStatus AM_CustomProps.bAPEnabled AM_CustomProps.bBOEnabled AM_CustomProps.BObComplianceStatus AM_CustomProps.ExploitPreventionContentVersion AM_CustomProps.ExploitPreventionContentCreated FW_CustomProps.FWStatus FW_CustomProps.FWMode FW_CustomProps.ServiceRunning WP_CustomProps.bWPEnabled WP_CustomProps.WCStatus WP_CustomProps.WPbComplianceStatus AM_CustomProps.ManifestVersion AM_CustomProps.AMCoreContentDate)&where=(+and+(+version_ge+EPOProdPropsView_UDLP.productversion+%2211%22+)+(+eq+EPOComputerProperties.OSPlatform+%22Workstation%22+)+)+)&:output=json"
$l_rest_api    = "/remote/core.executeQuery?target=EPOLeafNode&select=(select EPOLeafNode.AutoID EPOLeafNode.NodeName EPOBranchNode.NodeTextPath2 EPOComputerProperties.UserProperty1 EPOComputerProperties.UserProperty2 EPOComputerProperties.UserProperty3 EPOComputerProperties.UserProperty4 EPOComputerProperties.UserProperty5 EPOComputerProperties.UserProperty6 EPOComputerProperties.UserProperty7 EPOComputerProperties.UserProperty8 EPOComputerProperties.IPAddress EPOComputerProperties.SystemBootTime EPOLeafNode.LastUpdate AM_CustomProps.bOASEnabled AM_CustomProps.OASbComplianceStatus AM_CustomProps.APbComplianceStatus AM_CustomProps.bAPEnabled AM_CustomProps.bBOEnabled AM_CustomProps.BObComplianceStatus AM_CustomProps.ExploitPreventionContentVersion AM_CustomProps.ExploitPreventionContentCreated FW_CustomProps.FWStatus FW_CustomProps.FWMode FW_CustomProps.ServiceRunning WP_CustomProps.bWPEnabled WP_CustomProps.WCStatus WP_CustomProps.WPbComplianceStatus AM_CustomProps.ManifestVersion AM_CustomProps.AMCoreContentDate)&where=(+and(+eq+EPOComputerProperties.OSPlatform+%22Workstation%22+)+)&:output=json"
$l_rest_api    = "/remote/core.executeQuery?target=EPOLeafNode&select=(select EPOLeafNode.AutoID EPOLeafNode.NodeName EPOBranchNode.NodeTextPath2 EPOComputerProperties.UserProperty1 EPOComputerProperties.UserProperty2 EPOComputerProperties.UserProperty3 EPOComputerProperties.UserProperty4 EPOComputerProperties.UserProperty5 EPOComputerProperties.UserProperty6 EPOComputerProperties.UserProperty7 EPOComputerProperties.UserProperty8 EPOComputerProperties.IPAddress EPOComputerProperties.SystemBootTime EPOLeafNode.LastUpdate AM_CustomProps.bOASEnabled AM_CustomProps.OASbComplianceStatus AM_CustomProps.APbComplianceStatus AM_CustomProps.bAPEnabled AM_CustomProps.bBOEnabled AM_CustomProps.BObComplianceStatus AM_CustomProps.ExploitPreventionContentVersion AM_CustomProps.ExploitPreventionContentCreated FW_CustomProps.FWStatus FW_CustomProps.FWMode FW_CustomProps.ServiceRunning WP_CustomProps.bWPEnabled WP_CustomProps.WCStatus WP_CustomProps.WPbComplianceStatus AM_CustomProps.ManifestVersion AM_CustomProps.AMCoreContentDate)&where=(+startsWith+EPOComputerProperties.UserProperty7+%22h4l4j%22+%29+%29)&:output=json"

$l_rest_api    = "/remote/core.executeQuery?target=EPOLeafNode&select=(select EPOLeafNode.AutoID EPOLeafNode.NodeName EPOBranchNode.NodeTextPath2  EPOComputerProperties.IPV6 EPOLeafNode.LastUpdate AM_CustomProps.bOASEnabled AM_CustomProps.OASbComplianceStatus AM_CustomProps.APbComplianceStatus AM_CustomProps.bAPEnabled AM_CustomProps.bBOEnabled AM_CustomProps.BObComplianceStatus AM_CustomProps.ExploitPreventionContentVersion AM_CustomProps.ExploitPreventionContentCreated FW_CustomProps.FWStatus FW_CustomProps.FWMode FW_CustomProps.ServiceRunning WP_CustomProps.bWPEnabled WP_CustomProps.WCStatus WP_CustomProps.WPbComplianceStatus AM_CustomProps.ManifestVersion AM_CustomProps.AMCoreContentDate)&:output=json&order=(order(asc EPOLeafNode.NodeName))"
$l_rest_api    = "/remote/core.executeQuery?target=EPOLeafNode&select=(select EPOLeafNode.AutoID EPOLeafNode.NodeName EPOBranchNode.NodeTextPath2  EPOComputerProperties.IPV6 EPOLeafNode.LastUpdate AM_CustomProps.bOASEnabled AM_CustomProps.OASbComplianceStatus AM_CustomProps.APbComplianceStatus AM_CustomProps.bAPEnabled AM_CustomProps.bBOEnabled AM_CustomProps.BObComplianceStatus AM_CustomProps.ExploitPreventionContentVersion AM_CustomProps.ExploitPreventionContentCreated FW_CustomProps.FWStatus FW_CustomProps.FWMode FW_CustomProps.ServiceRunning WP_CustomProps.bWPEnabled WP_CustomProps.WCStatus WP_CustomProps.WPbComplianceStatus AM_CustomProps.ManifestVersion AM_CustomProps.AMCoreContentDate)&:output=json&order=(order(asc EPOLeafNode.NodeName))"
$l_rest_api    = "/remote/core.executeQuery?target=EPOLeafNode&select=(select EPOLeafNode.AutoID EPOLeafNode.NodeName EPOBranchNode.NodeTextPath2 EPOComputerProperties.IPV6 EPOLeafNode.LastUpdate AM_CustomProps.bOASEnabled AM_CustomProps.OASbComplianceStatus AM_CustomProps.APbComplianceStatus AM_CustomProps.bAPEnabled AM_CustomProps.bBOEnabled AM_CustomProps.BObComplianceStatus AM_CustomProps.ExploitPreventionContentVersion AM_CustomProps.ExploitPreventionContentCreated ATP_CustomProps.ATPEnabled ATP_CustomProps.ATPObserveModeEnabled ATP_CustomProps.RPStaticEnabled ATP_CustomProps.RPEnabled ATP_CustomProps.ATPAMSIEnabled ATP_CustomProps.CTPEnabled ATP_CustomProps.CommStatus FW_CustomProps.FWStatus FW_CustomProps.FWMode FW_CustomProps.ServiceRunning WP_CustomProps.bWPEnabled WP_CustomProps.WCStatus WP_CustomProps.WPbComplianceStatus AM_CustomProps.ManifestVersion AM_CustomProps.AMCoreContentDate EPOProdPropsView_ENDPOINTSECURITYPLATFORM.productversion EPOProdPropsView_THREATPREVENTION.productversion EPOProdPropsView_TIECLIENTMETA.productversion EPOProdPropsView_FIREWALL.productversion)&:output=json&order=(order(asc EPOLeafNode.NodeName))"
$l_rest_api    = "/remote/core.executeQuery?target=EPOLeafNode&select=(select EPOLeafNode.AutoID EPOLeafNode.NodeName EPOComputerProperties.DomainName EPOBranchNode.NodeTextPath2 EPOComputerProperties.IPAddress EPOLeafNode.LastUpdate AM_CustomProps.bOASEnabled AM_CustomProps.OASbComplianceStatus AM_CustomProps.APbComplianceStatus AM_CustomProps.bAPEnabled AM_CustomProps.bBOEnabled AM_CustomProps.BObComplianceStatus AM_CustomProps.ExploitPreventionContentVersion AM_CustomProps.ExploitPreventionContentCreated ATP_CustomProps.ATPEnabled ATP_CustomProps.ATPObserveModeEnabled ATP_CustomProps.RPStaticEnabled ATP_CustomProps.RPEnabled ATP_CustomProps.ATPAMSIEnabled ATP_CustomProps.CTPEnabled ATP_CustomProps.CommStatus FW_CustomProps.FWStatus FW_CustomProps.FWMode FW_CustomProps.ServiceRunning WP_CustomProps.bWPEnabled WP_CustomProps.WCStatus WP_CustomProps.WPbComplianceStatus AM_CustomProps.ManifestVersion AM_CustomProps.AMCoreContentDate AM_CustomProps.V2DATVersion EPOProdPropsView_ENDPOINTSECURITYPLATFORM.productversion EPOProdPropsView_THREATPREVENTION.productversion EPOProdPropsView_TIECLIENTMETA.productversion EPOProdPropsView_FIREWALL.productversion EPOProdPropsView_WEBCONTROL.productversion)&where=(newerThan EPOLeafNode.LastUpdate 604800000)&:output=json"
# The where filter includes systems connected in the last 1 week
# &where=(newerThan EPOLeafNode.LastUpdate 604800000)
# That is number of milliseconds for a week 604800000
# Last 1 day 86400000
# Last 1 month 2419200000

# List systems with DLP Installed
#$l_rest_api    = "/remote/core.executeQuery?target=EPOLeafNode&select=(select EPOLeafNode.AutoID EPOLeafNode.NodeName EPOLeafNode.LastUpdate EPOLeafNode.AgentGUID EPOComputerProperties.UserName EPOLeafNode.Tags EPOBranchNode.NodeTextPath2 EPOComputerProperties.UserProperty2 EPOComputerProperties.UserProperty3 EPOProdPropsView_UDLP.productversion )&where=(+and+(+version_ge+EPOProdPropsView_UDLP.productversion+%2211%22+)+(+eq+EPOComputerProperties.OSPlatform+%22Workstation%22+)+)+)&:output=json"

$l_url = $l_epo_address + $l_rest_api 

$l_headers = @{"X-Requested-With"="powershell"}  
$l_body= @{}
$l_OutFileName = $g_working_dir+"\response.json"
$l_OutFileName_tmp = $l_OutFileName+".tmp"
Remove-Item $l_OutFileName -ErrorAction Ignore
Remove-Item $l_OutFileName_tmp -ErrorAction Ignore

#Invoke-RestMethod -Uri $l_url -Body $l_body -Method Post -Credential $c_creds -OutFile $l_OutFileName -Verbose
# Write results directly to file where the OK: - the first line will be removed 
try {Invoke-RestMethod -Uri $l_url -Body $l_body -Method Post -Credential $c_creds -OutFile $l_OutFileName_tmp }
catch {
    Write-Output "Error getting ePO information from $l_epo_address"
    exit
    }

# Remove the first line where the OK: is located
get-content $l_OutFileName_tmp | select-object -skip 1 | Out-File $l_OutFileName

$Result=""
$result_Obj=""
#rm $l_OutFileName_tmp -ErrorAction Ignore
if (Test-Path $l_OutFileName) 
{ $Result=Get-Content $l_OutFileName }
$result_Obj = ConvertFrom-Json $([String]::new($Result.Replace('OK:',''))) # Remove the OK: fron the results

Write-Host "There are :"$result_Obj.Count" systems selected "
# This will output all the objects
$result_Obj
#$Result
Write-Host "There are :"$result_Obj.Count" systems selected "



