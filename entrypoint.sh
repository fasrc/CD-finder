#!/bin/sh

set -o errexit -o xtrace

if [ ! -f /mnt/drupal.sqlite ]
then
  drush site:install standard --db-url=sqlite://localhost//mnt/drupal.sqlite --account-name=admin --account-pass=admin --site-name="Drupal Site" -y
  drush cache:rebuild
  drush pm:enable paragraphs -y
  drush pm:enable finder -y
  drush cache:rebuild
  chmod 777 /mnt/drupal.sqlite
fi

docker-php-entrypoint apache2-foreground