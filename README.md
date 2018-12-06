# Mozilla static analysis crasher

# Configuration

Get a token from your dev Phabricator instance: http://phabricator-dev.allizom.org/conduit/login/

Write it in `.creds`


# Run

```
docker build -t crasher .
docker run -it --env-file=dev.env --env-file=.creds -v $(pwd)/cache:/cache  crasher bash
```
