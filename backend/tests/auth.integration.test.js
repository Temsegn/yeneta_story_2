import request from "supertest";
import app from "../server.js";
import { jest } from "@jest/globals";

jest.mock("../utils/auditLogger.js", () => ({
  logAction: jest.fn().mockResolvedValue({}),
}));

describe("Auth Integration Tests", () => {
  const testUser = {
    fullName: "Test User",
    email: "test@example.com",
    phoneNumber: "0912345678",
    password: "password123",
    securityQuestion: "What city were you born in?",
    securityAnswer: "Addis",
  };

  describe("POST /api/v1/auth/register", () => {
    it("should register a new user successfully", async () => {
      const res = await request(app)
        .post("/api/v1/auth/register")
        .send(testUser);

      expect(res.statusCode).toEqual(201);
      expect(res.body.message).toEqual("Signup successful");
      expect(res.body.user).toHaveProperty("email", testUser.email);
      expect(res.body.user.phoneNumber).toBe("+251912345678");
      expect(res.body.user).not.toHaveProperty("password");
    });

    it("should fail if phone already exists", async () => {
      await request(app).post("/api/v1/auth/register").send(testUser);
      const res = await request(app)
        .post("/api/v1/auth/register")
        .send({ ...testUser, email: "other@example.com" });

      expect(res.statusCode).toEqual(400);
      expect(res.body.message).toMatch(/phone/i);
    });
  });

  describe("POST /api/v1/auth/login", () => {
    beforeEach(async () => {
      await request(app).post("/api/v1/auth/register").send(testUser);
    });

    it("should login successfully with correct credentials", async () => {
      const res = await request(app).post("/api/v1/auth/login").send({
        phoneNumber: testUser.phoneNumber,
        password: testUser.password,
      });

      expect(res.statusCode).toEqual(200);
      expect(res.body.message).toEqual("Login successful");
      expect(res.body.user).toHaveProperty("accessToken");
    });

    it("should fail with incorrect password", async () => {
      const res = await request(app).post("/api/v1/auth/login").send({
        phoneNumber: testUser.phoneNumber,
        password: "wrongpassword",
      });

      expect(res.statusCode).toEqual(401);
      expect(res.body.message).toEqual("Invalid credentials");
    });
  });
});
