# SHACL GitHub action

This action will validate an RDF graph against a SHACL graph using [pySHACL](https://github.com/RDFLib/pySHACL).

## Use

Add `.github/workflows/shacl.yml` with the following content:

```yml
name: shacl
 
on:
  workflow_dispatch:   
  push:
    branches:
      - master    
 
jobs:
  test:
    runs-on: ubuntu-latest 
    steps:  
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Validate against SHACL shape
        uses: konradhoeffner/shacl@v1
        with:
          shacl: myshaclfile.ttl
          data: mydatafile.ttl  
```

## Develop

If you want to develop this action, you can run it locally using `act`.
However it includes other actions, which you can only do with the master branch but is not released as of 2022-03-10.
You can install the master branch of `act` with `go install -ldflags="-s -w" github.com/nektos/act@master`.
Test it using `act -j test --reuse`.
The first test step is designed to succeed, the second is designed to fail with 2 violations.

## Add SHACL badge in your repository README

You can show the SHACL validation status with a badge in your README.

TODO
