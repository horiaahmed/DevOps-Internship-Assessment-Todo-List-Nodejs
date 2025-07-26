FROM node:20

WORKDIR /todos_app

COPY package.json .

RUN npm install

EXPOSE 4000

COPY . .

CMD [ "npm","run","start" ]