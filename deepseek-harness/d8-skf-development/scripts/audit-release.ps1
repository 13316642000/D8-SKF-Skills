param([string]$RepositoryRoot = (Get-Location).Path)
$files = @(
 'SKF\D8Skf.h',
 'bin\Win32\Release\D8SKF.dll','bin\Win32\Release\D8SKF.lib','bin\Win32\Release\D8Static.lib',
 'bin\x64\Release\D8SKF.dll','bin\x64\Release\D8SKF.lib','bin\x64\Release\D8Static.lib',
 'bin\linux\x86_64-glibc231\libD8_x64.so','bin\linux\arm\libD8_arm.so',
 'bin\linux\arm64\libD8_arm64.so','bin\linux\LoongArch64\libD8_LoongArch64.so','bin\linux\loongson\libD8_loongson.so',
 'bin\macos\x86_64\libD8SKF.dylib','bin\macos\arm64\libD8SKF.dylib','bin\macos\universal\libD8SKF.dylib'
)
$result = foreach($file in $files){
 $path=Join-Path $RepositoryRoot $file
 if(Test-Path -LiteralPath $path -PathType Leaf){$item=Get-Item -LiteralPath $path;[pscustomobject]@{File=$file;Present=$true;Bytes=$item.Length;SHA256=(Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash}}
 else{[pscustomobject]@{File=$file;Present=$false;Bytes=$null;SHA256=$null}}
}
$result | Format-Table -AutoSize
if($result.Present -contains $false){exit 1}
