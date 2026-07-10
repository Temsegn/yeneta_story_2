import request from "supertest";
import app from "../server.js";
import mongoose from "mongoose";
import { jest } from "@jest/globals";

// Mock connectDB to avoid actual database connection during tests
jest.mock("../config/db.js", () => ({
  __esModule: true,
  default: jest.fn().mockImplementation(() => Promise.resolve()),
}));

describe("Health Check API", () => {

  it("should return 200 and status ok", async () => {
    const res = await request(app).get("/health");
    expect(res.statusCode).toEqual(200);
    expect(res.body).toHaveProperty("status", "ok");
    expect(res.body).toHaveProperty("message", "Server is healthy");
  });

  it("should return 404 for non-existent routes", async () => {
    const res = await request(app).get("/non-existent-route");
    expect(res.statusCode).toEqual(404);
  });
});
