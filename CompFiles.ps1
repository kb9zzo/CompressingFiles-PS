$RootDefault = 'C:\users\seth\desktop\flight logs'
$DestinationDefault = 'C:\users\seth\desktop'

Write-Host ""

$RootDefault
$root = Read-Host -Prompt 'Do you want to use the default search path? [Y] [N]' 
if ($root -eq 'Y')
    {$root = $RootDefault}
else
    {$root = Read-Host -Prompt 'Enter the root search path:'}

Write-Host ""
Write-Host ""

$DestinationDefault
$Destination = Read-Host -Prompt 'Do you want to use the default destination path? [Y] [N]' 
if ($Destination -eq 'Y')
    {$Destination = $DestinationDefault}
else
    {$Destination = Read-Host -Prompt 'Enter the destination Path:' }

Add-Type -assembly "system.io.compression.filesystem"

Write-Host ""
Write-Host ""

foreach ($Job in Get-Childitem -Path $root -Include '*spron.dbf' -File -Recurse) {
    $Files = Get-Childitem -Path $Job.Directory.FullName -Include ($Job.basename + '.*') -File -Recurse | SELECT fullname, name, directory, basename
    $Files 
    $FinalDestination = ($Destination + '\' + $job.BaseName)
    $i = 1

    if (Test-Path ($FinalDestination + '.zip')) {
        While (Test-Path ($FinalDestination + '-' + $i + '.zip')) { $i++ }
        $FinalDestination = ($FinalDestination + '-' + $i + '.zip') }
    else {$FinalDestination = ($FinalDestination + '.zip')}

    Get-Childitem -Path $Job.Directory.FullName -Include ($Job.basename + '.*') -File -Recurse | Write-Zip -OutputPath $FinalDestination -EntryPathRoot $Job.Directory.FullName -NoClobber 
}
