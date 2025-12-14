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
