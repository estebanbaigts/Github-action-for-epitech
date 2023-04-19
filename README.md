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

```
-------------------------------------------------------------------------------
                          Epitech Coding Style Report

Path: /repository
-------------------------------------------------------------------------------
File                 Line     Error     Severity
-------------------------------------------------------------------------------
map_collision.c      24       C-G8      MINOR
-------------------------------------------------------------------------------
TOTAL          MAJOR: 0       MINOR: 1      INFO: 0      NOTE: -1
-------------------------------------------------------------------------------
```

### Github Action

Github allows you to add automatic tests when you make a push. You can test for standard errors in your repository.

You will receive an email if the coding style checker detects standard errors.

Create a .github/workflows/ folder in the root of your project.
Create a file named coding_style.yml in the .github/workflows/ folder and place the following content inside the file:

```
name : check_program_epitech

on :
  push :
    branches :
      - main

env:
  MIRROR_URL: "put the mirror url here (the ssh github of your repo) or leave it empty"
  EXECUTABLES: " put the name of the executable here (ex: ./my_executable) or leave it empty"

jobs:
  check_coding_style:
    name: Coding Style
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: check coding style
        run: curl -fsSL https://raw.githubusercontent.com/estebanbaigts/Github-action-for-epitech/main/coding-style.sh | bash -s . .
  check_repo:
    name: "Checks if the repo is clean"
    runs-on: ubuntu-latest
    needs : [check_coding_style]
    steps:
      - uses: actions/checkout@v3
      - id: check_repo
        run: |
          if [[ $(git status --porcelain) ]]
          then
            echo "::error file=README.md,title=Repo is not clean::"
            exit 1
          else
            echo Repo is clean
          fi
  check_program_compilation:
    needs: [check_coding_style, check_repo]
    name: "Checks if the program compiles"
    runs-on: ubuntu-latest
    container:
      image: epitechcontent/epitest-docker:latest
    steps:
      - uses: actions/checkout@v3
      - id: check_program_compilation
        run: make
        timeout-minutes: 2
      - run: make clean
      - run: |
          OIFS=$IFS
          IFS=','
          for x in $EXECUTABLES
            do
              ./$x $ARGUMENTS
            done
          IFS=$OIFS

  run_tests:
    needs: [check_coding_style, check_repo, check_program_compilation]
    name: "Runs the tests"
    runs-on: ubuntu-latest
    container:
      image: epitechcontent/epitest-docker:latest
    steps:
      - uses: actions/checkout@v3
      - id: run_tests
        run: make tests_run
        timeout-minutes: 2
```
