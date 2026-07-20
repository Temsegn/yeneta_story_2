import mongoose from "mongoose";

const childProfileSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  birthdate: {
    type: Date,
    required: true,
  },
});

const userSchema = new mongoose.Schema(
  {
    fullName: {
      type: String,
      required: true,
      trim: true,
      index: true,
    },
    email: {
      type: String,
      required: false,
      lowercase: true,
      trim: true,
      // Unique only when a real email is present — blank/null must not collide.
      // See partial index below (sparse unique still indexes null and causes E11000).
    },
    phoneNumber: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      index: true,
    },
    password: {
      type: String,
      required: true,
      minlength: 6,
    },
    securityQuestion: {
      type: String,
      trim: true,
      default: null,
    },
    securityAnswerHash: {
      type: String,
      select: false,
      default: null,
    },
    role: {
      type: String,
      enum: ["parent", "admin", "finance", "content_manager"],
      default: "parent",
      index: true,
    },
    childProfiles: [childProfileSchema],
    isActive: {
      type: Boolean,
      default: true,
    },
    trialStartDate: {
      type: Date,
      default: Date.now,
    },
    trialEndDate: {
      type: Date,
      default: function () {
        const date = new Date();
        date.setDate(date.getDate() + 5); // 5-day trial
        return date;
      },
    },
    hasActiveSubscription: {
      type: Boolean,
      default: false,
    },
    subscriptionEndDate: {
      type: Date,
      default: null,
    },
    isPremium: {
      type: Boolean,
      default: false,
    },
    premiumExpiresAt: {
      type: Date,
      default: null,
    },
    currentPlan: {
      type: String,
      enum: [
        "trial",
        "monthly",
        "yearly",
        "semiannual",
        "premium_monthly",
        "premium_yearly",
      ],
      default: "trial",
    },
    deviceTokens: [
      {
        token: { type: String, required: true },
        platform: {
          type: String,
          enum: ["android", "ios", "web", "other"],
          default: "other",
        },
        updatedAt: { type: Date, default: Date.now },
      },
    ],
  },
  { timestamps: true }
);

userSchema.index(
  { email: 1 },
  {
    unique: true,
    name: "email_unique_nonempty",
    partialFilterExpression: {
      email: { $exists: true, $type: "string", $gt: "" },
    },
  }
);

userSchema.methods.toJSON = function () {
  const obj = this.toObject();
  delete obj.password;
  delete obj.securityAnswerHash;
  return obj;
};

const User = mongoose.model("User", userSchema);
export default User;
