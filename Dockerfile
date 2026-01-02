FROM node:18-alpine as build
WORKDIR /var/www/html

# 1. Pehle sirf package files copy karein
COPY package*.json ./

# 2. Dependencies install karein (Taqe node_modules ban jayein)
RUN npm install

# 3. Ab baqi saara code copy karein
COPY . .

# 4. Ab chmod chalayega toh folder mil jayega
RUN chmod -R 755 node_modules && chmod +x node_modules/.bin/vue-cli-service

# 5. Build karein
RUN npm run build

FROM nginx:stable-alpine
COPY --from=build /var/www/html/dist /usr/share/nginx/html
EXPOSE 80
