param(
    [string]$hostname,
    [string]$nodeTag,
    [string]$query,
    [string]$timeFilter = "(time > now() - 1h)",
    [string]$timeInterval = "1m",
    [string]$dbName = "k8s"
)

# Query example for cpu/usage_rate from Kubernetes cluster InfluxDB: $query = "SELECT sum(`"value`") FROM `"cpu/usage_rate`" WHERE `"type`" = 'node' AND (time > now() - 1h) GROUP BY time(1m), `"nodename`" fill(null) ORDER BY DESC LIMIT 1"
# Find more queries in the Grafana metric query for various dashboard entries (Nodes/Pods)

$result = Invoke-WebRequest "$hostname/query?q=$query&db=$dbName"
if ($result.StatusCode -eq 200) {
    $resultObj = ($result.Content | ConvertFrom-Json).results.series
    [System.Collections.ArrayList]$resultsArray = @()
    foreach ($entry in $resultObj) {
        if ($entry.tags.nodename -eq $nodeTag) {
            Write-Host "Yes $entry"
            [pscustomobject]$result = @{Time=$entry.values[0][0];Value=$entry.values[0][1];}
            [void]$resultsArray.Add($result)
        } else {
            continue
        }

        if ($resultsArray.Count -gt 0) {
            return $resultsArray
        } else {
            Write-Host "No results"
            return $null
        }
    }
}
else {
    Write-Error "Error from InfluxDB endpoint with status: $($result.StatusCode)"
}