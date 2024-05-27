#!/bin/sh

# Check if the cookiecutter.json file exists
if [ ! -f "cookiecutter.json" ]; then
    echo "Error: cookiecutter.json file not found. Please make sure it is present in the current directory. You should be at the root of the template."
    exit 1
fi

# Set up variables
git_repository_name=$(jq -r '.git_repository_name' cookiecutter.json)

# Define other variables
BUILD_DIR="./test"

# Clean the test directory
rm -rf "$BUILD_DIR"/*

# Build using Cookiecutter
cookiecutter . -o "$BUILD_DIR" --no-input

# Navigate to the generated project directory
cd "$BUILD_DIR/$git_repository_name"

cd iac/deploy-steps/2.accessmanagement/
terraform init -backend-config=../vars/backend/dv.tfvars
terraform apply -var-file=../vars/tfvars/dv.tfvars
