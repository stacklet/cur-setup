_:
    @just --list --unsorted

# format terraform files
format:
    terraform fmt -recursive

# lint files
lint:
    uvx prek run --all-files
