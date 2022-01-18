# Symfovite

[![gitmoji badge](https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg?style=flat-square)](https://github.com/carloscuesta/gitmoji)

> Start Vite a SPA with an API using API Platform and React !

### The project is actually working for a development environment, it is NOT production ready for the moment !

## Requirements

- [Docker](https://docs.docker.com/get-docker)
- [Docker Compose](https://docs.docker.com/compose/install)
- [Symfony CLI](https://symfony.com/download)
- [Composer](https://getcomposer.org/download)
- [Yarn](https://yarnpkg.com/getting-started/install)

## What is used inside this template ?

- Symfony project with API Platform
- Vite project with the React plugin and using TypeScript
- PostgreSQL database
- [Caddy](https://caddyserver.com/v2) server
- [MailCatcher](https://mailcatcher.me/) for debug mails and get a SMTP server
- A Makefile to automatise some process (run `make help` to list all available commands)

But you feel free to add or modify whatever you want !

## How to start a new project with this template ?

1) [Generate your project from GitHub](https://github.com/Arkanii/symfovite/generate) and create two more empties
   projects

2) Clone your project and go inside

3) If you want to update references automatically into the main repository for each push on
   submodules, [enable GitHub workflow](#enable-the-github-workflow).

4) Copy `.env.exemple` file into `.env` and [complete informations](#variables-available) :

```shell
$ cp .env.exemple .env
```

4) Run :

```shell
$ make init
```

This will :

- Create some git's aliases (`sdiff`, `spush`, `spull`)
- Pull submodules
- Checkout submodules branches to master
- Run `composer install` into `back` folder
- Run `yarn` into `front` folder
- Build Docker Compose configuration

5) Reset git configuration and change remote origin for `back` **and** `front` repositories :

```shell
$ cd back / front
$ rm -rf .git
$ git init
$ git remote add origin git@<repo_url>:<url>/<git_repository>.git
$ git add .
$ git commit -m 'Initial commit'
$ git push --force --set-upstream origin master
```

6) Inside `.gitmodules` file, change the `url` options to accord to your empties projects :

```
[submodule "back"]
	path = back
	url = git@<repo_url>:<url>/<git_repository>.git
[submodule "front"]
	path = front
	url = git@<repo_url>:<url>/<git_repository>.git
```

7) Push content of both submodules (you feel free to partially or completely edit them before !)

8) You're done ! Just run :

```shell
$ make start
```

All is started and opened for you ! :tada:

Run when you're done :

```shell
$ make stop
```

## Enable the GitHub Workflow

1) [Create a personal access token on GitHub](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
   with `read:org` and `repo` permissions with no expiration date

2) For each project (main one and both submodules) do :
    1) Go to `Settings > Secrets > Actions`
    2) Click on `New repository secret`
    3) Set `CI_TOKEN` into the `Name` input
    4) Paste your access token into the `Value` input
    5) Click on `Add secret` to validate

3) Run in a terminal where :
    - $CI_TOKEN is your personal access token
    - $PARENT_REPO is the name of the main repository (Ex : `Arkanii/symfovite`)

```shell
curl -X GET -H "Authorization: token $CI_TOKEN" https://api.github.com/repos/$PARENT_REPO/actions/workflows
```

4) Save the good workflow ID

5) In both submodules do:
    1) Go to `.github/workflows/submodule-notify-parent.yml`
    2) Change environment variables :
        - PARENT_REPO: The name of the main repository (Ex : `Arkanii/symfovite`)
        - PARENT_BRANCH: The main branch of your main repository
        - WORKFLOW_ID: The ID you saved in step 4

6) Optional : Change the name, the email and commit message in `.github/workflows/submodules-sync.yml`

7) Push all the files

8) And you're done ! :tada:

## Variables available

### Database

- `POSTGRES_DB`: Name of the database (Default: `symfony`)
- `POSTGRES_USER`: Name of the user (Default: `symfony`)
- `POSTGRES_PASSWORD`: User's password Please use a strong password (Default: `symfony`)
- `POSTGRES_PORT`: Port exposed by database container (Default: `5432`)
- `POSTGRES_VERSION`: Version of PostgreSQL (Default: `13`)

### PHP & Symfony ( API Platform )

- `PHP_VERSION`: PHP version (Default: `8.1`)
- `API_HTTP_PORT`: Port exposed by database container for browser connection in HTTP (Default: `55999`) 
- `API_HTTPS_PORT`: Port exposed by database container for browser connection in HTTPS (Default: `55995`)

### Vite

- `VITE_HTTP_PORT`: Port exposed by database container for browser connection in HTTP (Default: `80`)
- `VITE_HTTPS_PORT`: Port exposed by database container for browser connection in HTTPS (Default: `443`)

## What's next ?

- [ ] Tech : Automation of step 5-6-7 when create a new project
- [ ] Docs : Change default plugin for Vite (Vue.js / Preact / etc.)
- [ ] Tech : Create all production environment

## Credits

Created by Théo Frison, inspired and taken for some parts from [this project](https://github.com/dunglas/symfony-docker).
