# Reokr

## Table of Contents
* About
    * Resources
* Getting started
    * Installation
    * Scripts
    * Mail
* Contributing
    * Code Style
    * Testing
    * Deployment

## About
This project is the API that powers the Reokr web app.

### Resources
#### Environments
[Dev](https://reokr-dev.herokuapp.com/)

[Staging](https://reokr-staging.herokuapp.com/)

[Production](https://reokr.herokuapp.com/)

#### Other Links
[LogDNA](https://app.logdna.com/cd1986cee4/logs/view)


## Getting Started
### Installation
To install, first ensure that you have `docker` and `docker-compose` installed and running, then clone the repo:

```
git clone git@gitlab.com:mushaka-solutions/reokr.git
cd reokr
```

Create the local `.env` file and specify any sensitive credentials or other environment variables. To start, add the following
(non-sensitive) environment variables.

```
APP_DOMAIN=localhost:3000
AUTH_REDIRECT_URL=http://localhost:3000
THOR_MERGE=vim
```

Recommendation: set up `bash` aliases and functions for `docker-compose` to shorten some of the commonly used commands.
Add the following to your `.bashrc` configuration to enable use of `dew` instead of `docker-compose exec web` and `dup`
instead of `docker-compose up`.
```
dew() {
    docker-compose exec web $@
}

alias dup='docker-compose up'
```

Build the containers.
```
docker-compose build
```

Create the database and run the migrations.

```
docker-compose exec web bundle exec rails db:create
docker-compose exec web bundle exec rails db:migrate
```

Start the server.
```
docker-compose up
```

### Scripts
Scripts are built and used to test the API and create resources within the API. To run a script, execute command:

```
docker-compose exec web bundle exec rails runner scripts/[SCRIPT FILENAME]
```

### Mail
This application uses Mailcatcher for local development and Mailcatcher in the dev and staging environments. You
can access the Mailcatcher inbox by visiting [http://127.0.0.1:1080/](http://127.0.0.1:1080) in your browser. To
access the Mailtrap inboxes, you will need to click the Mailtrap integration from the app in the Heroku dashboard.

## Contributing
### Code Style
For ruby, we use Rubocop to enforce code style and Reek to find code smells.
To manually run `rubocop`, you can run the following commands:

```
# Run rubocop for the entire project
docker-compose exec web bundle exec rubocop
# Run rubocop for a specific file
docker-compose exec web bundle exec rubocop foo/bar.rb
```

To manually run `reek`, you can execute:
```
docker-compose exec web bundle exec reek
```

### Testing
The test suite is executed on every commit to GitLab, and it can be run manually on your local machine:
```
docker-compose exec web bundle exec rspec
```

### Deployment
To deploy, you will need the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#download-and-install) utility
installed as well as access to the app instances.

Set up the git remotes for each app instance.
```
heroku git:remote -a reokr-dev
git remote rename heroku heroku-dev
heroku git:remote -a reokr-staging
git remote rename heroku heroku-staging
```

The `heroku-dev` remote should be used when pushing up changes on a feature branch to test in a deployed environment prior
to merging that feature branch into `master`. You can do this by overwriting the `master` branch on the `heroku-dev` remote
(replace `feature-branch` with the name of your actual feature branch).
```
git push heroku-dev feature-branch:master
```

After merging a feature branch into `master`, you can deploy the changes to the staging environment of the production pipeline
for acceptance testing. Changes should be promoted to production via the pipeline functionality within the Heroku web interface
after acceptance testing has passed.
```
git push heroku-staging master
```
