# Base images
FROM nginx:alpine

# Copy your HTML file to nginx html folder
COPY index.html /usr/share/nginx/html/index.html
