import Book from "../models/book_models.js";
import AuditLog from "../models/auditlog_models.js";

export async function createBookService(data, userId, ipAddress = null) {
  const book = await Book.create({
    ...data,
    createdBy: userId,
  });

  // Log creation
  if (ipAddress) {
    await AuditLog.create({
      user: userId,
      action: "CREATE",
      targetModel: "Book",
      targetId: book._id,
      ipAddress,
    });
  }

  return book;
}

export async function getAllBooksService({ page = 1, limit = 10, search = "" } = {}) {
  const skip = (page - 1) * limit;
  const filter = search
    ? { title: { $regex: search, $options: "i" } }
    : {};

  const [books, total] = await Promise.all([
    Book.find(filter)
      .select("-pages") // omit pages for list
      .populate("createdBy", "fullName email")
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(Number(limit)),
    Book.countDocuments(filter),
  ]);

  return {
    page,
    limit: Number(limit),
    total,
    totalPages: Math.ceil(total / limit),
    books,
  };
}

// Get book by ID
export async function getBookByIdService(id) {
  const book = await Book.findById(id).populate("createdBy", "fullName email");
  if (!book) throw new Error("Book not found");
  return book;
}

// Update a book
export async function updateBookService(id, data, userId = null, ipAddress = null) {
  const book = await Book.findByIdAndUpdate(id, data, { new: true });
  if (!book) throw new Error("Book not found");

  if (userId && ipAddress) {
    await AuditLog.create({
      user: userId,
      action: "UPDATE",
      targetModel: "Book",
      targetId: book._id,
      ipAddress,
    });
  }

  return book;
}

// Delete a book
export async function deleteBookService(id, userId = null, ipAddress = null) {
  const book = await Book.findByIdAndDelete(id);
  if (!book) throw new Error("Book not found");

  if (userId && ipAddress) {
    await AuditLog.create({
      user: userId,
      action: "DELETE",
      targetModel: "Book",
      targetId: book._id,
      ipAddress,
    });
  }

  return book;
}