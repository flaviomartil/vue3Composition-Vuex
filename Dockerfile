# Use Node.js 14 as the base image
FROM node:14 as development

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose port 8080 for development server
EXPOSE 8080

# Start the Vue.js development server with hot-reloading
CMD ["npm", "run", "serve", "--host", "0.0.0.0"]

# Stage 2 - Production Stage
FROM node:14 as builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Vue.js app
RUN npm run build

# Stage 3 - Nginx Stage
FROM nginx:alpine as production

# Copy the built app from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
