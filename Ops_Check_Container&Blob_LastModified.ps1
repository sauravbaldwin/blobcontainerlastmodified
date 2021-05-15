$storageobjs=@()
$Subscriptions = Get-AzSubscription
#Set-AzContext -Subscription $Subscriptions
foreach ($sub in $Subscriptions)
{
   Get-AzSubscription -SubscriptionName $sub.Name | Set-AzContext
$storages = Get-AzStorageAccount
#$ctxs=$storages.Context
        foreach($storage in $storages)
            {
        #foreach($ctx in $ctxs)
            #{
            #$ctx=$null
                $ctx=$storage.Context
                $storageblobProperties = $storage | Get-AzStorageServiceProperty -ServiceType Blob
                $containers=Get-AzStorageContainer -Context $ctx #| Out-String | Select-Object -Property Name
                #$storageProperties = $storage | Get-AzStorageServiceProperty -ServiceType Blob
                    foreach($container in $containers)  
                        {
                        #$containername=$container.Name
                            $blobs=Get-AzStorageBlob -Container $container.Name -Context $ctx -MaxCount 50 #| Select-Object -Property Name
                                foreach($blob in $blobs)
                                {
         $storageInfo = [pscustomobject]@{
        'Storage Name'=$storage.StorageAccountName
        'Container Name'=$container.Name
        'Container Last Modified'=$container.LastModified.Date
        'Blob Name'=$blob.Name
        'Blob Last Modified'=$blob.LastModified.Date 
        'Soft Delete Enabled'= $storageblobProperties.DeleteRetentionPolicy.Enabled
        'Kind'=$storage.Kind
        'Replication'=$storage.Sku.Name
        'Secure Transfer Enabled'=$storage.EnableHttpsTrafficOnly
        'ResourceGroupName'=$storage.ResourceGroupName
        'Subscription'=$sub.Name
            }
        $storageobjs+=$storageInfo
                            }
            }
}
}
$storageobjs | Export-Csv -Path "xxxx\xxxx\xxxx\\Documents\xxxx\xxxxxx.csv" -NoTypeInformation
Write-Host "Storage Account Configuration written to the csv file"
Invoke-Item "xxxx\xxxx\xxxx\\Documents\xxxx\xxxxxx.csv"