#!/usr/bin/env python3
"""
Test script for email functionality
Run this to test if email configuration is working
"""

import os
from dotenv import load_dotenv
from flask import Flask
from flask_mail import Mail, Message

# Load environment variables
load_dotenv()

# Create Flask app
app = Flask(__name__)

# Email configuration
app.config['MAIL_SERVER'] = os.environ.get('MAIL_SERVER') or 'smtp.gmail.com'
app.config['MAIL_PORT'] = int(os.environ.get('MAIL_PORT') or 587)
app.config['MAIL_USE_TLS'] = os.environ.get('MAIL_USE_TLS', 'true').lower() in ['true', 'on', '1']
app.config['MAIL_USERNAME'] = os.environ.get('MAIL_USERNAME') or 'mapaoliteraryjournal@gmail.com'
app.config['MAIL_PASSWORD'] = os.environ.get('MAIL_PASSWORD')
app.config['MAIL_DEFAULT_SENDER'] = os.environ.get('MAIL_DEFAULT_SENDER') or 'mapaoliteraryjournal@gmail.com'

# Initialize Flask-Mail
mail = Mail(app)

def test_email():
    """Test email sending functionality"""
    try:
        with app.app_context():
            # Test email
            msg = Message(
                subject="Test Email from Fiction & Poetry Club Website",
                sender=app.config['MAIL_DEFAULT_SENDER'],
                recipients=['mapaoliteraryjournal@gmail.com']
            )
            msg.body = """
This is a test email from the Fiction & Poetry Club Manipur website.

If you receive this email, the email configuration is working correctly!

Test details:
- Contact form emails will be sent to: mapaoliteraryjournal@gmail.com
- Newsletter subscriptions will send welcome emails
- All emails are sent from: mapaoliteraryjournal@gmail.com

Best regards,
Fiction & Poetry Club Website Test
            """
            
            print("Sending test email...")
            mail.send(msg)
            print("✅ Test email sent successfully!")
            print("Check mapaoliteraryjournal@gmail.com for the test email.")
            
    except Exception as e:
        print(f"❌ Email test failed: {e}")
        print("\nTroubleshooting:")
        print("1. Make sure you have a .env file with correct email settings")
        print("2. Verify your Gmail App Password is correct")
        print("3. Check that 2-Factor Authentication is enabled on Gmail")
        print("4. Ensure MAIL_PASSWORD is set in your .env file")

if __name__ == "__main__":
    print("Testing email configuration...")
    print(f"Mail Server: {app.config['MAIL_SERVER']}")
    print(f"Mail Port: {app.config['MAIL_PORT']}")
    print(f"Mail Username: {app.config['MAIL_USERNAME']}")
    print(f"Mail Password: {'*' * len(app.config['MAIL_PASSWORD']) if app.config['MAIL_PASSWORD'] else 'NOT SET'}")
    print()
    
    test_email()
