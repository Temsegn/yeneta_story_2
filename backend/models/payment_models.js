import mongoose from "mongoose";
const paymentSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
        index: true
    },
    amount: {
        type: Number,
        required: true,
        min: 0
    },
    subscription:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "Subscription",
        required: false,
        index: true
    },
    status: {
        type: String,
        enum: ["pending", "completed", "failed"],
        default: "pending",
        index: true
    },
    paymentMethod: {
        type: String,
        enum: ["telebirr", "credit_card", "paypal", "chapa"],
        required: true
    },
    transactionId: {
        type: String,
        unique: true,
        sparse: true
    },
    chapaReference: {
        type: String,
        sparse: true
    },
    txRef: {
        type: String,
        unique: true,
        sparse: true
    },
}, { timestamps: true });
const Payment = mongoose.model("Payment", paymentSchema);
export default Payment;