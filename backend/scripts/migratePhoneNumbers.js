/**
 * One-time migration: normalize phone numbers to +2519XXXXXXXX
 * and report duplicates before unique index enforcement.
 *
 * Usage (from backend/):
 *   node scripts/migratePhoneNumbers.js
 *
 * Requires MONGODB_URI in env (.env or Render shell).
 */
import "dotenv/config";
import mongoose from "mongoose";
import User from "../models/user_model.js";
import { normalizeEthiopianPhone } from "../utils/phoneNormalizer.js";

async function migrate() {
  const uri = process.env.MONGODB_URI || process.env.MONGO_URI;
  if (!uri) {
    console.error("Missing MONGODB_URI");
    process.exit(1);
  }

  await mongoose.connect(uri);
  console.log("Connected.");

  const users = await User.find({}).select("+securityAnswerHash");
  const byPhone = new Map();
  let updated = 0;
  let invalid = 0;
  let skipped = 0;

  for (const user of users) {
    const normalized = normalizeEthiopianPhone(user.phoneNumber || "");
    if (!normalized) {
      invalid += 1;
      console.warn(`INVALID phone for user ${user._id}: ${user.phoneNumber}`);
      continue;
    }

    if (user.phoneNumber === normalized) {
      skipped += 1;
    } else {
      user.phoneNumber = normalized;
      await user.save();
      updated += 1;
      console.log(`Updated ${user._id} -> ${normalized}`);
    }

    const list = byPhone.get(normalized) || [];
    list.push(String(user._id));
    byPhone.set(normalized, list);
  }

  const duplicates = [...byPhone.entries()].filter(([, ids]) => ids.length > 1);
  if (duplicates.length) {
    console.warn("\nDUPLICATE phones (resolve before unique index):");
    for (const [phone, ids] of duplicates) {
      console.warn(`  ${phone}: ${ids.join(", ")}`);
    }
  } else {
    console.log("\nNo duplicate phones after normalization.");
  }

  console.log(
    `\nDone. updated=${updated} skipped=${skipped} invalid=${invalid} total=${users.length}`
  );
  await mongoose.disconnect();
}

migrate().catch((err) => {
  console.error(err);
  process.exit(1);
});
