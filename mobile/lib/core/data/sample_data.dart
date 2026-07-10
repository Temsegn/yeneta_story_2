import '../../features/video/data/models/video_model.dart';
import '../../features/library/domain/entities/story_entity.dart';
import '../../features/education/domain/entities/education_video_entity.dart';
import '../../features/games/domain/entities/game_entity.dart';

/// Centralized sample/demo content shown when the backend has no data
/// (or is unreachable). Keeps the app looking populated for new installs.
abstract class SampleData {
  static const _img1 =
      'https://images.unsplash.com/photo-1608106055806-e892769d2e5a?auto=format&fit=crop&q=80&w=800';
  static const _img2 =
      'https://images.unsplash.com/photo-1741356584024-11cfbec6454c?auto=format&fit=crop&q=80&w=800';
  static const _img3 =
      'https://images.unsplash.com/photo-1765934879305-e2ee18822f9c?auto=format&fit=crop&q=80&w=800';
  static const _img4 =
      'https://images.unsplash.com/photo-1564429238817-393bd4286b2d?auto=format&fit=crop&q=80&w=800';
  static const _img5 =
      'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?auto=format&fit=crop&q=80&w=800';
  static const _img6 =
      'https://images.unsplash.com/photo-1535637603896-07c179d71f96?auto=format&fit=crop&q=80&w=800';

  static List<VideoModel> videos() => const [
        VideoModel(
          id: 'sample_v1',
          title: 'የደስታ ሂፖ ጀብደኛ',
          thumbnail: _img1,
          duration: '05:12',
          description: 'Amazing hippo adventure',
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
          isPremium: false,
        ),
        VideoModel(
          id: 'sample_v2',
          title: 'አስማታዊ አረንጓዴ ጫካ',
          thumbnail: _img2,
          duration: '08:45',
          description: 'Magical green forest',
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
          isPremium: false,
        ),
        VideoModel(
          id: 'sample_v3',
          title: 'የሚዘምሩ ቀለማት ወፎች',
          thumbnail: _img3,
          duration: '03:30',
          description: 'Singing colorful birds',
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
          isPremium: true,
        ),
        VideoModel(
          id: 'sample_v4',
          title: 'የደመና ዝላይ ታሪኮች',
          thumbnail: _img4,
          duration: '12:10',
          description: 'Cloud jumping stories',
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
          isPremium: true,
        ),
      ];

  static List<StoryEntity> stories() => const [
        StoryEntity(
          id: 90001,
          title: 'ጎበዟ ጥንቸል',
          coverImage: _img5,
          isPremium: false,
          pages: [
            StoryPageEntity(
                id: 1,
                text: 'በአንድ ወቅት አንዲት ጎበዝ ጥንቸል ነበረች።',
                image: _img5),
            StoryPageEntity(
                id: 2,
                text: 'እርሷም በየቀኑ አዳዲስ ነገሮችን ትማር ነበር።',
                image: _img2),
          ],
        ),
        StoryEntity(
          id: 90002,
          title: 'ኮከቦቹ እና ጨረቃ',
          coverImage: _img4,
          isPremium: true,
          pages: [
            StoryPageEntity(
                id: 1, text: 'ጨረቃ ከኮከቦች ጋር ተጫወተች።', image: _img4),
            StoryPageEntity(
                id: 2, text: 'ሰማዩም በብርሃን ተሞላ።', image: _img3),
          ],
        ),
        StoryEntity(
          id: 90003,
          title: 'ትንሿ ዓሣ',
          coverImage: _img6,
          isPremium: true,
          pages: [
            StoryPageEntity(
                id: 1, text: 'ትንሿ ዓሣ ባሕሩን ዳሰሰች።', image: _img6),
          ],
        ),
      ];

  static List<StoryEntity> books() => const [
        StoryEntity(
          id: 91001,
          title: 'ፊደል እንማር',
          coverImage: _img1,
          isPremium: false,
          pages: [
            StoryPageEntity(id: 1, text: 'ሀ ለ ሐ መ ሠ ረ ሰ', image: _img1),
            StoryPageEntity(id: 2, text: 'ቀ በ ተ ቸ ኀ ነ ኘ', image: _img2),
          ],
        ),
        StoryEntity(
          id: 91002,
          title: 'ቁጥሮችን እንቁጠር',
          coverImage: _img3,
          isPremium: true,
          pages: [
            StoryPageEntity(id: 1, text: '1 2 3 4 5', image: _img3),
            StoryPageEntity(id: 2, text: '6 7 8 9 10', image: _img4),
          ],
        ),
      ];

  static List<EducationVideoEntity> educationVideos() => const [
        EducationVideoEntity(
          id: 92001,
          title: 'ቀለማትን እንማር',
          thumbnail: _img2,
          duration: '04:20',
          description: 'Learn colors with fun examples',
          author: 'Yeneta Story',
          isPremium: false,
        ),
        EducationVideoEntity(
          id: 92002,
          title: 'እንስሳትን እወቅ',
          thumbnail: _img3,
          duration: '06:05',
          description: 'Discover animals and their sounds',
          author: 'Yeneta Story',
          isPremium: true,
        ),
        EducationVideoEntity(
          id: 92003,
          title: 'ቅርጾችን እንለይ',
          thumbnail: _img5,
          duration: '03:48',
          description: 'Shapes all around us',
          author: 'Yeneta Story',
          isPremium: true,
        ),
      ];

  static List<GameEntity> games() => const [
        GameEntity(
          id: 93001,
          name: 'የማስታወስ ጨዋታ',
          category: 'Memory',
          emoji: '🧠',
          color: 'purple',
          type: 'memory-match',
        ),
        GameEntity(
          id: 93002,
          name: 'ፊኛ ምታ',
          category: 'Fun',
          emoji: '🎈',
          color: 'pink',
          type: 'balloon-pop',
        ),
        GameEntity(
          id: 93003,
          name: 'ሥዕል ሳል',
          category: 'Creative',
          emoji: '🎨',
          color: 'green',
          type: 'drawing',
        ),
        GameEntity(
          id: 93004,
          name: 'ሒሳብ ጨዋታ',
          category: 'Math',
          emoji: '➗',
          color: 'blue',
          type: 'math-quiz',
        ),
        GameEntity(
          id: 93005,
          name: 'ቃላት አዛምድ',
          category: 'Words',
          emoji: '🔤',
          color: 'orange',
          type: 'word-match',
        ),
      ];
}
