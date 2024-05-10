$media_capability = DISM /Online /Get-CapabilityInfo /CapabilityName:Media.MediaFeaturePack~~~~0.0.1.0

try{
    if ($media_capability -like "*error*") {
        Write-Host "[*] Media Feature Pack not installed, installing..."
        DISM /Online /Add-Capability /CapabilityName:Media.MediaFeaturePack~~~~0.0.1.0 /NoRestart /Quiet
        Write-Host "[*] Capability should be installed, checking..."
        try{
            $media_capability = DISM /Online /Get-CapabilityInfo /CapabilityName:Media.MediaFeaturePack~~~~0.0.1.0
            if ($media_capability -like "*error*") {
                Write-Host "[+] Device restart is required!"
            } else {
                Write-Host "[+] $media_capability is installed! Device should be restarted..."
            }
        } catch {
            Write-Error "[-] An error occurred!"
        }
        } else {
            Write-Host "[+] Feature Pack is already installed!"
    }
} catch {
    Write-Host "[-] An error occurred!"
}