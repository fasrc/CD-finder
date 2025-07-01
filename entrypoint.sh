#!/bin/sh

set -o errexit -o xtrace

if [ ! -f /mnt/drupal.sqlite ]
then
  drush site:install standard --db-url=sqlite://localhost//mnt/drupal.sqlite --account-name=admin --account-pass=admin --site-name="Drupal Site" -y
  drush cache:rebuild
  drush pm:enable paragraphs -y
  drush pm:enable finder -y
  drush pm:enable tome_static -y
  drush cache:rebuild
  chmod 777 /mnt/drupal.sqlite
fi

drush cache:rebuild

if ${STATIC_SITE:-false}
then
  drush tome:static "$@"
else
  docker-php-entrypoint apache2-foreground
fi