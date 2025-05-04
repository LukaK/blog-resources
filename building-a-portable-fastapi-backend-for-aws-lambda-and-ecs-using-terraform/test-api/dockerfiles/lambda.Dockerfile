FROM ghcr.io/astral-sh/uv:0.6.14 AS uv

# First, bundle the dependencies into the task root.
FROM public.ecr.aws/lambda/python:3.13 AS builder

# Enable bytecode compilation, to improve cold-start performance.
ENV UV_COMPILE_BYTECODE=1

# Disable installer metadata, to create a deterministic layer.
ENV UV_NO_INSTALLER_METADATA=1

# Enable copy mode to support bind mount caching.
ENV UV_LINK_MODE=copy

COPY . /project
WORKDIR /project/test-api

# Install requirements
RUN --mount=from=uv,source=/uv,target=/bin/uv \
    --mount=type=cache,target=/root/.cache/uv \
    uv export --frozen --no-emit-workspace --no-dev --no-editable -o requirements.txt && \
    uv pip install -r requirements.txt --target "${LAMBDA_TASK_ROOT}"

FROM public.ecr.aws/lambda/python:3.13


ENV EXECUTION_ENVIRONMENT=lambda

# Copy the runtime dependencies from the builder stage.
COPY --from=builder ${LAMBDA_TASK_ROOT} ${LAMBDA_TASK_ROOT}

# Copy the application code.
COPY ./test-api ${LAMBDA_TASK_ROOT}

# Set the AWS Lambda handler.
CMD ["main.handler"]
