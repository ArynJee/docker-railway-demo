# split Dockerfile into two stages: one for building the container and one for running it (for optimization)
#  building container
FROM node:20-alpine AS deps
WORKDIR /app
# copy package.json to tell Docker what dependencies to install
COPY package*.json ./
RUN npm ci --only=production

# running container
FROM node:20-alpine
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY app.js .
COPY package.json .
ENV PORT=3000
EXPOSE 3000
USER node
CMD ["node", "app.js"]
