# Fiction and Poetry Club Manipur - Web Application

A beautiful, modern web application for Fiction and Poetry Club Manipur, featuring their flagship publication "Mapao" journal. Built with Flask and featuring a responsive design, this application showcases the club's activities, magazine issues, and provides an engaging user experience for the literary community.

## Features

### 🎨 **Modern Design**
- Clean, elegant interface with beautiful typography
- Responsive design that works on all devices
- Smooth animations and transitions
- Professional color scheme and layout

### 📚 **Magazine Management**
- Display latest and past issues
- Detailed issue pages with table of contents
- Featured articles showcase
- Issue filtering by year and season

### 📧 **User Engagement**
- Newsletter subscription system
- Contact form with validation
- Social media integration
- Share functionality for issues

### 🔧 **Technical Features**
- Mobile-responsive navigation
- Flash message system
- Form validation
- Smooth scrolling
- Interactive elements

## Pages

1. **Homepage** - Fiction and Poetry Club Manipur landing page with club information, activities, and leadership
2. **Mapao** - Complete journal catalog with filtering, latest issue showcase, and all publications
3. **Moments & Milestones** - Past activities and memories of the club
4. **About** - Club history, mission, team, and publication process
5. **Contact** - Contact form, office information, and FAQ
6. **Issue Detail** - Full issue content with table of contents

## Technology Stack

- **Backend**: Flask (Python)
- **Frontend**: HTML5, CSS3, JavaScript
- **Styling**: Custom CSS with modern design principles
- **Icons**: Font Awesome
- **Fonts**: Google Fonts (Playfair Display, Inter)

## Installation & Setup

### Prerequisites
- Python 3.7 or higher
- pip (Python package installer)

### Step 1: Clone or Download
```bash
# If using git
git clone <repository-url>
cd Mapao_web_app

# Or download and extract the files to your desired directory
```

### Step 2: Set Up Virtual Environment
```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate

# On macOS/Linux:
source venv/bin/activate
```

### Step 3: Install Dependencies
```bash
pip install -r requirements.txt
```

### Step 4: Run the Application
```bash
python app.py
```

### Step 5: Access the Application
Open your web browser and navigate to:
```
http://localhost:5000
```

## Project Structure

```
Mapao_web_app/
├── app.py                 # Main Flask application
├── requirements.txt       # Python dependencies
├── README.md             # Project documentation
├── static/
│   ├── style.css         # Main stylesheet
│   └── script.js         # JavaScript functionality
└── templates/
    ├── home.html         # Fiction and Poetry Club homepage
    ├── mapao.html        # Mapao journal section (includes all issues)
    ├── issue_detail.html # Individual issue page
    ├── moments.html      # Moments & Milestones page
    ├── about.html        # About page
    └── contact.html      # Contact page
```

## Configuration

### Adding New Issues
To add new magazine issues, edit the `magazine_issues` list in `app.py`:

```python
magazine_issues = [
    {
        'id': 4,
        'title': 'Fall/Winter 2024',
        'cover_image': 'issue-fall-2024.jpg',
        'description': 'Your issue description here.',
        'release_date': 'September 2024',
        'featured_articles': ['Article 1', 'Article 2', 'Article 3']
    },
    # ... more issues
]
```

### Customizing Content
- **Templates**: Edit HTML files in the `templates/` directory
- **Styling**: Modify `static/style.css` for design changes
- **Functionality**: Update `static/script.js` for interactive features

## Features in Detail

### Responsive Design
- Mobile-first approach
- Breakpoints for tablets and desktops
- Touch-friendly navigation

### Interactive Elements
- Hover effects on cards and buttons
- Smooth scrolling navigation
- Animated page transitions
- Form validation with real-time feedback

### Content Management
- Dynamic issue display
- Filtering and sorting capabilities
- Search functionality (can be extended)
- Pagination support (can be added)

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## Future Enhancements

### Potential Additions
- **Admin Panel**: Content management system
- **Database Integration**: SQLite, PostgreSQL, or MongoDB
- **User Authentication**: Member accounts and preferences
- **Search Functionality**: Full-text search across issues
- **Image Gallery**: Enhanced photo galleries
- **Comments System**: Reader engagement features
- **Analytics**: Visitor tracking and insights
- **Email Integration**: Automated newsletter delivery

### Technical Improvements
- **Performance**: Image optimization and lazy loading
- **SEO**: Meta tags and structured data
- **Accessibility**: WCAG compliance improvements
- **Security**: CSRF protection and input sanitization
- **Caching**: Redis integration for better performance

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is open source and available under the [MIT License](LICENSE).

## Support

For questions or support, please contact:
- Email: hello@mapaomagazine.com
- Website: [Mapao Magazine](http://localhost:5000)

## Acknowledgments

- **Flask**: Web framework
- **Font Awesome**: Icons
- **Google Fonts**: Typography
- **CSS Grid & Flexbox**: Layout system

---

**Mapao Magazine** - Celebrating art, culture, and innovation through bi-annual publications.

*Built with ❤️ for the creative community* 