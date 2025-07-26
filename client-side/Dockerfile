# Builder Page

FROM node:21.5-bullseye-slim AS builder

WORKDIR /usr/src/app

COPY package*.json /usr/src/app/

RUN --mount=type=cache,target=/usr/src/app/.npm \
    npm set cache /usr/src/app/.npm && \
    npm install --force

COPY . /usr/src/app/

ARG NEXT_PUBLIC_APIURL

ENV NEXT_PUBLIC_APIURL=$NEXT_PUBLIC_APIURL

RUN npm run build

# Deployable Image

FROM nginx:alpine

COPY --from=builder /usr/src/app/out /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]