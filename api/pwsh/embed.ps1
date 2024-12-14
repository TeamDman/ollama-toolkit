# Define the API endpoint
$apiUrl = "http://localhost:11434/api/embed"

# Create the JSON payload
$payload = @{
    # model  = "snowflake-arctic-embed"
    # model  = "snowflake-arctic-embed:22m"
    model  = "snowflake-arctic-embed:137m"
    input = "this is some long content " * 400
} | ConvertTo-Json

# Set the content type header
$headers = @{
    "Content-Type" = "application/json"
}

# Send the POST request
$response = Invoke-WebRequest -Uri $apiUrl -Method POST -Headers $headers -Body $payload

$response | Write-Host

# Parse and display the response
$result = $response.Content | ConvertFrom-Json
Write-Output $result.response
