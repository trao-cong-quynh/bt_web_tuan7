# Sử dụng PHP 8.1 + Apache
FROM php:8.1-apache

# Cập nhật và cài đặt các package cần thiết
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql mysqli

# Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Thiết lập thư mục làm việc
WORKDIR /var/www/html

# Copy toàn bộ project Laravel vào container
COPY . .

# Copy file cấu hình Apache
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Cấp quyền cho storage và bootstrap/cache
RUN chmod -R 777 storage bootstrap/cache

# Kích hoạt mod_rewrite của Apache (cần thiết cho Laravel)
RUN a2enmod rewrite

# Restart Apache để áp dụng cấu hình mới
RUN service apache2 restart

# Cài đặt các thư viện PHP của Laravel
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs

# Expose port 80
EXPOSE 80

# Chạy Apache
CMD ["apache2-foreground"]
