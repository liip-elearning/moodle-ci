#!/bin/bash
set -e

function join_by { local IFS="$1"; shift; echo "$*"; }

function run_setup(){
    MOODLECIDIR=$1
    TO_VERIFY=$2
    PLUGIN_TO_SETUP_DIR="/tmp/ci/plugins/"
    mkdir -p ${PLUGIN_TO_SETUP_DIR}
    PLUGIN_TO_SETUP_FILE="${PLUGIN_TO_SETUP_DIR}/plugins.txt"
    # Create the config file
    rm $PLUGIN_TO_SETUP_FILE 2>&1 1>/dev/null || true
    touch $PLUGIN_TO_SETUP_FILE
    for i in "${TO_VERIFY[@]}"; do
        echo $i >> $PLUGIN_TO_SETUP_FILE
    done
    echo "Plugin that will be checked:"
    cat $PLUGIN_TO_SETUP_FILE

    # Drop previous setup if needed.
    php admin/tool/phpunit/cli/util.php  --drop 2>&1 1>/dev/null || true
    php admin/tool/behat/cli/util_single_run.php  --drop 2>&1 1>/dev/null || true

    # Run the setup
    export NPM_SUDO=1
    ${MOODLECIDIR}/bin/moodle-plugin-ci install \
        --moodle /vagrant -vvv --no-clone --db-type=pgsql --db-user=moodle --db-pass=moodle --db-create-skip --extra-plugins $PLUGIN_TO_SETUP_DIR -vvv
}

REPO_URL=https://github.com/ragusa87/moodle-plugin-ci
REPO_BRANCH=localmdl
MOODLECIDIR=/tmp/ci/moodle-plugin-ci
COMPOSER_BINARY=/opt/composer/composer.phar 
export MOODLE_DIR=/vagrant

if [ ${#TO_VERIFY[@]} -eq 0 ]; then
    echo "TO_VERIFY is empty. Nothing to do"
    echo "Please set TO_VERIFY and COMMANDS_TO_RUN before calling this script"
    exit 1
fi

echo "Clone moodle-plugin-ci"
[ -d $MOODLECIDIR ] && CURRENT=$(pwd) && cd $MOODLECIDIR && git pull && cd $CURRENT
[ ! -d $MOODLECIDIR ] && mkdir -p $MOODLECIDIR && git clone --single-branch --branch $REPO_BRANCH $REPO_URL $MOODLECIDIR

echo "Run composer"
CURRENT=$(pwd)
cd $MOODLECIDIR
$COMPOSER_BINARY install
cd $CURRENT

echo "Setup moodle"
[ ! -f /tmp/ci/setup ] && run_setup $MOODLECIDIR $TO_VERIFY && touch /tmp/ci/setup


echo "Run checks"
EXIT_STATUS=0
for plugin in "${TO_VERIFY[@]}"; do
    echo -e "\033[30;44m- $plugin \033[0m\n"
    for command in "${COMMANDS_TO_RUN[@]}"; do
        ${MOODLECIDIR}/bin/moodle-plugin-ci ${command} ${MOODLE_DIR}/${plugin} || EXIT_STATUS=$?
    done;
done;

exit $EXIT_STATUS
