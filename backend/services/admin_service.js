import bcrypt from "bcryptjs";
import User from "../models/user_model.js";
import Subscription from "../models/subscription_models.js";
import Payment from "../models/payment_models.js";
import Video from "../models/video_models.js";
import Story from "../models/story_models.js";
import Book from "../models/book_models.js";
import { assertEthiopianPhone } from "../utils/phoneNormalizer.js";

const escapeRegex = (value = "") =>
  value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

export async function getAdminStatsService() {
  const [
    users,
    admins,
    videos,
    stories,
    books,
    activeSubs,
    payments,
    revenue,
  ] = await Promise.all([
    User.countDocuments(),
    User.countDocuments({ role: "admin" }),
    Video.countDocuments(),
    Story.countDocuments(),
    Book.countDocuments(),
    Subscription.countDocuments({ status: "active" }),
    Payment.countDocuments(),
    Payment.aggregate([
      { $match: { status: "completed" } },
      { $group: { _id: null, total: { $sum: "$amount" } } },
    ]),
  ]);

  return {
    users,
    admins,
    videos,
    stories,
    books,
    activeSubscriptions: activeSubs,
    payments,
    revenue: revenue[0]?.total || 0,
  };
}

export async function listUsersService({
  page = 1,
  limit = 20,
  search = "",
  role,
  userType,
  isActive,
} = {}) {
  const filter = {};
  if (search) {
    const q = escapeRegex(search);
    filter.$or = [
      { fullName: { $regex: q, $options: "i" } },
      { email: { $regex: q, $options: "i" } },
      { phoneNumber: { $regex: q, $options: "i" } },
    ];
  }
  if (role) filter.role = role;
  if (userType === "external") filter.role = "parent";
  if (userType === "internal") {
    filter.role = { $in: ["admin", "finance", "content_manager"] };
  }
  if (isActive === "true" || isActive === true) filter.isActive = true;
  if (isActive === "false" || isActive === false) filter.isActive = false;

  const skip = (page - 1) * limit;
  const [users, total] = await Promise.all([
    User.find(filter)
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(Number(limit)),
    User.countDocuments(filter),
  ]);

  return {
    page: Number(page),
    limit: Number(limit),
    total,
    totalPages: Math.ceil(total / limit) || 1,
    users,
  };
}

export async function getUserByIdService(id) {
  const user = await User.findById(id);
  if (!user) throw new Error("User not found");

  const [subscriptions, payments] = await Promise.all([
    Subscription.find({ user: id }).sort({ createdAt: -1 }).limit(20),
    Payment.find({ userId: id })
      .populate("subscription")
      .sort({ createdAt: -1 })
      .limit(20),
  ]);

  return { user, subscriptions, payments };
}

export async function createUserService(data) {
  const {
    fullName,
    phoneNumber,
    password,
    email,
    role = "parent",
    isActive = true,
    securityQuestion,
  } = data;

  if (!fullName || !phoneNumber || !password) {
    throw new Error("fullName, phoneNumber, and password are required");
  }

  const normalizedPhone = assertEthiopianPhone(phoneNumber);
  const existing = await User.findOne({ phoneNumber: normalizedPhone });
  if (existing) throw new Error("Phone number already registered");

  const normalizedEmail =
    email && String(email).trim() ? String(email).trim().toLowerCase() : null;
  if (normalizedEmail) {
    const emailTaken = await User.findOne({ email: normalizedEmail });
    if (emailTaken) throw new Error("Email already registered");
  }

  const allowedRoles = ["parent", "admin", "finance", "content_manager"];
  const safeRole = allowedRoles.includes(role) ? role : "parent";

  const hashed = await bcrypt.hash(password, 10);
  const payload = {
    fullName,
    phoneNumber: normalizedPhone,
    password: hashed,
    role: safeRole,
    isActive,
    childProfiles: [],
    securityQuestion: securityQuestion || null,
  };
  // Omit email entirely when blank so unique index never sees null/"".
  if (normalizedEmail) payload.email = normalizedEmail;

  return User.create(payload);
}

