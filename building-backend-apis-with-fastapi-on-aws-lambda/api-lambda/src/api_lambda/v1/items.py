import logging
from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
import mylib.db as db

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

router = APIRouter(prefix="/items", tags = ["items"])

class Item(BaseModel):
    name: str
    price: int
    description: str = ""

class ItemOut(Item):
    id: str

@router.get("/", response_model=list[ItemOut])
def list_items(table=Depends(db.get_dynamodb_table)):
    logger.info("Listing items")
    return db.list_items(table)


@router.get("/{item_id}", response_model=ItemOut)
def get_item(item_id: str, table=Depends(db.get_dynamodb_table)):

    logger.info(f"Retrieving item {item_id=}")
    if(item := db.get_item(item_id, table)) is None:
        raise HTTPException(status_code = 404, detail="Item not found")

    return item


@router.post("/", status_code=201, response_model=ItemOut)
def create_item(item: Item, table=Depends(db.get_dynamodb_table)):
    logger.info(f"Creating item {item=}")
    return db.create_item(item.model_dump(), table)


@router.delete("/{item_id}", status_code=204)
def delete_item(item_id: str, table=Depends(db.get_dynamodb_table)):
    logger.info(f"Deleting item {item_id=}")
    if not db.delete_item(item_id, table):
        raise HTTPException(status_code=404, detail="Item not found")
