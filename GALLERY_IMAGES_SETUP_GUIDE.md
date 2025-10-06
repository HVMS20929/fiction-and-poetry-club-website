# Gallery Images Setup Guide

This guide explains how to set up and manage gallery images for the carousel on the home page.

## 📁 Image Storage Location

Store your images in Supabase Storage at:
```
storage/magazine-assets/gallery/
```

## 🗄️ Database Structure

Gallery images are stored in the existing `photos` table with these requirements:
- `file_url`: Full URL to the image in Supabase storage
- `filename`: Name of the image file (e.g., 'event1.jpg')
- `caption`: Image title/caption (optional)
- `alt_text`: Image description/alt text (optional)
- `issue_id`: Must be `null` for gallery images

## 📤 How to Upload Images

### Method 1: Supabase Dashboard (Recommended)

1. **Go to Supabase Dashboard**
   - Visit your Supabase project dashboard
   - Navigate to "Storage" in the left sidebar

2. **Navigate to Gallery Folder**
   - Go to `magazine-assets` bucket
   - Navigate to `gallery` folder
   - If the folder doesn't exist, create it

3. **Upload Images**
   - Click "Upload file" or drag and drop images
   - Upload your images (JPG, PNG, WebP recommended)
   - Note the file names for database entries

4. **Get Image URLs**
   - After upload, click on each image
   - Copy the "Public URL" - it will look like:
   ```
   https://kxxlyyqrzsxrzfwjadvg.supabase.co/storage/v1/object/public/magazine-assets/gallery/your-image-name.jpg
   ```

### Method 2: Using Supabase CLI

```bash
# Install Supabase CLI if not already installed
npm install -g supabase

# Login to Supabase
supabase login

# Link to your project
supabase link --project-ref your-project-ref

# Upload images
supabase storage cp local-image.jpg magazine-assets/gallery/remote-image.jpg
```

## 🗃️ Database Setup

### Step 1: Run the SQL Schema

1. Go to Supabase Dashboard → SQL Editor
2. Copy and paste the contents of `gallery_images_schema.sql`
3. Modify the example URLs with your actual image URLs
4. Run the SQL commands

### Step 2: Add Your Images

Use this SQL template to add your images:

```sql
INSERT INTO photos (file_url, filename, caption, alt_text, issue_id, created_at) VALUES
('https://kxxlyyqrzsxrzfwjadvg.supabase.co/storage/v1/object/public/magazine-assets/gallery/event1.jpg', 'event1.jpg', 'Your Caption', 'Your Description', null, NOW()),
('https://kxxlyyqrzsxrzfwjadvg.supabase.co/storage/v1/object/public/magazine-assets/gallery/event2.jpg', 'event2.jpg', 'Another Caption', 'Another Description', null, NOW());
```

## 🖼️ Image Requirements

### Recommended Specifications:
- **Format**: JPG, PNG, or WebP
- **Size**: 1200x800px or similar aspect ratio (3:2)
- **File Size**: Under 2MB per image
- **Quality**: High quality but optimized for web

### Naming Convention:
- Use descriptive names: `literary-workshop-2024.jpg`
- Use hyphens instead of spaces
- Include year if relevant: `award-ceremony-2023.jpg`

## 🔧 Managing Gallery Images

### View All Gallery Images:
```sql
SELECT * FROM photos WHERE issue_id IS NULL ORDER BY created_at DESC;
```

### Update an Image:
```sql
UPDATE photos 
SET caption = 'New Caption', alt_text = 'New Description' 
WHERE file_url = 'your-image-url';
```

### Delete an Image:
```sql
DELETE FROM photos 
WHERE file_url = 'your-image-url' AND issue_id IS NULL;
```

## 🎨 Carousel Features

The carousel will automatically:
- Display all images where `issue_id` is `null`
- Show captions and descriptions from the database
- Auto-advance every 5 seconds
- Allow manual navigation with arrows and dots
- Pause on hover
- Be responsive on mobile devices

## 🚨 Troubleshooting

### Images Not Showing:
1. Check that `issue_id` is `null` in the database
2. Verify the image URL is correct and accessible
3. Ensure the image is in the `gallery` folder in storage

### Database Errors:
1. Make sure the `photos` table exists
2. Check that all required fields are provided
3. Verify your Supabase connection is working

### Performance Issues:
1. Optimize image file sizes
2. Use appropriate image dimensions
3. Consider using WebP format for better compression

## 📝 Example Gallery Images

Here are some example entries you can use:

```sql
INSERT INTO photos (file_url, filename, caption, alt_text, issue_id, created_at) VALUES
('https://kxxlyyqrzsxrzfwjadvg.supabase.co/storage/v1/object/public/magazine-assets/gallery/literary-workshop-2024.jpg', 'literary-workshop-2024.jpg', 'Literary Workshop 2024', 'Annual literary workshop featuring renowned Manipuri writers and poets', null, NOW()),
('https://kxxlyyqrzsxrzfwjadvg.supabase.co/storage/v1/object/public/magazine-assets/gallery/poetry-reading-session.jpg', 'poetry-reading-session.jpg', 'Poetry Reading Session', 'Community poetry reading session at the Fiction & Poetry Club', null, NOW()),
('https://kxxlyyqrzsxrzfwjadvg.supabase.co/storage/v1/object/public/magazine-assets/gallery/award-ceremony-2023.jpg', 'award-ceremony-2023.jpg', 'Award Ceremony 2023', 'Hijam Anganghal Ningsing Mana Award ceremony honoring literary excellence', null, NOW()),
('https://kxxlyyqrzsxrzfwjadvg.supabase.co/storage/v1/object/public/magazine-assets/gallery/book-launch-event.jpg', 'book-launch-event.jpg', 'MAPAO Journal Launch', 'Launch event for the latest issue of MAPAO literary journal', null, NOW()),
('https://kxxlyyqrzsxrzfwjadvg.supabase.co/storage/v1/object/public/magazine-assets/gallery/cultural-program.jpg', 'cultural-program.jpg', 'Cultural Program', 'Traditional Manipuri cultural program celebrating literature and arts', null, NOW());
```

## ✅ Checklist

- [ ] Create `gallery` folder in `magazine-assets` bucket
- [ ] Upload images to the gallery folder
- [ ] Copy image URLs from Supabase storage
- [ ] Run SQL commands to insert image data
- [ ] Verify images appear in carousel
- [ ] Test carousel navigation and auto-play
- [ ] Check mobile responsiveness

Your gallery carousel is now ready to showcase your images! 🎉
