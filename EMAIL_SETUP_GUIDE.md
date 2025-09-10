# 📧 Email Setup Guide for Fiction & Poetry Club Manipur

This guide will help you set up email functionality for the contact form and newsletter subscription.

## 🎯 Email Features

### **Contact Form**
- Visitors can send messages to `mapaoliteraryjournal@gmail.com`
- Automatic confirmation email sent to the visitor
- Professional email formatting with all form details

### **Newsletter Subscription**
- Visitors can subscribe to the newsletter from any page
- Welcome email sent to new subscribers
- Confirmation of subscription with details about what they'll receive

## 🔧 Setup Instructions

### **Step 1: Install Dependencies**
```bash
pip install Flask-Mail==0.9.1
```

### **Step 2: Configure Gmail App Password**

1. **Enable 2-Factor Authentication** on your Gmail account
2. **Go to Google Account Settings**:
   - Visit: https://myaccount.google.com/
   - Click "Security" in the left sidebar
   - Under "Signing in to Google", click "2-Step Verification"
   - Make sure it's enabled

3. **Generate App Password**:
   - Still in Security settings, scroll down to "App passwords"
   - Click "App passwords"
   - Select "Mail" and "Other (Custom name)"
   - Enter "Fiction Poetry Club Website"
   - Click "Generate"
   - **Copy the 16-character password** (you'll need this)

### **Step 3: Create .env File**

Create a `.env` file in your project root with:

```env
# Supabase Configuration
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_KEY=your-anon-key-here

# Flask Configuration
SECRET_KEY=your-secret-key-here
FLASK_ENV=development
FLASK_DEBUG=1

# Email Configuration
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USE_TLS=true
MAIL_USERNAME=mapaoliteraryjournal@gmail.com
MAIL_PASSWORD=your-16-character-app-password-here
MAIL_DEFAULT_SENDER=mapaoliteraryjournal@gmail.com
```

**Important**: Replace `your-16-character-app-password-here` with the actual app password from Step 2.

### **Step 4: Test Email Functionality**

1. **Start the application**:
   ```bash
   python app.py
   ```

2. **Test Contact Form**:
   - Go to `/contact`
   - Fill out the form with your email
   - Submit and check both:
     - Your email for confirmation
     - `mapaoliteraryjournal@gmail.com` for the message

3. **Test Newsletter Subscription**:
   - Go to any page with subscribe form
   - Enter your email and subscribe
   - Check your email for welcome message

## 📧 Email Templates

### **Contact Form Email (to Club)**
```
Subject: Contact Form: [Subject]

Name: [Visitor Name]
Email: [Visitor Email]
Subject: [Subject]

Message:
[Visitor Message]

---
This message was sent from the Fiction & Poetry Club Manipur website contact form.
```

### **Contact Form Confirmation (to Visitor)**
```
Subject: Thank you for contacting Fiction & Poetry Club Manipur

Dear [Name],

Thank you for contacting Fiction & Poetry Club Manipur. We have received your message and will get back to you soon.

Your message:
[Message]

Best regards,
Fiction & Poetry Club Manipur
```

### **Newsletter Welcome Email**
```
Subject: Welcome to Fiction & Poetry Club Manipur Newsletter

Dear Subscriber,

Thank you for subscribing to the Fiction & Poetry Club Manipur newsletter!

You will now receive:
- Updates about new Mapao journal issues
- Information about literary events and workshops
- Behind-the-scenes content from our community
- Exclusive content and early access to publications

We're excited to have you as part of our literary community.

Best regards,
Fiction & Poetry Club Manipur
```

## 🔍 Troubleshooting

### **Common Issues**

1. **"Authentication failed" error**:
   - Make sure you're using an App Password, not your regular Gmail password
   - Ensure 2-Factor Authentication is enabled
   - Double-check the 16-character app password

2. **"Connection refused" error**:
   - Check your internet connection
   - Verify MAIL_SERVER and MAIL_PORT settings
   - Ensure MAIL_USE_TLS is set to true

3. **Emails not being sent**:
   - Check the console for error messages
   - Verify all email configuration in .env file
   - Test with a simple email first

4. **"SMTPAuthenticationError"**:
   - Regenerate the App Password
   - Make sure the email address is correct
   - Check if 2FA is properly enabled

### **Testing Steps**

1. **Check Console Logs**:
   - Look for any error messages when submitting forms
   - Email errors will be printed to the console

2. **Verify Configuration**:
   - Print email settings (temporarily) to verify they're loaded correctly
   - Test with a simple email first

3. **Gmail Security**:
   - Check Gmail's "Less secure app access" (if using older method)
   - Ensure App Passwords are enabled

## 🚀 Production Considerations

### **For Production Deployment**

1. **Use Environment Variables**:
   - Never hardcode passwords in your code
   - Use your hosting platform's environment variable system

2. **Email Service Providers**:
   - Consider using SendGrid, Mailgun, or AWS SES for production
   - These services are more reliable than SMTP for high volume

3. **Rate Limiting**:
   - Implement rate limiting to prevent spam
   - Add CAPTCHA for contact forms

4. **Email Templates**:
   - Use HTML email templates for better formatting
   - Add unsubscribe links for newsletters

## 📱 Mobile Considerations

- Email forms work on all devices
- Flash messages are responsive
- Contact form is mobile-friendly

## 🔒 Security Notes

- App passwords are more secure than regular passwords
- Never commit .env files to version control
- Use HTTPS in production for secure email transmission
- Consider implementing email validation and sanitization

## ✅ Success Checklist

- [ ] Gmail 2FA enabled
- [ ] App password generated
- [ ] .env file created with correct settings
- [ ] Flask-Mail installed
- [ ] Contact form sends emails
- [ ] Newsletter subscription works
- [ ] Confirmation emails received
- [ ] Error handling works properly

## 📞 Support

If you encounter issues:

1. Check the console logs for error messages
2. Verify your .env file configuration
3. Test with a simple email first
4. Ensure Gmail settings are correct
5. Check internet connectivity

---

**Your email system is now ready to handle contact form submissions and newsletter subscriptions!** 📧✨
