# Étape 1 : Build de l'application React
FROM node:16 AS react-build

# Définir le répertoire de travail pour le build
WORKDIR /usr/src/app

# Copier les fichiers package.json du dossier react-app
COPY react-app/package*.json ./

# Installer les dépendances de l'application React
RUN npm install

# Copier le reste des fichiers sources de l'application React
COPY react-app/ .

# Builder l'application React
RUN npm run build:monolith

# Étape 2 : Préparer l'image finale pour servir l'application
FROM node:16 AS backend-build

# Créer le répertoire de travail pour le backend
WORKDIR /usr/src/backend

# Copier les fichiers package.json du backend (monolith)
COPY monolith/package*.json ./

# Installer les dépendances du backend
RUN npm install

# Copier les fichiers sources du backend
COPY monolith/ .

# Copier les fichiers construits de l'application React dans le backend
COPY --from=react-build /usr/src/app/build ./public

# Exposer le port du backend
EXPOSE 8080

# Commande pour démarrer le backend
CMD [ "node", "src/server.js" ]
