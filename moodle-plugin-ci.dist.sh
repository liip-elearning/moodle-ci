#!/bin/bash
set -e

# Plugins to check
TO_VERIFY=('blocks/disk_quota')

# Commands to run
COMMANDS_TO_RUN=('phplint')
COMMANDS_TO_RUN+=('phpcpd')
COMMANDS_TO_RUN+=('phpmd')
COMMANDS_TO_RUN+=('codechecker')
COMMANDS_TO_RUN+=('validate')
COMMANDS_TO_RUN+=('savepoints')
COMMANDS_TO_RUN+=('mustache')
COMMANDS_TO_RUN+=('grunt')
COMMANDS_TO_RUN+=('phpdoc')
COMMANDS_TO_RUN+=('phpunit')
COMMANDS_TO_RUN+=('behat')


if [ ${#TO_VERIFY[@]} -eq 0 ]; then
    echo "TO_VERIFY is empty. Nothing to do"
    exit 0
fi

rm -rf /tmp/moodle-ci/ 2>&1 1 || true
git clone --single-branch --branch master git@gitlab.liip.ch:elearning/moodle-ci.git /tmp/moodle-ci

. /tmp/moodle-ci/moodle-plugin-ci-sample.sh
exit $?
