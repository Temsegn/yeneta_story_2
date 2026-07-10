/**
 * Test Chapa webhook locally
 * Usage: node test-webhook.js [ngrok-url]
 */

const webhookUrl = process.argv[2] || 'http://localhost:5000/api/v1/payments/chapa/webhook';

const testPayload = {
  event: 'charge.success',
  data: {
    first_name: 'Test',
    last_name: 'User',
    email: 'test@example.com',
    currency: 'ETB',
    amount: '1000',
    charge: '1000',
    mode: 'test',
    method: 'test',
    type: 'API',
    status: 'success',
    reference: 'CH_TEST_' + Date.now(),
    tx_ref: 'sub_test_yearly_' + Math.random().toString(36).substring(7),
    customization: {
      title: 'Yearly Subscription',
      description: 'Subscribe to premium content for 1 year',
    },
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  },
};

console.log('🧪 Testing Chapa Webhook\n');
console.log('Webhook URL:', webhookUrl);
console.log('TX Ref:', testPayload.data.tx_ref);
console.log('Amount:', testPayload.data.amount, 'ETB');
console.log('\nSending webhook...\n');

fetch(webhookUrl, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Chapa-Signature': 'test_signature',
  },
  body: JSON.stringify(testPayload),
})
  .then((response) => response.json())
  .then((data) => {
    console.log('✅ Response received:\n');
    console.log(JSON.stringify(data, null, 2));
    console.log('\n📝 Check your backend logs for processing details');
  })
  .catch((error) => {
    console.error('❌ Error:', error.message);
    console.log('\n💡 Make sure your backend is running:');
    console.log('   cd backend && npm start');
    if (webhookUrl.includes('ngrok')) {
      console.log('\n💡 Make sure ngrok is running:');
      console.log('   ngrok http 5000');
    }
  });
