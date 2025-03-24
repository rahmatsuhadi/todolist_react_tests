# Stage 1: Build React App
FROM node:16-alpine AS build

# Set working directory
WORKDIR /app

# Set environment variable untuk menghindari OpenSSL error
ENV NODE_ENV=production
ENV NODE_OPTIONS=--openssl-legacy-provider

# Copy package.json & package-lock.json
COPY package*.json ./

# Install dependencies tanpa devDependencies
# RUN npm ci --omit=dev
RUN npm install --unsafe-perm=true --legacy-peer-deps


# Copy seluruh kode setelah dependencies terinstall
COPY . .

# Build aplikasi React
RUN npm run build

# Stage 2: Setup Nginx untuk Serving React App
FROM nginx:alpine

# Salin file build ke Nginx public directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Jalankan Nginx
CMD ["nginx", "-g", "daemon off;"]
