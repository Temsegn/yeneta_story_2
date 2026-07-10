import request from "supertest";
import app from "../server.js";
import Video from "../models/video_models.js";
import { createTestUser } from "./testUtils.js";
import { jest } from "@jest/globals";

const apiPrefix = "/api/v1/videos";

jest.mock("../utils/auditLogger.js", () => ({
  logAction: jest.fn().mockResolvedValue({}),
}));

describe("Videos API Endpoints", () => {
  let adminToken, userToken, adminUser;

  beforeAll(async () => {
    const admin = await createTestUser("admin");
    const normal = await createTestUser("parent");
    adminToken = admin.token;
    adminUser = admin.user;
    userToken = normal.token;
  });

  describe("POST /", () => {
    const validVideo = {
      title: "Test Video",
      description: "Test Description",
      videoUrl: "http://example.com/video.mp4",
      thumbnail: "http://example.com/thumb.jpg",
      isPremium: true
    };

    it("should allow admin to create a video", async () => {
      const res = await request(app)
        .post(apiPrefix)
        .set("Authorization", `Bearer ${adminToken}`)
        .send(validVideo);

      expect(res.status).toBe(201);
      expect(res.body.title).toBe(validVideo.title);
    });

    it("should deny normal user from creating a video", async () => {
      const res = await request(app)
        .post(apiPrefix)
        .set("Authorization", `Bearer ${userToken}`)
        .send(validVideo);

      expect(res.status).toBe(403);
    });
  });

  describe("GET /", () => {
    it("should get all videos for authenticated user", async () => {
      const res = await request(app)
        .get(apiPrefix)
        .set("Authorization", `Bearer ${userToken}`);

      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty("videos");
      expect(Array.isArray(res.body.videos)).toBeTruthy();
    });
  });

  describe("Operations on specific video /:id", () => {
    let testVideoId;

    beforeAll(async () => {
      const video = await Video.create({
        title: "Specific Test Video",
        description: "Test",
        videoUrl: "http://example.com/video.mp4",
        thumbnail: "http://example.com/thumb.jpg",
        isPremium: false,
        createdBy: adminUser._id
      });
      testVideoId = video._id.toString();
    });

    it("should allow user to get non-premium video", async () => {
      const res = await request(app)
        .get(`${apiPrefix}/${testVideoId}`)
        .set("Authorization", `Bearer ${userToken}`);

      expect(res.status).toBe(200);
      expect(res.body._id).toBe(testVideoId);
    });

    it("should allow admin to update a video", async () => {
      const res = await request(app)
        .put(`${apiPrefix}/${testVideoId}`)
        .set("Authorization", `Bearer ${adminToken}`)
        .send({ title: "Updated Video Title" });

      expect(res.status).toBe(200);
      expect(res.body.title).toBe("Updated Video Title");
    });

    it("should deny normal user from updating a video", async () => {
      const res = await request(app)
        .put(`${apiPrefix}/${testVideoId}`)
        .set("Authorization", `Bearer ${userToken}`)
        .send({ title: "Hack Title" });

      expect(res.status).toBe(403);
    });

    it("should allow admin to delete a video", async () => {
      const res = await request(app)
        .delete(`${apiPrefix}/${testVideoId}`)
        .set("Authorization", `Bearer ${adminToken}`);

      expect(res.status).toBe(200);
      expect(res.body.message).toMatch(/deleted/i);
    });
  });
});
