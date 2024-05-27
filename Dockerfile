FROM nginx
COPY nginx.conf /usr/local/nginx/conf/
COPY src /usr/share/nginx/html/
COPY config/app-config.json /usr/share/nginx/html/config/
ARG IMAGE_VERSION
RUN <<EOF
echo "{ \"appVersion\": \"${IMAGE_VERSION}\" }" > /usr/share/nginx/html/app-version.json
EOF