/**
 * Quick test script to verify authentication endpoints
 * Run with: node test-auth.js
 */

const testEmail = `test${Date.now()}@example.com`;
const testPassword = 'password123';

async function testAuth() {
  const baseUrl = 'http://localhost:5000/api/v1';
  
  console.log('🧪 Testing Authentication Endpoints\n');
  
  // Test 1: Register
  console.log('1️⃣ Testing Registration...');
  try {
    const registerResponse = await fetch(`${baseUrl}/auth/register`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        fullName: 'Test User',
        email: testEmail,
        phoneNumber: '+251912345678',
        password: testPassword,
      }),
    });
    
    const registerData = await registerResponse.json();
    
    if (registerResponse.ok) {
      console.log('✅ Registration successful');
      console.log('   User ID:', registerData.user.id);
      console.log('   Email:', registerData.user.email);
      console.log('   Access Token:', registerData.user.accessToken ? 'Present' : 'Missing');
    } else {
      console.log('❌ Registration failed:', registerData.message);
      return;
    }
  } catch (error) {
    console.log('❌ Registration error:', error.message);
    return;
  }
  
  console.log('');
  
  // Test 2: Login
  console.log('2️⃣ Testing Login...');
  try {
    const loginResponse = await fetch(`${baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        email: testEmail,
        password: testPassword,
      }),
    });
    
    const loginData = await loginResponse.json();
    
    if (loginResponse.ok) {
      console.log('✅ Login successful');
      console.log('   User ID:', loginData.user.id);
      console.log('   Email:', loginData.user.email);
      console.log('   Access Token:', loginData.user.accessToken ? 'Present' : 'Missing');
    } else {
      console.log('❌ Login failed:', loginData.message);
    }
  } catch (error) {
    console.log('❌ Login error:', error.message);
  }
  
  console.log('');
  
  // Test 3: Invalid Login
  console.log('3️⃣ Testing Invalid Login...');
  try {
    const invalidLoginResponse = await fetch(`${baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        email: testEmail,
        password: 'wrongpassword',
      }),
    });
    
    const invalidLoginData = await invalidLoginResponse.json();
    
    if (!invalidLoginResponse.ok) {
      console.log('✅ Invalid login correctly rejected');
      console.log('   Error:', invalidLoginData.message);
    } else {
      console.log('❌ Invalid login should have failed');
    }
  } catch (error) {
    console.log('❌ Invalid login test error:', error.message);
  }
  
  console.log('\n✨ Tests completed!');
}

// Run tests
testAuth().catch(console.error);
