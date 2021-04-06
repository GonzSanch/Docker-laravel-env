#!bin/sh

# Execute composer to create a new app of laravel change "8.*" to selected version, check compatibility with php version 

docker-compose exec app composer create-project laravel/laravel="8.*" .