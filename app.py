from flask import Flask, render_template, request, redirect, url_for, flash, jsonify, send_from_directory
from flask_mail import Mail, Message
from datetime import datetime
import os
from config import Config
from database import get_db_service
import traceback

app = Flask(__name__)
app.config.from_object(Config)

# Initialize Flask-Mail (with error handling)
try:
    mail = Mail(app)
    email_configured = True
except Exception as e:
    print(f"Email configuration error: {e}")
    print("Email functionality will be disabled. Please check your .env file.")
    email_configured = False
    mail = None

# Database helper functions
def get_magazine_issues():
    """Get magazine issues from database with fallback to empty data"""
    try:
        db = get_db_service()
        if db:
            issues = db.get_all_issues()
            if issues:
                # Enrich issues with articles, contributors, and photos
                for issue in issues:
                    issue['featured_articles'] = db.get_articles_by_issue(issue['id'])
                    issue['contributors'] = db.get_contributors_by_issue(issue['id'])
                    issue['gallery'] = db.get_photos_by_issue(issue['id'])
                    # Ensure journal_type is set (default to 'literary' if not specified)
                    if 'journal_type' not in issue or not issue['journal_type']:
                        issue['journal_type'] = 'literary'
                return issues
    except Exception as e:
        print(f"Database error: {e}")
        traceback.print_exc()
    
    # Return empty data if database is not available
    return []

def get_moments_data():
    """Get moments data from database with fallback to empty data"""
    try:
        db = get_db_service()
        if db:
            moments = db.get_all_moments()
            if moments:
                return moments
    except Exception as e:
        print(f"Database error: {e}")
        traceback.print_exc()
    
    # Return empty data if database is not available
    return []

@app.route('/')
def home():
    issues = get_magazine_issues()
    latest_issue = issues[0] if issues else None
    # You can set these URLs from your Supabase Storage or environment variables
    club_logo_url = "https://kxxlyyqrzsxrzfwjadvg.supabase.co/storage/v1/object/public/magazine-assets/logos/fiction-poetry-club-logo.png"
    hero_video_url = "https://kxxlyyqrzsxrzfwjadvg.supabase.co/storage/v1/object/public/magazine-assets/videos/purple_background.mp4"
    return render_template('home.html', latest_issue=latest_issue, issues=issues, club_logo_url=club_logo_url, hero_video_url=hero_video_url)

@app.route('/mapao')
def mapao():
    issues = get_magazine_issues()
    latest_issue = issues[0] if issues else None
    return render_template('mapao.html', latest_issue=latest_issue, issues=issues)


@app.route('/issue/<int:issue_id>')
def issue_detail(issue_id):
    issues = get_magazine_issues()
    issue = next((issue for issue in issues if issue['id'] == issue_id), None)
    if issue is None:
        flash('Issue not found!', 'error')
        return redirect(url_for('issues'))
    
    # Organize articles by category for dropdown menu
    if 'featured_articles' in issue:
        articles_by_category = {}
        for article in issue['featured_articles']:
            category = article.get('category', 'Other')
            if category not in articles_by_category:
                articles_by_category[category] = []
            articles_by_category[category].append(article)
        issue['articles_by_category'] = articles_by_category
    
    return render_template('issue_detail.html', issue=issue)

@app.route('/about')
def about():
    try:
        db = get_db_service()
        if db:
            research_team = db.get_editorial_team('research_wing')
            literary_team = db.get_editorial_team('literary_wing')
        else:
            research_team = []
            literary_team = []
    except Exception as e:
        print(f"Error fetching editorial team: {e}")
        research_team = []
        literary_team = []
    
    return render_template('about.html', research_team=research_team, literary_team=literary_team)

@app.route('/contact', methods=['GET', 'POST'])
def contact():
    if request.method == 'POST':
        name = request.form.get('name')
        email = request.form.get('email')
        subject = request.form.get('subject', 'General Inquiry')
        message = request.form.get('message')
        
        if name and email and message:
            if email_configured and mail:
                try:
                    # Send email to the club
                    msg = Message(
                        subject=f"Contact Form: {subject}",
                        sender=app.config['MAIL_DEFAULT_SENDER'],
                        recipients=['mapaoliteraryjournal@gmail.com'],
                        reply_to=email
                    )
                    msg.body = f"""
Name: {name}
Email: {email}
Subject: {subject}

Message:
{message}

---
This message was sent from the Fiction & Poetry Club Manipur website contact form.
                    """
                    mail.send(msg)
                    
                    # Send confirmation email to the user
                    confirmation_msg = Message(
                        subject="Thank you for contacting Fiction & Poetry Club Manipur",
                        sender=app.config['MAIL_DEFAULT_SENDER'],
                        recipients=[email]
                    )
                    confirmation_msg.body = f"""
Dear {name},

Thank you for contacting Fiction & Poetry Club Manipur. We have received your message and will get back to you soon.

Your message:
{message}

Best regards,
Fiction & Poetry Club Manipur
                    """
                    mail.send(confirmation_msg)
                    
                    flash('Thank you for your message! We\'ll get back to you soon.', 'success')
                    return redirect(url_for('contact'))
                    
                except Exception as e:
                    print(f"Email sending failed: {e}")
                    flash('Sorry, there was an error sending your message. Please try again later.', 'error')
                    return redirect(url_for('contact'))
            else:
                # Email not configured - just show success message
                print(f"Contact form submission (email disabled): {name} - {email} - {message}")
                flash('Thank you for your message! We\'ll get back to you soon.', 'success')
                return redirect(url_for('contact'))
        else:
            flash('Please fill in all required fields.', 'error')
    
    return render_template('contact.html')

@app.route('/subscribe', methods=['POST'])
def subscribe():
    email = request.form.get('email')
    if email:
        if email_configured and mail:
            try:
                # Send confirmation email to subscriber
                msg = Message(
                    subject="Welcome to Fiction & Poetry Club Manipur Newsletter",
                    sender=app.config['MAIL_DEFAULT_SENDER'],
                    recipients=[email]
                )
                msg.body = f"""
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
                """
                mail.send(msg)
                
                # In a real app, you would also save this to a database
                flash('Thank you for subscribing! Check your email for confirmation.', 'success')
                
            except Exception as e:
                print(f"Subscription email failed: {e}")
                flash('Thank you for subscribing! (Email confirmation may be delayed)', 'success')
        else:
            # Email not configured - just show success message
            print(f"Newsletter subscription (email disabled): {email}")
            flash('Thank you for subscribing!', 'success')
    else:
        flash('Please provide a valid email address.', 'error')
    
    # Redirect to the page they came from
    referrer = request.referrer
    if referrer and 'mapao' in referrer:
        return redirect(url_for('mapao'))
    else:
        return redirect(url_for('home'))

@app.route('/moments')
def moments():
    moments_data = get_moments_data()
    return render_template('moments.html', moments=moments_data)

@app.route('/favicon.ico')
def favicon():
    return send_from_directory(os.path.join(app.root_path, 'static'), 'favicon.ico', mimetype='image/vnd.microsoft.icon')

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)