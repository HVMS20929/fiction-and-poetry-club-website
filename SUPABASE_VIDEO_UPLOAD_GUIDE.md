# 🎥 Supabase Video Upload Guide for Hero Background

This guide will help you upload a video file to Supabase Storage for use as the hero background on the home page.

## 🗂️ Step 1: Set Up Supabase Storage for Videos

### **Create the Videos Folder:**
1. Go to your **Supabase Dashboard** → **Storage**
2. Navigate to your existing `magazine-assets` bucket
3. Create a new folder called `videos/` inside the bucket
4. This will organize your video files properly

## 📤 Step 2: Upload Your Video

### **Video Requirements:**
- **Format**: MP4 (recommended for web compatibility)
- **Resolution**: 1920x1080 (Full HD) or higher
- **Duration**: 10-30 seconds (for seamless looping)
- **File Size**: Keep under 50MB for better loading performance
- **Aspect Ratio**: 16:9 (landscape) works best for hero sections

### **Upload Process:**
1. **Go to Storage**: Supabase Dashboard → Storage → magazine-assets
2. **Navigate to videos folder**: Click on the `videos/` folder
3. **Upload Video**: Click "Upload file" and select your video
4. **Name the file**: Use a descriptive name like `hero-background.mp4`

### **Get Public URL:**
After uploading:
1. Click on the uploaded video file
2. Copy the **public URL** (looks like: `https://your-project.supabase.co/storage/v1/object/public/magazine-assets/videos/hero-background.mp4`)

## 🔧 Step 3: Update Your Application

### **Update app.py:**
Replace the placeholder URL in `app.py` with your actual video URL:

```python
@app.route('/')
def home():
    issues = get_magazine_issues()
    latest_issue = issues[0] if issues else None
    # Update this URL with your actual Supabase Storage video URL
    club_logo_url = "https://your-project.supabase.co/storage/v1/object/public/magazine-assets/logos/fiction_&_poetry_logo.png"
    hero_video_url = "https://your-project.supabase.co/storage/v1/object/public/magazine-assets/videos/hero-background.mp4"
    return render_template('home.html', latest_issue=latest_issue, issues=issues, club_logo_url=club_logo_url, hero_video_url=hero_video_url)
```

### **Alternative: Use Environment Variables:**
For better security and flexibility, you can use environment variables:

1. **Add to .env file:**
```env
HERO_VIDEO_URL=https://your-project.supabase.co/storage/v1/object/public/magazine-assets/videos/hero-background.mp4
```

2. **Update app.py:**
```python
import os

@app.route('/')
def home():
    issues = get_magazine_issues()
    latest_issue = issues[0] if issues else None
    club_logo_url = os.environ.get('CLUB_LOGO_URL', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/logos/fiction_&_poetry_logo.png')
    hero_video_url = os.environ.get('HERO_VIDEO_URL', 'https://your-project.supabase.co/storage/v1/object/public/magazine-assets/videos/hero-background.mp4')
    return render_template('home.html', latest_issue=latest_issue, issues=issues, club_logo_url=club_logo_url, hero_video_url=hero_video_url)
```

## 🎨 Step 4: Video Optimization Tips

### **For Best Performance:**
1. **Compress the video** using tools like HandBrake or FFmpeg
2. **Use H.264 codec** for maximum compatibility
3. **Keep file size under 50MB** for faster loading
4. **Use 30fps or 60fps** for smooth playback
5. **Ensure seamless looping** by making the end match the beginning

### **Recommended Video Settings:**
- **Resolution**: 1920x1080 (Full HD)
- **Bitrate**: 2-5 Mbps
- **Frame Rate**: 30fps
- **Duration**: 10-30 seconds
- **Format**: MP4
- **Codec**: H.264

## 🎬 Step 5: Video Content Suggestions

### **Great Hero Video Ideas:**
1. **Literary Theme**: Books, writing, reading scenes
2. **Cultural Elements**: Manipuri cultural symbols, traditional art
3. **Nature Scenes**: Beautiful landscapes, peaceful environments
4. **Abstract Motion**: Gentle, flowing movements
5. **Club Activities**: Writing workshops, literary events

### **Video Guidelines:**
- **Keep it subtle**: Don't distract from the text content
- **Use muted colors**: Avoid bright, distracting colors
- **Smooth motion**: Gentle movements work best
- **High quality**: Ensure crisp, clear video
- **Loop seamlessly**: End should flow into beginning

## 📱 Step 6: Mobile Considerations

### **Mobile Performance:**
- The video will automatically scale and crop for mobile devices
- Consider creating a mobile-optimized version if needed
- Test on various devices to ensure good performance

### **Fallback Options:**
- The video has a fallback message for unsupported browsers
- Consider adding a background image fallback in CSS

## 🔒 Step 7: Security and Access

### **Bucket Permissions:**
- Ensure your `magazine-assets` bucket is **public**
- Videos need public access to be displayed on the website
- Check that the `videos/` folder allows public access

### **URL Structure:**
- Your video URL should follow this pattern:
- `https://[project-id].supabase.co/storage/v1/object/public/magazine-assets/videos/[filename].mp4`

## 🚀 Step 8: Testing Your Video

### **Test Checklist:**
1. **Video loads** on the home page
2. **Video plays automatically** (muted)
3. **Video loops seamlessly**
4. **Text is readable** over the video
5. **Mobile responsiveness** works
6. **Performance is good** (no lag)

### **Browser Compatibility:**
- **Chrome**: Full support
- **Firefox**: Full support
- **Safari**: Full support
- **Edge**: Full support
- **Mobile browsers**: Full support

## 🎯 Step 9: Advanced Customization

### **Video Controls (Optional):**
If you want to add video controls, you can modify the video tag:

```html
<video autoplay muted loop playsinline controls>
    <source src="{{ hero_video_url }}" type="video/mp4">
</video>
```

### **Multiple Video Sources:**
For better compatibility, you can add multiple formats:

```html
<video autoplay muted loop playsinline>
    <source src="{{ hero_video_url }}" type="video/mp4">
    <source src="{{ hero_video_webm_url }}" type="video/webm">
    Your browser does not support the video tag.
</video>
```

## 🛠️ Troubleshooting

### **Common Issues:**

1. **Video not loading:**
   - Check the URL is correct
   - Verify bucket is public
   - Check file permissions

2. **Video not playing:**
   - Ensure video format is MP4
   - Check browser compatibility
   - Verify video file is not corrupted

3. **Performance issues:**
   - Compress the video file
   - Reduce resolution if needed
   - Check file size

4. **Mobile issues:**
   - Test on different devices
   - Check mobile data usage
   - Consider mobile-optimized version

## 📊 Analytics and Monitoring

### **Track Video Performance:**
- Monitor page load times
- Check video loading success rates
- Track user engagement with video content

### **Optimization:**
- Use video analytics to improve performance
- A/B test different video content
- Monitor mobile vs desktop performance

## 🎉 Benefits of Video Background

✅ **Modern, engaging design**  
✅ **Professional appearance**  
✅ **Better user engagement**  
✅ **Unique brand identity**  
✅ **Mobile-friendly**  
✅ **Easy to update**  

---

**Your home page now has a stunning video background that will captivate visitors and create a memorable first impression!** 🎬✨

## 📞 Support

For questions or issues with video uploads:
1. Check Supabase Storage documentation
2. Verify file permissions and URLs
3. Test video compatibility
4. Review browser console for errors

**Happy video uploading!** 🚀
