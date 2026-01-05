FROM node:18-alpine as build
WORKDIR /var/www/html

COPY package*.json ./

RUN npm install

COPY . .

RUN chmod -R +x node_modules/.bin/

RUN npm run build

FROM nginx:stable-alpine
COPY --from=build /var/www/html/dist /usr/share/nginx/html
EXPOSE 80
