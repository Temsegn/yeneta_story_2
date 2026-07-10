import mongoose from "mongoose";

const auditLogSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User", 
      index: true,  
    },
    action: {
      type: String,
      required: true,
      trim: true,
      index: true,  
    },
    targetModel: {
      type: String, 
      trim: true,
      index: true,
    },
    targetId: {
      type: mongoose.Schema.Types.ObjectId,
      index: true,
    },
    ipAddress: {
      type: String,
    },
  },
  { timestamps: true }
);
const auditLog= mongoose.model("auditLog", auditLogSchema);
export default auditLog;
