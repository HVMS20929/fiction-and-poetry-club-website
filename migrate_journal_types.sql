-- Migration script to add journal_type field to existing magazine_issues table
-- Run this in your Supabase SQL Editor if you have an existing database

-- Add the journal_type column if it doesn't exist
ALTER TABLE magazine_issues 
ADD COLUMN IF NOT EXISTS journal_type VARCHAR(50) CHECK (journal_type IN ('literary', 'research')) DEFAULT 'literary';

-- Update existing records to have journal_type based on their titles or other criteria
-- You can customize these conditions based on your existing data

-- Example: Set journal_type based on title patterns
UPDATE magazine_issues 
SET journal_type = 'research' 
WHERE title ILIKE '%research%' OR title ILIKE '%academic%' OR title ILIKE '%study%';

-- Example: Set journal_type based on description content
UPDATE magazine_issues 
SET journal_type = 'research' 
WHERE description ILIKE '%research%' OR description ILIKE '%academic%' OR description ILIKE '%study%' OR description ILIKE '%scholarly%';

-- Set remaining records to 'literary' (this should be the default)
UPDATE magazine_issues 
SET journal_type = 'literary' 
WHERE journal_type IS NULL OR journal_type = '';

-- Verify the migration
SELECT id, title, journal_type, release_date 
FROM magazine_issues 
ORDER BY release_date DESC;
