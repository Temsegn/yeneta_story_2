import request from "supertest";
import app from "../server.js";
import User from "../models/user_model.js";
import jwt from "jsonwebtoken";
import { clearDatabase } from "./setup.js";

const apiPrefix = "/api/v1/auth";

afterEach(async () => {
  await clearDatabase();
});

describe("Auth Endpoints", () => {
  const testUser = {
    fullName: "Test User",
    email: "testuser@example.com",
    phoneNumber: "1234567890",
    password: "password123",
  };

  describe("POST /register", () => {
    it("should register a new user successfully", async () => {
      const res = await request(app)
        .post(`${apiPrefix}/register`)
        .send(testUser);
      
      expect(res.status).toBe(201);
      expect(res.body.message).toBe("Signup successful");
      expect(res.body.user).toHaveProperty("id");
      expect(res.body.user.email).toBe(testUser.email);
    });

    it("should fail if email is already registered", async () => {
      // Create user first
      await User.create(testUser);

      const res = await request(app)
        .post(`${apiPrefix}/register`)
        .send(testUser);

      expect(res.status).toBe(400); 
    });

    it("should fail validation if missing fields", async () => {
      const res = await request(app)
        .post(`${apiPrefix}/register`)
        .send({ email: "onlyemail@example.com" });

      expect(res.status).toBeGreaterThanOrEqual(400);
    });
  });

  describe("POST /login", () => {
    beforeEach(async () => {
      // Create the user before login tests
      await request(app).post(`${apiPrefix}/register`).send(testUser);
    });

    it("should login with correct credentials & return a token", async () => {
      const res = await request(app)
        .post(`${apiPrefix}/login`)
        .send({
          email: testUser.email,
          password: testUser.password,
        });

      expect(res.status).toBe(200);
      expect(res.body.message).toBe("Login successful");
      expect(res.body.user).toHaveProperty("accessToken");
    });

    it("should fail with incorrect password", async () => {
      const res = await request(app)
        .post(`${apiPrefix}/login`)
        .send({
          email: testUser.email,
          password: "wrongpassword",
        });

      expect(res.status).toBe(401);
    });
  });
});
