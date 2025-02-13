FROM nginx:stable-alpine3.19-slim
WORKDIR /workdir
RUN apk add --no-cache bash
COPY nginx.conf /etc/nginx/nginx.conf
COPY wait-for-it.sh /workdir/
RUN chmod +x wait-for-it.sh
CMD [ "./wait-for-it.sh", "session-service:8081", "-s", "-t", "0", "--", "./wait-for-it.sh", "gateway-service:8087", "-s", "-t", "0", "--", "nginx", "-g", "daemon off;" ]