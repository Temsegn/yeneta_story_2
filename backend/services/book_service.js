import Book from "../models/book_models.js";
import AuditLog from "../models/auditlog_models.js";

export async function createBookService(data, userId, ipAddress = null) {
  const book = await Book.create({
    ...data,
    createdBy: userId,
  });

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

export async function getAllBooksService({
  page = 1,
  limit = 10,
  search = "",
  includeHidden = false,
} = {}) {
  const skip = (page - 1) * limit;
  const filter = {};
  if (!includeHidden) filter.isVisible = true;
  if (search) filter.title = { $regex: search, $options: "i" };

  const [books, total] = await Promise.all([
    Book.find(filter)
      .select("-pages")
      .populate("createdBy", "fullName email")
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(Number(limit)),
    Book.countDocuments(filter),
  ]);

  return {
    page: Number(page),
    limit: Number(limit),
    total,
    totalPages: Math.ceil(total / limit) || 1,
    books,
  };
}

export async function getBookByIdService(id) {
  const book = await Book.findById(id).populate("createdBy", "fullName email");
  if (!book) throw new Error("Book not found");
  return book;
}

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
