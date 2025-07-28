FROM node:20-alpine as base 
WORKDIR /todos_app
COPY package.json .
RUN npm install
EXPOSE 4000
COPY . .



FROM base as development 
RUN npm install
CMD [ "npm","run","start-dev" ]


FROM base as production 
RUN npm install --only=production
CMD [ "npm","start" ]