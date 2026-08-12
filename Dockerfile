# Dockerfile 이라는 이름으로 아래 내용을 작성하여 저장합니다.
FROM nginx:alpine
COPY app/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

