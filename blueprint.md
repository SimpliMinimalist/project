
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

Refine the visual appearance of the product cards.

### Steps

1.  **Remove Card Shadow:** Set the `elevation` of the `ProductCard` to `0.0` to remove the box shadow effect.
