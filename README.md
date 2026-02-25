# Inventory Chatbot

This project is an AI-powered Inventory Chatbot built with **FastAPI**, **Cohere LLM API**, and **PostgreSQL**.  
It allows end users to ask inventory/business questions in natural language, generates the exact SQL query executed on the database, and returns both the query and the answer.

---

## **Features**

- Natural language understanding for inventory queries
- SQL generation based on user questions
- Executes queries on PostgreSQL database
- Returns structured JSON with:
  - `natural_language_answer`
  - `sql_query`
  - `data` (raw DB result)
  - `latency_ms`, `provider`, `model`, `status`

---

## **System Architecture**

![System Diagram](https://github.com/aminamohy/Inventory-chatbot/blob/main/Inventory_chatbot%20_system%20_diagram.png)

The diagram shows the data flow from user → FastAPI → Chat Service → LLM API → Database → back to user.

---

## **Setup & Installation**

### 1. Clone the repository

```bash
git clone https://github.com/aminamohy/Inventory-chatbot.git
cd Inventory-chatbot
