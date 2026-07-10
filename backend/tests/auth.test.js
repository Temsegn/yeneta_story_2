import request from "supertest";
import app from "../server.js";
import User from "../models/user_model.js";
import { clearDatabase } from "./setup.js";

const apiPrefix = "/api/v1/auth";

afterEach(async () => {
  await clearDatabase();
});

describe("Auth Endpoints", () => {
  const testUser = {
    fullName: "Test User",
    email: "testuser@example.com",
    phoneNumber: "0912345678",
    password: "password123",
    securityQuestion: "What is my pet name?",
    securityAnswer: "Buddy",
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
      expect(res.body.user.phoneNumber).toBe("+251912345678");
      expect(res.body.user).toHaveProperty("accessToken");
    });

    it("should register without email", async () => {
      const { email, ...noEmail } = testUser;
      const res = await request(app)
        .post(`${apiPrefix}/register`)
        .send({ ...noEmail, phoneNumber: "0911111111" });

      expect(res.status).toBe(201);
      expect(res.body.user.email).toBeNull();
      expect(res.body.user.phoneNumber).toBe("+251911111111");
    });

    it("should fail if phone is already registered", async () => {
      await request(app).post(`${apiPrefix}/register`).send(testUser);

      const res = await request(app)
        .post(`${apiPrefix}/register`)
        .send({
          ...testUser,
          email: "other@example.com",
        });

      expect(res.status).toBe(400);
    });

    it("should fail validation if missing fields", async () => {
      const res = await request(app)
        .post(`${apiPrefix}/register`)
        .send({ email: "onlyemail@example.com" });

      expect(res.status).toBeGreaterThanOrEqual(400);
    });

    it("should reject invalid phone numbers", async () => {
      const res = await request(app)
        .post(`${apiPrefix}/register`)
        .send({ ...testUser, phoneNumber: "12345" });

      expect(res.status).toBeGreaterThanOrEqual(400);
    });
  });

  describe("POST /login", () => {
    beforeEach(async () => {
      await request(app).post(`${apiPrefix}/register`).send(testUser);
    });

    it("should login with phone in 09 format", async () => {
      const res = await request(app).post(`${apiPrefix}/login`).send({
        phoneNumber: "0912345678",
        password: testUser.password,
      });

      expect(res.status).toBe(200);
      expect(res.body.message).toBe("Login successful");
      expect(res.body.user).toHaveProperty("accessToken");
    });

    it("should login with +251 format", async () => {
      const res = await request(app).post(`${apiPrefix}/login`).send({
        phoneNumber: "+251912345678",
        password: testUser.password,
      });

      expect(res.status).toBe(200);
      expect(res.body.user).toHaveProperty("accessToken");
    });

    it("should login with 9-digit local format", async () => {
      const res = await request(app).post(`${apiPrefix}/login`).send({
        phoneNumber: "912345678",
        password: testUser.password,
      });

      expect(res.status).toBe(200);
    });

    it("should fail with incorrect password", async () => {
      const res = await request(app).post(`${apiPrefix}/login`).send({
        phoneNumber: testUser.phoneNumber,
        password: "wrongpassword",
      });

      expect(res.status).toBe(401);
    });
  });

  describe("Forgot / reset password", () => {
    beforeEach(async () => {
      await request(app).post(`${apiPrefix}/register`).send(testUser);
    });

    it("should return security question for users with email", async () => {
      const res = await request(app)
        .post(`${apiPrefix}/forgot-password`)
        .send({ phoneNumber: "0912345678" });

      expect(res.status).toBe(200);
      expect(res.body.securityQuestion).toBe(testUser.securityQuestion);
    });

    it("should reset password with correct security answer", async () => {
      const reset = await request(app)
        .post(`${apiPrefix}/reset-password`)
        .send({
          phoneNumber: "0912345678",
          securityAnswer: "Buddy",
          newPassword: "newpass123",
        });

      expect(reset.status).toBe(200);

      const login = await request(app).post(`${apiPrefix}/login`).send({
        phoneNumber: "0912345678",
        password: "newpass123",
      });
      expect(login.status).toBe(200);
    });

    it("should block forgot-password for phone-only users", async () => {
      await request(app)
        .post(`${apiPrefix}/register`)
        .send({
          fullName: "Phone Only",
          phoneNumber: "0922222222",
          password: "password123",
          securityQuestion: "Favorite color?",
          securityAnswer: "blue",
        });

      const res = await request(app)
        .post(`${apiPrefix}/forgot-password`)
        .send({ phoneNumber: "0922222222" });

      expect(res.status).toBe(400);
      expect(res.body.code).toBe("SMS_RECOVERY_PENDING");
    });
  });
});
