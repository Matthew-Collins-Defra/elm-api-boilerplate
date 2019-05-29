# Set Node version
FROM node:10.15.3-alpine AS node-base

# Production base
FROM node-base AS production-base

USER node
WORKDIR /home/node

ENV NODE_ENV production

COPY --chown=node:node package.json package-lock.json /home/node/
RUN npm ci --loglevel verbose

# Development
FROM node-base AS development

USER node
WORKDIR /home/node

ENV NODE_ENV development

COPY --chown=node:node package.json package-lock.json /home/node/
RUN npm ci --loglevel verbose

COPY --chown=node:node . /home/node/

CMD ["node", "index.js"]

# Production
FROM node-base AS production

ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

USER node
WORKDIR /home/node

EXPOSE 3001

COPY --chown=node:node --from=production-base /home/node/package.json /home/node/package-lock.json /home/node/
COPY --chown=node:node --from=production-base /home/node/node_modules /home/node/node_modules/
COPY --chown=node:node --from=development /home/node/server /home/node/server/
COPY --chown=node:node --from=development /home/node/index.js /home/node/index.js

CMD ["node", "index.js"]
