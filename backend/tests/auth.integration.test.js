import request from "supertest";
import app from "../server.js";
import { connect, closeDatabase, clearDatabase } from "./setup.js";
import { jest } from "@jest/globals";

// Mock audit logger to avoid side effects
jest.mock("../utils/auditLogger.js", () => ({
  logAction: jest.fn().mockResolvedValue({}),
}));

describe("Auth Integration Tests", () => {
  const testUser = {
    fullName: "Test User",
    email: "test@example.com",
    phoneNumber: "1234567890",
    password: "password123",
  };

  describe("POST /api/v1/auth/register", () => {
    it("should register a new user successfully", async () => {
      const res = await request(app)
        .post("/api/v1/auth/register")
        .send(testUser);

      expect(res.statusCode).toEqual(201);
      expect(res.body.message).toEqual("Signup successful");
      expect(res.body.user).toHaveProperty("email", testUser.email);
      expect(res.body.user).not.toHaveProperty("password");
    });

    it("should fail if email already exists", async () => {
      await request(app).post("/api/v1/auth/register").send(testUser);
      const res = await request(app).post("/api/v1/auth/register").send(testUser);

      expect(res.statusCode).toEqual(400);
      expect(res.body.message).toEqual("User already exists");
    });
  });

  describe("POST /api/v1/auth/login", () => {
    beforeEach(async () => {
      await request(app).post("/api/v1/auth/register").send(testUser);
    });

    it("should login successfully with correct credentials", async () => {
      const res = await request(app)
        .post("/api/v1/auth/login")
        .send({
          email: testUser.email,
          password: testUser.password,
        });

      expect(res.statusCode).toEqual(200);
      expect(res.body.message).toEqual("Login successful");
      expect(res.body.user).toHaveProperty("accessToken");
    });

    it("should fail with incorrect password", async () => {
      const res = await request(app)
        .post("/api/v1/auth/login")
        .send({
          email: testUser.email,
          password: "wrongpassword",
        });

      expect(res.statusCode).toEqual(401);
      expect(res.body.message).toEqual("Invalid credentials");
    });
  });
});
