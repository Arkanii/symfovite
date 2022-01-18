# Symfovite

[![gitmoji badge](https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg?style=flat-square)](https://github.com/carloscuesta/gitmoji)

> Start Vite a SPA with an API using API Platform and React !

## Requirements

- [Docker](https://docs.docker.com/get-docker)
- [Docker Compose](https://docs.docker.com/compose/install)
- [Symfony CLI](https://symfony.com/download)
- [Composer](https://getcomposer.org/download)
- [Yarn](https://yarnpkg.com/getting-started/install)

## How to start a new project with this template ?

1) [Generate your project from GitHub](https://github.com/Arkanii/symfovite/generate) and create two more empties projects
2) Clone your project and go inside
3) Run :

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

4) Change Git remote origin from `back` and `front` repositories :

```shell
$ cd back
$ git remote set-url origin git@<repo_url>:<url>/<git_repository>.git
$ cd ../front
$ git remote set-url origin git@<repo_url>:<url>/<git_repository>.git
```

5) Inside `.gitmodules` file, change the `url` options to accord to your empties projects :

```
[submodule "back"]
	path = back
	url = git@<repo_url>:<url>/<git_repository>.git
[submodule "front"]
	path = front
	url = git@<repo_url>:<url>/<git_repository>.git
```

6) Push content of both submodules

7) You're done ! Just run :

```shell
$ make start
```

All is started and opened for you ! :tada:

## How to ... ? ( run `make help` to list all available commands )

- start to work on the project :

```shell
$ make start
```

- stop working on the project :

```shell
$ make stop
```

## How to open ... ? ( run `make help` to list all available commands )

- the API Platform interface : 

```shell
$ make open-api
```

- the React application :

```shell
$ make open-react
```
