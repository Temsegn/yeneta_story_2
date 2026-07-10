# Yeneta Story dashboard (Next.js)
FROM node:20

WORKDIR /app

# Copy the full repo contents (build system places them at the root).
COPY . .

# Lockfile is committed, so use the deterministic lockfile-driven install,
# then produce the production build.
RUN npm ci && npm run build

ENV NODE_ENV=production
ENV PORT=3000
EXPOSE 3000

CMD ["npm", "start"]
