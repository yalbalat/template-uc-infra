#!/bin/sh

# Check if the cookiecutter.json file exists
if [ ! -f "cookiecutter.json" ]; then
    echo "Error: cookiecutter.json file not found. Please make sure it is present in the current directory. You should be at the root of the template."
    exit 1
fi

# Set up variables
git_repository_name=$(jq -r '.git_repository_name' cookiecutter.json)
gcp_project_id=$(jq -r '.gcp_project_id' cookiecutter.json)
use_case=$(jq -r '.use_case' cookiecutter.json)

# Define other variables
BUILD_DIR="./test"
BUILD_SUBSTITUTIONS="_APPLY_CHANGES=false,_ENV=dv,_REGION=europe-west1,_USECASE=$use_case"

# Clean the test directory
rm -rf "$BUILD_DIR"/*

# Build using Cookiecutter
cookiecutter . -o "$BUILD_DIR" --no-input

# Navigate to the generated project directory
cd "$BUILD_DIR/$git_repository_name"

# Set the GCP project
gcloud config set project "$gcp_project_id"

# Submit the build
gcloud builds submit --substitutions "$BUILD_SUBSTITUTIONS" .
