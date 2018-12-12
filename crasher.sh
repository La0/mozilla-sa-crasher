#!/bin/bash
set -e -x

CACHE=/cache
REPO=$CACHE/mozilla-central
SHARED=$CACHE/mozilla-central-shared
PATCH=/patch.diff

# Check phabricator config from env
# TODO

# Check we have a patch
[ -f $PATCH ]

# Clone repo
echo 'Cloning mozilla-central'
hg robustcheckout --purge --sharebase $SHARED --branch tip https://hg.mozilla.org/mozilla-central $REPO

# Setup arcanist
echo 'Writing arcanist config'
cat <<EOF >$REPO/.arcconfig 
{
  "phabricator.uri" : "$PHABRICATOR_URI",
  "repository.callsign": "MOZILLACENTRAL",
  "history.immutable": false
}
EOF
cat <<EOF >$HOME/.arcrc 
{
  "hosts": {
    "$PHABRICATOR_URI/api/": {
      "token": "$PHABRICATOR_TOKEN"
    }
  },
  "config": {
    "default": "$PHABRICATOR_URI/api/"
  }
}
EOF
chmod 600 $HOME/.arcrc 

# Test credentials
echo {} | arc call-conduit user.whoami | python -m json.tool

# Apply crash
cd $REPO
patch -p1 -i $PATCH

# Create a revision
arc diff -a -m "Test automatic static analysis crash" --skip-staging --reviewers ReviewBot --nounit --nolint
