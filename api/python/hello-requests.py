import requests

# Define the API endpoint
api_url = "http://localhost:11434/api/generate"

# Create the JSON payload
payload = {
    "model": "qwq",  # Specify the model to use
    "prompt": "hello",    # The input prompt
    "stream": False       # Disable streaming for a single response
}

# Set the headers
headers = {
    "Content-Type": "application/json"
}

# Send the POST request
response = requests.post(api_url, json=payload, headers=headers)

# Parse and display the response
if response.status_code == 200:
    result = response.json()
    print(result.get("response", "No response field found in the API response."))
else:
    print(f"Error: {response.status_code}, {response.text}")
