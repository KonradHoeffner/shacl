# SHACL GitHub action

[![SHACL status](https://github.com/konradhoeffner/shacl/actions/workflows/test-action.yml/badge.svg)](https://github.com/konradhoeffner/shacl/actions/workflows/test-action.yml)

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
        uses: actions/checkout@v3
      - name: Validate against SHACL shape
        uses: konradhoeffner/shacl@v1
        with:
          shacl: myshaclfile.ttl
          data: |
                mydatafile1.ttl  
                mydatafile2.ttl  
                ...
                mydatafilen.ttl  
```

## Develop

If you want to develop this action, you can run it locally using `act`.
Test it using `act -j test-correct --reuse` and `act -j test-incorrect --reuse`.
You may need to specify a personal access token with `act -s GITHUB\_TOKEN=inserttokenhere`.
The first test is designed to succeed, the second is designed to fail with 2 violations but the result is inverted.

## Add SHACL badge in your repository README

You can show the SHACL validation status with a badge in your README like this:

```
[![SHACL status](https://github.com/username/reponame/actions/workflows/workflowname.yml/badge.svg)](https://github.com/username/reponame/actions/workflows/workflowname.yml)
```
