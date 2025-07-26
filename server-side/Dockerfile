# =================================
# Stage 1: Base Dependencies
# =================================
FROM python:3.11-slim AS base

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app


# =================================
# Stage 2: Dependencies Builder
# =================================
FROM base AS deps-builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# =================================
# Stage 3: Production
# =================================
FROM base AS production

# Install runtime dependencies only
RUN apt-get update && apt-get install -y \
    libpq5 \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -r fastapi && useradd -r -g fastapi fastapi

# Copy virtual environment
COPY --from=deps-builder /venv /venv
ENV PATH="/venv/bin:$PATH"

# Copy application
COPY . /app/

# Make scripts executable
RUN chmod +x /app/scripts/entrypoint.sh
RUN chmod +x /app/scripts/healthcheck.sh

# Set ownership
RUN chown -R fastapi:fastapi /app

USER fastapi

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD /app/scripts/healthcheck.sh

EXPOSE 8000

ENTRYPOINT ["/app/scripts/entrypoint.sh"]