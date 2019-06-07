# Base
FROM node:10.15.3-alpine AS base

USER node
WORKDIR /home/node

ARG NODE_ENV=production
ENV NODE_ENV ${NODE_ENV}

ARG PORT=3001
ENV PORT ${PORT}
EXPOSE ${PORT}

COPY --chown=node:node package.json package-lock.json /home/node/

RUN npm ci --loglevel verbose && npm cache clean --force

# Development
FROM base AS development

CMD ["npm", "run", "dev"]

ENV NODE_ENV development

USER root
RUN apk update && apk add git
USER node

RUN npm install --loglevel verbose && npm cache clean --force

COPY --chown=node:node ./index.js /home/node/index.js
COPY --chown=node:node ./server/ /home/node/server/
COPY --chown=node:node ./test/ /home/node/test/

# Production
FROM base AS production

CMD ["npm", "run", "start"]

COPY --chown=node:node ./index.js /home/node/index.js
COPY --chown=node:node ./server/ /home/node/server/
