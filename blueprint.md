
# Blueprint

## Overview

This document outlines the project's style, design, and features, from its initial version to the current one. It provides a comprehensive guide to the application's architecture, components, and user interface.

## Key Features

### 1. **Product Management**

- **Add Products**: Users can add new products with a name, description, price, and images.
- **Edit Products**: Existing products can be edited to update their information.
- **Delete Products**: Products can be deleted from the store.
- **Drafts**: Products can be saved as drafts to be completed later. The app supports up to 5 drafts.

### 2. **Category Management**

- **Add Categories**: Users can create new product categories via a bottom sheet.
- **Filter by Category**: The home screen displays a filter to view products by category.
- **Assign Categories**: Products can be assigned to a category when they are created or edited.

### 3. **Store Customization**

- **Store Name**: Users can set a custom name for their store.
- **Store Logo**: A logo can be uploaded to represent the store.

### 4. **User Interface**

- **Home Screen**: Displays a list of products with a category filter.
- **Add/Edit Product Screen**: A form for adding or editing product details.
- **Bottom Sheet for Categories**: A bottom sheet allows users to add new categories from both the home screen and the product creation screen.

## Design and Styling

- **Theme**: The app uses a custom theme with a primary color and a clean, modern design.
- **Layout**: The layout is designed to be intuitive and user-friendly, with a focus on a smooth and responsive user experience.
- **Icons**: The app uses a combination of standard Material Design icons and custom SVG icons for a consistent and polished look.

## Current Plan

- **Implement Category Feature**: The primary goal of the current development phase is to add a category management system. This includes:
  - Adding a category field to the product model.
  - Creating a `CategoryProvider` to manage category data.
  - Building a bottom sheet to add new categories.
  - Integrating the category filter on the home screen.
  - Allowing users to assign categories to products when adding or editing them.
