if !has('win32') && !exists('$WSLENV')
  finish
endif

command PasteImage
      \ echo system('powershell.exe -Command -', [
      \ '[Console]::OutputEncoding = [System.Text.Encoding]::UTF8;',
      \ 'Add-Type -AssemblyName System.Windows.Forms',
      \ 'Add-Type -AssemblyName System.Drawing',
      \ '$img = [Windows.Forms.Clipboard]::GetImage();',
      \ 'if (-not $img) { Write-Output "image not found"; exit 1; }',
      \ '$filename = (Get-Date -Format "yyyy-MMdd-HHmm-ss") + ".png"',
      \ '$img.Save($filename, [System.Drawing.Imaging.ImageFormat]::Png)',
      \ 'Write-Output "saved: $filename"',
      \ ])->trim()
