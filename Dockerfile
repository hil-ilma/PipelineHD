FROM node:18-alpine

# Install netcat so we can use nc in wait-for.sh
RUN apk add --no-cache netcat-openbsd mysql-client

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Make sure wait-for.sh is copied and executable
COPY wait-for.sh .
RUN chmod +x wait-for.sh

EXPOSE 3000

# The actual app will not run directly in test, it's started via wait-for.sh
CMD ["node", "src/index.js"]
