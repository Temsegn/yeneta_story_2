import mongoose from "mongoose";

// Schema for individual book pages
const bookPageSchema = new mongoose.Schema({
  pageNumber: {
    type: Number,
    required: true
  },
  title: String,
  content: {
    type: String,
    required: true
  },
  imageUrl: {
    type: String,
    required: true
  }
});

// Main book schema
const bookSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
      trim: true,
      index: true
    },
    coverImageUrl: {
      type: String,
      required: true
    },
    description: String,
    isPremium: {
      type: Boolean,
      default: true,
      index: true
    },
    totalPages: {
      type: Number,
      default: 0
    },
    pages: [bookPageSchema],
    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true
    }
  },
  { timestamps: true }
);

// Pre-save hook to calculate totalPages automatically
bookSchema.pre("save", function () {
  this.totalPages = this.pages.length;
});

// Create the model
const Book = mongoose.model("Book", bookSchema);

export default Book;
