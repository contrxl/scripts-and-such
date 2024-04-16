#contrxl
#spectrev2 patch undo
#guidance from MS at https://msrc.microsoft.com/update-guide/vulnerability/CVE-2022-0001
#checks for spectre v2 patch & undoes it if detected

$spec_fix_key_path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
$spec_fix_key_present = Get-ItemProperty $spec_fix_key_path | Select-Object FeatureSettingsOverride
$spec_fix_key_value = (Get-ItemProperty -Path $spec_fix_key_path).FeatureSettingsOverride

try {
    if ($spec_fix_key_present) {
        Write-Host "`nKey detected, checking value..."
        if ($spec_fix_key_value -eq '0x00800000') {
            Write-Host "`nPatch detected, removing patch..." -f Red
            Remove-ItemProperty -Path $spec_fix_key_path -Name 'FeatureSettingsOverride'
            Write-Host "Patch removed!" -f Green

            $spec_fix_key_updated = Get-ItemProperty $spec_fix_key_path | Select-Object FeatureSettingsOverride
            Write-Host "Key located at: $spec_fix_key_path" -f Yellow
            Write-Host "Current key value: $spec_fix_key_updated`n" -f Yellow
        } else {
            Write-Host "Patch not applied." -f Green
            
            $spec_fix_key_updated = Get-ItemProperty $spec_fix_key_path | Select-Object FeatureSettingsOverride
            Write-Host "Key located at: $spec_fix_key_path" -f Yellow
            Write-Host "Current key value: $spec_fix_key_updated`n" -f Yellow
        }
    } else {
        Write-Host "Key not found, no action required to undo." -f Green
    }
} catch {
    Write-Warning "Failed to detect key or patch!"
}