export async function updateUserService(id, data) {
  const user = await User.findById(id);
  if (!user) throw new Error("User not found");

  if (data.fullName != null) user.fullName = data.fullName;
  let clearEmail = false;
  if (data.email !== undefined) {
    const normalizedEmail =
      data.email && String(data.email).trim()
        ? String(data.email).trim().toLowerCase()
        : null;
    if (normalizedEmail) {
      const emailTaken = await User.findOne({
        email: normalizedEmail,
        _id: { $ne: user._id },
      });
      if (emailTaken) throw new Error("Email already registered");
      user.email = normalizedEmail;
    } else {
      clearEmail = true;
    }
  }
  if (data.phoneNumber) {
    user.phoneNumber = assertEthiopianPhone(data.phoneNumber);
  }
  if (
    data.role === "admin" ||
    data.role === "parent" ||
    data.role === "finance" ||
    data.role === "content_manager"
  ) {
    user.role = data.role;
  }
  if (data.securityQuestion !== undefined) {
    user.securityQuestion = data.securityQuestion || null;
  }
  if (typeof data.isActive === "boolean") user.isActive = data.isActive;
  if (typeof data.isPremium === "boolean") user.isPremium = data.isPremium;
  if (data.currentPlan != null) user.currentPlan = data.currentPlan;
  if (data.premiumExpiresAt !== undefined) {
    user.premiumExpiresAt = data.premiumExpiresAt
      ? new Date(data.premiumExpiresAt)
      : null;
  }
  if (data.subscriptionEndDate !== undefined) {
    user.subscriptionEndDate = data.subscriptionEndDate
      ? new Date(data.subscriptionEndDate)
      : null;
  }
  if (typeof data.hasActiveSubscription === "boolean") {
    user.hasActiveSubscription = data.hasActiveSubscription;
  }
  if (data.password) {
    user.password = await bcrypt.hash(data.password, 10);
  }

  await user.save();
  if (clearEmail) {
    await User.updateOne({ _id: user._id }, { $unset: { email: 1 } });
    return User.findById(user._id);
  }
  return user;
}

export async function deleteUserService(id) {
  const user = await User.findById(id);
  if (!user) throw new Error("User not found");
  if (user.role === "admin") {
    const adminCount = await User.countDocuments({ role: "admin", isActive: true });
    if (adminCount <= 1) {
      throw new Error("Cannot delete the last active admin");
    }
  }
  user.isActive = false;
  await user.save();
  return user;
}

export async function listSubscriptionsService({
  page = 1,
  limit = 20,
  status,
  search = "",
} = {}) {
  const filter = {};
  if (status) filter.status = status;

  if (search) {
    const users = await User.find({
      $or: [
        { fullName: { $regex: escapeRegex(search), $options: "i" } },
        { phoneNumber: { $regex: escapeRegex(search), $options: "i" } },
        { email: { $regex: escapeRegex(search), $options: "i" } },
      ],
    }).select("_id");
    filter.user = { $in: users.map((u) => u._id) };
  }

  const skip = (page - 1) * limit;
  const [subscriptions, total] = await Promise.all([
    Subscription.find(filter)
      .populate("user", "fullName email phoneNumber role")
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(Number(limit)),
    Subscription.countDocuments(filter),
  ]);

  return {
    page: Number(page),
    limit: Number(limit),
    total,
    totalPages: Math.ceil(total / limit) || 1,
    subscriptions,
  };
}

export async function getSubscriptionByIdService(id) {
  const subscription = await Subscription.findById(id).populate(
    "user",
    "fullName email phoneNumber role isPremium currentPlan"
  );
  if (!subscription) throw new Error("Subscription not found");
  return subscription;
}

