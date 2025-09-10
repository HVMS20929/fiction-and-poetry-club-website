# Supabase Integration Setup Guide for Mapao Magazine

This guide will help you set up Supabase as your database backend for the Mapao Magazine web application.

## Prerequisites

- A Supabase account (free tier available at [supabase.com](https://supabase.com))
- Python 3.8+ installed
- Your Mapao web application code

## Step 1: Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign up/sign in
2. Click "New Project"
3. Choose your organization
4. Enter project details:
   - **Name**: `mapao-magazine` (or your preferred name)
   - **Database Password**: Choose a strong password
   - **Region**: Select the region closest to your users
5. Click "Create new project"
6. Wait for the project to be created (this may take a few minutes)

## Step 2: Get Your Supabase Credentials

1. In your project dashboard, go to **Settings** → **API**
2. Copy the following values:
   - **Project URL** (e.g., `https://your-project-id.supabase.co`)
   - **Anon public key** (starts with `eyJ...`)

## Step 3: Set Up Environment Variables

1. Create a `.env` file in your project root directory
2. Add the following content:

```env
# Supabase Configuration
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_KEY=your-anon-key-here

# Flask Configuration
SECRET_KEY=your-secret-key-here
FLASK_ENV=development
FLASK_DEBUG=1

# File Upload Configuration
MAX_CONTENT_LENGTH=16777216
UPLOAD_FOLDER=static/uploads
```

3. Replace the placeholder values with your actual Supabase credentials

## Step 4: Set Up the Database Schema

1. In your Supabase dashboard, go to **SQL Editor**
2. Copy the entire content of `database_schema.sql` from your project
3. Paste it into the SQL Editor
4. Click "Run" to execute the schema creation

This will create:
- `magazine_issues` table for magazine issues
- `articles` table for articles within issues
- `photos` table for photos and images
- `contributors` table for editorial team, writers, and photographers
- `moments` table for milestones and events
- Proper indexes and relationships
- Row Level Security (RLS) policies
- Sample data

## Step 5: Set Up Storage Bucket

1. In your Supabase dashboard, go to **Storage**
2. Click "Create a new bucket"
3. Name it `magazine-assets`
4. Set it to **Public** (so images can be accessed by your website)
5. Click "Create bucket"

## Step 6: Install Dependencies

Run the following command in your project directory:

```bash
pip install -r requirements.txt
```

This will install:
- `supabase` - Python client for Supabase
- `python-dotenv` - For environment variable management
- `Pillow` - For image processing

## Step 7: Test the Integration

1. Start your Flask application:
   ```bash
   python app.py
   ```

2. Visit your website - it should now be using Supabase as the database
3. Check the console for any database connection errors

## Step 8: Verify Database Connection

1. Go to your Supabase dashboard → **Table Editor**
2. You should see your tables populated with sample data
3. Check that the data is being displayed on your website

## Troubleshooting

### Common Issues

1. **"Supabase credentials not configured" error**
   - Make sure your `.env` file exists and has the correct credentials
   - Verify that the environment variables are being loaded

2. **Database connection errors**
   - Check that your Supabase project is active
   - Verify your API keys are correct
   - Ensure your IP is not blocked by Supabase

3. **"Table not found" errors**
   - Make sure you ran the `database_schema.sql` script
   - Check that the table names in `config.py` match your database

4. **Permission errors**
   - Verify that RLS policies are set up correctly
   - Check that your API key has the right permissions

### Fallback Mode

The application is designed to work even if the database is not available. It will automatically fall back to the sample data if:
- Supabase credentials are missing
- Database connection fails
- Tables don't exist

## Next Steps

Once your database is working:

1. **Add Real Content**: Replace sample data with your actual magazine content
2. **Upload Images**: Use the Supabase Storage API to upload real images
3. **User Authentication**: Implement user login for content management
4. **Content Management**: Create admin interfaces for managing articles and photos

## Security Notes

- Never commit your `.env` file to version control
- Use environment variables for sensitive information
- Regularly rotate your API keys
- Monitor your Supabase usage and costs

## Support

If you encounter issues:
1. Check the Supabase documentation: [docs.supabase.com](https://docs.supabase.com)
2. Check the Flask console for error messages
3. Verify your database schema and policies

## File Structure

After setup, your project should have:

```
Mapao_web_app/
├── app.py                 # Main Flask application (updated)
├── config.py             # Configuration settings
├── database.py           # Database service layer
├── database_schema.sql   # Database schema
├── requirements.txt      # Python dependencies (updated)
├── .env                  # Environment variables (create this)
├── templates/            # HTML templates
├── static/               # Static files
└── SUPABASE_SETUP_GUIDE.md  # This guide
```

Your application is now ready to use Supabase as a powerful, scalable backend for your magazine content!
