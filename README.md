# usc-gha

A Github action for using the upload service client, `usc`.

## Setup

- Add an action below to your workflow.
- Change the code to fit your project and paths.
- Add the required secrets, the AWS keys, to your Github project.
- Push it, then watch the Action tab on Github.
- Debug whatever problems you get.


### Action

```yaml
# Deploy contents of build directory to dev
- name: Deploy to Dev
  if: github.ref == 'refs/heads/master'
  uses: mammutmw/usc-gha@v1.1.0
  with:
    aws_access_key: ${{secrets.AWS_ACCESS_KEY_ID}}
    aws_secret_access_key: ${{secrets.AWS_SECRET_ACCESS_KEY}}
    cmd: 'upload'
    src: 'build'
    target: 'my-target'
    info_git: 'https://github.com/my-org/my-repo'
    info_slack: '#project-slack-channel'
    info_email: 'project@email.com'
```

### Example workflow

Here's a full example, [usc-github-action-example](https://github.com/ingka-group-digital/usc-github-action-example).

```yaml
# .github/workflows/main.yml
name: Node build and deploy with USC
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v1
        with:
          node-version: '12.x'
      - name: Dump GitHub context, for debugging
        env:
          GITHUB_CONTEXT: ${{ toJson(github) }}
        run: echo "$GITHUB_CONTEXT"

      # Your stuff
      - run: npm install

      # Build the site in the build directory.
      # build/
      #     - se/sv/your-project
      #     - ca/en/your-project
      #     - ca/fr/your-project
      - run: npm run build
        env:
          SITE_FOLDER: aj/xx,aj/yy
          IS_RELEASE: ${{github.ref == 'refs/heads/release'}}

      - name: List the files in your build, for debugging
        run: find build -print

        # Deploy contents of build directory to dev
      - name: Deploy to CTE
        if: github.ref == 'refs/heads/master'
        uses: mammutmw/usc-gha@v1.0.0
        with:
          aws_access_key: ${{secrets.AWS_ACCESS_KEY_ID}}
          aws_secret_access_key: ${{secrets.AWS_SECRET_ACCESS_KEY}}
          cmd: 'upload'
          src: 'build'
          target: 'my-target'
          info_git: 'https://github.com/my-org/my-repo'
          info_slack: '#project-slack-channel'
          info_email: 'project@email.com'

        # Deploy contents of build directory prod
      - name: Deploy to PROD
        if: github.ref == 'refs/heads/release'
        uses: mammutmw/usc-gha@v1.0.0
        with:
          aws_access_key: ${{secrets.AWS_ACCESS_KEY_ID}}
          aws_secret_access_key: ${{secrets.AWS_ACCESS_KEY_SECRET}}
          cmd: 'upload'
          src: 'build'
          target: 'my-prod-target'
          info_git: 'https://github.com/my-org/my-repo'
          info_slack: '#project-slack-channel'
          info_email: 'project@email.com'
```

### Parameters

| Name | Description | Default |
-------|-------------|----------|
| aws_access_key | The AWS_ACCESS_KEY_ID | required |
| aws_secret_access_key | 'The AWS_SECRET_ACCESS_KEY' | required |
| cmd | 'The command to run' | 'upload' |
| debug | 'Debug output' | false |
| src | 'root directory of files' | required |
| dry | 'dry run, only output files to be uploaded' | false |
| files | 'Comma-separated list of files to wait upload' | optional |
| target | 'The target site and (optionally) directory' | required |
| timeout | 'timeout in seconds' | 60 |
| verbose | 'verbose output' | true |
| wait | 'wait until files are uploaded' | false |
| info_git | 'Git repository of this project' | optional |
| info_slack | 'Slack channel of this project' | optional |
| info_email | 'Email address of this project or person responsible' | optional |
| newer | Files must be newer than this date, format: https://github.com/tj/go-naturaldate/blob/master/naturaldate_test.go' | optional |
| older | Files must be older than this date, format: https://github.com/tj/go-naturaldate/blob/master/naturaldate_test.go' | optional |
| includes | Files must match this regexp | optional |
| excludes | Files must NOT match this regexp | optional |
