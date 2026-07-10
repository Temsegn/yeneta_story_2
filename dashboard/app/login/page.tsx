import { LoginForm } from "@/components/auth/login-form";

export default function LoginPage() {
  return (
    <div className="relative flex min-h-screen items-center justify-center px-4 py-10">
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute -left-16 top-10 h-56 w-56 rounded-full bg-orange/20 blur-3xl" />
        <div className="absolute -right-10 bottom-8 h-64 w-64 rounded-full bg-green/20 blur-3xl" />
      </div>

      <div className="relative w-full max-w-md overflow-hidden rounded-[28px] border border-border bg-white/95 shadow-[0_30px_80px_rgba(15,31,23,0.12)]">
        <div className="bg-gradient-to-r from-[#123526] to-[#f97316] px-8 py-7 text-white">
          <p className="text-xs font-bold uppercase tracking-[0.22em] text-white/70">
            Yeneta Story
          </p>
          <h1 className="mt-2 text-3xl font-black tracking-tight">Admin Studio</h1>
          <p className="mt-2 text-sm text-white/80">
            Sign in with your admin phone number to manage kids content.
          </p>
        </div>

        <div className="space-y-5 px-8 py-8">
          <LoginForm />
          <p className="text-center text-xs text-muted-fg">
            Phone login only. Admin role required.
          </p>
        </div>
      </div>
    </div>
  );
}
