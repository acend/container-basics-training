FROM klakegg/hugo:0.90.1-ext-ubuntu AS builder

ARG TRAINING_HUGO_ENV=default

COPY . /src

RUN hugo --environment ${TRAINING_HUGO_ENV} --minify

FROM nginxinc/nginx-unprivileged:1.21-alpine

LABEL maintainer acend.ch
LABEL org.opencontainers.image.title "acend.ch's Container Basics Training"
LABEL org.opencontainers.image.description "Container with acend.ch's Container Basics Training content"
LABEL org.opencontainers.image.authors acend.ch
LABEL org.opencontainers.image.source https://github.com/acend/container-basics-training/
LABEL org.opencontainers.image.licenses CC-BY-SA-4.0

EXPOSE 8080

COPY --from=builder /src/public /usr/share/nginx/html
