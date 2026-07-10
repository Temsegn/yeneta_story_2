import User from "../models/user_model.js";
import request from "supertest";
import app from "../server.js";

export const createTestUser = async (role = "parent") => {
  const email = `test${role}${Date.now()}@test.com`;
  const password = "password123";

  // Register via the API (goes through the server's full auth flow)
  await request(app)
    .post("/api/v1/auth/register")
    .send({
      fullName: `Test ${role}`,
      email,
      password,
      phoneNumber: `09${Date.now().toString().slice(-8)}`,
      role,
    });

  // Update the role directly in DB (register only creates 'parent' unless admin sets it)
  const user = await User.findOneAndUpdate({ email }, { role }, { new: true });

  // Login to get real token
  const loginRes = await request(app).post("/api/v1/auth/login").send({ email, password });
  const token = loginRes.body.user?.accessToken;
  const cookies = loginRes.headers["set-cookie"];

  return { user, token, cookies };
};
