FROM node:20-alpine as base
COPY package*.json .
WORKDIR /todos_app
EXPOSE 4000

FROM base as development 
COPY package*.json .
RUN npm install
COPY . .
CMD [ "npm","run","start-dev" ]


FROM base as production 
COPY package*.json .
RUN npm install --only=production
COPY . .
CMD [ "npm","start" ]