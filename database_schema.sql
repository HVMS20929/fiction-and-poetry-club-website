-- Database Schema for Mapao Magazine Web Application
-- Run these SQL commands in your Supabase SQL Editor

-- Enable Row Level Security (RLS)
ALTER DATABASE postgres SET "app.jwt_secret" TO 'your-jwt-secret-here';

-- Create magazine_issues table
CREATE TABLE IF NOT EXISTS magazine_issues (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    cover_image VARCHAR(500),
    description TEXT,
    release_date VARCHAR(100),
    editorial TEXT,
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

-- Create photos table
CREATE TABLE IF NOT EXISTS photos (
    id SERIAL PRIMARY KEY,
    issue_id INTEGER REFERENCES magazine_issues(id) ON DELETE CASCADE,
    filename VARCHAR(500) NOT NULL,
    caption TEXT,
    alt_text VARCHAR(255),
    file_url VARCHAR(1000),
    file_size INTEGER,
    mime_type VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create contributors table
CREATE TABLE IF NOT EXISTS contributors (
    id SERIAL PRIMARY KEY,
    issue_id INTEGER REFERENCES magazine_issues(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(255) NOT NULL,
    photo VARCHAR(500),
    role_type VARCHAR(50) CHECK (role_type IN ('editorial_team', 'featured_writers', 'photographers')),
    bio TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create moments table
CREATE TABLE IF NOT EXISTS moments (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    date VARCHAR(100),
    description TEXT,
    image VARCHAR(500),
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

-- Insert sample data for magazine_issues
INSERT INTO magazine_issues (title, cover_image, description, release_date, editorial) VALUES
('Fall/Winter 2024', 'fall_winter_2024.jpg', 'Kaodri, karamnabu kaogani - ahing adu eigi punsigi tamthiraba ahingni.', 'September 2024', 'Phan pareng amagi satra - adungeigi marup Bijoy , doctor oiduna car tongduna lakli. Eina khongna hotnare. Amalba file ama pairi . Khanloidaba thabakki interview ywba chatli . Chahi kharagi tungda khetnaraba maheigi thak - technical education na khunai amagi leibak amagi maru oiba potchangla ? Meitei machasingna doctor, engineer Ashtabu tamnaba hotnei. Khanbiraktaba keiyasu sen donation touraga tamnei . Sarkar gi leingak chuklidi makhoina paiba ngamde . Mathakta miram macha IAS Officer na loisang khudinggi makok oirare. Marak marakta reserve amasung quota da phaorakpa chingmi echin enaosing yaorak e . Technical education nattaba asomda hotnabasu phabani.'),
('Spring/Summer 2024', 'spring_summer_2024.jpg', 'Kaodri, karamnabu kaogani - ahing adu eigi punsigi tamthiraba ahingni.', 'March 2024', 'Phan pareng amagi satra - adungeigi marup Bijoy , doctor oiduna car tongduna lakli. Eina khongna hotnare. Amalba file ama pairi . Khanloidaba thabakki interview ywba chatli . Chahi kharagi tungda khetnaraba maheigi thak - technical education na khunai amagi leibak amagi maru oiba potchangla ? Meitei machasingna doctor, engineer Ashtabu tamnaba hotnei. Khanbiraktaba keiyasu sen donation touraga tamnei . Sarkar gi leingak chuklidi makhoina paiba ngamde . Mathakta miram macha IAS Officer na loisang khudinggi makok oirare. Marak marakta reserve amasung quota da phaorakpa chingmi echin enaosing yaorak e . Technical education nattaba asomda hotnabasu phabani.'),
('Fall/Winter 2023', 'fall_winter_2023.jpg', 'A deep dive into sustainable living and environmental consciousness.', 'September 2023', 'Sustainability is at the heart of this issue. Join us as we spotlight the people and projects making a real difference for our planet.')
ON CONFLICT DO NOTHING;

-- Insert sample data for articles
INSERT INTO articles (issue_id, title, content, author, category) VALUES
(1, 'Paodam Ama', 'Phan pareng amagi satra - adungeigi marup Bijoy , doctor oiduna car tongduna lakli. Eina khongna hotnare. Amalba file ama pairi . Khanloidaba thabakki interview ywba chatli . Chahi kharagi tungda khetnaraba maheigi thak - technical education na khunai amagi leibak amagi maru oiba potchangla ? Meitei machasingna doctor, engineer Ashtabu tamnaba hotnei. Khanbiraktaba keiyasu sen donation touraga tamnei . Sarkar gi leingak chuklidi makhoina paiba ngamde . Mathakta miram macha IAS Officer na loisang khudinggi makok oirare. Marak marakta reserve amasung quota da phaorakpa chingmi echin enaosing yaorak e . Technical education nattaba asomda hotnabasu phabani.', 'Bijoy', 'Editorial'),
(1, 'Makhum Wari', 'Phan pareng amagi satra - adungeigi marup Bijoy , doctor oiduna car tongduna lakli. Eina khongna hotnare. Amalba file ama pairi . Khanloidaba thabakki interview ywba chatli . Chahi kharagi tungda khetnaraba maheigi thak - technical education na khunai amagi leibak amagi maru oiba potchangla ? Meitei machasingna doctor, engineer Ashtabu tamnaba hotnei. Khanbiraktaba keiyasu sen donation touraga tamnei . Sarkar gi leingak chuklidi makhoina paiba ngamde . Mathakta miram macha IAS Officer na loisang khudinggi makok oirare. Marak marakta reserve amasung quota da phaorakpa chingmi echin enaosing yaorak e . Technical education nattaba asomda hotnabasu phabani.', 'Bijoy', 'Feature'),
(1, 'Lannai Mityeng Ama', 'Phan pareng amagi satra - adungeigi marup Bijoy , doctor oiduna car tongduna lakli. Eina khongna hotnare. Amalba file ama pairi . Khanloidaba thabakki interview ywba chatli . Chahi kharagi tungda khetnaraba maheigi thak - technical education na khunai amagi leibak amagi maru oiba potchangla ? Meitei machasingna doctor, engineer Ashtabu tamnaba hotnei. Khanbiraktaba keiyasu sen donation touraga tamnei . Sarkar gi leingak chuklidi makhoina paiba ngamde . Mathakta miram macha IAS Officer na loisang khudinggi makok oirare. Marak marakta reserve amasung quota da phaorakpa chingmi echin enaosing yaorak e . Technical education nattaba asomda hotnabasu phabani.', 'Bijoy', 'Feature')
ON CONFLICT DO NOTHING;

-- Insert sample data for contributors
INSERT INTO contributors (issue_id, name, role, photo, role_type) VALUES
(1, 'Alice Smith', 'Editor-in-Chief', 'alice_smith.jpg', 'editorial_team'),
(1, 'Bob Johnson', 'Managing Editor', 'bob_johnson.jpg', 'editorial_team'),
(1, 'Carol Lee', 'Senior Writer', 'carol_lee.jpg', 'featured_writers'),
(1, 'David Kim', 'Feature Writer', 'david_kim.jpg', 'featured_writers'),
(1, 'Eve Martinez', 'Lead Photographer', 'eve_martinez.jpg', 'photographers'),
(1, 'Frank Brown', 'Photo Editor', 'frank_brown.jpg', 'photographers')
ON CONFLICT DO NOTHING;

-- Insert sample data for moments
INSERT INTO moments (title, date, description, image, category) VALUES
('Mapao Magazine Launch Event', 'March 2022', 'The historic launch of Mapao Magazine, bringing together writers, photographers, and the community to celebrate the beginning of a new era in storytelling.', 'launch_event.jpg', 'Launch'),
('First Annual Writers Workshop', 'June 2022', 'A collaborative workshop where aspiring writers learned from established authors, sharing techniques and building the foundation for future magazine content.', 'writers_workshop.jpg', 'Workshop'),
('Community Photography Exhibition', 'September 2022', 'Showcasing the work of local photographers, this exhibition highlighted the diverse perspectives and stories within our community.', 'photo_exhibition.jpg', 'Exhibition'),
('Mapao Magazine Anniversary Celebration', 'March 2023', 'Celebrating one year of Mapao Magazine with a special event featuring readings, performances, and community recognition.', 'anniversary.jpg', 'Celebration'),
('Youth Writing Competition', 'July 2023', 'Encouraging young voices through a writing competition that brought forward new talent and fresh perspectives.', 'youth_competition.jpg', 'Competition'),
('Cultural Heritage Photography Project', 'October 2023', 'A collaborative project documenting local cultural heritage through photography, preserving memories for future generations.', 'cultural_heritage.jpg', 'Project')
ON CONFLICT DO NOTHING;
