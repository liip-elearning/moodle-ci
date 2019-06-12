# Testing with Moodle
This project intent to provide templates to use on Moodle plugins repositories for unit testing.
This will run the <https://github.com/blackboard-open-source/moodle-plugin-ci> on gitlab or github.


## On Gitlab (via gitlab-ci)
We use or own integration to support gitlab in addition to the official travis support.
Note that it's not supported upstream and that our integration is not tested with Behat (But PR are welcome).

The work is based on the [gist](https://gist.github.com/Dagefoerde/b8ebf54438b8a77ee4ea73f552fc0a01) from [PR-36](https://github.com/blackboard-open-source/moodle-plugin-ci/pull/36)
It has been improved to use docker images and templating system.

### Getting started
To avoid writing the same "before_script", and have something maintainable, we provided a "base" file that can be extended to run the test.

*Just copy the file `gitlab-ci.dist.yml` as `.gitlab-ci.yml` in your repository.*

Note that you may have to fork this project on your gitlab instance to make it work. 

Be sure that your runner support dockers images.

## On Github (via Travis)
The file is provided by default by the moodle-plugin-ci. See <https://github.com/blackboard-open-source/moodle-plugin-ci/blob/master/.travis.dist.yml>

You can follow the [Getting started](https://blackboard-open-source.github.io/moodle-plugin-ci/#getting-started) procedure.

(An archive is stored as `travis.dist.yml` in this repository)

# Locally
It's not possible to run the moodle-plugin-ci on your computer locally.
But we forked the project to make it happen and submitted a PR here: <https://github.com/blackboard-open-source/moodle-plugin-ci/pull/94>

You can copy and customize the file `moodle-plugin-ci.dist.sh` in your instance/host to run the tests locally.

