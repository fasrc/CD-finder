FROM docker.io/library/node:22-alpine AS node
COPY package*.json .
RUN npm ci
COPY gulpfile.js .
COPY sass sass
RUN mkdir css && npm run gulp

FROM docker.io/library/drupal:11.1.8-apache
RUN composer require 'drupal/paragraphs:^1.19' \
 && composer require 'drupal/tome:^1.13' \
 && composer config --no-plugins allow-plugins.composer/installers true \
 && composer config --no-plugins allow-plugins.drupal/core-composer-scaffold true \
 && composer config --no-plugins allow-plugins.drupal/core-project-message true \
 && composer require drush/drush \
 && mkdir -m 777 /var/www/html/sites/default/files \
 && cp /var/www/html/sites/default/default.settings.php /var/www/html/sites/default/settings.php \
 && echo "\$databases['default']['default'] = ['driver' => 'sqlite', 'database' => '/mnt/drupal.sqlite'];" >> /var/www/html/sites/default/settings.php \
 && echo "\$settings['hash_salt'] = 'my-hash-salt';" >> /var/www/html/sites/default/settings.php
COPY --chmod=555 . /var/www/html/modules/finder
COPY --from=node --chmod=555 /css/finder.css /var/www/html/modules/finder/css
ENV PATH="/opt/drupal/vendor/bin:${PATH}"
ENTRYPOINT ["/var/www/html/modules/finder/entrypoint.sh"]
