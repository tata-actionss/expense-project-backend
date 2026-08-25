FROM node:20-alpine AS build

WORKDIR /opt/server

COPY package.json .
COPY package-lock.json .
RUN npm ci

COPY . .



FROM node:20-alpine

WORKDIR /opt/server

RUN apk upgrade --no-cache && \
    addgroup -S expense && \
    adduser -S expense -G expense

COPY --from=build --chown=expense:expense /opt/server /opt/server

ENV DB_HOST="mysql"

EXPOSE 8080

LABEL com.project="expense" \
      component="backend" \
      created_by="vignesh"

USER expense

ENTRYPOINT ["node"]
CMD ["index.js"]