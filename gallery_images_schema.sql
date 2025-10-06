-- Gallery Images Database Schema
-- This file contains the SQL commands to set up the database for gallery images

-- The gallery images will use the existing 'photos' table
-- Images for the carousel should have issue_id = null

-- Example: Insert gallery images into the photos table
-- Replace the URLs with your actual Supabase storage URLs

INSERT INTO photos (file_url, filename, caption, alt_text, issue_id, created_at) VALUES
-- Example gallery images (replace with your actual image URLs)
('https://kxxlyyqrzsxrzfwjadvg.supabase.co/storage/v1/object/public/magazine-assets/gallery/event1.jpg', 'event1.jpg', 'Literary Workshop 2024', 'Annual literary workshop with renowned Manipuri writers', null, NOW()),
('https://kxxlyyqrzsxrzfwjadvg.supabase.co/storage/v1/object/public/magazine-assets/gallery/event2.jpg', 'event2.jpg', 'Poetry Reading Session', 'Community poetry reading session at the club', null, NOW()),
('https://kxxlyyqrzsxrzfwjadvg.supabase.co/storage/v1/object/public/magazine-assets/gallery/event3.jpg', 'event3.jpg', 'Award Ceremony', 'Hijam Anganghal Ningsing Mana Award ceremony', null, NOW()),
('https://kxxlyyqrzsxrzfwjadvg.supabase.co/storage/v1/object/public/magazine-assets/gallery/event4.jpg', 'event4.jpg', 'Book Launch Event', 'Launch of latest MAPAO journal issue', null, NOW()),
('https://kxxlyyqrzsxrzfwjadvg.supabase.co/storage/v1/object/public/magazine-assets/gallery/event5.jpg', 'event5.jpg', 'Cultural Program', 'Traditional Manipuri cultural program', null, NOW());

-- To add more gallery images, use this format:
-- INSERT INTO photos (file_url, filename, caption, alt_text, issue_id, created_at) VALUES
-- ('your-image-url', 'your-filename.jpg', 'Your Caption', 'Your Description', null, NOW());

-- To view all gallery images:
-- SELECT * FROM photos WHERE issue_id IS NULL ORDER BY created_at DESC;

-- To update an existing gallery image:
-- UPDATE photos SET caption = 'New Caption', alt_text = 'New Description' WHERE file_url = 'your-image-url';

-- To delete a gallery image:
-- DELETE FROM photos WHERE file_url = 'your-image-url' AND issue_id IS NULL;
