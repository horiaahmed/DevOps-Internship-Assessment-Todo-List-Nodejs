FROM node:20-alpine as base 
WORKDIR /todos_app
COPY package*.json .
EXPOSE 4000




FROM base as development 
RUN npm install
COPY . .
CMD [ "npm","run","start-dev" ]


FROM base as production 
RUN npm install --only=production
COPY . .
CMD [ "npm","start" ]