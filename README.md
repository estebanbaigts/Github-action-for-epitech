# Github-action-for-epitech

## Scripts to generate coding style reports

### Linux

Requirement :

- [Docker](https://docs.docker.com/engine/install/) installed

Use `coding-style.sh`

It is also possible to generate a report without cloning the file with all the latest updates:

Use `curl -fsSL https://raw.githubusercontent.com/estebanbaigts/Github-action-for-epitech/main/coding-style.sh | bash -s`

### Windows

Requirements :

- [Docker](https://docs.docker.com/engine/install/) installed
- [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows) installed

Use `coding-style.ps1`

### Report

## '''

                          Epitech Coding Style Report

## Path: /repository

## File Line Error Severity

## map_collision.c 24 C-G8 MINOR

## TOTAL MAJOR: 0 MINOR: 1 INFO: 0 NOTE: -1

'''

### Github Action

Github allows you to add automatic tests when you make a push. You can test for standard errors in your repository.

You will receive an email if the coding style checker detects standard errors.

Create a .github/workflows/ folder in the root of your project.
Create a file named coding_style.yml in the .github/workflows/ folder and place the following content inside the file:
