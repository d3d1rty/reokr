# Reokr

## Table of Contents
* About
    * Resources
* Getting started
    * Local Setup
    * Scripts
    * Mail
* API
    * Authentication
    * GraphQL
        * Queries
        * Mutations
* Contributing
    * Code Style
    * Testing
    * Deployment

## About
This project is the authenticated GraphQL API that powers the Reokr web app.

### Resources
#### Environments
[Dev](https://reokr-dev.herokuapp.com/)

[Staging](https://reokr-staging.herokuapp.com/)

[Production](https://reokr.herokuapp.com/)

#### Other Links
[LogDNA](https://app.logdna.com/cd1986cee4/logs/view)


## Getting Started
### Local Setup
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

## API
### Authentication
The authentication routes are mounted at `/auth`.

| ipath | method | purpose |
|-------|--------|---------|
| / | POST | Email registration. Requires email, password, password_confirmation, and confirm_success_url params (this last one can be omitted if you have set config.default_confirm_success_url in config/initializers/devise_token_auth.rb). A verification email will be sent to the email address provided. Upon clicking the link in the confirmation email, the API will redirect to the URL specified in confirm_success_url. Accepted params can be customized using the devise_parameter_sanitizer system. |
| / | DELETE | Account deletion. This route will destroy users identified by their uid, access-token and client headers. |
| / | PUT | Account updates. This route will update an existing user's account settings. The default accepted params are password and password_confirmation, but this can be customized using the devise_parameter_sanitizer system. If config.check_current_password_before_update is set to :attributes the current_password param is checked before any update, if it is set to :password the current_password param is checked only if the request updates user password. |
| /sign_in | POST | Email authentication. Requires email and password as params. This route will return a JSON representation of the User model on successful login along with the access-token and client in the header of the response. |
| /sign_out | DELETE | Use this route to end the user's current session. This route will invalidate the user's authentication token. You must pass in uid, client, and access-token in the request headers. |
| /:provider | GET | Set this route as the destination for client authentication. Ideally this will happen in an external window or popup. Read more. |
| /:provider/callback | GET/POST | Destination for the oauth2 provider's callback uri. postMessage events containing the authenticated user's data will be sent back to the main client window from this page. Read more. |
| /validate_token | GET | Use this route to validate tokens on return visits to the client. Requires uid, client, and access-token as params. These values should correspond to the columns in your User table of the same names. |
| /password | POST | Use this route to send a password reset confirmation email to users that registered by email. Accepts email and redirect_url as params. The user matching the email param will be sent instructions on how to reset their password. redirect_url is the url to which the user will be redirected after visiting the link contained in the email. |
| /password | PUT | Use this route to change users' passwords. Requires password and password_confirmation as params. This route is only valid for users that registered by email (OAuth2 users will receive an error). It also checks current_password if config.check_current_password_before_update is not set false (disabled by default). |
| /password/edit | GET | Verify user by password reset token. This route is the destination URL for password reset confirmation. This route must contain reset_password_token and redirect_url params. These values will be set automatically by the confirmation email that is generated by the password reset request. |
| /confirmation | POST | Re-sends confirmation email. Requires email and accepts redirect_url params (this last one can be omitted if you have set config.default_confirm_success_url in config/initializers/devise_token_auth.rb) |

### GraphQL
The GraphQL endpoint is mounted at `POST /graphql`. The following queries and mutations are defined:

#### Queries

allUsers
```
query {
  allUsers {
    id
    email
    firstName
    lastName
    username
    imageUrl
    bio
  }
}
```

showUser
```
query {
  showUser(id: 42 /*  Required; the user's ID */){
    id
    email
    firstName
    lastName
    username
    imageUrl
    bio
  }
}
```

#### Mutations

updateUser
```
mutation {
    updateUser(
      input: {
        id: 42 // Required; the user's ID.
        // The following arguments are optional.
        email: "jdoe@example.com
        firstName: "John"
        lastName: "Doe"
        username: "jdoe"
        imageUrl: "https://foo.bar/baz.png
        bio: "Hacking the day away."
      }
    )
  {
    errors
    user {
      id
      email
      firstName
      lastName
      username
      imageUrl
      bio
    }
  }
}
```

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
