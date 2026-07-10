import mongoose from "mongoose";
import bcrypt from "bcryptjs";
import User from "../models/user_model.js";
import Video from "../models/video_models.js";
import Story from "../models/story_models.js";
import dotenv from "dotenv";

dotenv.config();

const seedDatabase = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGO_URI);
    console.log("✅ Connected to MongoDB");

    // ============================================
    // 1. SEED ADMIN USERS
    // ============================================
    console.log("\n📝 Seeding Admin Users...");
    
    const adminUsers = [
      {
        fullName: "Super Admin",
        email: "admin@yeneta.com",
        phoneNumber: "+251911234567",
        password: "Admin@123",
        role: "admin",
      },
      {
        fullName: "Content Manager",
        email: "manager@yeneta.com",
        phoneNumber: "+251911234568",
        password: "Manager@123",
        role: "admin",
      },
    ];

    for (const userData of adminUsers) {
      const existingUser = await User.findOne({ email: userData.email });
      
      if (!existingUser) {
        const hashedPassword = await bcrypt.hash(userData.password, 10);
        await User.create({
          ...userData,
          password: hashedPassword,
          isActive: true,
          childProfiles: [],
        });
        console.log(`✅ Created admin: ${userData.email}`);
      } else {
        console.log(`⚠️  Admin already exists: ${userData.email}`);
      }
    }

    // ============================================
    // 2. SEED SAMPLE VIDEOS
    // ============================================
    console.log("\n📹 Seeding Sample Videos...");
    
    const sampleVideos = [
      {
        title: "የአማርኛ ፊደላት - ሀ እስከ ሐ",
        description: "ለልጆች የተዘጋጀ የአማርኛ ፊደላት ትምህርት",
        videoUrl: "https://example.com/videos/amharic-letters-1.mp4",
        thumbnail: "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800",
        duration: "5:30",
        isPremium: false,
      },
      {
        title: "የእንስሳት ስሞች በአማርኛ",
        description: "የተለያዩ እንስሳትን በአማርኛ እንማር",
        videoUrl: "https://example.com/videos/animals.mp4",
        thumbnail: "https://images.unsplash.com/photo-1564349683136-77e08dba1ef7?w=800",
        duration: "8:15",
        isPremium: false,
      },
      {
        title: "ቁጥሮች 1-20",
        description: "ቁጥሮችን በአማርኛ እንማር",
        videoUrl: "https://example.com/videos/numbers.mp4",
        thumbnail: "https://images.unsplash.com/photo-1509228468518-180dd4864904?w=800",
        duration: "6:45",
        isPremium: true,
      },
      {
        title: "ቀለሞች በአማርኛ",
        description: "የተለያዩ ቀለሞችን እንማር",
        videoUrl: "https://example.com/videos/colors.mp4",
        thumbnail: "https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=800",
        duration: "4:20",
        isPremium: false,
      },
    ];

    const videoCount = await Video.countDocuments();
    if (videoCount === 0) {
      await Video.insertMany(sampleVideos);
      console.log(`✅ Created ${sampleVideos.length} sample videos`);
    } else {
      console.log(`⚠️  Videos already exist (${videoCount} videos)`);
    }

    // ============================================
    // 3. SEED SAMPLE STORIES
    // ============================================
    console.log("\n📚 Seeding Sample Stories...");
    
    const sampleStories = [
      {
        title: "ቀበሮና ጥንቸል",
        content: "በአንድ ጫካ ውስጥ ቀበሮ እና ጥንቸል ይኖሩ ነበር...",
        coverImage: "https://images.unsplash.com/photo-1516627145497-ae6968895b74?w=800",
        ageGroup: "3-5",
        category: "story",
        isPremium: false,
      },
      {
        title: "ጠቢቡ ዝንጀሮ",
        content: "በአንድ ጊዜ በጫካ ውስጥ በጣም ጠቢብ ዝንጀሮ ይኖር ነበር...",
        coverImage: "https://images.unsplash.com/photo-1540573133985-87b6da6d54a9?w=800",
        ageGroup: "5-8",
        category: "story",
        isPremium: false,
      },
      {
        title: "የአማርኛ ፊደላት መጽሐፍ",
        content: "ሀ - ሀበሻ, ሁ - ሁለት, ሂ - ሂሳብ...",
        coverImage: "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800",
        ageGroup: "3-5",
        category: "book",
        isPremium: true,
      },
    ];

    const storyCount = await Story.countDocuments();
    if (storyCount === 0) {
      await Story.insertMany(sampleStories);
      console.log(`✅ Created ${sampleStories.length} sample stories/books`);
    } else {
      console.log(`⚠️  Stories already exist (${storyCount} stories)`);
    }

    // ============================================
    // SUMMARY
    // ============================================
    console.log("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("✅ Database seeding completed!");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("\n👤 Admin Credentials:");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("1. Super Admin");
    console.log("   📧 Email: admin@yeneta.com");
    console.log("   🔑 Password: Admin@123");
    console.log("\n2. Content Manager");
    console.log("   📧 Email: manager@yeneta.com");
    console.log("   🔑 Password: Manager@123");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("\n⚠️  IMPORTANT: Change these passwords after first login!");
    console.log("\n📊 Database Statistics:");
    console.log(`   Users: ${await User.countDocuments()}`);
    console.log(`   Videos: ${await Video.countDocuments()}`);
    console.log(`   Stories: ${await Story.countDocuments()}`);
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");

    await mongoose.connection.close();
    console.log("✅ Database connection closed");
  } catch (error) {
    console.error("❌ Error seeding database:", error.message);
    console.error(error);
    process.exit(1);
  }
};

// Run the seed function
seedDatabase();
