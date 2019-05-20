ARG NODE_VERSION=10.15.3

# Development
FROM node:${NODE_VERSION}-alpine AS development

USER node
WORKDIR /home/node

ENV NODE_ENV development

COPY --chown=node:node package.json package-lock.json /home/node/
RUN npm ci

COPY --chown=node:node . /home/node/

CMD ["node", "index.js"]

# Production
FROM node:${NODE_VERSION}-alpine AS production

ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

USER node
WORKDIR /home/node

EXPOSE 3001

COPY --chown=node:node --from=development /home/node/package.json /home/node/package-lock.json /home/node/
COPY --chown=node:node --from=development /home/node/node_modules /home/node/node_modules/
RUN npm prune


COPY --chown=node:node --from=development /home/node/server /home/node/server/
COPY --chown=node:node --from=development /home/node/index.js /home/node/index.js

CMD ["node", "index.js"]
