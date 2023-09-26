# SHACL GitHub action

[![SHACL status](https://github.com/konradhoeffner/shacl/actions/workflows/test-action.yml/badge.svg)](https://github.com/konradhoeffner/shacl/actions/workflows/test-action.yml)

This action will validate an RDF graph against a SHACL graph using [pySHACL](https://github.com/RDFLib/pySHACL).

## Use

Add `.github/workflows/shacl.yml` with the following content:

```yaml
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
        uses: actions/checkout@v4
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
This was tested with the `act` medium image, however `act` differs from GitHub in many ways so this is just an approximation for quick iteration and you need to execute a test case on GitHub to get the exact output.

## Add SHACL badge in your repository README

You can show the SHACL validation status with a badge in your README like this:

```
[![SHACL status](https://github.com/username/reponame/actions/workflows/workflowname.yml/badge.svg)](https://github.com/username/reponame/actions/workflows/workflowname.yml)
```

## Example
On <https://github.com/hitontology/ontology> you can see an example of how it works.

### Status report on success

![Screenshot from 2022-09-21 10-08-21](https://user-images.githubusercontent.com/839577/191450639-b93bb54e-207d-4359-be34-a70f48220087.png)

### Status report on failure from another repository
![Screenshot from 2022-09-21 10-09-50](https://user-images.githubusercontent.com/839577/191451021-50cfaa6c-3d78-414b-8416-96bf797deb05.png)

### Badge
![shaclbadge](https://user-images.githubusercontent.com/839577/191450114-3aca51ab-27db-46b1-96fd-676a8d29749a.png)

## Technical details and history

At first there was a separate workflow that built a Dockerfile that just installed pySHACL on top of a Python image and included a custom entry point script that calls pySHACL in a loop over the potentially multiple data files and that creates the right output strings to interface with GitHub to get nice output like errors, warnings and info notifications and groups.
The reason to use a Dockerfile was that GitHub actions use a lot of time and clutter the log with messages to install dependencies and I wanted a quick build time and a clean log with only the statements that are interesting for the user who is validating SHACL data and is not interested in logging about installing things.

However I learned that while Docker is amazing for many things, it is not the preferred GitHub-way of doing things, because an action already has a "runner" which is kind of like a virtual machine / container, and using Docker on top of that does seem to integrate that well.
For example, the idea was to build the Docker image only once and save all the time for setup, but now GitHub actions would create the Docker image at every run, ruining all the potential benefits.
So I had to create another workflow inside the repository that built the Dockerfile and deployed it to the GitHub container registry.
While this was a few seconds quicker and the output more clean, this approach was much too convoluted and could get out of sync between the Docker image and the action itself, for example when running an older version of the workflow.

The current version v1 replaces the Dockerfile with a composite action that installs Python and then runs the entrypoint script directly.
While that created a few problems, for example that a workflow referencing the shared workflow from another repository couldn't access the entrypoint script or that there was no file at the target repository to create a hash for the setup-python cache for, this was solvable by disabling the setup-python cache and using actions/cache instead and by using the `${{github.action_path}}`.
