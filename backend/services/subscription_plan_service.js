import SubscriptionPlan from "../models/subscription_plan_models.js";
import Subscription from "../models/subscription_models.js";

export async function listPlansService({ includeHidden = true } = {}) {
  const filter = includeHidden ? {} : { isVisible: true };
  const plans = await SubscriptionPlan.find(filter).sort({
    sortOrder: 1,
    createdAt: -1,
  });
  return { plans, total: plans.length };
}

export async function getVisiblePlansMap() {
  const plans = await SubscriptionPlan.find({ isVisible: true });
  const map = {};
  for (const plan of plans) {
    map[plan.key] = {
      id: plan.key,
      name: plan.name,
      price: plan.price,
      durationDays: plan.durationInDays,
      description: plan.description,
    };
  }
  return map;
}

export async function getPlanByIdService(id) {
  const plan = await SubscriptionPlan.findById(id);
  if (!plan) {
    const err = new Error("Plan not found");
    err.statusCode = 404;
    throw err;
  }
  return plan;
}

export async function createPlanService(data) {
  const { key, name, description, price, durationInDays, isVisible, sortOrder } =
    data;
  if (!key || !name || price == null || !durationInDays) {
    throw new Error("key, name, price, and durationInDays are required");
  }
  const existing = await SubscriptionPlan.findOne({ key });
  if (existing) throw new Error("A plan with this key already exists");

  return SubscriptionPlan.create({
    key,
    name,
    description: description || "",
    price: Number(price),
    durationInDays: Number(durationInDays),
    isVisible: isVisible !== false,
    sortOrder: Number(sortOrder) || 0,
  });
}

export async function updatePlanService(id, data) {
  const plan = await SubscriptionPlan.findById(id);
  if (!plan) {
    const err = new Error("Plan not found");
    err.statusCode = 404;
    throw err;
  }

  if (data.name != null) plan.name = data.name;
  if (data.description !== undefined) plan.description = data.description;
  if (data.price != null) plan.price = Number(data.price);
  if (data.durationInDays != null) {
    plan.durationInDays = Number(data.durationInDays);
  }
  if (typeof data.isVisible === "boolean") plan.isVisible = data.isVisible;
  if (data.sortOrder != null) plan.sortOrder = Number(data.sortOrder);

  await plan.save();
  return plan;
}

export async function deletePlanService(id) {
  const plan = await SubscriptionPlan.findById(id);
  if (!plan) {
    const err = new Error("Plan not found");
    err.statusCode = 404;
    throw err;
  }

  const activeCount = await Subscription.countDocuments({
    plan: plan.key,
    status: "active",
  });
  if (activeCount > 0) {
    const err = new Error(
      `Cannot delete plan while ${activeCount} active subscriber(s) remain. Deactivate (hide) the plan instead.`
    );
    err.statusCode = 400;
    throw err;
  }

  await plan.deleteOne();
  return plan;
}
