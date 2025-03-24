# menggunakna node 16 sebagai base image
FROM node:16-alpine AS build

#  direktori kerja dalam container
WORKDIR /app

# Menyalin package.json dan package-lock.json sebelum menginstal dependencies
# COPY package.json package-lock.json ./
COPY package*.json ./

RUN rm -rf node_modules package-lock.json
# Install 
RUN npm install

# Menyalin semua kode ke container
COPY . .

# Build aplikasi
RUN npm run build

# Menggunakan Nginx sebagai web server untuk serving React app
FROM nginx:alpine

# Salin file build ke direktori Nginx
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 agar bisa diakses dari luar
EXPOSE 80

# Menjalankan Nginx
CMD ["nginx", "-g", "daemon off;"]