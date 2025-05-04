import os
import uvicorn
from fastapi import FastAPI
from mangum import Mangum

app = FastAPI()

@app.get("/", response_model=str)
def list_items():
    return f"Hello from {os.environ.get('EXECUTION_ENVIRONMENT')}"

handler = Mangum(app)
