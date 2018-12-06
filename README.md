# Mozilla static analysis crasher

This is a tool used to test Mozilla static analysis bot.

It provides the following:

 * hg robustcheckout
 * arcanist
 * a fresh clone of mozilla-central
 * automatic rebase of a provided patch
 * automatic login on [Phabricator dev](http://phabricator-dev.allizom.org)
 * keep your own environment clean

## Configuration

Get a token from your dev Phabricator instance: http://phabricator-dev.allizom.org/conduit/login/

Write it in `.creds` as following:

```
PHABRICATOR_TOKEN=cli-XXXX
```

## Build docker image

```shell
make build
```

## Publish a crash case

```shell
make crash patch=patches/xxx.diff
```
