FROM nginx:alpine
LABEL org.opencontainers.image.title="yeonwoo-devsetup-web"
ENV APP_ENV=dev
COPY site/ /usr/share/nginx/html/
EXPOSE 80
