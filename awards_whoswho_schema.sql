-- Database Schema for Awards and Who's Who pages
-- Run these SQL commands in your Supabase SQL Editor

-- Create awards table
CREATE TABLE IF NOT EXISTS awards (
    id SERIAL PRIMARY KEY,
    year INTEGER NOT NULL,
    awardee_name VARCHAR(255) NOT NULL,
    awardee_photo_url TEXT,
    awardee_bio TEXT,
    award_speech TEXT,
    ceremony_photos TEXT[], -- Array of photo URLs
    literary_genre VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create whos_who table
CREATE TABLE IF NOT EXISTS whos_who (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    photo_url TEXT,
    bio TEXT,
    birth_year INTEGER,
    death_year INTEGER,
    notable_works TEXT[],
    awards_received TEXT[],
    literary_genre VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_awards_year ON awards(year);
CREATE INDEX IF NOT EXISTS idx_awards_awardee ON awards(awardee_name);
CREATE INDEX IF NOT EXISTS idx_whos_who_name ON whos_who(name);
CREATE INDEX IF NOT EXISTS idx_whos_who_genre ON whos_who(literary_genre);

-- Enable Row Level Security
ALTER TABLE awards ENABLE ROW LEVEL SECURITY;
ALTER TABLE whos_who ENABLE ROW LEVEL SECURITY;

-- Create policies for public read access
CREATE POLICY "Allow public read access to awards" ON awards
    FOR SELECT USING (true);

CREATE POLICY "Allow public read access to whos_who" ON whos_who
    FOR SELECT USING (true);

-- Create policies for authenticated users to manage data
CREATE POLICY "Allow authenticated users to manage awards" ON awards
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to manage whos_who" ON whos_who
    FOR ALL USING (auth.role() = 'authenticated');

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers to automatically update updated_at
CREATE TRIGGER update_awards_updated_at BEFORE UPDATE ON awards
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_whos_who_updated_at BEFORE UPDATE ON whos_who
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample data for awards
INSERT INTO awards (year, awardee_name, awardee_photo_url, awardee_bio, award_speech, ceremony_photos, literary_genre) VALUES
(2024, 'Dr. Thangjam Ibopishak Singh', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/awards/2024_thangjam_ibopishak.jpg', 'Renowned Manipuri poet and literary critic known for his contributions to modern Manipuri literature. Born in 1950, he has published over 20 collections of poetry and numerous critical essays.', 'I am deeply honored to receive the Hijam Anganghal Ningsing Mana award. This recognition not only celebrates my work but also the rich literary tradition of Manipur that I am proud to be part of.', ARRAY['https://your-project.supabase.co/storage/v1/object/public/magazine-assets/awards/ceremony_2024_1.jpg', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/awards/ceremony_2024_2.jpg'], 'Poetry'),
(2023, 'Prof. Nongmaithem Rajendra Singh', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/awards/2023_nongmaithem_rajendra.jpg', 'Distinguished Manipuri novelist and short story writer. His works have been translated into multiple languages and he is considered one of the most influential voices in contemporary Manipuri literature.', 'This award represents the collective voice of Manipuri literature. I dedicate this honor to all the writers who have contributed to our rich literary heritage.', ARRAY['https://your-project.supabase.co/storage/v1/object/public/magazine-assets/awards/ceremony_2023_1.jpg'], 'Fiction'),
(2022, 'Dr. Sarangthem Bormani Singh', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/awards/2022_sarangthem_bormani.jpg', 'Eminent Manipuri playwright and theatre director. He has written over 30 plays and directed numerous productions that have been performed across India and internationally.', 'Theatre is the mirror of society, and this award encourages me to continue reflecting the truth through my work on stage.', ARRAY['https://your-project.supabase.co/storage/v1/object/public/magazine-assets/awards/ceremony_2022_1.jpg', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/awards/ceremony_2022_2.jpg'], 'Drama'),
(2021, 'Dr. Elangbam Nilakanta Singh', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/awards/2021_elangbam_nilakanta.jpg', 'Pioneering Manipuri folklorist and cultural researcher. His extensive work on Manipuri folk traditions and oral literature has been instrumental in preserving our cultural heritage.', 'This award is not just for me, but for all the storytellers and keepers of our oral traditions who have passed down our culture through generations.', ARRAY['https://your-project.supabase.co/storage/v1/object/public/magazine-assets/awards/ceremony_2021_1.jpg'], 'Folk Literature'),
(2020, 'Dr. Arambam Ongbi Memchoubi Devi', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/awards/2020_arambam_ongbi.jpg', 'Acclaimed Manipuri essayist and social commentator. Her essays on women''s issues and social justice have been widely read and have influenced public discourse in Manipur.', 'As a woman writer, this award represents the growing recognition of women''s voices in Manipuri literature. I hope it inspires more women to share their stories.', ARRAY['https://your-project.supabase.co/storage/v1/object/public/magazine-assets/awards/ceremony_2020_1.jpg'], 'Essay');

-- Insert sample data for who's who
INSERT INTO whos_who (name, photo_url, bio, birth_year, death_year, notable_works, awards_received, literary_genre) VALUES
('Hijam Anganghal Singh', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/whos_who/hijam_anganghal.jpg', 'Father of modern Manipuri literature. A revolutionary poet, playwright, and social reformer who laid the foundation for contemporary Manipuri writing.', 1892, 1983, ARRAY['Khamba Thoibi Sheireng', 'Nungshitki Puya', 'Meitei Puya'], ARRAY['Sahitya Akademi Award', 'Manipur State Kala Akademi Award'], 'Poetry'),
('Dr. Lamabam Kamal Singh', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/whos_who/lamabam_kamal.jpg', 'Renowned Manipuri novelist and short story writer. Known for his realistic portrayal of Manipuri society and his contribution to the development of Manipuri prose.', 1910, 1985, ARRAY['Madhabi', 'Nongthang Khunthok', 'Eigi Thawai'], ARRAY['Sahitya Akademi Award'], 'Fiction'),
('Dr. Arambam Dorendrajit Singh', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/whos_who/arambam_dorendrajit.jpg', 'Distinguished Manipuri critic and literary historian. His critical works have shaped the understanding of Manipuri literature and its place in Indian literature.', 1925, 1995, ARRAY['Manipuri Sahityagi Itihas', 'Manipuri Kavya Darshan'], ARRAY['Sahitya Akademi Award'], 'Literary Criticism'),
('Dr. Elangbam Nilakanta Singh', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/whos_who/elangbam_nilakanta.jpg', 'Pioneering Manipuri folklorist and cultural researcher. His extensive work on Manipuri folk traditions has been instrumental in preserving our cultural heritage.', 1930, 2010, ARRAY['Manipuri Folk Literature', 'Manipuri Oral Traditions'], ARRAY['Manipur State Kala Akademi Award'], 'Folk Literature'),
('Dr. Sarangthem Bormani Singh', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/whos_who/sarangthem_bormani.jpg', 'Eminent Manipuri playwright and theatre director. His plays have been performed across India and have contributed significantly to Manipuri theatre.', 1940, 2020, ARRAY['Nongpok Ningthou', 'Thoubal', 'Ema Ema'], ARRAY['Sangeet Natak Akademi Award'], 'Drama'),
('Dr. Thangjam Ibopishak Singh', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/whos_who/thangjam_ibopishak.jpg', 'Contemporary Manipuri poet and literary critic. Known for his experimental poetry and critical essays that have influenced modern Manipuri literature.', 1950, NULL, ARRAY['Eigi Thawai', 'Manipuri Kavya', 'Modern Manipuri Poetry'], ARRAY['Hijam Anganghal Ningsing Mana Award 2024'], 'Poetry'),
('Prof. Nongmaithem Rajendra Singh', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/whos_who/nongmaithem_rajendra.jpg', 'Distinguished Manipuri novelist and short story writer. His works have been translated into multiple languages and he is considered a leading voice in contemporary Manipuri literature.', 1955, NULL, ARRAY['Eigi Thawai', 'Manipuri Novel', 'Short Stories'], ARRAY['Hijam Anganghal Ningsing Mana Award 2023'], 'Fiction'),
('Dr. Arambam Ongbi Memchoubi Devi', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/whos_who/arambam_ongbi.jpg', 'Acclaimed Manipuri essayist and social commentator. Her essays on women''s issues and social justice have influenced public discourse in Manipur.', 1960, NULL, ARRAY['Women in Manipuri Literature', 'Social Essays'], ARRAY['Hijam Anganghal Ningsing Mana Award 2020'], 'Essay'),
('Dr. Elangbam Nilakanta Singh', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/whos_who/elangbam_nilakanta_2.jpg', 'Contemporary Manipuri folklorist and cultural researcher. Continuing the work of preserving and documenting Manipuri oral traditions.', 1965, NULL, ARRAY['Contemporary Folk Literature', 'Cultural Documentation'], ARRAY['Manipur State Kala Akademi Award'], 'Folk Literature'),
('Dr. Sarangthem Bormani Singh', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/whos_who/sarangthem_bormani_2.jpg', 'Modern Manipuri playwright and theatre director. Known for his innovative approach to Manipuri theatre and his contribution to contemporary drama.', 1970, NULL, ARRAY['Modern Manipuri Theatre', 'Contemporary Plays'], ARRAY['Sangeet Natak Akademi Award'], 'Drama');

-- Create a view for alphabetical listing
CREATE OR REPLACE VIEW whos_who_alphabetical AS
SELECT 
    id,
    name,
    photo_url,
    bio,
    birth_year,
    death_year,
    notable_works,
    awards_received,
    literary_genre,
    UPPER(SUBSTRING(name, 1, 1)) as first_letter
FROM whos_who
ORDER BY name;

-- Create a view for awards by year
CREATE OR REPLACE VIEW awards_by_year AS
SELECT 
    year,
    COUNT(*) as award_count,
    ARRAY_AGG(awardee_name ORDER BY awardee_name) as awardees
FROM awards
GROUP BY year
ORDER BY year DESC;
