FROM python:3.12-slim

# Install uv.
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV EXECUTION_ENVIRONMENT=ecs

# Copy the application into the container.
COPY test-api /api

# Install the application dependencies.
WORKDIR /api
RUN uv sync --frozen --no-cache


# Run the application.
CMD ["/api/.venv/bin/fastapi", "run", "main.py", "--port", "80", "--host", "0.0.0.0"]
