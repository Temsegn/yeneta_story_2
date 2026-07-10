# Authentication Screens

Beautiful, modern authentication screens for the Kids Learning App.

## Screens

### 1. Splash Screen
- Animated logo with scale and fade effects
- Gradient background (purple to pink)
- Auto-navigates to onboarding after 3 seconds
- Duration: 2 seconds animation + 1 second display

### 2. Onboarding Screen
- 3 pages with smooth page transitions
- Features:
  - Read Stories (የተረቶችን ያንብቡ)
  - Watch Videos (ቪዲዮዎችን ይመልከቱ)
  - Play Games (ጨዋታዎችን ይጫወቱ)
- Animated page indicators
- Skip button to jump to sign in
- Next/Get Started button

### 3. Sign In Screen
- Email and password fields
- Password visibility toggle
- Form validation
- Forgot password link
- Loading state with spinner
- Link to sign up screen
- Gradient app logo

### 4. Sign Up Screen
- Full name, email, phone, password fields
- Password confirmation
- Terms & conditions checkbox
- Form validation
- Password visibility toggles
- Loading state
- Link to sign in screen

## Features

### Design
- Modern, colorful UI perfect for kids app
- Smooth animations and transitions
- Consistent color scheme (purple primary)
- Rounded corners and soft shadows
- Clean, spacious layout

### Validation
- Email format validation
- Password length check (min 6 characters)
- Password confirmation match
- Required field validation
- Real-time error messages

### User Experience
- Loading indicators during async operations
- Clear error messages
- Easy navigation between screens
- Responsive design
- Accessible form fields

## Color Palette

```dart
Primary: Color(0xFF6B4CE6)  // Purple
Secondary: Color(0xFF9B6BFF) // Light Purple
Accent: Color(0xFFFF6B9D)   // Pink
Success: Color(0xFF4ECDC4)  // Teal
Text: Color(0xFF2D3142)     // Dark Gray
```

## Navigation Flow

```
Splash → Onboarding → Sign In ⇄ Sign Up → Home
         ↓ (skip)
         Sign In
```

## TODO

- [ ] Integrate with auth datasource
- [ ] Add social login (Google, Apple)
- [ ] Implement forgot password flow
- [ ] Add biometric authentication
- [ ] Store first-time user flag
- [ ] Add email verification
- [ ] Implement remember me functionality
