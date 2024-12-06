set shell := ["pwsh","-NoProfile","-NoLogo","-Command"]

default:
  @just --choose

list model:
    ollama list

chat:
    ollama run qwq

vram-usage-show:
    nvidia-smi --query-gpu=memory.total,memory.used,memory.free --format=csv

vram-usage-watch:
    #!pwsh
    while ($true) {
        $x = nvidia-smi --query-gpu=memory.total,memory.used,memory.free --format=csv
        Clear-Host
        $x | Write-Host
        Start-Sleep -Seconds 1
    }

run-pwsh-embed:
    #!pwsh
    cd api/pwsh
    .\embed.ps1

run-python-hello-requests:
    #!pwsh
    cd api/python
    uv run hello-requests.py

run-python-hello-sdk:
    #!pwsh
    cd api/python
    uv run hello-sdk.py

run-python-structured:
    #!pwsh
    cd api/python
    uv run structured-output.py

create-ollama-qwen-model:
    ollama create qwen2.5:iq4 --file .\models\Qwen2.5-14B-Instruct-IQ4_XS.Modelfile