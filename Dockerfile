FROM node:18-alpine as build

WORKDIR /var/www/html
COPY . .
RUN npm install && npm run build

FROM nginx:stable-alpine
COPY --from=build /var/www/html/dist /usr/share/nginx/html
EXPOSE 80
