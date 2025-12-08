
# Project Blueprint

## Overview

This document outlines the design, features, and development plan for the E-commerce App. It serves as a single source of truth for the application's architecture and functionality.

## Style and Design

### General Principles

*   **Modern & Clean:** The app will have a modern, clean, and intuitive user interface.
*   **Brand-Centric:** The color scheme, typography, and iconography will align with the brand's identity.
*   **Responsive:** The layout will be responsive and adapt to various screen sizes, ensuring a seamless experience on both mobile and web.
*   **Accessibility:** The app will adhere to accessibility standards to be usable by a wide range of users.

### Color Palette

*   **Primary Color:** The primary color will be a deep, elegant shade, used for branding, key actions, and highlights.
*   **Accent Colors:** A vibrant accent color will be used for interactive elements and to draw attention to specific features.
*   **Neutral Colors:** A range of neutral colors will be used for backgrounds, text, and to create a balanced layout.

### Typography

*   **Font Family:** A modern, readable font will be used throughout the app.
*   **Font Sizes:** A clear typographic hierarchy will be established to guide the user's attention and improve readability.
*   **Font Weights:** A variety of font weights will be used to create emphasis and visual interest.

### Iconography

*   **Style:** A consistent set of icons will be used to enhance usability and provide clear visual cues.
*   **Size:** Icons will be appropriately sized to be easily tappable and recognizable.

## Features

### Core

*   **User Authentication:** Secure user authentication will be implemented, allowing users to sign up, log in, and manage their accounts.
*   **Product Catalog:** A comprehensive product catalog will be available, with detailed product information and images.
*   **Shopping Cart:** A fully functional shopping cart will allow users to add, remove, and manage products.
*   **Checkout:** A streamlined and secure checkout process will be implemented to facilitate purchases.
*   **Order History:** Users will be able to view their order history and track the status of their purchases.

### "Add Product" Screen

*   **Image Picker:** Users can add up to 10 product images from their device's gallery.
*   **Image Carousel:** Selected images are displayed in a carousel with a counter and the option to remove individual images.
*   **Swipe Indicator:** A subtle, non-looping swipe indicator shows the current position in the image carousel.
*   **Form Validation:** The "Product Name" and "Price" fields are required. The form validates on user interaction and displays an error message if the fields are empty.
*   **"Add Product" Button:**
    *   The button is always active.
    *   When clicked, the button triggers validation and displays error messages if the required fields are empty.
    *   The button's background is always a solid primary color.
    *   The button has no box shadow and is elevated by 5 pixels from the bottom.
*   **Title:** The screen's title is "New Product."

## Current Task

### Goal

Refine the home screen's scrolling behavior and animations for a smoother user experience.

### Steps

1.  **Smoother App Bar Hiding:** The `snap` property was removed from the `SliverAppBar` to prevent it from reappearing abruptly at the top of the scroll view.
2.  **Rotation-Free FAB Animation:** The default rotation animation for the Floating Action Button has been replaced with a simple fade-in/fade-out transition using `AnimatedSwitcher` for a cleaner look.
3.  **Code Style Correction:** A lint warning was addressed by reordering the `child` property in the `FadeTransition` widget to adhere to best practices.
4.  **Robust FAB Visibility Logic:** To fix a flickering issue at the top and bottom of the list, the scroll listener logic was enhanced. It now checks if the scroll position is `atEdge` and, if so, ensures the FAB is visible. This prevents the `userScrollDirection` from causing inconsistent state changes at the scroll boundaries. The standard hide/show logic is only applied when scrolling through the middle of the list.

