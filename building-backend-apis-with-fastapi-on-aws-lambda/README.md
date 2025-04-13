## Steps

```bash
# create infra
mkdir infra layers

cd layers
uv init --library mylib
cd mylib

uv add fastapi mangum boto3  pydantic-settings
# add makefile to layers
cd ../..


uv init --package api-lambda
cd api-lambda
uv add --editable ../layers/mylib
uv add --dev pytest pytest-xdist requests "fastapi[standard]"
source .venv/bin/activate
cd ..
```

```bash
# testing
cd infra
sam build -t infra.sam.yaml && sam deploy
cd ../api-lambda
uv run pytest -n auto
cd ../infra


# cleanup
sam delete
```
