# Use the official Node.js image as the base image
FROM node:18 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Use a lightweight image for the production environment
FROM node:18-alpine AS runner

# Set environment variables
ENV NODE_ENV production
ENV PORT 3000

# Set the working directory
WORKDIR /app

# Copy built files and necessary dependencies from the builder stage
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Expose the port the app runs on
EXPOSE 4400

# Start the Next.js application
CMD ["npm", "start"]

