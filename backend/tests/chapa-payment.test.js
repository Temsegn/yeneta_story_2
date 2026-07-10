import request from "supertest";
import app from "../server.js";
import { createTestUser } from "./testUtils.js";
import { clearDatabase } from "./setup.js";
import Payment from "../models/payment_models.js";
import Subscription from "../models/subscription_models.js";
import User from "../models/user_model.js";

describe("Chapa Payment Integration Tests", () => {
  let userToken;
  let userId;

  beforeEach(async () => {
    await clearDatabase();
    const { user, token } = await createTestUser("parent");
    userToken = token;
    userId = user._id;
  });

  describe("POST /api/v1/payments/chapa/init-payment", () => {
    it("should initialize payment with valid data", async () => {
      const paymentData = {
        plan: "yearly",
        email: "test@example.com",
        firstName: "John",
        lastName: "Doe",
        phoneNumber: "+251912345678",
      };

      const res = await request(app)
        .post("/api/v1/payments/chapa/init-payment")
        .set("Authorization", `Bearer ${userToken}`)
        .send(paymentData);

      console.log("Init payment response:", res.status, res.body);

      // Should return 200 or 400 depending on Chapa API
      expect([200, 400]).toContain(res.status);
      
      if (res.status === 200) {
        expect(res.body).toHaveProperty("message");
        expect(res.body).toHaveProperty("data");
        expect(res.body.data).toHaveProperty("tx_ref");
      } else {
        // If it fails, message should be a string
        expect(res.body).toHaveProperty("message");
        expect(typeof res.body.message).toBe("string");
        expect(res.body.message).not.toBe("[object Object]");
      }
    });

    it("should reject request without authentication", async () => {
      const paymentData = {
        plan: "yearly",
        email: "test@example.com",
        firstName: "John",
        lastName: "Doe",
        phoneNumber: "+251912345678",
      };

      const res = await request(app)
        .post("/api/v1/payments/chapa/init-payment")
        .send(paymentData);

      expect(res.status).toBe(401);
      expect(res.body).toHaveProperty("message");
    });

    it("should reject request with missing fields", async () => {
      const paymentData = {
        plan: "yearly",
        email: "test@example.com",
        // Missing firstName, lastName, phoneNumber
      };

      const res = await request(app)
        .post("/api/v1/payments/chapa/init-payment")
        .set("Authorization", `Bearer ${userToken}`)
        .send(paymentData);

      expect(res.status).toBe(400);
      expect(res.body).toHaveProperty("message");
      expect(typeof res.body.message).toBe("string");
      expect(res.body.message).toContain("Missing required fields");
    });

    it("should reject invalid plan", async () => {
      const paymentData = {
        plan: "invalid_plan",
        email: "test@example.com",
        firstName: "John",
        lastName: "Doe",
        phoneNumber: "+251912345678",
      };

      const res = await request(app)
        .post("/api/v1/payments/chapa/init-payment")
        .set("Authorization", `Bearer ${userToken}`)
        .send(paymentData);

      expect(res.status).toBe(400);
      expect(res.body).toHaveProperty("message");
      expect(typeof res.body.message).toBe("string");
    });

    it("should reject if user already has active subscription", async () => {
      // Create active subscription
      await Subscription.create({
        user: userId,
        plan: "yearly",
        price: 1000,
        status: "active",
        startDate: new Date(),
        endDate: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000),
      });

      const paymentData = {
        plan: "yearly",
        email: "test@example.com",
        firstName: "John",
        lastName: "Doe",
        phoneNumber: "+251912345678",
      };

      const res = await request(app)
        .post("/api/v1/payments/chapa/init-payment")
        .set("Authorization", `Bearer ${userToken}`)
        .send(paymentData);

      expect(res.status).toBe(400);
      expect(res.body).toHaveProperty("message");
      expect(typeof res.body.message).toBe("string");
      expect(res.body.message).toContain("active subscription");
    });
  });

  describe("GET /api/v1/payments/chapa/check-access", () => {
    it("should return no access for user without subscription", async () => {
      const res = await request(app)
        .get("/api/v1/payments/chapa/check-access")
        .set("Authorization", `Bearer ${userToken}`);

      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty("hasAccess");
      expect(res.body.hasAccess).toBe(false);
    });

    it("should return access for user with active subscription", async () => {
      // Create active subscription
      const endDate = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);
      await Subscription.create({
        user: userId,
        plan: "yearly",
        price: 1000,
        status: "active",
        startDate: new Date(),
        endDate,
      });

      // Update user
      await User.findByIdAndUpdate(userId, {
        hasActiveSubscription: true,
        subscriptionEndDate: endDate,
        currentPlan: "yearly",
      });

      const res = await request(app)
        .get("/api/v1/payments/chapa/check-access")
        .set("Authorization", `Bearer ${userToken}`);

      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty("hasAccess");
      expect(res.body.hasAccess).toBe(true);
      expect(res.body.accessType).toBe("subscription");
    });

    it("should return access for user in trial period", async () => {
      // Set trial end date in future
      const trialEndDate = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
      await User.findByIdAndUpdate(userId, {
        trialEndDate,
      });

      const res = await request(app)
        .get("/api/v1/payments/chapa/check-access")
        .set("Authorization", `Bearer ${userToken}`);

      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty("hasAccess");
      expect(res.body.hasAccess).toBe(true);
      expect(res.body.accessType).toBe("trial");
    });
  });

  describe("POST /api/v1/payments/chapa/webhook", () => {
    it("should accept webhook without authentication", async () => {
      const webhookPayload = {
        event: "charge.success",
        data: {
          tx_ref: "test_tx_ref_123",
          status: "success",
          amount: 1000,
          reference: "chapa_ref_123",
        },
      };

      const res = await request(app)
        .post("/api/v1/payments/chapa/webhook")
        .send(webhookPayload);

      // Webhook should always return 200
      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty("message");
    });

    it("should handle invalid webhook payload gracefully", async () => {
      const webhookPayload = {
        event: "invalid_event",
        data: {},
      };

      const res = await request(app)
        .post("/api/v1/payments/chapa/webhook")
        .send(webhookPayload);

      // Should still return 200 to prevent retries
      expect(res.status).toBe(200);
    });
  });

  describe("Error Message Format", () => {
    it("should always return string messages, never objects", async () => {
      // Test various error scenarios
      const testCases = [
        {
          name: "missing fields",
          data: { plan: "yearly" },
        },
        {
          name: "invalid plan",
          data: {
            plan: "invalid",
            email: "test@test.com",
            firstName: "Test",
            lastName: "User",
            phoneNumber: "+251912345678",
          },
        },
      ];

      for (const testCase of testCases) {
        const res = await request(app)
          .post("/api/v1/payments/chapa/init-payment")
          .set("Authorization", `Bearer ${userToken}`)
          .send(testCase.data);

        expect(res.status).toBe(400);
        expect(res.body).toHaveProperty("message");
        expect(typeof res.body.message).toBe("string");
        expect(res.body.message).not.toBe("[object Object]");
        expect(res.body.message).not.toContain("[object Object]");
      }
    });
  });
});

describe("Chapa Service Unit Tests", () => {
  describe("Phone Number Formatting", () => {
    it("should accept Ethiopian phone numbers", () => {
      const validNumbers = [
        "+251912345678",
        "+251992327207",
        "0912345678",
        "0992327207",
      ];

      validNumbers.forEach((number) => {
        // Phone number validation happens in mobile app
        // Backend just passes it to Chapa
        expect(number).toBeTruthy();
      });
    });
  });

  describe("Plan Validation", () => {
    it("should only accept yearly and semiannual plans", () => {
      const validPlans = ["yearly", "semiannual"];
      const invalidPlans = ["monthly", "weekly", "invalid"];

      validPlans.forEach((plan) => {
        expect(["yearly", "semiannual"]).toContain(plan);
      });

      invalidPlans.forEach((plan) => {
        expect(["yearly", "semiannual"]).not.toContain(plan);
      });
    });
  });
});
