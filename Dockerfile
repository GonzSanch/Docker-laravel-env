FROM php:7.3-fpm
#Copia los composer
#COPY composer.lock composer.json /var/www/

# Configura el directorio raiz
WORKDIR /var/www/app

# Instalamos dependencias
RUN apt-get update && apt-get install -y \
    build-essential \
    default-mysql-client \
    libpng-dev \
    libjpeg62-turbo-dev \
    libzip-dev \
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
RUN npm install n -g && n stable

# Borramos cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalamos extensiones
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl gd
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/

# Instalar composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# agregar usuario para la aplicación laravel, si falla con permisos comprobar id -u que coincida con 1000
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# copiar directorio existente y los permisos del directorio de la aplicación
RUN git clone https://github.com/laravel/laravel.git .
#Instalacion necesaria para React (opcional)
RUN composer require laravel/ui &&\
    npm install react-bootstrap bootstrap &&\
    npm install --save react-router-dom

# # node-modules
RUN npm install && npm run dev

# # cambiar el usuario actual por www
USER www

# exponer el puerto 9000 e iniciar php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
