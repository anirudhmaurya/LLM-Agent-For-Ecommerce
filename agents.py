from fastapi import FastAPI, HTTPException
from sqlalchemy import create_engine, text
from langchain.llms import LlamaCpp
from langchain.prompts import PromptTemplate
import pymysql
import os
import dotenv
from pydantic import BaseModel

dotenv.load_dotenv()

# Initialize FastAPI
app = FastAPI()

# MySQL Database Connection
MYSQL_URL = os.getenv("MYSQL_URL", "mysql+mysqlconnector://user:password@localhost/db")
engine = create_engine(MYSQL_URL)

# Load Llama model
llm_model_path = os.getenv("LLAMA_MODEL_PATH", "./models/llama-7b.ggmlv3.q4_0.bin")
llm = LlamaCpp(model_path=llm_model_path)

# Define request model
class QueryRequest(BaseModel):
    question: str

# Generate SQL from natural language
def generate_sql(question: str) -> str:
    prompt = PromptTemplate(template="Convert the following question into an SQL query: {question}", input_variables=["question"])
    response = llm(prompt.format(question=question))
    return response["choices"][0]["text"].strip()

# Summarize SQL result
def summarize_result(query: str, result: list) -> str:
    summary_prompt = PromptTemplate(template="Summarize the following SQL query result: {query}, Result: {result}", input_variables=["query", "result"])
    response = llm(summary_prompt.format(query=query, result=str(result)))
    return response["choices"][0]["text"].strip()

# Query database endpoint
@app.post("/query")
def query_db(request: QueryRequest):
    try:
        sql_query = generate_sql(request.question)
        with engine.connect() as connection:
            result = connection.execute(text(sql_query))
            data = [dict(row) for row in result]
        summary = summarize_result(sql_query, data)
        return {"query": sql_query, "result": data, "summary": summary}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
