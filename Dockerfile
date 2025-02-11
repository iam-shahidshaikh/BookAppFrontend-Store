# Stage 1: Build the React app
FROM node:16-alpine AS build-stage

# Set environment variable for the port
ENV PORT=3000

# Set the working directory
WORKDIR /bookapp-react-js

# Copy package.json and package-lock.json first for better caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Serve the app with Nginx
FROM nginx:1.22.1-alpine AS prod-stage

# Copy the build output to Nginx's HTML directory
COPY --from=build-stage /bookapp-react-js/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
