# Etapa 1: build da aplicação
FROM node:20-alpine AS builder

WORKDIR /app

ARG DATABASE_URL
ENV DATABASE_URL=$DATABASE_URL

# Copia os arquivos de config e instala as dependências
COPY package.json package-lock.json ./
RUN npm install

# Copia o restante do projeto
COPY . .

# Compila o projeto TypeScript
RUN npm run build

# Gera o Prisma Client
RUN npx prisma generate

# Etapa 2: imagem final (mais enxuta)
FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app/package.json .
COPY --from=builder /app/package-lock.json .
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/node_modules ./node_modules

# Gera o Prisma Client novamente só por segurança no runtime
RUN npx prisma generate

# Porta da aplicação (ajuste conforme necessário)
EXPOSE 3000

# Comando para rodar a API
CMD ["node", "dist/index.js"]