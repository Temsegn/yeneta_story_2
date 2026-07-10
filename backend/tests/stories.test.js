import request from "supertest";
import app from "../server.js";
import Story from "../models/story_models.js";
import { createTestUser } from "./testUtils.js";
import { jest } from "@jest/globals";

const apiPrefix = "/api/v1/stories";

jest.mock("../utils/auditLogger.js", () => ({
  logAction: jest.fn().mockResolvedValue({}),
}));

describe("Stories API Endpoints", () => {
  let adminToken, userToken, adminUser;

  beforeAll(async () => {
    const admin = await createTestUser("admin");
    const normal = await createTestUser("parent");
    adminToken = admin.token;
    adminUser = admin.user;
    userToken = normal.token;
  });

  describe("POST /", () => {
    const validStory = {
      title: "Test Story",
      coverImageUrl: "http://example.com/cover.jpg",
      description: "Test Description",
      isPremium: true
    };

    it("should allow admin to create a story", async () => {
      const res = await request(app)
        .post(apiPrefix)
        .set("Authorization", `Bearer ${adminToken}`)
        .send(validStory);

      expect(res.status).toBe(201);
      expect(res.body.title).toBe(validStory.title);
    });

    it("should deny normal user from creating a story", async () => {
      const res = await request(app)
        .post(apiPrefix)
        .set("Authorization", `Bearer ${userToken}`)
        .send(validStory);

      expect(res.status).toBe(403);
    });
  });

  describe("GET /", () => {
    it("should get all stories for authenticated user", async () => {
      const res = await request(app)
        .get(apiPrefix)
        .set("Authorization", `Bearer ${userToken}`);

      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty("stories");
      expect(Array.isArray(res.body.stories)).toBeTruthy();
    });
  });

  describe("Operations on specific story /:id", () => {
    let testStoryId;

    beforeAll(async () => {
      const story = await Story.create({
        title: "Specific Test Story",
        coverImageUrl: "http://example.com/cover.jpg",
        description: "Test",
        isPremium: false,
        createdBy: adminUser._id
      });
      testStoryId = story._id.toString();
    });

    it("should allow user to get non-premium story", async () => {
      const res = await request(app)
        .get(`${apiPrefix}/${testStoryId}`)
        .set("Authorization", `Bearer ${userToken}`);

      expect(res.status).toBe(200);
      expect(res.body._id).toBe(testStoryId);
    });

    it("should allow admin to update a story", async () => {
      const res = await request(app)
        .put(`${apiPrefix}/${testStoryId}`)
        .set("Authorization", `Bearer ${adminToken}`)
        .send({ title: "Updated Story Title" });

      expect(res.status).toBe(200);
      expect(res.body.title).toBe("Updated Story Title");
    });

    it("should allow admin to delete a story", async () => {
      const res = await request(app)
        .delete(`${apiPrefix}/${testStoryId}`)
        .set("Authorization", `Bearer ${adminToken}`);

      expect(res.status).toBe(200);
      expect(res.body.message).toMatch(/deleted/i);
    });
  });
});
