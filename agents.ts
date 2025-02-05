import express from "express";
import mysql from "mysql2/promise";
import dotenv from "dotenv";
import { LLMChain, PromptTemplate } from "langchain";
import { LlamaCpp } from "langchain/llms/llama_cpp";

dotenv.config();

const app = express();
app.use(express.json());

// MySQL Database Connection
const pool = mysql.createPool({
    host: process.env.MYSQL_HOST || "localhost",
    user: process.env.MYSQL_USER || "root",
    password: process.env.MYSQL_PASSWORD || "password",
    database: process.env.MYSQL_DATABASE || "test_db",
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Load Llama model
const llm = new LlamaCpp({ modelPath: process.env.LLAMA_MODEL_PATH || "./models/llama-7b.ggmlv3.q4_0.bin" });

// Generate SQL from natural language
async function generateSQL(question: string): Promise<string> {
    const prompt = new PromptTemplate({
        template: "Convert the following question into an SQL query: {question}",
        inputVariables: ["question"]
    });
    const chain = new LLMChain({ llm, prompt });
    const response = await chain.run({ question });
    return response.trim();
}

// Summarize SQL result
async function summarizeResult(query: string, result: any): Promise<string> {
    const summaryPrompt = new PromptTemplate({
        template: "Summarize the following SQL query result: {query}, Result: {result}",
        inputVariables: ["query", "result"]
    });
    const chain = new LLMChain({ llm, prompt: summaryPrompt });
    const summary = await chain.run({ query, result: JSON.stringify(result) });
    return summary.trim();
}

// Query database endpoint
app.post("/query", async (req, res) => {
    try {
        const { question } = req.body;
        if (!question) {
            return res.status(400).json({ error: "Question is required" });
        }

        const sqlQuery = await generateSQL(question);
        const [rows] = await pool.query(sqlQuery);
        const summary = await summarizeResult(sqlQuery, rows);
        
        res.json({ query: sqlQuery, result: rows, summary });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});