FROM node:argon

RUN mkdir -p /usr/src/app
WORDIR /usr/src/app

COPY package.json /usr/src/app

RUN npm install

COPY . /usr/src/app

EXPOSE 3000

CMD [ "bin/www" ]
