# ePO_Query
Use PowerShell to extract data from ePO using queries composed in the ePO API.
This example is pulling many properties related to compliance for ENS TP, ATP, FW and WC. 
The “select” has a where/filter for all systems which has communicated in the last 1 week. The filter is based on number of milliseconds in a week.

If you need examples of selected statements and what can be extracted from ePO:
-	Compose a query in ePO which includes the properties and the filters
-	Save the query in ePO
-	Then select the query and choose “Export Queries” 
-	Review the XML file 
- - see the name of the properties
- - see the where statement 


The Output is generated in JSON and then converted into PowerShell object 


Example:
```
EPOLeafNode.AutoID                                       : 4
EPOLeafNode.NodeName                                     : EPO002
EPOComputerProperties.DomainName                         : MCTEST
EPOBranchNode.NodeTextPath2                              : \
EPOComputerProperties.IPAddress                          : 10.10.10.222
EPOLeafNode.LastUpdate                                   : 2022-02-20T17:43:04+01:00
AM_CustomProps.bOASEnabled                               : True
AM_CustomProps.OASbComplianceStatus                      : 1
AM_CustomProps.APbComplianceStatus                       : 1
AM_CustomProps.bAPEnabled                                : True
AM_CustomProps.bBOEnabled                                : True
AM_CustomProps.BObComplianceStatus                       : 1
AM_CustomProps.ExploitPreventionContentVersion           : 10.6.0.12052
AM_CustomProps.ExploitPreventionContentCreated           : 2022-01-29 20:03:08.0
ATP_CustomProps.ATPEnabled                               : 1
ATP_CustomProps.ATPObserveModeEnabled                    : 0
ATP_CustomProps.RPStaticEnabled                          : 1
ATP_CustomProps.RPEnabled                                : 1
ATP_CustomProps.ATPAMSIEnabled                           : 1
ATP_CustomProps.CTPEnabled                               : 1
ATP_CustomProps.CommStatus                               : 1
FW_CustomProps.FWStatus                                  :
FW_CustomProps.FWMode                                    :
FW_CustomProps.ServiceRunning                            :
WP_CustomProps.bWPEnabled                                :
WP_CustomProps.WCStatus                                  :
WP_CustomProps.WPbComplianceStatus                       :
AM_CustomProps.ManifestVersion                           : 4725.0
AM_CustomProps.AMCoreContentDate                         : 2022-03-01T10:58:00+01:00
AM_CustomProps.V2DATVersion                              :
EPOProdPropsView_ENDPOINTSECURITYPLATFORM.productversion : 10.7.0.3255
EPOProdPropsView_THREATPREVENTION.productversion         : 10.7.0.3299
EPOProdPropsView_TIECLIENTMETA.productversion            : 10.7.0.3437
EPOProdPropsView_FIREWALL.productversion                 :
EPOProdPropsView_WEBCONTROL.productversion               :
```
