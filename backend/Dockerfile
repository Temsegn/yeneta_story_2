# Yeneta Story backend (Express + Mongoose API)
FROM node:20

WORKDIR /app

# Copy the full repo contents (build system places them at the root).
COPY . .

# No committed lockfile, so a bare install resolves from package.json.
RUN npm install --omit=dev

ENV NODE_ENV=production
ENV PORT=5000
EXPOSE 5000

CMD ["node", "server.js"]
