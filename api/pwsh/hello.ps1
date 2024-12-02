# Define the API endpoint
$apiUrl = "http://localhost:11434/api/generate"

# Create the JSON payload
$payload = @{
    model  = "qwq"  # Specify the model to use
    prompt = "hello"     # The input prompt
    stream = $false      # Disable streaming for a single response
} | ConvertTo-Json

# Set the content type header
$headers = @{
    "Content-Type" = "application/json"
}

# Send the POST request
$response = Invoke-WebRequest -Uri $apiUrl -Method POST -Headers $headers -Body $payload

# Parse and display the response
$result = $response.Content | ConvertFrom-Json
Write-Output $result.response
