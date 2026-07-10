export type StaffRole = "admin" | "finance" | "content_manager";
export type UserRole = "parent" | StaffRole;

export type AdminUser = {
  id: string;
  fullName: string;
  email?: string | null;
  phoneNumber?: string | null;
  role: UserRole | string;
  accessToken?: string;
  refreshToken?: string;
  isActive?: boolean;
  securityQuestion?: string | null;
};

export const INTERNAL_ROLES: StaffRole[] = [
  "admin",
  "finance",
  "content_manager",
];

export function isInternalRole(role?: string | null): boolean {
  return !!role && INTERNAL_ROLES.includes(role as StaffRole);
}

export type Paginated<T> = {
  videos?: T[];
  stories?: T[];
  books?: T[];
  education?: T[];
  users?: T[];
  subscriptions?: T[];
  payments?: T[];
  plans?: T[];
  total?: number;
  totalPages?: number;
  page?: number;
  limit?: number;
};

export type VideoItem = {
  _id: string;
  title: string;
  description?: string;
  thumbnail?: string;
  videoUrl?: string;
  duration?: string | number;
  isPremium?: boolean;
  isVisible?: boolean;
  createdAt?: string;
};

export type StoryItem = {
  _id: string;
  title: string;
  description?: string;
  coverImageUrl?: string;
  isPremium?: boolean;
  isVisible?: boolean;
  totalPages?: number;
  pages?: StoryPage[];
  createdAt?: string;
};

export type StoryPage = {
  pageNumber: number;
  title: string;
  imageUrl: string;
  audioUrl: string;
  content: string;
};

export type BookItem = {
  _id: string;
  title: string;
  description?: string;
  coverImageUrl?: string;
  isPremium?: boolean;
  isVisible?: boolean;
  totalPages?: number;
  pages?: BookPage[];
  createdAt?: string;
};

export type BookPage = {
  pageNumber: number;
  title?: string;
  content: string;
  imageUrl: string;
};

export type EducationItem = {
  _id: string;
  title: string;
  description?: string;
  thumbnail?: string;
  videoUrl?: string;
  duration?: string;
  author?: string;
  ageGroup?: string;
  isPremium?: boolean;
  isVisible?: boolean;
  createdAt?: string;
};

export type AuditLogItem = {
  _id: string;
  action?: string;
  targetModel?: string;
  targetId?: string;
  createdAt?: string;
  user?: { fullName?: string; email?: string };
};

export type SubscriptionPlan = {
  _id: string;
  key: string;
  name: string;
  description?: string;
  price: number;
  durationInDays: number;
  isVisible: boolean;
  sortOrder?: number;
};

export type SubscriptionItem = {
  _id: string;
  plan: string;
  price: number;
  status: string;
  startDate?: string;
  endDate?: string;
  txRef?: string;
  user?: {
    _id?: string;
    fullName?: string;
    phoneNumber?: string;
    email?: string;
  };
  createdAt?: string;
};

export type PaymentItem = {
  _id: string;
  amount: number;
  status: string;
  paymentMethod?: string;
  transactionId?: string;
  txRef?: string;
  chapaReference?: string;
  userId?: {
    _id?: string;
    fullName?: string;
    phoneNumber?: string;
  };
  createdAt?: string;
};

export type ManagedUser = {
  _id: string;
  fullName: string;
  email?: string | null;
  phoneNumber?: string;
  role: string;
  isActive?: boolean;
  isPremium?: boolean;
  securityQuestion?: string | null;
  createdAt?: string;
};

export type DashboardStats = {
  users: number;
  admins: number;
  videos: number;
  stories: number;
  books: number;
  activeSubscriptions: number;
  payments: number;
  revenue: number;
};

export type ContentKind = "videos" | "stories" | "books" | "education";
