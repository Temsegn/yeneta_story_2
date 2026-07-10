import User from "../models/user_model.js";
import request from "supertest";
import app from "../server.js";

export const createTestUser = async (role = "parent") => {
  const email = `test${role}${Date.now()}@test.com`;
  const password = "password123";
  const phoneSuffix = Date.now().toString().slice(-8);
  const phoneNumber = `09${phoneSuffix}`;

  await request(app)
    .post("/api/v1/auth/register")
    .send({
      fullName: `Test ${role}`,
      email,
      password,
      phoneNumber,
      role,
      securityQuestion: "What is your favorite book?",
      securityAnswer: "Yeneta",
    });

  const user = await User.findOneAndUpdate(
    { phoneNumber: `+2519${phoneSuffix}` },
    { role },
    { new: true }
  );

  const loginRes = await request(app)
    .post("/api/v1/auth/login")
    .send({ phoneNumber, password });
  const token = loginRes.body.user?.accessToken;
  const cookies = loginRes.headers["set-cookie"];

  return { user, token, cookies, phoneNumber };
};
