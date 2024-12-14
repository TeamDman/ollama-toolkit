$action = Get-ChildItem -Path actions `
| Select-Object -ExpandProperty name `
| Sort-Object -Descending `
| fzf --prompt "Action: " --header "Select an action to run"
if ([string]::IsNullOrWhiteSpace($action)) {
    break
}

# Run the selected action
. ".\actions\$action"