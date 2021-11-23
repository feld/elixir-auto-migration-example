#!/bin/sh
# Hardcoded path, will only be useful in Docker images

set -eu

SCRIPTPATH="/opt/example/bin"

${SCRIPTPATH}/example eval Example.ReleaseTasks.run'('\"create\"')'
${SCRIPTPATH}/example eval Example.ReleaseTasks.run'('\"migrate\"')'
