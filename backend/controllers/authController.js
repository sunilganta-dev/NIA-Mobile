import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

let users = []; 
// example: { id: 1, name: "Sunil", email: "test@test.com", password: "hashed" }

export const register = async (req, res) => {
  const { name, email, password } = req.body;

  const exists = users.find(u => u.email === email);
  if (exists) return res.status(400).json({ msg: "User already exists" });

  const hashed = await bcrypt.hash(password, 10);
  const newUser = {
    id: Date.now(),
    name,
    email,
    password: hashed
  };

  users.push(newUser);
  return res.json({ msg: "User registered (in-memory)" });
};

export const login = async (req, res) => {
  const { email, password } = req.body;

  const user = users.find(u => u.email === email);
  if (!user) return res.status(400).json({ msg: "Invalid credentials" });

  const ok = await bcrypt.compare(password, user.password);
  if (!ok) return res.status(400).json({ msg: "Invalid credentials" });

  const token = jwt.sign(
    { user: { id: user.id, email: user.email } },
    process.env.JWT_SECRET,
    { expiresIn: "7d" }
  );

  res.json({ token });
};

export const me = (req, res) => {
  const user = users.find(u => u.id === req.user.id);
  res.json(user);
};
