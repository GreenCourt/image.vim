#
# powershell.exe -ExecutionPolicy Bypass -File script.ps1 
#
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName PresentationFramework

$img = [Windows.Forms.Clipboard]::GetImage();
if (-not $img) {
  Write-Output "image not found";
  [System.Windows.MessageBox]::Show("image not found","Error");
  exit 1;
}
$ms = New-Object System.IO.MemoryStream;
$img.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png);
$filename = (Get-Date -Format "yyyy-MMdd-HHmm-ss") + ".png";
[Convert]::ToBase64String($ms.ToArray()) | ssh host "tr -d '\r' | base64 -d >" $filename;
if ($LASTEXITCODE -ne 0) {
  [System.Windows.MessageBox]::Show("ssh failed","Error");
  exit 1
}
