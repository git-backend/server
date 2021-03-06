# GitBackend Server

GitBackend Server provides an API for cloning, editing and pushing data to a git repository.

## Example

[Simple UI](https://github.com/git-backend/simple-ui)

## Installation

The easiest way to deploy is to use this "deploy to heroku" button:

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

For other platforms, GitBackend Server is a [sinatra](http://www.sinatrarb.com/)
app, so instructions for deploying a sinatra app on your chosen platform should
work.

GitBackend Server relies on the following environment variables:

* `LOGIN_USER`
* `LOGIN_PASS`
* `SECRET` - e.g. 'F33UDNFUEPE8SURJ9BE44PI38PRNV58'
* `REMOTE_URL` - e.g. "https://[username]:[password]@github.com/owner/repo.git"
* `REMOTE_BRANCH`

## Usage

The server has the following routes:

### `POST /clone`

This clones the repo into the server's 'tmp' directory. Each session is given
it's own unique subdirectory to work in.

The route will respond with a list of the files in the repo, like the `GET /ls`
route below.

### `POST /push`

This pushes any changes back to the remote origin. It accepts a `message` URL
query to be used as a commit message. If not supplied, the default commit
message "GitBackend changes" is used.

### `GET /ls`

This route responds with a list of all the files in the local clone of the repo, e.g.

```json
{
  "files": ["index.html", "assets/app.js", "assets/img/logo.png"]
}
```

### `GET /read/*`

This route will respond with the content of a file, e.g.

```json
{
  "content": "console.log('hello world!');"
}
```

It uses the path given as the url as the path to find the file, e.g.

```
GET https://my-awesom-server.io/read/assets/app.js
```

### `POST /write/*`

This replaces or creates a file with the contents of the request body.

### `POST /delete/*`

This deletes a file.

## Contributing

1. [Fork it](https://github.com/git-backend/server/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
