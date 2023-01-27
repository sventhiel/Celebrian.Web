# Variables / Parameters
$imageDirectory = "C:\inetpub\wwwroot\JenaExperiment\images\"
$jsonFile = "C:\inetpub\wwwroot\JenaExperiment\images.json"
$baseUrl = "http://www.bgc-jena.mpg.de/~freiland/biodiv/images/Bio"

# Images Download
$currentDate = Get-Date -date "2020-04-01"
$today = Get-Date

while($currentDate -le $today)
{
    # Write-Output (Get-Date -format "yyyyMMdd" -date $currentDate)
    try 
    {
        $source = $baseUrl+$(Get-Date -format "yyyyMMdd" -date $currentDate)+"1400.jpg"
        $contentType = (Invoke-WebRequest $source -Method Head).Headers.'Content-Type'
        $contentLength = (Invoke-WebRequest $source -Method Head).Headers.'Content-Length'

        if($contentType -eq "image/jpeg")
        {
            $destination = $imageDirectory+$(Get-Date -format "yyyy-MM-dd" -date $currentDate)+".jpg"
            if(Test-Path $destination) # -And ($contentLength -eq (Get-Item $destination).length)
            {
                Write-Output "The image for $(Get-Date -format "yyyy-MM-dd" -date $currentDate) was downloaded already."
                continue;
            }

            Invoke-WebRequest $source -OutFile $destination
            
            # image optimization
            .\jpegoptim.exe --max=55 -o --strip-all $destination
            .\jpegtran.exe -optimize $destination $destination
        }
        else
        {
            Write-Output "There is no image for $(Get-Date -format "yyyy-MM-dd" -date $currentDate)."
        }
    } 
    catch 
    {
	Write-Warning $Error[0]
        Write-Output "Cannot find image for $(Get-Date -format "yyyy-MM-dd" -date $currentDate)"
    }
    finally
    {
        $currentDate = (Get-Date -date $currentDate).AddDays(1)
    }

    
}

# JSON File

$jsonBase = @{}
$list = New-Object System.Collections.ArrayList

foreach($file in (Get-ChildItem $imageDirectory | Sort-Object -Property Name))
{
    $list.Add($file.Name) | Out-Null
}

$jsonBase.Add("images",$list)

$jsonBase | ConvertTo-Json -Depth 10 | Out-File $jsonFile -Encoding Default