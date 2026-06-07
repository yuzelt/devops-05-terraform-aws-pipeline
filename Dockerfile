# Resmi bir Node.js çalışma zamanını (runtime) taban imaj olarak kullan
FROM node:24

# Konteyner içindeki çalışma dizinini ayarla
WORKDIR /app

# package.json ve package-lock.json dosyalarını çalışma dizinine kopyala
COPY package*.json ./

# Material-UI 5 dahil uygulamanın tüm bağımlılıklarını yükle
RUN npm install

# Uygulama kodunun geri kalanını çalışma dizinine kopyala
COPY . .

# React uygulamasını derle (build et)
RUN npm run build

# Uygulamanın çalışacağı portu dışa aç (gerekirse değiştirebilirsiniz)
EXPOSE 3000

# Uygulamayı başlatacak komutu tanımla
CMD ["npm", "start"]