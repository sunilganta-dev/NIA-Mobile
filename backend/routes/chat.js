import express from "express";
import { getChats, sendMessage } from "../controllers/chatController.js";

const router = express.Router();

router.get("/", getChats);
router.post("/send", sendMessage);

export default router;
