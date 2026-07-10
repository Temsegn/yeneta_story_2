# Database Seeding Guide

This directory contains seed scripts to populate your database with initial data.

## Available Seed Scripts

### 1. Admin Only Seed (`adminSeed.js`)
Creates a single admin user for accessing the admin dashboard.

**Run:**
```bash
npm run seed:admin
```

**Creates:**
- 1 Admin user

**Credentials:**
- Email: `admin@yeneta.com`
- Password: `Admin@123`

---

### 2. Full Database Seed (`seed.js`)
Creates admin users and sample content (videos, stories, books).

**Run:**
```bash
npm run seed
```

**Creates:**
- 2 Admin users (Super Admin + Content Manager)
- 4 Sample videos (mix of free and premium)
- 3 Sample stories/books

**Admin Credentials:**

1. **Super Admin**
   - Email: `admin@yeneta.com`
   - Password: `Admin@123`

2. **Content Manager**
   - Email: `manager@yeneta.com`
   - Password: `Manager@123`

---

## Usage Instructions

### First Time Setup

1. Make sure your MongoDB is running
2. Ensure `.env` file has correct `MONGO_URI`
3. Run the seed script:

```bash
cd backend
npm run seed
```

### Admin Only Setup

If you only need admin users without sample content:

```bash
cd backend
npm run seed:admin
```

---

## Important Notes

⚠️ **Security:**
- Change default passwords immediately after first login
- Never use these credentials in production
- These are for development/testing only

⚠️ **Idempotency:**
- Scripts check if data already exists
- Safe to run multiple times
- Won't create duplicates

⚠️ **Sample Data:**
- Video URLs and thumbnails use placeholder links
- Replace with actual content URLs before production
- Images use Unsplash for demonstration

---

## Customization

### Adding More Admin Users

Edit `backend/seeds/seed.js` and add to the `adminUsers` array:

```javascript
{
  fullName: "Your Name",
  email: "your.email@yeneta.com",
  phoneNumber: "+251911234569",
  password: "YourPassword@123",
  role: "admin",
}
```

### Adding Sample Content

Add to the respective arrays in `seed.js`:
- `sampleVideos` - for video content
- `sampleStories` - for stories and books

---

## Troubleshooting

### Connection Error
```
Error: connect ECONNREFUSED
```
**Solution:** Make sure MongoDB is running

### Duplicate Key Error
```
E11000 duplicate key error
```
**Solution:** Data already exists. This is normal and safe to ignore.

### Authentication Error
```
MongoServerError: Authentication failed
```
**Solution:** Check your `MONGO_URI` credentials in `.env`

---

## Database Reset

To completely reset and reseed:

```bash
# Drop all collections (use with caution!)
mongosh
use your_database_name
db.dropDatabase()
exit

# Then run seed again
npm run seed
```

---

## Production Considerations

🚫 **DO NOT** run seed scripts in production!

For production:
1. Create admin users manually through secure process
2. Use strong, unique passwords
3. Enable 2FA if available
4. Use environment-specific credentials
5. Audit admin access regularly