export async function createSubscriptionService(data) {
  const {
    userId,
    plan,
    price,
    status = "active",
    startDate,
    endDate,
    durationInDays,
  } = data;

  if (!userId || !plan || price == null) {
    throw new Error("userId, plan, and price are required");
  }

  const user = await User.findById(userId);
  if (!user) throw new Error("User not found");

  const start = startDate ? new Date(startDate) : new Date();
  let end = endDate ? new Date(endDate) : null;
  if (!end && durationInDays) {
    end = new Date(start);
    end.setDate(end.getDate() + Number(durationInDays));
  }

  const subscription = await Subscription.create({
    user: userId,
    plan,
    price: Number(price),
    status,
    startDate: start,
    endDate: end,
    txRef: data.txRef || `admin-${Date.now()}`,
  });

  if (status === "active") {
    user.hasActiveSubscription = true;
    user.isPremium = true;
    user.currentPlan = plan;
    user.subscriptionEndDate = end;
    user.premiumExpiresAt = end;
    await user.save();
  }

  return subscription.populate("user", "fullName email phoneNumber");
}

export async function updateSubscriptionService(id, data) {
  const subscription = await Subscription.findById(id);
  if (!subscription) throw new Error("Subscription not found");

  if (data.plan != null) subscription.plan = data.plan;
  if (data.price != null) subscription.price = Number(data.price);
  if (data.status != null) subscription.status = data.status;
  if (data.startDate !== undefined) {
    subscription.startDate = data.startDate ? new Date(data.startDate) : null;
  }
  if (data.endDate !== undefined) {
    subscription.endDate = data.endDate ? new Date(data.endDate) : null;
  }

  await subscription.save();

  if (
    data.status === "active" ||
    data.status === "cancelled" ||
    data.status === "expired" ||
    data.status === "inactive"
  ) {
    const user = await User.findById(subscription.user);
    if (user) {
      const active = data.status === "active";
      user.hasActiveSubscription = active;
      user.isPremium = active;
      if (active) {
        user.currentPlan = subscription.plan;
        user.subscriptionEndDate = subscription.endDate;
        user.premiumExpiresAt = subscription.endDate;
      }
      await user.save();
    }
  }

  return subscription.populate("user", "fullName email phoneNumber");
}

export async function deleteSubscriptionService(id) {
  const subscription = await Subscription.findById(id);
  if (!subscription) throw new Error("Subscription not found");

  if (subscription.status === "active") {
    const err = new Error(
      "Cannot delete an active subscription. Deactivate or cancel it first."
    );
    err.statusCode = 400;
    throw err;
  }

  await subscription.deleteOne();

  const user = await User.findById(subscription.user);
  if (user) {
    const stillActive = await Subscription.exists({
      user: user._id,
      status: "active",
    });
    if (!stillActive) {
      user.hasActiveSubscription = false;
      user.isPremium = false;
      await user.save();
    }
  }

  return subscription;
}

export async function listPaymentsService({
  page = 1,
  limit = 20,
  status,
  search = "",
} = {}) {
  const filter = {};
  if (status) filter.status = status;

  if (search) {
    const users = await User.find({
      $or: [
        { fullName: { $regex: escapeRegex(search), $options: "i" } },
        { phoneNumber: { $regex: escapeRegex(search), $options: "i" } },
      ],
    }).select("_id");
    filter.$or = [
      { userId: { $in: users.map((u) => u._id) } },
      { txRef: { $regex: escapeRegex(search), $options: "i" } },
      { transactionId: { $regex: escapeRegex(search), $options: "i" } },
      { chapaReference: { $regex: escapeRegex(search), $options: "i" } },
    ];
  }

  const skip = (page - 1) * limit;
  const [payments, total] = await Promise.all([
    Payment.find(filter)
      .populate("userId", "fullName email phoneNumber")
      .populate("subscription")
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(Number(limit)),
    Payment.countDocuments(filter),
  ]);

  return {
    page: Number(page),
    limit: Number(limit),
    total,
    totalPages: Math.ceil(total / limit) || 1,
    payments,
  };
}

export async function getPaymentByIdService(id) {
  const payment = await Payment.findById(id)
    .populate("userId", "fullName email phoneNumber role")
    .populate("subscription");
  if (!payment) throw new Error("Payment not found");
  return payment;
}
