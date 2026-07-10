import request from "supertest";
import app from "../server.js";
import { createTestUser } from "./testUtils.js";
import { jest } from "@jest/globals";

const apiPrefix = "/api/v1/subscriptions";

jest.mock("../utils/auditLogger.js", () => ({
  logAction: jest.fn().mockResolvedValue({}),
}));

describe("Subscriptions API Endpoints", () => {
  let userToken;

  beforeAll(async () => {
    const normal = await createTestUser("parent");
    userToken = normal.token;
  });

  describe("POST /register", () => {
    it("should allow a user to create a subscription", async () => {
      const res = await request(app)
        .post(`${apiPrefix}/register`)
        .set("Authorization", `Bearer ${userToken}`)
        .send({ plan: "monthly", durationInDays: 30, price: 50 });

      expect(res.status).toBe(201);
      expect(res.body).toHaveProperty("plan", "monthly");
    });

    it("should return 401 if not authenticated", async () => {
      const res = await request(app)
        .post(`${apiPrefix}/register`)
        .send({ plan: "monthly", price: 10 });
      expect(res.status).toBe(401);
    });
  });

  describe("GET /me", () => {
    it("should get user's subscription if authenticated", async () => {
      const res = await request(app)
        .get(`${apiPrefix}/me`)
        .set("Authorization", `Bearer ${userToken}`);

      expect([200, 404]).toContain(res.status); // 404 if none, 200 if exists
    });

    it("should return 401 if not authenticated", async () => {
      const res = await request(app).get(`${apiPrefix}/me`);
      expect(res.status).toBe(401);
    });
  });

  describe("GET /check", () => {
    it("should check subscription status if authenticated", async () => {
      const res = await request(app)
        .get(`${apiPrefix}/check`)
        .set("Authorization", `Bearer ${userToken}`);

      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty("active");
    });
  });
});
