# frontend/Dockerfile
FROM node:23-slim

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# serve built files
RUN npm install -g serve
CMD ["serve", "-s", "build", "-l", "3000"]