FROM node:17-alpine3.14

WORKDIR /app

RUN npm install -g hexo-cli

EXPOSE 4000