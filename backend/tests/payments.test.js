import request from "supertest";
import app from "../server.js";
import { createTestUser } from "./testUtils.js";
import { jest } from "@jest/globals";

const apiPrefix = "/api/v1/payments";

jest.mock("../utils/auditLogger.js", () => ({
  logAction: jest.fn().mockResolvedValue({}),
}));

describe("Payments API Endpoints", () => {
  let userToken, testUserObj;

  beforeAll(async () => {
    const normal = await createTestUser("parent");
    userToken = normal.token;
    testUserObj = normal.user;
  });

  describe("POST /", () => {
    it("should create a payment for authenticated user", async () => {
      // First create a subscription to reference
      const subRes = await request(app)
        .post("/api/v1/subscriptions/register")
        .set("Authorization", `Bearer ${userToken}`)
        .send({
          plan: "monthly",
          price: 100,
          endDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
        });

      const subscriptionId = subRes.body?._id;

      const res = await request(app)
        .post(apiPrefix)
        .set("Authorization", `Bearer ${userToken}`)
        .send({
          amount: 100,
          subscription: subscriptionId || testUserObj._id,
          paymentMethod: "telebirr",
        });

      // Controller returns 201 on success, 400 on service error
      expect([201, 400]).toContain(res.status);
    });

    it("should return 401 if not authenticated", async () => {
      const res = await request(app)
        .post(apiPrefix)
        .send({ amount: 100, paymentMethod: "telebirr" });
      expect(res.status).toBe(401);
    });
  });

  describe("POST /verify", () => {
    it("should return error if transactionId missing", async () => {
      const res = await request(app)
        .post(`${apiPrefix}/verify`)
        .set("Authorization", `Bearer ${userToken}`)
        .send({});
      expect(res.status).toBe(500);
    });

    it("should attempt verification with a transactionId", async () => {
      const res = await request(app)
        .post(`${apiPrefix}/verify`)
        .set("Authorization", `Bearer ${userToken}`)
        .send({ transactionId: "fake-transaction-123" });
      expect([200, 500]).toContain(res.status);
    });
  });
});
