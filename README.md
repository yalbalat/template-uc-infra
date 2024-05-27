# EMEA UC cookiecutter template

This repository contains a Cookiecutter template designed specifically for data transformation use cases in EMEA. Cookiecutter is a command-line utility that automates the creation of project structures based on predefined templates. It streamlines the setup process and promotes consistency across projects.

To see an example of a built template with default variables, go to the `cookiecutter-built-template-default` branch.

## 🎥 How to initialize a new project using the template infra v2 ?

- Link to confluence page: https://confluence.e-loreal.com/pages/viewpage.action?pageId=503492275

## Prerequisites
Before using this template, make sure you have the following installed on your system:

1. [Python](https://www.python.org/)
2. [Cookiecutter](https://cookiecutter.readthedocs.io/)

## Usage

### 1. Installing Cookiecutter
If you don't already have Cookiecutter installed, you can install it using `pip` by running the following command:

```sh
pip install cookiecutter
```

### 2. Setting up the template

```sh
cd path/where/you/want/to/clone/the/repo/
cookiecutter https://github.com/oa-emea/emea-template-uc-infrastructure-v2
```

Cookiecutter will prompt you to enter values for variables defined in the template. These variables could include project names and other project-specific information.

Once you have provided all the necessary inputs, Cookiecutter will generate the project structure based on the template and fill in the provided values for variables.

Then, you are ready to go. A folder with the name of your project has been created. You can now start working on your project.

## GitHub Action: Build Cookiecutter Template on Push to Main

A GitHub Action has been created to automate the building process of the Cookiecutter template. Whenever a push event occurs on the `main` branch, the action triggers the generation of the Cookiecutter template and places it in the branch named `cookiecutter-built-template-default`. This built template is made available for informational purposes and serves as an example of a fully built template. It can also be useful for running tests, such as executing pre-commit checks.

The automated building of the template ensures that the latest changes and improvements are immediately available for viewing and testing.

## Develop in the template

To test your changes directly in GCP, you can use the utility tool in the `dev-utils` folder. It will use the variables you specify in the `cookiecutter.json` file and submit a build in Cloud Build with all the CI/CD steps (Only terraform plan, no apply).

Please note, this tool is only for development purposes and will use the default Cloud Build service account, which is not recommended for production.

To run the CI/CD tests, run the following command:

```sh
./dev-utils/test-cicd.sh
```

You have also other utility scripts, for example to make a pre-commit test or to apply terraform code.
