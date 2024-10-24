# Set resource group, vmss name, and connection string to reflect your environment
$ResourceGroup = "acdnd-project"
$VMSSName = "udacity-vmss"
$ConnectionString = "InstrumentationKey=bc78d1dd-d45c-4c43-bedc-8b9edf698946;IngestionEndpoint=https://eastasia-0.in.applicationinsights.azure.com/;LiveEndpoint=https://eastasia.livediagnostics.monitor.azure.com/;ApplicationId=30425753-d629-4c36-8bfe-55816ecd5ca3"
$publicCfgHashtable =
@{
  "redfieldConfiguration"= @{
    "instrumentationKeyMap"= @{
      "filters"= @(
        @{
          "appFilter"= ".*";
          "machineFilter"= ".*";
          "virtualPathFilter"= ".*";
          "instrumentationSettings" = @{
            "connectionString"= "$ConnectionString"
          }
        }
      )
    }
  }
};
$privateCfgHashtable = @{};
$vmss = Get-AzVmss -ResourceGroupName $ResourceGroup -VMScaleSetName $VMSSName
Add-AzVmssExtension -VirtualMachineScaleSet $vmss -Name "ApplicationMonitoringWindows" -Publisher "Microsoft.Azure.Diagnostics" -Type "ApplicationMonitoringWindows" -TypeHandlerVersion "2.8" -Setting $publicCfgHashtable -ProtectedSetting $privateCfgHashtable
Update-AzVmss -ResourceGroupName $vmss.ResourceGroupName -Name $vmss
# Note: Depending on your update policy, you might need to run Update-AzVmssInstance for each instance