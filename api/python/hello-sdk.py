import ollama

# Define the model and prompt
model_name = 'qwq'
prompt = 'hello'

# Create the message payload
messages = [{'role': 'user', 'content': prompt}]

# Generate the response
response = ollama.chat(model=model_name, messages=messages)

# Output the response content
print(response['message']['content'])
