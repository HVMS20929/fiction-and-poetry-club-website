// Mobile Navigation Toggle
document.addEventListener('DOMContentLoaded', function() {
    const hamburger = document.querySelector('.hamburger');
    const navMenu = document.querySelector('.nav-menu');

    if (hamburger && navMenu) {
        hamburger.addEventListener('click', function() {
            hamburger.classList.toggle('active');
            navMenu.classList.toggle('active');
        });

        // Close mobile menu when clicking on a link
        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', () => {
                hamburger.classList.remove('active');
                navMenu.classList.remove('active');
            });
        });
    }

    // Flash Message Handling
    const flashMessages = document.querySelectorAll('.flash-message');
    flashMessages.forEach(message => {
        const closeBtn = message.querySelector('.close-flash');
        if (closeBtn) {
            closeBtn.addEventListener('click', () => {
                message.style.animation = 'slideOut 0.3s ease forwards';
                setTimeout(() => {
                    message.remove();
                }, 300);
            });
        }

        // Auto-remove flash messages after 5 seconds
        setTimeout(() => {
            if (message.parentNode) {
                message.style.animation = 'slideOut 0.3s ease forwards';
                setTimeout(() => {
                    if (message.parentNode) {
                        message.remove();
                    }
                }, 300);
            }
        }, 5000);
    });

    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Issues Filtering
    const yearFilter = document.getElementById('year-filter');
    const seasonFilter = document.getElementById('season-filter');
    const issueCards = document.querySelectorAll('.issue-card-large');

    function filterIssues() {
        const selectedYear = yearFilter ? yearFilter.value : '';
        const selectedSeason = seasonFilter ? seasonFilter.value : '';
        const selectedType = document.querySelector('.journal-tab.active') ? document.querySelector('.journal-tab.active').dataset.type : 'all';

        issueCards.forEach(card => {
            const year = card.dataset.year;
            const season = card.dataset.season;
            const type = card.dataset.type;
            
            let showCard = true;

            if (selectedYear && year !== selectedYear) {
                showCard = false;
            }

            if (selectedSeason && season !== selectedSeason) {
                showCard = false;
            }

            if (selectedType !== 'all' && type !== selectedType) {
                showCard = false;
            }

            if (showCard) {
                card.style.display = 'block';
                card.style.animation = 'fadeIn 0.5s ease';
            } else {
                card.style.display = 'none';
            }
        });
    }

    if (yearFilter) {
        yearFilter.addEventListener('change', filterIssues);
    }

    if (seasonFilter) {
        seasonFilter.addEventListener('change', filterIssues);
    }

    // Journal Type Tabs
    const journalTabs = document.querySelectorAll('.journal-tab');
    journalTabs.forEach(tab => {
        tab.addEventListener('click', function() {
            // Remove active class from all tabs
            journalTabs.forEach(t => t.classList.remove('active'));
            // Add active class to clicked tab
            this.classList.add('active');
            // Filter issues
            filterIssues();
        });
    });

    // Share Button Functionality
    const shareButtons = document.querySelectorAll('.share-btn');
    shareButtons.forEach(button => {
        button.addEventListener('click', function() {
            const issueTitle = this.dataset.issue || 'Mapao Magazine';
            const url = window.location.href;
            const text = `Check out "${issueTitle}" from Mapao Magazine!`;
            
            if (navigator.share) {
                navigator.share({
                    title: issueTitle,
                    text: text,
                    url: url
                });
            } else {
                // Fallback: copy to clipboard
                const shareText = `${text} ${url}`;
                navigator.clipboard.writeText(shareText).then(() => {
                    showNotification('Link copied to clipboard!', 'success');
                }).catch(() => {
                    // Fallback for older browsers
                    const textArea = document.createElement('textarea');
                    textArea.value = shareText;
                    document.body.appendChild(textArea);
                    textArea.select();
                    document.execCommand('copy');
                    document.body.removeChild(textArea);
                    showNotification('Link copied to clipboard!', 'success');
                });
            }
        });
    });

    // Form Validation and Enhancement
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            const requiredFields = form.querySelectorAll('[required]');
            let isValid = true;

            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    isValid = false;
                    field.style.borderColor = '#e74c3c';
                    field.classList.add('error');
                } else {
                    field.style.borderColor = '#ddd';
                    field.classList.remove('error');
                }
            });

            if (!isValid) {
                e.preventDefault();
                showNotification('Please fill in all required fields.', 'error');
            }
        });

        // Real-time validation
        const inputs = form.querySelectorAll('input, textarea, select');
        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                if (this.hasAttribute('required') && !this.value.trim()) {
                    this.style.borderColor = '#e74c3c';
                    this.classList.add('error');
                } else {
                    this.style.borderColor = '#ddd';
                    this.classList.remove('error');
                }
            });

            input.addEventListener('input', function() {
                if (this.classList.contains('error') && this.value.trim()) {
                    this.style.borderColor = '#ddd';
                    this.classList.remove('error');
                }
            });
        });
    });

    // Newsletter Section Animation
    const newsletterSection = document.querySelector('.newsletter-section');
    if (newsletterSection) {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.animation = 'fadeInUp 0.8s ease';
                }
            });
        });

        observer.observe(newsletterSection);
    }

    // Parallax effect for hero section
    const hero = document.querySelector('.hero');
    if (hero) {
        window.addEventListener('scroll', () => {
            const scrolled = window.pageYOffset;
            const rate = scrolled * -0.5;
            hero.style.transform = `translateY(${rate}px)`;
        });
    }

    // Lazy loading for images (if any are added later)
    const images = document.querySelectorAll('img[data-src]');
    if (images.length > 0) {
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    img.src = img.dataset.src;
                    img.classList.remove('lazy');
                    imageObserver.unobserve(img);
                }
            });
        });

        images.forEach(img => imageObserver.observe(img));
    }

    // Table of Contents highlighting
    const tocLinks = document.querySelectorAll('.toc-nav a');
    const sections = document.querySelectorAll('article[id], section[id]');

    if (tocLinks.length > 0 && sections.length > 0) {
        window.addEventListener('scroll', () => {
            let current = '';
            sections.forEach(section => {
                const sectionTop = section.offsetTop;
                const sectionHeight = section.clientHeight;
                if (window.pageYOffset >= sectionTop - 200) {
                    current = section.getAttribute('id');
                }
            });

            tocLinks.forEach(link => {
                link.classList.remove('active');
                if (link.getAttribute('href') === `#${current}`) {
                    link.classList.add('active');
                }
            });
        });
    }
});

