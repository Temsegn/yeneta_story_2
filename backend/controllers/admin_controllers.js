import fs from "fs";
import {
  getAdminStatsService,
  listUsersService,
  getUserByIdService,
  createUserService,
  updateUserService,
  deleteUserService,
  listSubscriptionsService,
  getSubscriptionByIdService,
  createSubscriptionService,
  updateSubscriptionService,
  deleteSubscriptionService,
  listPaymentsService,
  getPaymentByIdService,
} from "../services/admin_service.js";
import {
  listPlansService,
  getPlanByIdService,
  createPlanService,
  updatePlanService,
  deletePlanService,
} from "../services/subscription_plan_service.js";
import { uploadToCloudinary } from "../config/cloudinary.js";
import { logAction } from "../utils/auditLogger.js";

const friendlyDbError = (err) => {
  if (err?.code === 11000) {
    const field = Object.keys(err.keyPattern || err.keyValue || {})[0] || "field";
    if (field === "email") return "Email already registered";
    if (field === "phoneNumber") return "Phone number already registered";
    return `Duplicate ${field}`;
  }
  return err.message || "Request failed";
};

const handle = (fn) => async (req, res) => {
  try {
    await fn(req, res);
  } catch (err) {
    const status = err.code === 11000 ? 409 : err.statusCode || 400;
    res.status(status).json({ message: friendlyDbError(err) });
  }
};

export const getAdminStats = handle(async (req, res) => {
  const stats = await getAdminStatsService();
  res.status(200).json(stats);
});

export const listUsers = handle(async (req, res) => {
  const data = await listUsersService(req.query);
  res.status(200).json(data);
});

export const getUser = handle(async (req, res) => {
  const data = await getUserByIdService(req.params.id);
  res.status(200).json(data);
});

export const createUser = handle(async (req, res) => {
  const user = await createUserService(req.body);
  res.status(201).json(user);
  await logAction({
    user: req.user._id,
    action: "CREATE_USER",
    targetModel: "User",
    targetId: user._id,
    ipAddress: req.ip,
  });
});

export const updateUser = handle(async (req, res) => {
  if (req.body.role === "admin" && req.user.role !== "admin") {
    return res.status(403).json({ message: "Only admins can grant admin role" });
  }
  const user = await updateUserService(req.params.id, req.body);
  res.status(200).json(user);
  await logAction({
    user: req.user._id,
    action: "UPDATE_USER",
    targetModel: "User",
    targetId: user._id,
    ipAddress: req.ip,
  });
});

export const deleteUser = handle(async (req, res) => {
  if (req.user.role !== "admin") {
    return res.status(403).json({ message: "Only admins can deactivate users" });
  }
  const user = await deleteUserService(req.params.id);
  res.status(200).json({ message: "User deactivated", user });
  await logAction({
    user: req.user._id,
    action: "DEACTIVATE_USER",
    targetModel: "User",
    targetId: user._id,
    ipAddress: req.ip,
  });
});

export const listSubscriptions = handle(async (req, res) => {
  const data = await listSubscriptionsService(req.query);
  res.status(200).json(data);
});

export const getSubscription = handle(async (req, res) => {
  const subscription = await getSubscriptionByIdService(req.params.id);
  res.status(200).json(subscription);
});

export const createSubscription = handle(async (req, res) => {
  const subscription = await createSubscriptionService(req.body);
  res.status(201).json(subscription);
  await logAction({
    user: req.user._id,
    action: "CREATE_SUBSCRIPTION",
    targetModel: "Subscription",
    targetId: subscription._id,
    ipAddress: req.ip,
  });
});

export const updateSubscription = handle(async (req, res) => {
  const subscription = await updateSubscriptionService(req.params.id, req.body);
  res.status(200).json(subscription);
  await logAction({
    user: req.user._id,
    action: "UPDATE_SUBSCRIPTION",
    targetModel: "Subscription",
    targetId: subscription._id,
    ipAddress: req.ip,
  });
});

export const deleteSubscription = handle(async (req, res) => {
  const subscription = await deleteSubscriptionService(req.params.id);
  res.status(200).json({ message: "Subscription deleted", subscription });
  await logAction({
    user: req.user._id,
    action: "DELETE_SUBSCRIPTION",
    targetModel: "Subscription",
    targetId: subscription._id,
    ipAddress: req.ip,
  });
});

export const listPayments = handle(async (req, res) => {
  const data = await listPaymentsService(req.query);
  res.status(200).json(data);
});

export const getPayment = handle(async (req, res) => {
  const payment = await getPaymentByIdService(req.params.id);
  res.status(200).json(payment);
});

export const listPlans = handle(async (req, res) => {
  const data = await listPlansService(req.query);
  res.status(200).json(data);
});

export const getPlan = handle(async (req, res) => {
  const plan = await getPlanByIdService(req.params.id);
  res.status(200).json(plan);
});

export const createPlan = handle(async (req, res) => {
  const plan = await createPlanService(req.body);
  res.status(201).json(plan);
  await logAction({
    user: req.user._id,
    action: "CREATE_PLAN",
    targetModel: "SubscriptionPlan",
    targetId: plan._id,
    ipAddress: req.ip,
  });
});

export const updatePlan = handle(async (req, res) => {
  const plan = await updatePlanService(req.params.id, req.body);
  res.status(200).json(plan);
  await logAction({
    user: req.user._id,
    action: "UPDATE_PLAN",
    targetModel: "SubscriptionPlan",
    targetId: plan._id,
    ipAddress: req.ip,
  });
});

export const deletePlan = handle(async (req, res) => {
  await deletePlanService(req.params.id);
  res.status(200).json({ message: "Plan deleted" });
  await logAction({
    user: req.user._id,
    action: "DELETE_PLAN",
    targetModel: "SubscriptionPlan",
    targetId: req.params.id,
    ipAddress: req.ip,
  });
});

export const uploadFile = handle(async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ message: "No file uploaded" });
  }

  const localPath = req.file.path;

  try {
    const uploaded = await uploadToCloudinary(localPath, {
      mimetype: req.file.mimetype,
      originalname: req.file.originalname,
    });

    const url = uploaded.delivery_url || uploaded.secure_url;

    res.status(201).json({
      url,
      posterUrl: uploaded.poster_url || null,
      filename: uploaded.original_filename || req.file.originalname,
      publicId: uploaded.public_id,
      resourceType: uploaded.resource_type,
      kind: uploaded.kind,
      mimetype: req.file.mimetype,
      size: req.file.size,
      bytes: uploaded.bytes || req.file.size,
      width: uploaded.width || null,
      height: uploaded.height || null,
      duration: uploaded.duration_label || null,
      durationSeconds: uploaded.duration || null,
      format: uploaded.format || null,
    });

    await logAction({
      user: req.user._id,
      action: "UPLOAD_FILE",
      targetModel: "Upload",
      targetId: uploaded.public_id,
      ipAddress: req.ip,
    });
  } finally {
    if (localPath) {
      fs.unlink(localPath, () => {});
    }
  }
});
