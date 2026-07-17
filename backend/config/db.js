import mongoose from "mongoose";

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

const connectDB = async (attempt = 1) => {
  const maxAttempts = Number(process.env.MONGO_CONNECT_RETRIES) || 8;
  const retryDelayMs = Number(process.env.MONGO_CONNECT_RETRY_MS) || 3000;

  try {
    const conn = await mongoose.connect(process.env.MONGO_URI, {
      maxPoolSize: Number(process.env.MONGO_MAX_POOL) || 10,
      minPoolSize: Number(process.env.MONGO_MIN_POOL) || 2,
      serverSelectionTimeoutMS: 5000,
      socketTimeoutMS: 45000,
      autoIndex: process.env.NODE_ENV !== "production",
    });

    if (process.env.NODE_ENV !== "test") {
      console.log(`MongoDB Connected: ${conn.connection.host}`);
    }

    mongoose.connection.on("connected", () => {
      if (process.env.NODE_ENV !== "test") console.log(" Mongoose connected");
    });

    mongoose.connection.on("error", (err) => {
      if (process.env.NODE_ENV !== "test") {
        console.error(" Mongoose error:", err.message);
      }
    });

    mongoose.connection.on("disconnected", () => {
      if (process.env.NODE_ENV !== "test") {
        console.warn(" Mongoose disconnected");
      }
    });
  } catch (error) {
    console.error(
      ` MongoDB connection failed (attempt ${attempt}/${maxAttempts}):`,
      error.message
    );

    if (attempt < maxAttempts) {
      await sleep(retryDelayMs);
      return connectDB(attempt + 1);
    }

    // Keep the HTTP process alive in production so Render health checks can
    // still respond while ops fix Atlas/network; crash only in local/dev.
    if (process.env.NODE_ENV === "production") {
      console.error(
        " MongoDB unavailable after retries. API will stay up but DB routes will fail until Mongo reconnects."
      );
      setTimeout(() => {
        connectDB(1).catch(() => {});
      }, retryDelayMs * 5);
      return;
    }

    process.exit(1);
  }
};

export default connectDB;
