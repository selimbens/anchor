# Build stage
FROM golang:1.25-alpine AS builder

WORKDIR /app

# Install git for build information
RUN apk add --no-cache git

# Copy go mod files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o anchor main.go

# Final stage
FROM alpine:latest

# Install ca-certificates for HTTPS requests
RUN apk --no-cache add ca-certificates

# Create a non-root user
RUN addgroup -g 1001 -S anchor && \
    adduser -u 1001 -S anchor -G anchor

WORKDIR /home/anchor

# Copy the binary from builder stage
COPY --from=builder /app/anchor .

# Copy README and LICENSE
COPY README.md LICENSE ./

# Change ownership to anchor user
RUN chown -R anchor:anchor /home/anchor

USER anchor

# Expose port (if needed for future web interface)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ./anchor --version || exit 1

# Default command
ENTRYPOINT ["./anchor"]

# Set default command arguments
CMD ["--help"]