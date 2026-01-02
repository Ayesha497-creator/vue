FROM node:18-alpine as build
WORKDIR /var/www/html

# 1. Pehle sirf package files copy karein (build cache optimize karne ke liye)
COPY package*.json ./

# 2. Dependencies install karein (is se node_modules ban jayega)
RUN npm install

# 3. Ab baqi saara code copy karein
COPY . .

# 4. Ab permission dein (Ab folder mil jayega)
RUN chmod -R +x node_modules/.bin/

# 5. Build karein
RUN npm run build

FROM nginx:stable-alpine
COPY --from=build /var/www/html/dist /usr/share/nginx/html
EXPOSE 80
