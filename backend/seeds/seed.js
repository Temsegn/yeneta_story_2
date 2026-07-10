import mongoose from "mongoose";
import bcrypt from "bcryptjs";
import User from "../models/user_model.js";
import Video from "../models/video_models.js";
import Story from "../models/story_models.js";
import Book from "../models/book_models.js";
import Education from "../models/education_models.js";
import SubscriptionPlan from "../models/subscription_plan_models.js";
import dotenv from "dotenv";

dotenv.config();

// Admin who owns all seeded content (only admins can upload).
const ADMIN_OWNER_ID = "6a50a307aa8c13d1bdc2fc89";

const seedDatabase = async () => {
  try {
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
        role: "content_manager",
      },
      {
        fullName: "Finance Officer",
        email: "finance@yeneta.com",
        phoneNumber: "+251911234569",
        password: "Finance@123",
        role: "finance",
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
          securityQuestion: "What is the Yeneta recovery word?",
          securityAnswerHash: await bcrypt.hash("yeneta", 10),
        });
        console.log(`✅ Created admin: ${userData.email}`);
      } else {
        console.log(`⚠️  Admin already exists: ${userData.email}`);
      }
    }

    const createdBy = new mongoose.Types.ObjectId(ADMIN_OWNER_ID);
    const admin = await User.findById(createdBy);

    if (!admin || admin.role !== "admin") {
      throw new Error(
        `Admin owner not found or not admin: ${ADMIN_OWNER_ID}`
      );
    }

    console.log(`✅ Content owner: ${admin.email} (${ADMIN_OWNER_ID})`);

    // ============================================
    // 2. SEED SAMPLE VIDEOS
    // ============================================
    console.log("\n📹 Seeding Sample Videos...");

    const sampleVideos = [
      {
        title: "የአማርኛ ፊደላት - ሀ እስከ ሐ",
        description: "ለልጆች የተዘጋጀ የአማርኛ ፊደላት ትምህርት",
        videoUrl: "https://example.com/videos/amharic-letters-1.mp4",
        thumbnail:
          "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800",
        isPremium: false,
        createdBy,
      },
      {
        title: "የእንስሳት ስሞች በአማርኛ",
        description: "የተለያዩ እንስሳትን በአማርኛ እንማር",
        videoUrl: "https://example.com/videos/animals.mp4",
        thumbnail:
          "https://images.unsplash.com/photo-1564349683136-77e08dba1ef7?w=800",
        isPremium: false,
        createdBy,
      },
      {
        title: "ቁጥሮች 1-20",
        description: "ቁጥሮችን በአማርኛ እንማር",
        videoUrl: "https://example.com/videos/numbers.mp4",
        thumbnail:
          "https://images.unsplash.com/photo-1509228468518-180dd4864904?w=800",
        isPremium: true,
        createdBy,
      },
      {
        title: "ቀለሞች በአማርኛ",
        description: "የተለያዩ ቀለሞችን እንማር",
        videoUrl: "https://example.com/videos/colors.mp4",
        thumbnail:
          "https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=800",
        isPremium: false,
        createdBy,
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
        coverImageUrl:
          "https://images.unsplash.com/photo-1516627145497-ae6968895b74?w=800",
        description: "የልጆች ተወዳጅ ታሪክ",
        isPremium: false,
        createdBy,
        pages: [
          {
            pageNumber: 1,
            title: "ገጽ 1",
            imageUrl:
              "https://images.unsplash.com/photo-1516627145497-ae6968895b74?w=800",
            audioUrl: "https://example.com/audio/fox-rabbit-1.mp3",
            content: "በአንድ ጫካ ውስጥ ቀበሮ እና ጥንቸል ይኖሩ ነበር...",
          },
        ],
      },
      {
        title: "ጠቢቡ ዝንጀሮ",
        coverImageUrl:
          "https://images.unsplash.com/photo-1540573133985-87b6da6d54a9?w=800",
        description: "የዝንጀሮ ታሪክ",
        isPremium: false,
        createdBy,
        pages: [
          {
            pageNumber: 1,
            title: "ገጽ 1",
            imageUrl:
              "https://images.unsplash.com/photo-1540573133985-87b6da6d54a9?w=800",
            audioUrl: "https://example.com/audio/monkey-1.mp3",
            content: "በአንድ ጊዜ በጫካ ውስጥ በጣም ጠቢብ ዝንጀሮ ይኖር ነበር...",
          },
        ],
      },
    ];

    const storyCount = await Story.countDocuments();
    if (storyCount === 0) {
      await Story.insertMany(sampleStories);
      console.log(`✅ Created ${sampleStories.length} sample stories`);
    } else {
      console.log(`⚠️  Stories already exist (${storyCount} stories)`);
    }

    // ============================================
    // 4. SEED SAMPLE BOOKS
    // ============================================
    console.log("\n📖 Seeding Sample Books...");

    const sampleBooks = [
      {
        title: "የአማርኛ ፊደላት መጽሐፍ",
        coverImageUrl:
          "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800",
        description: "ፊደላትን በቀላሉ እንማር",
        isPremium: true,
        createdBy,
        pages: [
          {
            pageNumber: 1,
            title: "ሀ",
            content: "ሀ - ሀበሻ",
            imageUrl:
              "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800",
          },
          {
            pageNumber: 2,
            title: "ለ",
            content: "ለ - ለምን",
            imageUrl:
              "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800",
          },
        ],
      },
    ];

    const bookCount = await Book.countDocuments();
    if (bookCount === 0) {
      await Book.insertMany(sampleBooks);
      console.log(`✅ Created ${sampleBooks.length} sample books`);
    } else {
      console.log(`⚠️  Books already exist (${bookCount} books)`);
    }

    // ============================================
    // 5. SEED SUBSCRIPTION PLANS
    // ============================================
    console.log("\n💳 Seeding Subscription Plans...");
    const samplePlans = [
      {
        key: "premium_monthly",
        name: "Premium Monthly",
        description: "Full access for 30 days",
        price: 499,
        durationInDays: 30,
        isVisible: true,
        sortOrder: 1,
      },
      {
        key: "premium_yearly",
        name: "Premium Yearly",
        description: "Full access for 365 days",
        price: 4999,
        durationInDays: 365,
        isVisible: true,
        sortOrder: 2,
      },
    ];
    for (const plan of samplePlans) {
      const existing = await SubscriptionPlan.findOne({ key: plan.key });
      if (!existing) {
        await SubscriptionPlan.create(plan);
        console.log(`✅ Created plan: ${plan.key}`);
      } else {
        console.log(`⚠️  Plan already exists: ${plan.key}`);
      }
    }

    // ============================================
    // 6. SEED EDUCATION
    // ============================================
    console.log("\n🎓 Seeding Education content...");
    const sampleEducation = [
      {
        title: "ፊደላት ለ 3-5",
        description: "ቀላል የፊደል ትምህርት",
        videoUrl: "https://example.com/videos/edu-letters.mp4",
        thumbnail:
          "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800",
        duration: "4:20",
        author: "Yeneta",
        ageGroup: "3-5",
        isPremium: false,
        isVisible: true,
        createdBy,
      },
      {
        title: "ቁጥሮች ለ 5-8",
        description: "ቁጥር መማር በጨዋታ",
        videoUrl: "https://example.com/videos/edu-numbers.mp4",
        thumbnail:
          "https://images.unsplash.com/photo-1509228468518-180dd4864904?w=800",
        duration: "6:10",
        author: "Yeneta",
        ageGroup: "5-8",
        isPremium: false,
        isVisible: true,
        createdBy,
      },
      {
        title: "ሳይንስ ለ 8-11",
        description: "ቀላል የሳይንስ ሙከራዎች",
        videoUrl: "https://example.com/videos/edu-science.mp4",
        thumbnail:
          "https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=800",
        duration: "8:00",
        author: "Yeneta",
        ageGroup: "8-11",
        isPremium: true,
        isVisible: true,
        createdBy,
      },
    ];
    const educationCount = await Education.countDocuments();
    if (educationCount === 0) {
      await Education.insertMany(sampleEducation);
      console.log(`✅ Created ${sampleEducation.length} education items`);
    } else {
      console.log(`⚠️  Education already exists (${educationCount})`);
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
    console.log("   📱 Phone: +251911234567 / 0911234567");
    console.log("   🔑 Password: Admin@123");
    console.log("\n2. Content Manager");
    console.log("   📧 Email: manager@yeneta.com");
    console.log("   📱 Phone: +251911234568");
    console.log("   🔑 Password: Manager@123");
    console.log("\n3. Finance Officer");
    console.log("   📧 Email: finance@yeneta.com");
    console.log("   📱 Phone: +251911234569");
    console.log("   🔑 Password: Finance@123");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("\n⚠️  IMPORTANT: Change these passwords after first login!");
    console.log("\n📊 Database Statistics:");
    console.log(`   Users: ${await User.countDocuments()}`);
    console.log(`   Videos: ${await Video.countDocuments()}`);
    console.log(`   Stories: ${await Story.countDocuments()}`);
    console.log(`   Books: ${await Book.countDocuments()}`);
    console.log(`   Education: ${await Education.countDocuments()}`);
    console.log(`   Plans: ${await SubscriptionPlan.countDocuments()}`);
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");

    await mongoose.connection.close();
    console.log("✅ Database connection closed");
  } catch (error) {
    console.error("❌ Error seeding database:", error.message);
    console.error(error);
    process.exit(1);
  }
};

seedDatabase();
