

import os
from dotenv import load_dotenv
import cohere
from sqlalchemy import text
from db.database import SessionLocal
from .prompt import SYSTEM_PROMPT_SQL, build_sql_prompt, build_answer_prompt

load_dotenv()

# Cohere setup
COHERE_API_KEY = os.getenv("COHERE_API_KEY")
if not COHERE_API_KEY:
    raise ValueError("COHERE_API_KEY not found in .env")

co = cohere.Client(COHERE_API_KEY)

# ---------------------
# Generate SQL from LLM
# ---------------------

def generate_sql(user_question: str) -> str:
   
    prompt_text = build_sql_prompt(user_question)

   
    response = co.chat(
        model="command-a-03-2025",
        message=prompt_text,
        preamble=SYSTEM_PROMPT_SQL,
        temperature=0
    )

   
    sql_query = response.text.strip()

   
    sql_query = sql_query.replace("```sql", "").replace("```", "").strip()

    return sql_query

# ---------------------
# Execute SQL on DB
# ---------------------
def execute_sql(sql_query: str):
    db = SessionLocal()
    try:
        result = db.execute(text(sql_query))
        rows = result.fetchall()
        columns = result.keys()
        return [dict(zip(columns, row)) for row in rows]
    finally:
        db.close()


# ---------------------
# Main service function
# ---------------------
import time

def ask_inventory(user_question: str) -> dict:
    start_time = time.time()

    # Step 1: Generate SQL
    sql_query = generate_sql(user_question)

    # Step 2: Execute SQL
    data = execute_sql(sql_query)

    # Step 3: Build answer prompt
    answer_prompt = build_answer_prompt(user_question, sql_query, data)

    # Step 4: Ask LLM to generate natural language answer
    response = co.chat(
        model="command-a-03-2025",
        message=answer_prompt,
        temperature=0.2
    )
    answer = response.text.strip()

    end_time = time.time()
    latency_ms = int((end_time - start_time) * 1000)

    return {
        "natural_language_answer": answer,
        "sql_query": sql_query,
        "token_usage": {
            "prompt_tokens": None,
            "completion_tokens": None,
            "total_tokens": None
        },
        "latency_ms": latency_ms,
        "provider": "cohere",
        "model": "command-a-03-2025",
        "status": "ok",
        "data": data  
    }