// Utility Functions
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `flash-message ${type}`;
    notification.innerHTML = `
        ${message}
        <span class="close-flash">&times;</span>
    `;

    const flashContainer = document.querySelector('.flash-messages') || createFlashContainer();
    flashContainer.appendChild(notification);

    // Add close functionality
    const closeBtn = notification.querySelector('.close-flash');
    closeBtn.addEventListener('click', () => {
        notification.style.animation = 'slideOut 0.3s ease forwards';
        setTimeout(() => notification.remove(), 300);
    });

    // Auto-remove after 5 seconds
    setTimeout(() => {
        if (notification.parentNode) {
            notification.style.animation = 'slideOut 0.3s ease forwards';
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.remove();
                }
            }, 300);
        }
    }, 5000);
}

function createFlashContainer() {
    const container = document.createElement('div');
    container.className = 'flash-messages';
    document.body.appendChild(container);
    return container;
}

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .toc-nav a.active {
        color: #e74c3c !important;
        font-weight: 600;
    }

    .form-group input.error,
    .form-group textarea.error,
    .form-group select.error {
        border-color: #e74c3c !important;
        box-shadow: 0 0 0 2px rgba(231, 76, 60, 0.2);
    }

    .hamburger.active .bar:nth-child(2) {
        opacity: 0;
    }

    .hamburger.active .bar:nth-child(1) {
        transform: translateY(8px) rotate(45deg);
    }

    .hamburger.active .bar:nth-child(3) {
        transform: translateY(-8px) rotate(-45deg);
    }
