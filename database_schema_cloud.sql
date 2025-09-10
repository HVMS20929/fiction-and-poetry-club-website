-- Cloud-Based Database Schema for Mapao Magazine Web Application
-- This version stores full Supabase Storage URLs instead of local filenames
-- Run these SQL commands in your Supabase SQL Editor

-- Drop existing tables if they exist (be careful with this in production!)
-- DROP TABLE IF EXISTS moments CASCADE;
-- DROP TABLE IF EXISTS contributors CASCADE;
-- DROP TABLE IF EXISTS photos CASCADE;
-- DROP TABLE IF EXISTS articles CASCADE;
-- DROP TABLE IF EXISTS magazine_issues CASCADE;

-- Create magazine_issues table with cloud storage URLs
CREATE TABLE IF NOT EXISTS magazine_issues (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    cover_image_url TEXT, -- Full Supabase Storage URL
    description TEXT,
    release_date VARCHAR(100),
    editorial TEXT,
    journal_type VARCHAR(50) CHECK (journal_type IN ('literary', 'research')) DEFAULT 'literary',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create articles table
CREATE TABLE IF NOT EXISTS articles (
    id SERIAL PRIMARY KEY,
    issue_id INTEGER REFERENCES magazine_issues(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    author VARCHAR(255),
    category VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create photos table with cloud storage URLs
CREATE TABLE IF NOT EXISTS photos (
    id SERIAL PRIMARY KEY,
    issue_id INTEGER REFERENCES magazine_issues(id) ON DELETE CASCADE,
    filename VARCHAR(500) NOT NULL,
    caption TEXT,
    alt_text VARCHAR(255),
    file_url TEXT NOT NULL, -- Full Supabase Storage URL
    file_size INTEGER,
    mime_type VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create contributors table with cloud storage URLs
CREATE TABLE IF NOT EXISTS contributors (
    id SERIAL PRIMARY KEY,
    issue_id INTEGER REFERENCES magazine_issues(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(255) NOT NULL,
    photo_url TEXT, -- Full Supabase Storage URL
    role_type VARCHAR(50) CHECK (role_type IN ('editorial_team', 'featured_writers', 'photographers')),
    bio TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create moments table with cloud storage URLs
CREATE TABLE IF NOT EXISTS moments (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    date VARCHAR(100),
    description TEXT,
    image_url TEXT, -- Full Supabase Storage URL
    category VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_articles_issue_id ON articles(issue_id);
CREATE INDEX IF NOT EXISTS idx_photos_issue_id ON photos(issue_id);
CREATE INDEX IF NOT EXISTS idx_contributors_issue_id ON contributors(issue_id);
CREATE INDEX IF NOT EXISTS idx_moments_category ON moments(category);

-- Enable Row Level Security
ALTER TABLE magazine_issues ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE contributors ENABLE ROW LEVEL SECURITY;
ALTER TABLE moments ENABLE ROW LEVEL SECURITY;

-- Create policies for public read access
CREATE POLICY "Allow public read access to magazine_issues" ON magazine_issues
    FOR SELECT USING (true);

CREATE POLICY "Allow public read access to articles" ON articles
    FOR SELECT USING (true);

CREATE POLICY "Allow public read access to photos" ON photos
    FOR SELECT USING (true);

CREATE POLICY "Allow public read access to contributors" ON contributors
    FOR SELECT USING (true);

CREATE POLICY "Allow public read access to moments" ON moments
    FOR SELECT USING (true);

-- Create policies for authenticated users to insert/update/delete
CREATE POLICY "Allow authenticated users to manage magazine_issues" ON magazine_issues
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to manage articles" ON articles
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to manage photos" ON photos
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to manage contributors" ON contributors
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to manage moments" ON moments
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
CREATE TRIGGER update_magazine_issues_updated_at BEFORE UPDATE ON magazine_issues
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_articles_updated_at BEFORE UPDATE ON articles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_photos_updated_at BEFORE UPDATE ON photos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_contributors_updated_at BEFORE UPDATE ON contributors
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_moments_updated_at BEFORE UPDATE ON moments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample data with cloud storage URLs
-- NOTE: Replace these placeholder URLs with your actual Supabase Storage URLs
INSERT INTO magazine_issues (title, cover_image_url, description, release_date, editorial, journal_type) VALUES
('Fall/Winter 2024 - Literary', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/covers/fall_winter_2024_literary.jpg', 'Kaodri, karamnabu kaogani - ahing adu eigi punsigi tamthiraba ahingni.', 'September 2024', 'Phan pareng amagi satra - adungeigi marup Bijoy , doctor oiduna car tongduna lakli. Eina khongna hotnare. Amalba file ama pairi . Khanloidaba thabakki interview ywba chatli . Chahi kharagi tungda khetnaraba maheigi thak - technical education na khunai amagi leibak amagi maru oiba potchangla ? Meitei machasingna doctor, engineer Ashtabu tamnaba hotnei. Khanbiraktaba keiyasu sen donation touraga tamnei . Sarkar gi leingak chuklidi makhoina paiba ngamde . Mathakta miram macha IAS Officer na loisang khudinggi makok oirare. Marak marakta reserve amasung quota da phaorakpa chingmi echin enaosing yaorak e . Technical education nattaba asomda hotnabasu phabani.', 'literary'),
('Spring/Summer 2024 - Research', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/covers/spring_summer_2024_research.jpg', 'A comprehensive research journal exploring Manipuri culture, language, and society through academic perspectives.', 'March 2024', 'This research issue presents scholarly articles on Manipuri literature, cultural studies, and linguistic research. We feature groundbreaking research from academics and researchers working in the field of Manipuri studies.', 'research'),
('Fall/Winter 2023 - Literary', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/covers/fall_winter_2023_literary.jpg', 'A collection of creative writing, poetry, and literary works from Manipuri writers.', 'September 2023', 'This literary issue celebrates the creative spirit of Manipuri writers with poetry, short stories, and literary essays that capture the essence of our culture and contemporary life.', 'literary'),
('Spring/Summer 2023 - Research', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/covers/spring_summer_2023_research.jpg', 'Academic research and scholarly articles on Manipuri history, culture, and social issues.', 'March 2023', 'Our research journal presents in-depth academic studies on various aspects of Manipuri society, culture, and history, contributing to the scholarly understanding of our region.', 'research'),
('Fall/Winter 2022 - Literary', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/covers/fall_winter_2022_literary.jpg', 'Creative expressions and literary works from emerging and established Manipuri writers.', 'September 2022', 'This issue showcases the diversity and richness of Manipuri literature through creative writing, poetry, and literary criticism.', 'literary')
ON CONFLICT DO NOTHING;

-- Insert sample data for articles
INSERT INTO articles (issue_id, title, content, author, category) VALUES
(1, 'Paodam Ama', 'Phan pareng amagi satra - adungeigi marup Bijoy , doctor oiduna car tongduna lakli. Eina khongna hotnare. Amalba file ama pairi . Khanloidaba thabakki interview ywba chatli . Chahi kharagi tungda khetnaraba maheigi thak - technical education na khunai amagi leibak amagi maru oiba potchangla ? Meitei machasingna doctor, engineer Ashtabu tamnaba hotnei. Khanbiraktaba keiyasu sen donation touraga tamnei . Sarkar gi leingak chuklidi makhoina paiba ngamde . Mathakta miram macha IAS Officer na loisang khudinggi makok oirare. Marak marakta reserve amasung quota da phaorakpa chingmi echin enaosing yaorak e . Technical education nattaba asomda hotnabasu phabani.', 'Bijoy', 'Editorial'),
(1, 'Makhum Wari', 'Phan pareng amagi satra - adungeigi marup Bijoy , doctor oiduna car tongduna lakli. Eina khongna hotnare. Amalba file ama pairi . Khanloidaba thabakki interview ywba chatli . Chahi kharagi tungda khetnaraba maheigi thak - technical education na khunai amagi leibak amagi maru oiba potchangla ? Meitei machasingna doctor, engineer Ashtabu tamnaba hotnei. Khanbiraktaba keiyasu sen donation touraga tamnei . Sarkar gi leingak chuklidi makhoina paiba ngamde . Mathakta miram macha IAS Officer na loisang khudinggi makok oirare. Marak marakta reserve amasung quota da phaorakpa chingmi echin enaosing yaorak e . Technical education nattaba asomda hotnabasu phabani.', 'Bijoy', 'Feature'),
(1, 'Lannai Mityeng Ama', 'Phan pareng amagi satra - adungeigi marup Bijoy , doctor oiduna car tongduna lakli. Eina khongna hotnare. Amalba file ama pairi . Khanloidaba thabakki interview ywba chatli . Chahi kharagi tungda khetnaraba maheigi thak - technical education na khunai amagi leibak amagi maru oiba potchangla ? Meitei machasingna doctor, engineer Ashtabu tamnaba hotnei. Khanbiraktaba keiyasu sen donation touraga tamnei . Sarkar gi leingak chuklidi makhoina paiba ngamde . Mathakta miram macha IAS Officer na loisang khudinggi makok oirare. Marak marakta reserve amasung quota da phaorakpa chingmi echin enaosing yaorak e . Technical education nattaba asomda hotnabasu phabani.', 'Bijoy', 'Feature')
ON CONFLICT DO NOTHING;

-- Insert sample data for contributors with cloud storage URLs
INSERT INTO contributors (issue_id, name, role, photo_url, role_type) VALUES
(1, 'Alice Smith', 'Editor-in-Chief', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/contributors/alice_smith.jpg', 'editorial_team'),
(1, 'Bob Johnson', 'Managing Editor', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/contributors/bob_johnson.jpg', 'editorial_team'),
(1, 'Carol Lee', 'Senior Writer', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/contributors/carol_lee.jpg', 'featured_writers'),
(1, 'David Kim', 'Feature Writer', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/contributors/david_kim.jpg', 'featured_writers'),
(1, 'Eve Martinez', 'Lead Photographer', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/contributors/eve_martinez.jpg', 'photographers'),
(1, 'Frank Brown', 'Photo Editor', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/contributors/frank_brown.jpg', 'photographers')
ON CONFLICT DO NOTHING;

-- Insert sample data for moments with cloud storage URLs
INSERT INTO moments (title, date, description, image_url, category) VALUES
('Mapao Magazine Launch Event', 'March 2022', 'The historic launch of Mapao Magazine, bringing together writers, photographers, and the community to celebrate the beginning of a new era in storytelling.', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/moments/launch_event.jpg', 'Launch'),
('First Annual Writers Workshop', 'June 2022', 'A collaborative workshop where aspiring writers learned from established authors, sharing techniques and building the foundation for future magazine content.', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/moments/writers_workshop.jpg', 'Workshop'),
('Community Photography Exhibition', 'September 2022', 'Showcasing the work of local photographers, this exhibition highlighted the diverse perspectives and stories within our community.', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/moments/photo_exhibition.jpg', 'Exhibition'),
('Mapao Magazine Anniversary Celebration', 'March 2023', 'Celebrating one year of Mapao Magazine with a special event featuring readings, performances, and community recognition.', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/moments/anniversary.jpg', 'Celebration'),
('Youth Writing Competition', 'July 2023', 'Encouraging young voices through a writing competition that brought forward new talent and fresh perspectives.', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/moments/youth_competition.jpg', 'Competition'),
('Cultural Heritage Photography Project', 'October 2023', 'A collaborative project documenting local cultural heritage through photography, preserving memories for future generations.', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/moments/cultural_heritage.jpg', 'Project')
ON CONFLICT DO NOTHING;

-- Insert sample data for photos with cloud storage URLs
INSERT INTO photos (issue_id, filename, caption, alt_text, file_url, file_size, mime_type) VALUES
(1, 'fw2024_1.jpg', 'Opening Ceremony', 'Opening ceremony of Fall/Winter 2024 issue', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/gallery/fw2024_1.jpg', 1024000, 'image/jpeg'),
(1, 'fw2024_2.jpg', 'Tech Expo', 'Technology exhibition showcase', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/gallery/fw2024_2.jpg', 2048000, 'image/jpeg')
ON CONFLICT DO NOTHING;
