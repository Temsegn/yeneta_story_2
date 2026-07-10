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
      unique: true,
      sparse: true,
      lowercase: true,
      trim: true,
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
      enum: ["parent", "admin"],
      default: "parent",
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
  },
  { timestamps: true }
);

userSchema.methods.toJSON = function () {
  const obj = this.toObject();
  delete obj.password;
  delete obj.securityAnswerHash;
  return obj;
};

const User = mongoose.model("User", userSchema);
export default User;
