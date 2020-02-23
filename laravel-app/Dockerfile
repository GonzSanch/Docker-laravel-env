FROM php:7.2-fpm

# Copiar composer.lock y composer.json
COPY composer.lock composer.json /var/www/

# Configura el directorio raiz
WORKDIR /var/www

# Instalamos dependencias
RUN apt-get update && apt-get install -y \
    build-essential \
    default-mysql-client \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
	nodejs \
	npm

#Actualizamos npm a la ultima version
RUN npm install npm@latest -g

# Borramos cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalamos extensiones
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd

# Instalar composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# agregar usuario para la aplicación laravel, si falla con permisos comprobar id -u que coincida con 1000
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copiar el directorio existente a /var/www
COPY . /var/www

# copiar los permisos del directorio de la aplicación
COPY --chown=www:www . /var/www

# cambiar el usuario actual por www
USER www

# exponer el puerto 9000 e iniciar php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
