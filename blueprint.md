# E-Commerce Admin Panel Blueprint

## Overview

A Flutter-based mobile application for e-commerce administrators to manage their products. The application provides functionalities for adding, editing, and organizing products, including support for product variants and draft management.

## Style, Design, and Features Implemented

### Core Functionality
- **Product Management:**
  - Create, edit, and publish products.
  - Fields for product name, description, price, sale price, and stock quantity.
- **Image Management:**
  - Add up to 10 images per product from the device's gallery.
  - An interactive image carousel to view and remove uploaded images.
- **Category Management:**
  - Assign products to one or more categories.
  - Ability to add new categories on the fly from the product editing screen.
- **Draft System:**
  - Save products as drafts to finish later.
  - A limit of up to 5 drafts can be stored.
  - A drafts popup allows users to view, load, and manage existing drafts.
  - Automatic prompts to save changes as a draft when leaving a modified product form.
- **Product Variants:**
  - Define product options (e.g., Size, Color).
  - Add multiple values for each option (e.g., Small, Medium, Large for Size).
  - Automatically generate all possible variant combinations.
  - A dedicated screen to edit the price, stock, and image for each individual variant.
  - A list of variants is displayed on the main product form.

### UI/UX Design
- **Modern Aesthetics:**
  - Clean and intuitive user interface.
  - Use of `Material Design 3` principles.
  - Clear and readable typography.
- **Responsive Layout:**
  - The application is designed to be responsive and work well on various screen sizes.
- **Interactive Elements:**
  - `ClearableTextFormField` for easy input clearing.
  - Smooth page indicators for image carousels.
  - Modals and bottom sheets for interactive category and draft selection.
- **Navigation:**
  - A `PopScope` is used to prevent accidental data loss by prompting users to save changes before navigating away.
  - Seamless navigation between the product list, product editor, and variant editor.

## Current Requested Change: Implement Variant Editing Flow

### Plan and Steps
- **Goal:** Enhance the product variant functionality to allow users to edit individual variants from the "Add Product" screen, as per the provided design.
- **Steps Taken:**
  1. **Created `ProductVariant` Model:**
     - A new file `lib/features/add_product/models/product_variant_model.dart` was created to define the `ProductVariant` class. This class holds the data for each specific variant combination, including its attributes (e.g., {'Size': 'Small', 'Color': 'Red'}), price, and stock.
  2. **Created `EditVariantScreen`:**
     - A new screen was built at `lib/features/add_product/screens/edit_variant_screen.dart` to provide a dedicated UI for editing the details (price, stock, image) of a single product variant.
  3. **Updated `Product` Model:**
     - The main `Product` model in `lib/features/add_product/models/product_model.dart` was updated to include `List<ProductVariant>` to store the generated variants.
  4. **Modified `AddProductScreen`:**
     - The button text now dynamically changes from "Add Product Variants" to "Edit Product Variants" once variants are created.
     - A `ListView` is now rendered below the button to display the list of generated product variants.
     - Each item in the list is tappable, navigating the user to the `EditVariantScreen` for the selected variant.
     - The screen was updated to handle the return data from `EditVariantScreen` and update the state accordingly.
  5. **Bug Fixes:**
     - Resolved a `non_abstract_class_inherits_abstract_member` error by correctly implementing the `isValidKey` method in the `ProductVariantEquality` class within `add_product_screen.dart`.
     - Fixed an `undefined_method` error in `product_variant_model.dart` by importing the `package:collection/collection.dart` library.
