import { clearSession, getAccessToken } from "./auth";
import type {
  AuditLogItem,
  BookItem,
  DashboardStats,
  EducationItem,
  ManagedUser,
  Paginated,
  PaymentItem,
  StoryItem,
  SubscriptionItem,
  SubscriptionPlan,
  VideoItem,
} from "./types";

const API_URL =
  process.env.NEXT_PUBLIC_API_URL || "https://yeneta-zq3w.onrender.com/api/v1";

type RequestOptions = {
  method?: string;
  body?: unknown;
  auth?: boolean;
  formData?: FormData;
};

async function request<T>(path: string, options: RequestOptions = {}): Promise<T> {
  const headers: Record<string, string> = {
    Accept: "application/json",
  };

  if (!options.formData) {
    headers["Content-Type"] = "application/json";
  }

  if (options.auth !== false) {
    const token = getAccessToken();
    if (token) headers.Authorization = `Bearer ${token}`;
  }

  const response = await fetch(`${API_URL}${path}`, {
    method: options.method || "GET",
    headers,
    body: options.formData
      ? options.formData
      : options.body
        ? JSON.stringify(options.body)
        : undefined,
  });

  const data = await response.json().catch(() => ({}));

  if (response.status === 401) {
    clearSession();
    if (typeof window !== "undefined") {
      window.location.href = "/login";
    }
    throw new Error("Session expired. Please sign in again.");
  }

  if (!response.ok) {
    const message =
      typeof data?.message === "string"
        ? data.message
        : `Request failed (${response.status})`;
    throw new Error(message);
  }

  return data as T;
}

export async function loginAdmin(phoneNumber: string, password: string) {
  return request<{ message: string; user: Record<string, unknown> }>(
    "/auth/login",
    {
      method: "POST",
      auth: false,
      body: { phoneNumber, password },
    }
  );
}

export async function fetchAdminStats() {
  return request<DashboardStats>("/admin/stats");
}

export type UploadResult = {
  url: string;
  posterUrl?: string | null;
  filename: string;
  publicId?: string;
  resourceType?: string;
  kind?: string;
  mimetype: string;
  size: number;
  bytes?: number;
  width?: number | null;
  height?: number | null;
  duration?: string | null;
  durationSeconds?: number | null;
  format?: string | null;
};

export async function uploadFile(
  file: File,
  onProgress?: (percent: number) => void
): Promise<UploadResult> {
  const formData = new FormData();
  formData.append("file", file);

  // XHR so we can show real upload progress for large videos.
  return new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest();
    xhr.open("POST", `${API_URL}/admin/uploads`);
    xhr.responseType = "json";

    const token = getAccessToken();
    if (token) xhr.setRequestHeader("Authorization", `Bearer ${token}`);
    xhr.setRequestHeader("Accept", "application/json");

    xhr.upload.onprogress = (event) => {
      if (!event.lengthComputable || !onProgress) return;
      onProgress(Math.round((event.loaded / event.total) * 100));
    };

    xhr.onload = () => {
      const raw = xhr.response;
      const data =
        typeof raw === "string"
          ? (() => {
              try {
                return JSON.parse(raw);
              } catch {
                return {};
              }
            })()
          : raw || {};
      if (xhr.status === 401) {
        clearSession();
        if (typeof window !== "undefined") window.location.href = "/login";
        reject(new Error("Session expired. Please sign in again."));
        return;
      }
      if (xhr.status < 200 || xhr.status >= 300) {
        reject(
          new Error(
            typeof data?.message === "string"
              ? data.message
              : `Upload failed (${xhr.status})`
          )
        );
        return;
      }
      if (!data?.url || typeof data.url !== "string") {
        reject(new Error("Upload succeeded but no file URL was returned."));
        return;
      }
      resolve(data as UploadResult);
    };

    xhr.onerror = () => reject(new Error("Upload failed. Check your connection."));
    xhr.send(formData);
  });
}


export async function fetchVideos(page = 1, limit = 20, search = "") {
  const params = new URLSearchParams({
    page: String(page),
    limit: String(limit),
    includeHidden: "true",
  });
  if (search) params.set("search", search);
  return request<Paginated<VideoItem>>(`/videos?${params}`);
}

export async function fetchVideo(id: string) {
  return request<VideoItem>(`/videos/${id}`);
}

export async function createVideo(body: Partial<VideoItem>) {
  return request<VideoItem>("/videos", { method: "POST", body });
}

export async function updateVideo(id: string, body: Partial<VideoItem>) {
  return request<VideoItem>(`/videos/${id}`, { method: "PUT", body });
}

export async function deleteVideo(id: string) {
  return request(`/videos/${id}`, { method: "DELETE" });
}

export async function fetchStories(page = 1, limit = 20, search = "") {
  const params = new URLSearchParams({
    page: String(page),
    limit: String(limit),
    includeHidden: "true",
  });
  if (search) params.set("search", search);
  return request<Paginated<StoryItem>>(`/stories?${params}`);
}

export async function fetchStory(id: string) {
  return request<StoryItem>(`/stories/${id}`);
}

