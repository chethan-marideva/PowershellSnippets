try
{
    # Load WinSCP .NET assembly
    Add-Type -Path "E:\Program Files\WinSCP\WinSCPnet.dll"
 
    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = ""
        UserName = ""
        Password = ""
        GiveUpSecurityAndAcceptAnySshHostKey="true" # do this line only for trusted system
        
        
    }
 
    $session = New-Object WinSCP.Session
 
    try
    {
        # Connect
        $session.Open($sessionOptions)
 
        # Upload files
        $transferOptions = New-Object WinSCP.TransferOptions
        $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary
        $transferOptions.ResumeSupport.State = [WinSCP.TransferResumeSupportState]::Off
 
        $transferResult =
            $session.PutFiles("E:\testc1.csv", "/HDFS_ROOT/user/srvc_ima_platform/EA/ibp_source_files/", $False, $transferOptions)
 
        # Throw on any error
        $transferResult.Check()
 
        # Print results
        foreach ($transfer in $transferResult.Transfers)
        {
            Write-Host "Upload of $($transfer.FileName) succeeded"
        }
    }
    finally
    {
        # Disconnect, clean up
        $session.Dispose()
    }
 
    exit 0
}
catch
{
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}