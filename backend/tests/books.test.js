import request from "supertest";
import app from "../server.js";
import Book from "../models/book_models.js";
import { createTestUser } from "./testUtils.js";
import { jest } from "@jest/globals";

const apiPrefix = "/api/v1/books";

jest.mock("../utils/auditLogger.js", () => ({
  logAction: jest.fn().mockResolvedValue({}),
}));

describe("Books API Endpoints", () => {
  let adminToken, userToken, adminUser;

  beforeAll(async () => {
    const admin = await createTestUser("admin");
    const normal = await createTestUser("parent");
    adminToken = admin.token;
    adminUser = admin.user;
    userToken = normal.token;
  });

  describe("POST /", () => {
    const validBook = {
      title: "Test Book",
      coverImageUrl: "http://example.com/cover.jpg",
      description: "Test Description",
      isPremium: true
    };

    it("should allow admin to create a book", async () => {
      const res = await request(app)
        .post(apiPrefix)
        .set("Authorization", `Bearer ${adminToken}`)
        .send(validBook);

      expect(res.status).toBe(201);
      expect(res.body.title).toBe(validBook.title);
    });

    it("should deny normal user from creating a book", async () => {
      const res = await request(app)
        .post(apiPrefix)
        .set("Authorization", `Bearer ${userToken}`)
        .send(validBook);

      expect(res.status).toBe(403);
    });
  });

  describe("GET /", () => {
    it("should get all books for authenticated user", async () => {
      const res = await request(app)
        .get(apiPrefix)
        .set("Authorization", `Bearer ${userToken}`);

      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty("books");
      expect(Array.isArray(res.body.books)).toBeTruthy();
    });

    it("should deny access if no token is provided", async () => {
      const res = await request(app).get(apiPrefix);
      expect(res.status).toBe(401);
    });
  });

  describe("Operations on specific book /:id", () => {
    let testBookId;

    beforeAll(async () => {
      // Create a book directly in DB
      const book = await Book.create({
        title: "Specific Test Book",
        coverImageUrl: "http://example.com/cover.jpg",
        description: "Test",
        isPremium: false,
        createdBy: adminUser._id,
      });
      testBookId = book._id.toString();
    });

    it("should allow user to get non-premium book", async () => {
      const res = await request(app)
        .get(`${apiPrefix}/${testBookId}`)
        .set("Authorization", `Bearer ${userToken}`);

      expect(res.status).toBe(200);
      expect(res.body._id).toBe(testBookId);
    });

    it("should allow admin to update a book", async () => {
      const res = await request(app)
        .put(`${apiPrefix}/${testBookId}`)
        .set("Authorization", `Bearer ${adminToken}`)
        .send({ title: "Updated Title" });

      expect(res.status).toBe(200);
      expect(res.body.title).toBe("Updated Title");
    });

    it("should deny normal user from updating a book", async () => {
      const res = await request(app)
        .put(`${apiPrefix}/${testBookId}`)
        .set("Authorization", `Bearer ${userToken}`)
        .send({ title: "Hack Title" });

      expect(res.status).toBe(403);
    });

    it("should allow admin to delete a book", async () => {
      const res = await request(app)
        .delete(`${apiPrefix}/${testBookId}`)
        .set("Authorization", `Bearer ${adminToken}`);

      expect(res.status).toBe(200);
      expect(res.body.message).toMatch(/deleted/i);
    });
  });
});
