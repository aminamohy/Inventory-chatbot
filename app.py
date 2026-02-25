
from fastapi import FastAPI
from pydantic import BaseModel

from services.chat_service import ask_inventory

app = FastAPI(title="Inventory Chatbot API")

class ChatRequest(BaseModel):
    session_id: str
    message: str

@app.post("/chat")
def chat_endpoint(req: ChatRequest):
    result = ask_inventory(req.message)
    return result