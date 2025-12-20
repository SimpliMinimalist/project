# Project Blueprint

## Overview

This is a Flutter application designed for managing products. It allows users to add, edit, and delete products, as well as save them as drafts. The application features a clean, modern user interface following Material Design principles.

## Features & Design Outline

### Core Functionality
- **Product Management**: Add, update, and delete products.
- **Drafts**: Save products as drafts to finish later. A maximum of 5 drafts is allowed.
- **Image Picker**: Select multiple images for a product from the device's gallery.

### Style & Design
- **Theme**: Modern theme with a custom color scheme and typography using `google_fonts`.
- **UI Components**:
  - `ClearableTextFormField`: A custom text field with a clear button.
  - `DraftsPopup`: A pop-up dialog to view and manage saved drafts.
  - Image carousel with smooth page indicator for product images.
- **Layout**:
  - Responsive design for different screen sizes.
  - Use of `SafeArea` to avoid UI overlapping with system elements like the status bar.

### Implemented Features Log

- **Initial Setup**: Created the basic Flutter project structure.
- **Product Model & Provider**: Implemented the `Product` model and `ProductProvider` for state management.
- **Add/Edit Product Screen**: Created the main screen for adding and editing products.
- **Image Picker & Carousel**: Added functionality to pick and display multiple images in a carousel.
- **Draft Functionality**: Implemented saving products as drafts and viewing them in a pop-up.
- **ClearableTextFormField**: Created a reusable custom text form field.
- **Form Reset Fix**: Fixed an issue where the form was not resetting correctly.
- **Draft Limit and UI Fixes**:
    - Correctly implemented the dialog to show when the draft limit is reached.
    - Fixed the draft pop-up appearing under the status bar by correctly using `SafeArea`.
    - Corrected a typo in `AutovalidateMode`.
- **Navigation Error Resolution**: Refactored the draft loading mechanism to prevent a navigator lock error by loading draft data directly into the existing `AddProductScreen` state.
- **Improved Discard Dialog**: When editing a published product, the exit confirmation dialog no longer offers to "Save as Draft." It now simply asks the user to confirm if they want to discard their changes, providing a more intuitive workflow for live products.
- **Code Quality and Best Practices**:
  - Replaced the deprecated `withOpacity` with the recommended `withAlpha` to avoid precision loss.
  - Resolved a `use_build_context_synchronously` warning by ensuring the `BuildContext` is not used across asynchronous gaps.
- **Image Validation Fix**: Fixed a bug where the image validation message would not disappear after an image was selected. This was resolved by using a `GlobalKey` to manually trigger validation on the image `FormField`.
- **Draft Price Field Fix**: Fixed a bug where a draft saved without a price would display "0.0" when re-edited. The price field now correctly remains empty for drafts until a price is entered.
- **Smarter Draft Dialog**: The "Save changes" dialog is now context-aware. When editing an existing draft, it correctly shows a "Save" button to update the current draft, instead of the confusing "Save as Draft" option.
- **Contextual Draft Icon**: The drafts icon in the app bar is now only visible when creating a new product or editing an existing draft. It is correctly hidden when editing a published product, reducing UI clutter.
- **Contextual Delete Button**: The "Delete" button is now only visible when editing a published product, not when editing a draft, which streamlines the UI and prevents accidental draft deletion.
- **Draft Load Confirmation**: To prevent accidental data loss, a confirmation dialog now appears when a user tries to load a draft, ensuring they want to discard any current changes.
