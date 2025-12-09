
# Project Blueprint

## Overview

This project is a Flutter application that allows users to manage and sell products. It includes features for adding, viewing, and managing products. The application is designed to be user-friendly and visually appealing, with a focus on a clean and modern user interface.

## Features

### Implemented

*   **Product Management:**
    *   Add new products with a name, price, stock, and multiple images.
    *   View a list of all products in a grid layout on the home screen.
    *   Edit existing products.
    *   Delete existing products.
*   **User Interface:**
    *   A home screen with a scroll-aware Floating Action Button (FAB) and a snapping app bar.
    *   A dedicated screen for adding new products.
    *   An image carousel for displaying product images.
    *   A smooth page indicator for the image carousel.
*   **Styling and Theming:**
    *   A consistent color scheme and typography.
    *   A modern and clean design with a focus on user experience.

### Current Task: Implement Discard Changes Confirmation

*   **Objective:** Prevent accidental data loss when editing a product by showing a confirmation dialog if there are unsaved changes.
*   **Steps:**
    1.  **Detect Changes:** Track the initial state of the product when the "Edit Product" screen is opened.
    2.  **Intercept Back Navigation:** Use `WillPopScope` to intercept the back button press and back gestures.
    3.  **Show Confirmation Dialog:** If changes are detected, display a dialog with the message "Discard changes?" and options to "Continue editing" or "Discard".
    4.  **Handle User's Choice:** The app will either stay on the screen or navigate back based on the user's selection.
