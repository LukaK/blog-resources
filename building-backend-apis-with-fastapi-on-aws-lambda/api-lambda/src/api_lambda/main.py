from fastapi import FastAPI
from mangum import Mangum
from .v1 import items

app = FastAPI()
app.include_router(items.router)

handler = Mangum(app)
