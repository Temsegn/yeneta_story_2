import {
  createBookService,
  getAllBooksService,
  getBookByIdService,
  updateBookService,
  deleteBookService,
} from "../services/book_service.js";
import { logAction } from "../utils/auditLogger.js";
import { isInternalRole } from "../middlewares/role_middlewares.js";
import { notifyContentReleasedSafe } from "../services/notification_service.js";

export const createBook = async (req, res) => {
  try {
    const book = await createBookService(req.body, req.user._id);
    res.status(201).json(book);

    await logAction({
      user: req.user._id,
      action: "CREATE_BOOK",
      targetModel: "Book",
      targetId: book._id,
      ipAddress: req.ip,
    });

    if (book.isVisible !== false) {
      notifyContentReleasedSafe(book.title, "Book", "/books");
    }
  } catch (err) {
    res.status(500).json({ message: "Failed to create book", error: err.message });
  }
};

export const getAllBooks = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const search = req.query.search || "";
    const includeHidden =
      req.query.includeHidden === "true" &&
      req.user &&
      isInternalRole(req.user.role);

    const books = await getAllBooksService({
      page,
      limit,
      search,
      includeHidden,
    });
    res.status(200).json(books);
  } catch (err) {
    res.status(500).json({ message: "Failed to get books", error: err.message });
  }
};

export const getBookById = async (req, res) => {
  try {
    const book = await getBookByIdService(req.params.id);
    res.status(200).json(book);
  } catch (err) {
    res.status(404).json({ message: err.message });
  }
};

export const updateBook = async (req, res) => {
  try {
    const previous = await getBookByIdService(req.params.id);
    const wasHidden = previous.isVisible === false;
    const book = await updateBookService(req.params.id, req.body);
    res.status(200).json(book);

    await logAction({
      user: req.user._id,
      action: "UPDATE_BOOK",
      targetModel: "Book",
      targetId: req.params.id,
      ipAddress: req.ip,
    });

    if (wasHidden && book.isVisible !== false) {
      notifyContentReleasedSafe(book.title, "Book", "/books");
    }
  } catch (err) {
    res.status(404).json({ message: err.message });
  }
};

export const deleteBook = async (req, res) => {
  try {
    await deleteBookService(req.params.id);
    res.status(200).json({ message: "Book deleted" });

    await logAction({
      user: req.user._id,
      action: "DELETE_BOOK",
      targetModel: "Book",
      targetId: req.params.id,
      ipAddress: req.ip,
    });
  } catch (err) {
    res.status(404).json({ message: err.message });
  }
};