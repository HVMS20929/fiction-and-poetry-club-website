# 📸 Supabase Image Upload Guide for Fiction & Poetry Club Manipur

This guide will help you upload and manage images for your website using Supabase Storage.

## 🗂️ Step 1: Set Up Supabase Storage Bucket

### **Create the Main Bucket:**
1. Go to your **Supabase Dashboard** → **Storage**
2. Click **"Create a new bucket"**
3. **Name**: `magazine-assets`
4. **Public**: ✅ Check this (so images can be accessed by your website)
5. Click **"Create bucket"**

### **Create Organized Folders:**
Inside `magazine-assets`, create these folders:
- `logos/` - Club and organization logos
- `covers/` - Magazine cover images
- `contributors/` - Team member photos
- `moments/` - Event/milestone photos
- `gallery/` - General photo gallery
- `articles/` - Article images

## 📤 Step 2: Upload Your Club Logo

### **Method 1: Using Supabase Dashboard (Recommended for beginners)**

1. **Navigate to Storage:**
   - Go to your Supabase Dashboard
   - Click on **Storage** in the left sidebar
   - Select your `magazine-assets` bucket

2. **Create Logos Folder:**
   - Click **"New folder"**
   - Name it `logos`
   - Click **"Create folder"**

3. **Upload Your Logo:**
   - Click on the `logos` folder
   - Click **"Upload file"**
   - Select your logo image file
   - **Recommended formats**: PNG, JPG, SVG
   - **Recommended size**: 200x200px to 400x400px
   - **File name**: `fiction-poetry-club-logo.png` (or your preferred name)

4. **Get the Public URL:**
   - After upload, click on your logo file
   - Copy the **public URL** (looks like: `https://your-project.supabase.co/storage/v1/object/public/magazine-assets/logos/fiction-poetry-club-logo.png`)

### **Method 2: Using Supabase CLI (For developers)**

```bash
# Install Supabase CLI
npm install -g supabase

# Login to Supabase
supabase login

# Upload file
supabase storage upload magazine-assets/logos/fiction-poetry-club-logo.png ./path/to/your/logo.png
```

## 🔧 Step 3: Update Your Website Code

### **Update the Logo URL in app.py:**

```python
@app.route('/')
def home():
    issues = get_magazine_issues()
    latest_issue = issues[0] if issues else None
    # Replace with your actual Supabase Storage URL
    club_logo_url = "https://your-project.supabase.co/storage/v1/object/public/magazine-assets/logos/fiction-poetry-club-logo.png"
    return render_template('home.html', latest_issue=latest_issue, issues=issues, club_logo_url=club_logo_url)
```

### **Alternative: Use Environment Variable (Recommended)**

1. **Add to your `.env` file:**
```env
CLUB_LOGO_URL=https://your-project.supabase.co/storage/v1/object/public/magazine-assets/logos/fiction-poetry-club-logo.png
```

2. **Update app.py:**
```python
import os

@app.route('/')
def home():
    issues = get_magazine_issues()
    latest_issue = issues[0] if issues else None
    club_logo_url = os.environ.get('CLUB_LOGO_URL', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/logos/fiction-poetry-club-logo.png')
    return render_template('home.html', latest_issue=latest_issue, issues=issues, club_logo_url=club_logo_url)
```

## 🎨 Step 4: Logo Design Recommendations

### **Logo Specifications:**
- **Format**: PNG with transparent background (preferred) or JPG
- **Size**: 200x200px to 400x400px
- **File size**: Under 500KB for fast loading
- **Style**: Should work well on the purple background (#493D9E)

### **Design Tips:**
- Use contrasting colors (white, light colors work well on purple)
- Keep it simple and recognizable
- Consider including text "Fiction & Poetry Club Manipur"
- Make it scalable (works at different sizes)

## 📱 Step 5: Test Your Logo

1. **Start your Flask application:**
   ```bash
   python app.py
   ```

2. **Visit your website:**
   - Go to `http://localhost:5000`
   - Check that the logo appears in the hero section
   - Test on mobile devices to ensure it's responsive

## 🔄 Step 6: Managing Multiple Images

### **Upload Other Images:**

1. **Magazine Covers:**
   - Upload to `covers/` folder
   - Use descriptive names: `fall-winter-2024.jpg`
   - Update your database with the URLs

2. **Team Photos:**
   - Upload to `contributors/` folder
   - Use names: `dr-hesnam-singh.jpg`
   - Update contributor records

3. **Event Photos:**
   - Upload to `moments/` folder
   - Use descriptive names: `launch-event-2024.jpg`

### **Batch Upload (For multiple files):**

1. **Using Supabase Dashboard:**
   - Select multiple files
   - Drag and drop into the appropriate folder

2. **Using Supabase CLI:**
   ```bash
   # Upload entire folder
   supabase storage upload magazine-assets/covers ./local-covers-folder
   ```

## 🛠️ Step 7: Advanced Configuration

### **Set Up Automatic Image Optimization:**

1. **Create a Python script for image processing:**
```python
from PIL import Image
import requests
from io import BytesIO

def optimize_image(image_url, max_size=(400, 400)):
    response = requests.get(image_url)
    img = Image.open(BytesIO(response.content))
    img.thumbnail(max_size, Image.Resampling.LANCZOS)
    return img
```

### **Add Image Fallbacks:**
```html
<img src="{{ club_logo_url }}" 
     alt="Fiction & Poetry Club Manipur Logo" 
     class="club-logo"
     onerror="this.src='{{ url_for('static', filename='images/default-logo.png') }}'">
```

## 🔒 Step 8: Security & Best Practices

### **Bucket Permissions:**
- ✅ **Public bucket** for images that need to be accessed by your website
- ❌ **Private bucket** for sensitive files (if any)

### **File Naming Conventions:**
- Use lowercase letters and hyphens
- Be descriptive: `fiction-poetry-club-logo.png`
- Avoid spaces and special characters
- Include version numbers if needed: `logo-v2.png`

### **Storage Limits:**
- **Free tier**: 1GB storage
- **Pro tier**: 100GB storage
- Monitor your usage in the Supabase dashboard

## 🚨 Troubleshooting

### **Common Issues:**

1. **Logo not displaying:**
   - Check the URL is correct
   - Verify the bucket is public
   - Check file permissions

2. **Slow loading:**
   - Optimize image size
   - Use appropriate format (PNG for logos, JPG for photos)
   - Consider using WebP format for better compression

3. **CORS errors:**
   - Check Supabase CORS settings
   - Ensure your domain is allowed

### **Testing URLs:**
- Test your image URL directly in browser
- Check Supabase Storage logs for errors
- Verify file exists in the correct folder

## 📋 Quick Checklist

- [ ] Supabase Storage bucket created and set to public
- [ ] `logos/` folder created
- [ ] Logo uploaded with proper naming
- [ ] Public URL copied
- [ ] URL updated in app.py or .env file
- [ ] Website tested and logo displays correctly
- [ ] Mobile responsiveness checked

## 🎉 Next Steps

Once your logo is working:
1. **Upload other images** (covers, team photos, etc.)
2. **Update database records** with new image URLs
3. **Set up automated image processing** if needed
4. **Monitor storage usage** and upgrade plan if necessary

Your Fiction & Poetry Club Manipur website now has a professional logo display in the hero section! 🎨✨
