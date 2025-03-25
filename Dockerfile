 # Sử dụng PHP 8.1 + Apache
FROM php:8.1-apache

# Cài đặt các extension PHP cần thiết
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql mysqli

# Copy toàn bộ project Laravel vào container
COPY . /var/www/html

# Thiết lập thư mục làm việc
WORKDIR /var/www/html

# Cài đặt Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Cài đặt các thư viện PHP của Laravel
RUN composer install --no-dev --optimize-autoloader

# Thiết lập quyền cho storage
RUN chmod -R 777 storage bootstrap/cache

# Expose port 80
EXPOSE 80

# Chạy Apache
CMD ["apache2-foreground"]

