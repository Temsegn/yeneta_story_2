import request from "supertest";
import app from "../server.js";
import User from "../models/user_model.js";
import jwt from "jsonwebtoken";

const apiPrefix = "/api/v1";

describe("Protected API Endpoints", () => {
  let authToken;
  let cookies;
  const testUser = {
    fullName: "API Tester",
    email: "apitester@example.com",
    phoneNumber: "0987654321",
    password: "password123",
  };

  beforeAll(async () => {
    // Register and login to get the token for protected routes
    await request(app).post(`${apiPrefix}/auth/register`).send(testUser);
    const loginRes = await request(app).post(`${apiPrefix}/auth/login`).send({
      email: testUser.email,
      password: testUser.password,
    });
    
    // Depending on whether JWT is returned in body or in cookies. Adjust as needed.
    authToken = loginRes.body.user?.accessToken; 
    
    // Also save the cookies to send along
    cookies = loginRes.headers['set-cookie'];
  });

  describe("GET /auth/profile", () => {
    it("should access profile if authenticated", async () => {
      const req = request(app).get(`${apiPrefix}/auth/profile`);
        
      if (cookies) {
         req.set('Cookie', cookies);
      }
      
      const res = await req
        .set("Authorization", `Bearer ${authToken}`);

      expect(res.status).toBeGreaterThanOrEqual(200);
      expect(res.status).toBeLessThan(400);
    });

    it("should deny access if unauthorized", async () => {
      const res = await request(app).get(`${apiPrefix}/auth/profile`);
      expect(res.status).toBe(401);
    });
  });
});
