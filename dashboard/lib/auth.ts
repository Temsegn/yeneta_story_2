import type { AdminUser } from "./types";

const ACCESS_KEY = "accessToken";
const REFRESH_KEY = "refreshToken";
const USER_KEY = "user";

export function getAccessToken(): string | null {
  if (typeof window === "undefined") return null;
  return localStorage.getItem(ACCESS_KEY);
}

export function getStoredUser(): AdminUser | null {
  if (typeof window === "undefined") return null;
  const raw = localStorage.getItem(USER_KEY);
  if (!raw) return null;
  try {
    return JSON.parse(raw) as AdminUser;
  } catch {
    return null;
  }
}

export function saveSession(user: AdminUser) {
  const accessToken = user.accessToken;
  const refreshToken = user.refreshToken;
  if (!accessToken) {
    throw new Error("Login succeeded but no access token was returned.");
  }

  localStorage.setItem(ACCESS_KEY, accessToken);
  if (refreshToken) localStorage.setItem(REFRESH_KEY, refreshToken);

  const { accessToken: _a, refreshToken: _r, ...safeUser } = user;
  localStorage.setItem(USER_KEY, JSON.stringify(safeUser));
}

export function clearSession() {
  localStorage.removeItem(ACCESS_KEY);
  localStorage.removeItem(REFRESH_KEY);
  localStorage.removeItem(USER_KEY);
}

export function requireAdminUser(): AdminUser {
  const user = getStoredUser();
  const token = getAccessToken();
  if (!user || !token || user.role !== "admin") {
    throw new Error("Admin session required");
  }
  return user;
}
