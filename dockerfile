FROM debian:latest

RUN apt update

RUN apt install -y nano \
                   php8.4 \
                   php8.4-xml \
                   zip \
                   curl \
                   git

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');"

RUN mv composer.phar /usr/local/bin/composer

RUN curl -fsSL https://bun.sh/install | bash

RUN cp /root/.bun/bin/bun /usr/local/bin/bun

RUN git clone https://github.com/Kasparsu/kta25blog.git

WORKDIR /kta25blog

RUN composer install

RUN bun i

RUN bun run build

RUN cp .env.example .env

RUN php artisan key:generate

CMD ["php", "artisan", "serve", "--host=0.0.0.0"]