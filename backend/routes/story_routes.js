import express from 'express';
import {
  createStory,
  getAllStories,
  getStoryById,
  updateStory,
  deleteStory,
} from "../controllers/story_controllers.js";
import Story from "../models/story_models.js";
import { loadContent } from '../middlewares/load_content_middlewares.js';
import { protect } from "../middlewares/auth_middlewares.js";
import { isAdmin } from "../middlewares/role_middlewares.js";
import { checkSubscription } from "../middlewares/subscription_middlewares.js";
const router= express.Router();

/**
 * @swagger
 * /api/v1/stories:
 *   get:
 *     summary: Get all stories
 *     tags: [Stories]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           default: 1
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           default: 10
 *     responses:
 *       200:
 *         description: List of stories
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 stories:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Story'
 *                 totalPages:
 *                   type: integer
 *                 currentPage:
 *                   type: integer
 */
router.get("/", getAllStories);

/**
 * @swagger
 * /api/v1/stories/{id}:
 *   get:
 *     summary: Get a story by ID
 *     tags: [Stories]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Story details
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Story'
 *       404:
 *         description: Story not found
 */
router.get("/:id",protect,loadContent(Story),checkSubscription,getStoryById);

/**
 * @swagger
 * /api/v1/stories:
 *   post:
 *     summary: Create a new story
 *     tags: [Stories]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Story'
 *     responses:
 *       201:
 *         description: Story created successfully
 *       403:
 *         description: Admin only
 */
router.post("/",protect, isAdmin,createStory);

/**
 * @swagger
 * /api/v1/stories/{id}:
 *   put:
 *     summary: Update a story
 *     tags: [Stories]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Story'
 *     responses:
 *       200:
 *         description: Story updated successfully
 *       404:
 *         description: Story not found
 */
router.put("/:id",protect,isAdmin, updateStory);

/**
 * @swagger
 * /api/v1/stories/{id}:
 *   delete:
 *     summary: Delete a story
 *     tags: [Stories]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Story deleted successfully
 *       404:
 *         description: Story not found
 */
router.delete("/:id",protect,isAdmin, deleteStory);

export default router;
