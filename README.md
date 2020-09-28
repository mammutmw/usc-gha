# usc-gha

A Github action for using the upload service client, `usc`.

## Setup

- Add the workflow to `.github/workflows/main.yml`
- Change the code to fit your project and paths.
- Add the required secrets, the AWS keys, to your Github project.
- Push it, then watch the Action tab on Github.
- Debug whatever problems you get.


### Example workflow

```
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
        uses: mammutmw/usc
        with:
          aws_access_key: ${{secrets.AWS_ACCESS_KEY_ID}}
          aws_secret_access_key: ${{secrets.AWS_SECRET_ACCESS_KEY}}
          cmd: 'upload'
          src: 'build'
          target: 'my-target'
          verbose: 'true'
          info_git: 'https://github.com/my-org/my-repo'
          info_slack: '#project-slack-channel'
          info_email: 'project@email.com'

        # Deploy contents of build directory prod
      - name: Deploy to PROD
        if: github.ref == 'refs/heads/release'
        uses: mammutmw/usc
        with:
          aws_access_key: ${{secrets.AWS_ACCESS_KEY_ID}}
          aws_secret_access_key: ${{secrets.AWS_ACCESS_KEY_SECRET}}
          cmd: 'upload'
          src: 'build'
          target: 'my-prod-target'
          verbose: 'true'
          info_git: 'https://github.com/my-org/my-repo'
          info_slack: '#project-slack-channel'
          info_email: 'project@email.com'
```

Here's a working example, [usc-github-action-example](https://github.com/ingka-group-digital/usc-github-action-example).

