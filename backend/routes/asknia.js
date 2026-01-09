import express from "express";
import auth from "../middleware/auth.js";
import { askNIA } from "../controllers/askniaController.js";

const router = express.Router();

router.post("/", auth, askNIA);

export default router;
