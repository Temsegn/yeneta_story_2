import { createPaymentService, verifyPaymentService } from "../services/payment_service.js";
export const createPayment = async (req, res) => {
  try {
    // Pass IP address for audit logging
    const result = await createPaymentService(req.user._id, req.body, req.ip);

    res.status(201).json({
      message: "Payment successful & subscription activated",
      payment: result.payment,
      subscription: result.subscription,
    });
  } catch (error) {
    console.error(error);
    res.status(400).json({
      message: error.message || "Payment creation failed",
    });
  }
};


export const verifyPayment = async (req, res) => {
  try {
    const { transactionId } = req.body;
    if (!transactionId) throw new Error("transactionId is required");

    const result = await verifyPaymentService(transactionId);
    res.status(200).json(result);
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: error.message || "Payment verification failed",
    });
  }
};