export async function createStory(body: Partial<StoryItem>) {
  return request<StoryItem>("/stories", { method: "POST", body });
}

export async function updateStory(id: string, body: Partial<StoryItem>) {
  return request<StoryItem>(`/stories/${id}`, { method: "PUT", body });
}

export async function deleteStory(id: string) {
  return request(`/stories/${id}`, { method: "DELETE" });
}

export async function fetchBooks(page = 1, limit = 20, search = "") {
  const params = new URLSearchParams({
    page: String(page),
    limit: String(limit),
    includeHidden: "true",
  });
  if (search) params.set("search", search);
  return request<Paginated<BookItem>>(`/books?${params}`);
}

export async function fetchBook(id: string) {
  return request<BookItem>(`/books/${id}`);
}

export async function createBook(body: Partial<BookItem>) {
  return request<BookItem>("/books", { method: "POST", body });
}

export async function updateBook(id: string, body: Partial<BookItem>) {
  return request<BookItem>(`/books/${id}`, { method: "PUT", body });
}

export async function deleteBook(id: string) {
  return request(`/books/${id}`, { method: "DELETE" });
}

export async function fetchEducation(page = 1, limit = 20, search = "", ageGroup = "") {
  const params = new URLSearchParams({
    page: String(page),
    limit: String(limit),
    includeHidden: "true",
  });
  if (search) params.set("search", search);
  if (ageGroup) params.set("ageGroup", ageGroup);
  return request<Paginated<EducationItem>>(`/education?${params}`);
}

export async function fetchEducationItem(id: string) {
  return request<EducationItem>(`/education/${id}`);
}

export async function createEducation(body: Partial<EducationItem>) {
  return request<EducationItem>("/education", { method: "POST", body });
}

export async function updateEducation(id: string, body: Partial<EducationItem>) {
  return request<EducationItem>(`/education/${id}`, { method: "PUT", body });
}

export async function deleteEducation(id: string) {
  return request(`/education/${id}`, { method: "DELETE" });
}

export async function fetchUsers(params: Record<string, string> = {}) {
  const q = new URLSearchParams(params);
  return request<Paginated<ManagedUser>>(`/admin/users?${q}`);
}

export async function fetchUser(id: string) {
  return request<{
    user: ManagedUser;
    subscriptions: SubscriptionItem[];
    payments: PaymentItem[];
  }>(`/admin/users/${id}`);
}

export async function createUser(body: Record<string, unknown>) {
  return request<ManagedUser>("/admin/users", { method: "POST", body });
}

export async function updateUser(id: string, body: Record<string, unknown>) {
  return request<ManagedUser>(`/admin/users/${id}`, { method: "PUT", body });
}

export async function deleteUser(id: string) {
  return request(`/admin/users/${id}`, { method: "DELETE" });
}

export async function fetchPlans() {
  return request<{ plans: SubscriptionPlan[]; total: number }>("/admin/plans");
}

export async function createPlan(body: Partial<SubscriptionPlan>) {
  return request<SubscriptionPlan>("/admin/plans", { method: "POST", body });
}

export async function updatePlan(id: string, body: Partial<SubscriptionPlan>) {
  return request<SubscriptionPlan>(`/admin/plans/${id}`, { method: "PUT", body });
}

export async function deletePlan(id: string) {
  return request(`/admin/plans/${id}`, { method: "DELETE" });
}

export async function fetchSubscriptions(params: Record<string, string> = {}) {
  const q = new URLSearchParams(params);
  return request<Paginated<SubscriptionItem>>(`/admin/subscriptions?${q}`);
}

export async function fetchSubscription(id: string) {
  return request<SubscriptionItem>(`/admin/subscriptions/${id}`);
}

export async function createSubscription(body: Record<string, unknown>) {
  return request<SubscriptionItem>("/admin/subscriptions", {
    method: "POST",
    body,
  });
}

export async function updateSubscription(id: string, body: Record<string, unknown>) {
  return request<SubscriptionItem>(`/admin/subscriptions/${id}`, {
    method: "PUT",
    body,
  });
}

export async function deleteSubscription(id: string) {
  return request(`/admin/subscriptions/${id}`, { method: "DELETE" });
}

export async function fetchPayments(params: Record<string, string> = {}) {
  const q = new URLSearchParams(params);
  return request<Paginated<PaymentItem>>(`/admin/payments?${q}`);
}

export async function fetchPayment(id: string) {
  return request<PaymentItem>(`/admin/payments/${id}`);
}

export async function fetchAuditLogs(params: Record<string, string> = {}) {
  const q = new URLSearchParams(params);
  return request<AuditLogItem[] | { logs: AuditLogItem[] }>(`/auditlogs?${q}`);
}

export async function broadcastNotification(body: {
  title: string;
  message: string;
  type?: string;
  actionUrl?: string;
}) {
  return request<{ message: string; created: number; pushed: number }>(
    "/admin/notifications/broadcast",
    { method: "POST", body }
  );
}

export function getApiBaseUrl() {
  return API_URL;
}
