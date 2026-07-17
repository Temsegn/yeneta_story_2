import express from "express";
import dotenv from "dotenv";
import path from "path";
import connectDB from "./config/db.js";
import apiRoutes from "./routes/index_routes.js";

import cookieParser from "cookie-parser";
import helmet from "helmet";
import compression from "compression";
import cors from "cors";
import rateLimit from "express-rate-limit";
import { logger } from "./middlewares/logger_middlewares.js";
import { notFound, errorHandler } from "./middlewares/error_handler.js";
import { startSubscriptionCron } from "./utils/subscriptionCron.js";

// Swagger
import swaggerUi from "swagger-ui-express";
import swaggerJsdoc from "swagger-jsdoc";

dotenv.config();
const app = express();
connectDB();

// Start subscription cron jobs
if (process.env.NODE_ENV !== "test") {
  startSubscriptionCron();
}

app.use(helmet());
// Enable CORS (frontend integration)
const allowedOrigins = [
  process.env.CLIENT_URL || "http://localhost:5173",
  "http://localhost:3000", // Dashboard
  "http://10.0.2.2:5000", // Android emulator
  "http://localhost:5000", // iOS simulator
];

app.use(
  cors({
    origin: (origin, callback) => {
      // Allow requests with no origin (mobile apps, Postman, etc.)
      if (!origin || allowedOrigins.includes(origin)) {
        callback(null, true);
      } else {
        callback(null, true); // Allow all origins for mobile app compatibility
      }
    },
    credentials: true,
  })
);

app.use(compression());
app.use(cookieParser());
app.use(express.json());
app.use(logger);

app.use(
  rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100,
    message: "Too many requests from this IP, please try again later.",
  })
);

// Local /uploads is only a temporary landing pad for multer before Cloudinary.
app.use("/uploads", express.static(path.join(process.cwd(), "uploads")));

// swagger setup

const swaggerOptions = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "Express Mongo API",
      version: "1.0.0",
      description:
        "Production-ready API with authentication, validation, pagination, and documentation",
    },
    servers: [
      {
        url: `http://localhost:${process.env.PORT || 5000}`,
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: "http",
          scheme: "bearer",
          bearerFormat: "JWT",
        },
      },
      schemas: {
        Video: {
          type: "object",
          required: ["title", "description", "videoUrl", "thumbnail", "createdBy"],
          properties: {
            _id: { type: "string" },
            title: { type: "string" },
            description: { type: "string" },
            videoUrl: { type: "string" },
            thumbnail: { type: "string" },
            isPremium: { type: "boolean", default: true },
            createdBy: { type: "string" },
            createdAt: { type: "string", format: "date-time" },
            updatedAt: { type: "string", format: "date-time" },
          },
        },

        User: {
          type: "object",
          required: ["fullName", "email", "phoneNumber", "password"],
          properties: {
            _id: { type: "string" },
            fullName: { type: "string" },
            email: { type: "string", format: "email" },
            phoneNumber: { type: "string" },
            password: { type: "string", minLength: 6 },
            role: {
              type: "string",
              enum: ["parent", "admin"],
              default: "parent",
            },
            childProfiles: {
              type: "array",
              items: {
                type: "object",
                required: ["name", "birthdate"],
                properties: {
                  name: { type: "string" },
                  birthdate: { type: "string", format: "date" },
                },
              },
            },
            isActive: { type: "boolean", default: true },
            createdAt: { type: "string", format: "date-time" },
            updatedAt: { type: "string", format: "date-time" },
          },
        },

        Book: {
          type: "object",
          required: ["title", "coverImageUrl", "createdBy"],
          properties: {
            _id: { type: "string" },
            title: { type: "string" },
            coverImageUrl: { type: "string" },
            description: { type: "string" },
            isPremium: { type: "boolean", default: true },
            totalPages: { type: "integer", default: 0 },
            pages: {
              type: "array",
              items: {
                type: "object",
                required: ["pageNumber", "content", "imageUrl"],
                properties: {
                  pageNumber: { type: "integer" },
                  title: { type: "string" },
                  content: { type: "string" },
                  imageUrl: { type: "string" },
                },
              },
            },
            createdBy: { type: "string" },
            createdAt: { type: "string", format: "date-time" },
            updatedAt: { type: "string", format: "date-time" },
          },
        },

        Story: {
          type: "object",
          required: ["title", "coverImageUrl", "createdBy"],
          properties: {
            _id: { type: "string" },
            title: { type: "string" },
            coverImageUrl: { type: "string" },
            description: { type: "string" },
            isPremium: { type: "boolean", default: true },
            totalPages: { type: "integer", default: 0 },
            createdBy: { type: "string" },
            pages: {
              type: "array",
              items: {
                type: "object",
                required: ["pageNumber", "title", "imageUrl", "audioUrl", "content"],
                properties: {
                  pageNumber: { type: "integer" },
                  title: { type: "string" },
                  imageUrl: { type: "string" },
                  audioUrl: { type: "string" },
                  content: { type: "string" },
                },
              },
            },
            createdAt: { type: "string", format: "date-time" },
            updatedAt: { type: "string", format: "date-time" },
          },
        },

        Subscription: {
          type: "object",
          required: ["user", "plan", "price", "endDate"],
          properties: {
            _id: { type: "string" },
            user: { type: "string" },
            plan: { type: "string", enum: ["monthly", "yearly"] },
            price: { type: "number", minimum: 0 },
            status: {
              type: "string",
              enum: ["active", "inactive", "cancelled"],
              default: "active",
            },
            startDate: { type: "string", format: "date-time" },
            endDate: { type: "string", format: "date-time" },
            createdAt: { type: "string", format: "date-time" },
            updatedAt: { type: "string", format: "date-time" },
          },
        },

        Payment: {
          type: "object",
          required: ["userId", "amount", "subscription", "paymentMethod"],
          properties: {
            _id: { type: "string" },
            userId: { type: "string" },
            amount: { type: "number", minimum: 0 },
            subscription: { type: "string" },
            status: {
              type: "string",
              enum: ["pending", "completed", "failed"],
              default: "pending",
            },
            paymentMethod: {
              type: "string",
              enum: ["telebirr", "credit_card", "paypal"],
            },
            transactionId: { type: "string" },
            createdAt: { type: "string", format: "date-time" },
            updatedAt: { type: "string", format: "date-time" },
          },
        },

        AuditLog: {
          type: "object",
          required: ["action"],
          properties: {
            _id: { type: "string" },
            user: { type: "string" },
            action: { type: "string" },
            targetModel: { type: "string" },
            targetId: { type: "string" },
            ipAddress: { type: "string" },
            createdAt: { type: "string", format: "date-time" },
            updatedAt: { type: "string", format: "date-time" },
          },
        },
      },
    },
  },
  apis: ["./routes/*.js"],
};

const specs = swaggerJsdoc(swaggerOptions);
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(specs));

app.use("/api/v1", apiRoutes);

app.get("/health", (req, res) => {
  res.status(200).json({ status: "ok", message: "Server is healthy" });
});

app.use(notFound);
app.use(errorHandler);

const PORT = process.env.PORT || 5000;

if (process.env.NODE_ENV !== "test") {
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}

export default app;
