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
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
      index: true,
    },
    phoneNumber: {
      type: String,
      required: true,
    },
    password: {
      type: String,
      required: true,
      minlength: 6,
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
      default: function() {
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
    // Desired premium flags (kept alongside legacy fields for compatibility).
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
  return obj;
};

const User = mongoose.model("User", userSchema);
export default User;