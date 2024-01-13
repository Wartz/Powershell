# Set the tenant ID, client ID, and client secret
$tenantID = "your_tenant_id"
$clientID = "your_client_id"
$clientSecret = "your_client_secret"

# Set the serial number of the device and the security group ID
$serialNumber = "your_device_serial_number"
$securityGroupID = "your_security_group_id"

# Get an access token for the Microsoft Graph API
$tokenAuthUrl = "https://login.microsoftonline.com/$tenantID/oauth2/token"
$resource = "https://graph.microsoft.com"
$body = @{
    grant_type = "client_credentials"
    client_id = $clientID
    client_secret = $clientSecret
    resource = $resource
}
$token = (Invoke-WebRequest -Method Post -Uri $tokenAuthUrl -Body $body).Content | ConvertFrom-Json
$accessToken = $token.access_token

# Get the device ID with the given serial number
$devicesUrl = "https://graph.microsoft.com/beta/devices?$filter=serialNumber eq '$serialNumber'"
$devices = (Invoke-WebRequest -Headers @{Authorization = "Bearer $accessToken"} -Uri $devicesUrl).Content | ConvertFrom-Json
$deviceID = $devices.value[0].id

# Add the device to the security group
$addDeviceUrl = "https://graph.microsoft.com/beta/groups/$securityGroupID/members/$ref"
$body = @{
    "@odata.id" = "https://graph.microsoft.com/beta/devices/$deviceID"
}
Invoke-RestMethod -Method Post -Uri $addDeviceUrl -Headers @{Authorization = "Bearer $accessToken"} -ContentType "application/json" -Body (ConvertTo-Json $body)
