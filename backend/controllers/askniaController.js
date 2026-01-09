import OpenAI from "openai";

export const askNIA = async (req, res) => {
  const { question } = req.body;

  if (!process.env.OPENAI_KEY) {
    return res.status(400).json({ error: "OpenAI API key not configured" });
  }

  const client = new OpenAI({ apiKey: process.env.OPENAI_KEY });

  const completion = await client.chat.completions.create({
    model: "gpt-4o-mini",
    messages: [{ role: "user", content: question }]
  });

  res.json({ reply: completion.choices[0].message.content });
};
