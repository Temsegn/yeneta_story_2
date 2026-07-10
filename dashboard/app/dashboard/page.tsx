'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';

interface Stats {
  users: number;
  videos: number;
  stories: number;
  subscriptions: number;
}

export default function DashboardPage() {
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [stats, setStats] = useState<Stats>({
    users: 0,
    videos: 0,
    stories: 0,
    subscriptions: 0,
  });

  useEffect(() => {
    // Check authentication
    const storedUser = localStorage.getItem('user');
    if (!storedUser) {
      router.push('/login');
      return;
    }
    setUser(JSON.parse(storedUser));

    // Fetch stats (placeholder for now)
    // TODO: Implement actual API calls
    setStats({
      users: 150,
      videos: 45,
      stories: 32,
      subscriptions: 89,
    });
  }, [router]);

  const handleLogout = () => {
    localStorage.removeItem('accessToken');
    localStorage.removeItem('refreshToken');
    localStorage.removeItem('user');
    router.push('/login');
  };

  if (!user) {
    return <div className="min-h-screen flex items-center justify-center">Loading...</div>;
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 flex justify-between items-center">
          <h1 className="text-2xl font-bold text-gray-900">Yeneta Admin Dashboard</h1>
          <div className="flex items-center gap-4">
            <span className="text-sm text-gray-600">Welcome, {user.fullName}</span>
            <button
              onClick={handleLogout}
              className="px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-lg hover:bg-red-700"
            >
              Logout
            </button>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Stats Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <StatsCard
            title="Total Users"
            value={stats.users}
            icon="👥"
            color="bg-blue-500"
          />
          <StatsCard
            title="Videos"
            value={stats.videos}
            icon="🎬"
            color="bg-orange-500"
          />
          <StatsCard
            title="Stories & Books"
            value={stats.stories}
            icon="📚"
            color="bg-purple-500"
          />
          <StatsCard
            title="Subscriptions"
            value={stats.subscriptions}
            icon="💳"
            color="bg-green-500"
          />
        </div>

        {/* Quick Actions */}
        <div className="bg-white rounded-lg shadow p-6 mb-8">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Quick Actions</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <ActionButton
              title="Upload Video"
              description="Add new video content"
              icon="📹"
              onClick={() => alert('Video upload coming soon!')}
            />
            <ActionButton
              title="Create Story"
              description="Add new story or book"
              icon="✍️"
              onClick={() => alert('Story creation coming soon!')}
            />
            <ActionButton
              title="Manage Users"
              description="View and manage users"
              icon="👤"
              onClick={() => alert('User management coming soon!')}
            />
          </div>
        </div>

        {/* Coming Soon */}
        <div className="bg-gradient-to-r from-orange-500 to-green-500 rounded-lg shadow p-8 text-white text-center">
          <h2 className="text-2xl font-bold mb-2">🚀 Full Dashboard Coming Soon!</h2>
          <p className="text-lg opacity-90">
            Complete content management, user analytics, and more features are being built.
          </p>
        </div>
      </main>
    </div>
  );
}

function StatsCard({ title, value, icon, color }: { title: string; value: number; icon: string; color: string }) {
  return (
    <div className="bg-white rounded-lg shadow p-6">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm font-medium text-gray-600">{title}</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">{value}</p>
        </div>
        <div className={`${color} w-12 h-12 rounded-lg flex items-center justify-center text-2xl`}>
          {icon}
        </div>
      </div>
    </div>
  );
}

function ActionButton({ title, description, icon, onClick }: { title: string; description: string; icon: string; onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      className="text-left p-4 border-2 border-gray-200 rounded-lg hover:border-orange-500 hover:shadow-md transition-all duration-200"
    >
      <div className="text-3xl mb-2">{icon}</div>
      <h3 className="font-semibold text-gray-900">{title}</h3>
      <p className="text-sm text-gray-600 mt-1">{description}</p>
    </button>
  );
}
