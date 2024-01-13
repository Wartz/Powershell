$uri = "https://download.microsoft.com/download/1/0/5/1059800B-F375-451C-B37E-758FFC7C8C8B/WindowsAdminCenter2311.msi"
$file = "wac2311.msi"

Invoke-WebRequest -uri $uri -OutFile $file

# Install WAC with self signed cert and default port
# Set SME_PORT=443 for self-signed https
msiexec /i .\wac2311.msi /qn /L*v log.txt SME_PORT=6516 SSL_CERTIFICATE_OPTION=generate
