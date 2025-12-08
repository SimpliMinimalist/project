
# Blueprint: East Store Onboarding

This document outlines the plan for building a Flutter application with a user onboarding flow and a basic home screen, as per the provided UI mockups.

## 1. Overview

The goal is to create a multi-screen onboarding process for an application called "East". The flow includes:
- A welcome screen.
- A seamless, single-sheet phone number and OTP verification process.
- Store setup (adding a logo and name).
- A final home screen.
- A feature to add products to the store.

The application will be built with a focus on a clean, modern UI, adhering to the design and color scheme of the mockups.

## 2. Style and Design

- **Color Palette:**
  - **Primary:** Vibrant Orange (`#FF7A21`)
  - **Background:** Light Gray (`#F2F2F2`)
  - **Text:** Dark Gray/Black
  - **Secondary/Subtle:** Light gray for borders and disabled elements.
- **Typography:**
  - The font has been changed from Urbanist to **Roboto**.
  - Font sizes will be used to create a clear visual hierarchy (e.g., large "Welcome to East" title).
- **Components:**
  - Buttons will be rounded and have the primary orange color.
  - Text fields will be simple and clean.
  - The OTP input is a stylized `Pinput` widget.
  - Icons will be from the Material Icons library.
- **Layout:**
  - The layout will be centered and spacious.
  - The app will be responsive to different screen sizes.

## 3. Features & Implementation Plan

### Step 1: Project Setup & Dependencies
- Add necessary dependencies: `google_fonts`, `go_router`, and `pinput`.
- Create a well-organized folder structure:
  - `lib/core`: For shared code like theming and routing.
  - `lib/features/auth`: For all authentication-related screens.
  - `lib/features/home`: For the main application screen after authentication.
  - `lib/features/add_product`: For the new feature to add products.

### Step 2: Core Implementation
- **Theming (`lib/core/theme.dart`):**
  - Create a centralized `ThemeData` object.
  - Use `ColorScheme.fromSeed` with the primary orange color.
  - Define a `TextTheme` with the **Roboto** font from `google_fonts`.
- **Routing (`lib/core/router.dart`):**
  - Set up `GoRouter` to manage navigation between screens.
  - Define routes for `/`, `/store-setup`, `/home`, and the new `/add-product` route.

### Step 3: Screen Implementation

1.  **Welcome Screen (`/`)**
    - Path: `lib/features/auth/screens/welcome_screen.dart`
    - UI: "Welcome to East" title, a privacy policy text, and an "Agree and Continue" button.
    - Action: Opens a single, stateful bottom sheet for both phone and OTP verification, providing a seamless user experience.

2.  **Phone & OTP Verification (Bottom Sheet)**
    - Path: `lib/features/auth/widgets/phone_otp_bottom_sheet.dart`
    - UI: A two-step view within a single bottom sheet.
    - **Step 1 (Phone):** "Enter Phone Number" title, a standard `TextField` for the number with a `+91 - ` prefix, and a "Send OTP" button. The button is disabled until a valid 10-digit number is entered.
    - **Step 2 (OTP):** "Enter OTP" title, a centered `Pinput` widget for the 6-digit OTP, and a "Verify OTP" button.
    - **Library:** Utilized the `pinput` library for a stylized and robust OTP input experience.
    - **Layout Fix:** The OTP input is now centered for better visual balance.
    - Action: After successful verification, navigates to the store setup screen.

3.  **Store Setup Screen (`/store-setup`)**
    - Path: `lib/features/auth/screens/store_setup_screen.dart`
    - UI: "Set Up Your Store" title, a circular area to add a store logo, a text field for the store name, and a "Create Store" button.
    - **Change:** The title is now centered.
    - Action: Navigates to the home screen.

4.  **Home Screen (`/home`)**
    - Path: `lib/features/home/screens/home_screen.dart`
    - UI: An `AppBar` that displays the store's logo and name, along with search and notification icons.
    - **Store Display:** Connects to the `StoreProvider` to show the store logo and name. If no logo exists, a default icon is displayed.
    - **Store Name Style:** The store name in the `AppBar` is displayed with a font size of 16 and is bold.
    - **Floating Action Button:** A square-shaped FAB with a plus icon has been added. When tapped, it navigates to the `/add-product` screen.
    - **AppBar Polish:** The `titleSpacing` is set to `0` to bring the store name closer to the logo. The logo's `radius` has been reduced to `18` for a more balanced look.
    - **Consistent Alignment:** The `AppBar`'s `leading` widget now wraps both the logo and the default icon in a `CircleAvatar` with consistent padding. This ensures perfect alignment regardless of whether a custom logo is used.

5. **Add Product Screen (`/add-product`)**
   - Path: `lib/features/add_product/screens/add_product_screen.dart`
   - UI: A comprehensive form for adding a new product.
   - **Form Fields:**
     - **Media:** A section to add photos or videos.
     - **Product Name:** A text field for the product's name.
     - **Description:** A multi-line text field for the product description.
     - **Price & Sale Price:** Two separate fields for regular and sale prices.
     - **Stock:** A field for the number of items in stock.
   - Action: Accessible via the FAB on the home screen.

### Step 4: Widget Implementation

1.  **Add Product FAB (`lib/features/add_product/widgets/add_product_fab.dart`)**
    - A reusable, square-shaped Floating Action Button with a plus icon.
    - Uses the primary theme color for its background.

### Step 5: Finalization & Recent Changes
- Update `lib/main.dart` to use the `GoRouter` configuration and the custom theme.
- Ensure all navigation links are working correctly.
- **Removed the debug banner** from the top right of the application.
- **Refactored Authentication Flow:** Replaced separate phone/OTP screens with a single, stateful bottom sheet to fix UI flickering and improve user experience.
- **Improved OTP Entry:** Replaced the manual OTP `TextField`s with the `pinput` library for a cleaner implementation and better UI.
- **Corrected Phone Input:** Reverted the phone number input to a standard `TextField` for better usability.
- **Fixed OTP Layout:** Centered the `Pinput` widget to ensure proper visual alignment.
- **Custom Icons:** Added custom SVG icons for search and notification in the `AppBar` of the home screen using the `flutter_svg` package.
- **Home Screen Update:** The home screen now displays the store's name and logo from the `StoreProvider`. The store name is styled to be bold with a font size of 16.
- **Added FAB:** A square-shaped Floating Action Button with a plus icon has been added to the home screen for future use (e.g., adding a new product).
- **AppBar Polish & Alignment Fix:** Refined the `AppBar` layout by reducing the logo size, bringing the title closer, and ensuring the logo and default icon have identical, consistent padding for perfect alignment.
- **Moved FAB:** The `AddProductFab` widget has been moved to `lib/features/add_product/widgets`.
- **Created Add Product Screen:** A new screen with a detailed form for adding products has been created at `lib/features/add_product/screens/add_product_screen.dart`.
