let chats = [
  {
    id: 1,
    users: ["sunil@example.com", "alice@gmail.com"],
    messages: [
      { from: "alice", text: "Hello Sunil!" },
      { from: "sunil", text: "Hey Alice!" }
    ]
  }
];

export const getChats = (req, res) => {
  res.json(chats);
};

export const sendMessage = (req, res) => {
  const { chatId, text, from } = req.body;

  const chat = chats.find(c => c.id === chatId);
  if (!chat) return res.status(404).json({ msg: "Chat not found" });

  chat.messages.push({ from, text });
  res.json({ msg: "Message added" });
};
