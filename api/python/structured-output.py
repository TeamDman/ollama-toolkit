from pydantic import AfterValidator, BaseModel, ValidationError
from typing import Annotated, Dict, List, Set
from openai import OpenAI
import instructor
from loguru import logger
import requests

ollama_url = "http://127.0.0.1:11434"
model = "qwen2.5:iq4"
# model = "qwq"

# Initialize the instructor client
client = instructor.from_openai(
    OpenAI(
        base_url=f"{ollama_url}/v1",
        api_key="ollama",  # required, but unused
    ),
    mode=instructor.Mode.JSON,
)

class ModelResponseType(BaseModel):
    numbers: List[int]

class DesiredResponseType(BaseModel):
    numbers: List[int]
    min: int
    max: int


def main():
    prompt = """
<purpose>
    You are a number printing agent.
    Your response should be a JSON object containing a single property "numbers" which is a list of 3 numbers N := {n | 100 <= n < 1000}
</purpose>
<example-response>
<![CDATA[
    {
        "numbers": [100,101,200]
    }
]]>
</example-response>
"""
    logger.debug(f"Prompt: {prompt}")

    def validate(model_response: ModelResponseType) -> DesiredResponseType:
        min_value = min(model_response.numbers)
        max_value = max(model_response.numbers)
        if min_value < 100 or max_value >= 1000:
            raise ValueError(f"Invalid numbers: {model_response.numbers}")
        return DesiredResponseType(numbers=model_response.numbers, min=min_value, max=max_value)
    
    logger.info("Sending prompt to LLM")
    response: DesiredResponseType = client.completions.create(
        model=model,
        messages = [
            {
                "role": "system",
                "content":prompt
            }
        ],
        # max_retries=10,
        max_retries=1,
        response_model=Annotated[ModelResponseType, AfterValidator(validate)], # type: ignore
    )
    logger.info(f"Model said: {response}")


# Run the app
if __name__ == "__main__":
    main()