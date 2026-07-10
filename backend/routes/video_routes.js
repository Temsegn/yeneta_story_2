import express from "express";
import {
  createVideo,
  getAllVideos,
  getVideoById,
  deleteVideo,
  updateVideo
} from "../controllers/video_controllers.js";
import Video from "../models/video_models.js";
import { loadContent } from "../middlewares/load_content_middlewares.js";
import { protect } from "../middlewares/auth_middlewares.js";
import { isAdmin } from "../middlewares/role_middlewares.js";
import { checkSubscription } from "../middlewares/subscription_middlewares.js";

const router = express.Router();

/**
 * @swagger
 * /api/v1/videos:
 *   get:
 *     summary: Get all videos
 *     tags: [Videos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           default: 1
 *         description: Page number
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           default: 10
 *         description: Number of videos per page
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         description: Search term for video titles
 *     responses:
 *       200:
 *         description: List of videos with pagination
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 videos:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Video'
 *                 totalPages:
 *                   type: integer
 *                 currentPage:
 *                   type: integer
 *                 totalVideos:
 *                   type: integer
 *       500:
 *         description: Server error
 */
router.get("/", getAllVideos);

/**
 * @swagger
 * /api/v1/videos/{id}:
 *   get:
 *     summary: Get a video by ID
 *     tags: [Videos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Video ID
 *     responses:
 *       200:
 *         description: Video details
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Video'
 *       404:
 *         description: Video not found
 *       500:
 *         description: Server error
 */
router.get("/:id", protect, loadContent(Video), checkSubscription, getVideoById);

/**
 * @swagger
 * /api/v1/videos:
 *   post:
 *     summary: Create a new video
 *     tags: [Videos]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: ["title", "description", "videoUrl", "thumbnail"]
 *             properties:
 *               title:
 *                 type: string
 *                 description: Video title
 *               description:
 *                 type: string
 *                 description: Video description
 *               videoUrl:
 *                 type: string
 *                 description: URL of the video file
 *               thumbnail:
 *                 type: string
 *                 description: URL of the thumbnail image
 *               isPremium:
 *                 type: boolean
 *                 description: Whether the video is premium content
 *                 default: true
 *     responses:
 *       201:
 *         description: Video created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Video'
 *       500:
 *         description: Server error
 */
router.post("/", protect, isAdmin, createVideo);
/**
 * @swagger
 * /api/v1/videos/{id}:
 *   put:
 *     summary: Update a video
 *     tags: [Videos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Video ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               title:
 *                 type: string
 *                 description: Video title
 *               description:
 *                 type: string
 *                 description: Video description
 *               videoUrl:
 *                 type: string
 *                 description: URL of the video file
 *               thumbnail:
 *                 type: string
 *                 description: URL of the thumbnail image
 *               isPremium:
 *                 type: boolean
 *                 description: Whether the video is premium content
 *     responses:
 *       200:
 *         description: Video updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Video'
 *       404:
 *         description: Video not found
 *       500:
 *         description: Server error
 */router.put("/:id", protect, isAdmin, updateVideo);

/**
 * @swagger
 * /api/v1/videos/{id}:
 *   delete:
 *     summary: Delete a video
 *     tags: [Videos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Video ID
 *     responses:
 *       200:
 *         description: Video deleted successfully
 *       404:
 *         description: Video not found
 *       500:
 *         description: Server error
 */
router.delete("/:id", protect, isAdmin, deleteVideo);
export default router;
