#!/bin/sh

/app/config.sh --url ${GH_REPO_URL} --token ${GHA_RUNNER_TOKEN}
/app/run.sh
