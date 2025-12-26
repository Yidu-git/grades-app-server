import dotenv from "dotenv";
dotenv.config();
import jwt from "jsonwebtoken";
import {
  saveRefreshToken,
  findRefreshToken,
  deleteRefreshToken,
  getAllTokens,
} from "./tokenModule.js";

export const generateAccessToken = (user) => {
  return jwt.sign(user, process.env.ACCESS_TOKEN_SECRET, { expiresIn: "10m" });
};

export const generateToken = async (req, res) => {
  const refresh_token = req.headers["token"];
  if (refresh_token == null) {
    res.status(401);
  }

  const Verify = async (err, user) => {
    console.log(err);
    if (err)
      return res
        .status(403)
        .json({ error: "Invalid refresh token", data: req.headers });
    const tokenExists = await findRefreshToken(user.name);
    if (tokenExists?.token === refresh_token) {
      const token = generateAccessToken({ name: user.name });
      return res.status(200).json(token);
    } else {
      res.status(403).json("Forbiden");
    }
  };

  jwt.verify(refresh_token, process.env.REFRESH_TOKEN_SECRET, Verify);
};

export const generateRefreshToken = async (user) => {
  const username = user.name;
  const refresh_token = await findRefreshToken(username);
  if (refresh_token) {
    deleteRefreshToken(username);
  }
  const token = jwt.sign(user, process.env.REFRESH_TOKEN_SECRET);
  await saveRefreshToken(token, user.name);
  return token;
};

export const AuthToken = (req, res, next) => {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];
  if (token == null) return res.sendStatus(401);

  jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, user) => {
    console.log(err);
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
};

export const deleteToken = async (req, res) => {
  const token = req.params.username;
  await deleteRefreshToken(token);
  res.status(200);
};

export const fetchRefreshToken = async (req, res) => {
  const username = req.body;
  const token = findRefreshToken(username);
  return token;
};

export const fetchAllTokens = async (req, res) => {
  try {
    const result = await getAllTokens();
    res.status(200).json(result);
  } catch (error) {
    res.status(500);
  }
};
