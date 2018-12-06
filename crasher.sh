#!/bin/bash
set -e -x

CACHE=/cache
REPO=$CACHE/mozilla-central
SHARED=$CACHE/mozilla-central-shared

# Check phabricator config from env
# TODO

# Clone repo
echo 'Cloning mozilla-central'
hg robustcheckout --purge --sharebase $SHARED --branch tip https://hg.mozilla.org/mozilla-central $REPO

# Setup arcanist
echo 'Writing arcanist config'
cat <<EOF >$REPO/.arcconfig 
{
  "phabricator.uri" : "$PHABRICATOR_URI"
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
