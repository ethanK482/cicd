# Stage 1: Build the React app with Vite
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and yarn.lock
COPY package.json ./
COPY package-lock.json ./

# Install dependencies
RUN npm i

# Copy the rest of the application code
COPY . .

# Build the React app for production
RUN npm run build

# Stage 2: Serve the React app with Nginx
FROM nginx:stable-alpine

# Copy the built files from the previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy custom Nginx configuration file
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]