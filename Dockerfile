# Production
FROM node:10.15.3-alpine AS production

USER node
WORKDIR /home/node

ARG NODE_ENV=production
ENV NODE_ENV ${NODE_ENV}

ARG PORT=3001
ENV PORT ${PORT}
EXPOSE ${PORT}

COPY --chown=node:node package.json package-lock.json /home/node/

RUN npm ci --loglevel verbose

COPY --chown=node:node ./server/ /home/node/server/
COPY --chown=node:node ./index.js /home/node/index.js

CMD ["node", "index.js"]

# Development
FROM production AS development

ENV NODE_ENV development

RUN npm ci --loglevel verbose

COPY --chown=node:node ./test/ /home/node/test/
