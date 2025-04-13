import boto3
import uuid
from botocore.exceptions import ClientError
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    aws_region: str
    table_name: str

    class Config:
        validate_by_name = True

def get_dynamodb_table(settings: Settings = Settings()):
    dynamodb = boto3.resource("dynamodb", region_name=settings.aws_region)
    return dynamodb.Table(settings.table_name)


def create_item(item: dict, table) -> dict:
    item["id"] = str(uuid.uuid4())
    table.put_item(Item=item)
    return item

def get_item(item_id: str, table) -> dict | None:
    try:
        response = table.get_item(Key={"id": item_id})
        return response.get("Item")
    except ClientError:
        return None

def list_items(table) -> list[dict]:
    response = table.scan()
    return response.get("Items", [])

def update_item(item_id: int, item_data: dict, table) -> dict | None:
    item_data["id"] = item_id
    table.put_item(Item=item_data)
    return item_data

def delete_item(item_id: str, table) -> bool:
    try:
        table.delete_item(Key={"id": item_id})
        return True
    except ClientError:
        return False