`;
document.head.appendChild(style);

// Performance optimization: Debounce scroll events
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Apply debouncing to scroll events
const debouncedScrollHandler = debounce(() => {
    // Scroll-based animations and effects
    const navbar = document.querySelector('.navbar');
    if (navbar) {
        if (window.scrollY > 100) {
            navbar.style.background = '#493D9E';
            navbar.style.boxShadow = '0 2px 20px rgba(0, 0, 0, 0.1)';
        } else {
            navbar.style.background = '#493D9E';
            navbar.style.boxShadow = 'none';
        }
    }
}, 10);

window.addEventListener('scroll', debouncedScrollHandler);

// Initialize tooltips for better UX
function initTooltips() {
    const elementsWithTooltips = document.querySelectorAll('[data-tooltip]');
    elementsWithTooltips.forEach(element => {
        element.addEventListener('mouseenter', function() {
            const tooltip = document.createElement('div');
            tooltip.className = 'tooltip';
            tooltip.textContent = this.dataset.tooltip;
            tooltip.style.cssText = `
                position: absolute;
                background: #333;
                color: white;
                padding: 8px 12px;
                border-radius: 4px;
                font-size: 14px;
                z-index: 1000;
                pointer-events: none;
                white-space: nowrap;
            `;
            
            document.body.appendChild(tooltip);
            
            const rect = this.getBoundingClientRect();
            tooltip.style.left = rect.left + (rect.width / 2) - (tooltip.offsetWidth / 2) + 'px';
            tooltip.style.top = rect.top - tooltip.offsetHeight - 8 + 'px';
        });
        
        element.addEventListener('mouseleave', function() {
            const tooltip = document.querySelector('.tooltip');
            if (tooltip) {
                tooltip.remove();
            }
        });
    });
}

// Initialize tooltips when DOM is loaded
document.addEventListener('DOMContentLoaded', initTooltips);

// Hero Title Animation
function initHeroTitleAnimation() {
    const titles = document.querySelectorAll('.hero-title');
    let currentIndex = 0;
    
    if (titles.length === 0) return;
    
    function showNextTitle() {
        // Hide current title
        titles[currentIndex].classList.remove('active');
        
        // Move to next title
        currentIndex = (currentIndex + 1) % titles.length;
        
        // Show next title
        titles[currentIndex].classList.add('active');
    }
    
    // Start the animation after initial load
    setTimeout(() => {
        setInterval(showNextTitle, 3000); // Change every 3 seconds
    }, 2000); // Wait 2 seconds before starting
}

// Initialize hero title animation when DOM is loaded
document.addEventListener('DOMContentLoaded', initHeroTitleAnimation);

// TOC Section Dropdown Toggle
document.addEventListener('DOMContentLoaded', function() {
    // TOC Section Dropdown functionality
    const tocToggleBtns = document.querySelectorAll('.toc-toggle-btn');
    
    tocToggleBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const sectionId = this.getAttribute('data-section');
            const sectionContent = document.getElementById(sectionId);
            
            if (sectionContent) {
                const isVisible = sectionContent.style.display !== 'none';
                
                if (isVisible) {
                    sectionContent.style.display = 'none';
                    this.classList.remove('expanded');
                } else {
                    sectionContent.style.display = 'block';
                    this.classList.add('expanded');
                }
            }
        });
    });

    // Article Content Switching functionality
    const articleSwitchLinks = document.querySelectorAll('.article-switch-link');
    
    articleSwitchLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            const articleId = this.getAttribute('data-article-id');
            const category = this.getAttribute('data-category');
            
            // Hide all articles in the same category
            const articlesInCategory = document.querySelectorAll(`[data-category="${category}"]`);
            articlesInCategory.forEach(article => {
                article.style.display = 'none';
            });
            
            // Show the selected article
            const selectedArticle = document.getElementById(articleId);
            if (selectedArticle) {
                selectedArticle.style.display = 'block';
                
                // Scroll to the article smoothly
                selectedArticle.scrollIntoView({ 
                    behavior: 'smooth', 
                    block: 'start',
                    inline: 'nearest'
                });
            }
            
            // Update active states in TOC
            // Remove active state from all links in this category
            const categoryLinks = document.querySelectorAll(`[data-category="${category}"]`);
            categoryLinks.forEach(link => {
                if (link.classList.contains('article-switch-link')) {
                    link.removeAttribute('data-active');
                }
            });
            
            // Add active state to clicked link
            this.setAttribute('data-active', 'true');
        });
    });
}); 