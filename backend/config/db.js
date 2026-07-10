import mongoose from "mongoose";

const connectDB = async () => {
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
      if (process.env.NODE_ENV !== "test") console.error(" Mongoose error:", err.message);
    });

    mongoose.connection.on("disconnected", () => {
      if (process.env.NODE_ENV !== "test") console.warn(" Mongoose disconnected");
    });

  } catch (error) {
    console.error(" MongoDB connection failed:", error.message);
    process.exit(1);
  }
};

export default connectDB;