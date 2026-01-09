import express from "express";
import cors from "cors";

const app = express();
app.use(cors());
app.use(express.json());

// Root check
app.get("/", (req, res) => {
  res.send("Backend running (no DB, no OpenAI, no JWT)");
});

// Dummy Register
app.post("/auth/register", (req, res) => {
  res.json({ msg: "Registered (dummy response)" });
});

// Dummy Login
app.post("/auth/login", (req, res) => {
  res.json({ token: "dummy_token" });
});

// Dummy user profile
app.get("/user/me", (req, res) => {
  res.json({
    id: 1,
    name: "Demo User",
    email: "demo@example.com"
  });
});

// Dummy Chat List
app.get("/chat", (req, res) => {
  res.json([
    { id: 1, name: "Alice", last: "Hello!" },
    { id: 2, name: "Bob", last: "How are you?" }
  ]);
});

// Dummy send message
app.post("/chat/send", (req, res) => {
  res.json({ msg: "Message sent (dummy)" });
});

// Dummy Ask NIA
app.post("/asknia", (req, res) => {
  res.json({ reply: "NIA AI is disabled. (Dummy response)" });
});

// Run server
const PORT = process.env.PORT || 5050;
app.listen(PORT, () => console.log(`Backend running on port ${PORT}`));
