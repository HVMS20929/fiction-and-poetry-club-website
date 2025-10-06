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
            const href = this.getAttribute('href');
            
            // Skip if href is just '#' (invalid selector)
            if (href === '#') {
                e.preventDefault();
                return;
            }
            
            e.preventDefault();
            const target = document.querySelector(href);
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

    // Note: Removed old scroll-based highlighting to prevent conflicts with content switching
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
        btn.addEventListener('click', function(e) {
            e.stopPropagation(); // Prevent event bubbling
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

    // Prevent dropdown from closing when clicking inside dropdown content
    const tocSectionContents = document.querySelectorAll('.toc-section-content');
    tocSectionContents.forEach(content => {
        content.addEventListener('click', function(e) {
            e.stopPropagation(); // Prevent event bubbling to parent elements
        });
    });

    // Prevent section header from interfering with dropdown
    const tocSectionHeaders = document.querySelectorAll('.toc-section-header');
    tocSectionHeaders.forEach(header => {
        header.addEventListener('click', function(e) {
            // Only allow toggle button to handle the click
            if (e.target.classList.contains('toc-toggle-btn') || e.target.closest('.toc-toggle-btn')) {
                return; // Let the toggle button handle it
            }
            e.stopPropagation(); // Prevent other clicks from interfering
        });
    });

    // Content Section Navigation and Article Switching
    const tocNavLinks = document.querySelectorAll('.toc-nav-link');
    const articleSwitchLinks = document.querySelectorAll('.article-switch-link');

    // Function to clear all active states
    function clearAllActiveStates() {
        // Remove active class from all navigation links
        const allNavLinks = document.querySelectorAll('.toc-nav-link');
        allNavLinks.forEach(navLink => navLink.classList.remove('active'));
        
        // Remove active class from all article switch links
        const allArticleLinks = document.querySelectorAll('.article-switch-link');
        allArticleLinks.forEach(articleLink => articleLink.classList.remove('active'));
    }

    // Ensure active states persist on scroll
    window.addEventListener('scroll', function() {
        // Prevent any scroll-based interference with our active states
        // The active classes should remain unless explicitly changed by user interaction
    });

    // Add a more robust state management system
    let currentActiveElement = null;
    
    function setActiveElement(element, type) {
        // Clear ALL active states from ALL possible elements
        clearAllActiveStates();
        
        // Set new active element
        currentActiveElement = element;
        element.classList.add('active');
        
        // Store the active state in a data attribute for persistence
        element.setAttribute('data-persistent-active', 'true');
    }

    // Initialize page state - show editorial by default and set it as active
    function initializePageState() {
        // Hide all content sections first
        const contentSections = document.querySelectorAll('.content-section');
        contentSections.forEach(section => {
            section.style.display = 'none';
        });
        
        // Show editorial section by default
        const editorialSection = document.querySelector('[data-section="editorial"]');
        if (editorialSection) {
            editorialSection.style.display = 'block';
        }
        
        // Set editorial nav link as active by default
        const editorialNavLink = document.querySelector('[data-section="editorial"]');
        if (editorialNavLink) {
            setActiveElement(editorialNavLink, 'nav');
        }
    }
    
    // Initialize the page
    initializePageState();

    // Enhanced click handlers that use the new state management
    tocNavLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            const section = this.getAttribute('data-section');
            setActiveElement(this, 'nav');
            
            // Hide all content sections
            const contentSections = document.querySelectorAll('.content-section');
            contentSections.forEach(section => {
                section.style.display = 'none';
            });
            
            // Show the selected section
            const targetSection = document.querySelector(`[data-section="${section}"]`);
            if (targetSection) {
                setTimeout(() => {
                    targetSection.style.display = 'block';
                    // Scroll to top of the main content area with offset for title visibility
                    const mainContent = document.querySelector('.issue-main-content');
                    if (mainContent) {
                        const offset = -100; // Scroll 100px higher than the element
                        const elementPosition = mainContent.offsetTop;
                        const offsetPosition = elementPosition + offset;
                        
                        window.scrollTo({
                            top: offsetPosition,
                            behavior: 'smooth'
                        });
                    }
                }, 150);
            }
        });
    });

    articleSwitchLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            const category = this.getAttribute('data-category');
            const articleId = this.getAttribute('data-article');
            
            // Set the sub-item as active
            setActiveElement(this, 'article');
            
            // Hide all content sections first
            const contentSections = document.querySelectorAll('.content-section');
            contentSections.forEach(section => {
                section.style.display = 'none';
            });
            
            // Hide all articles in the same category
            const categoryArticles = document.querySelectorAll(`.category-article[data-category="${category}"]`);
            categoryArticles.forEach(article => {
                article.style.display = 'none';
                article.classList.add('hidden');
            });
            
            // Show the selected article
            const targetArticle = document.getElementById(articleId);
            if (targetArticle) {
                setTimeout(() => {
                    targetArticle.style.display = 'block';
                    targetArticle.classList.remove('hidden');
                    // Scroll to top of the main content area with offset for title visibility
                    const mainContent = document.querySelector('.issue-main-content');
                    if (mainContent) {
                        const offset = -100; // Scroll 100px higher than the element
                        const elementPosition = mainContent.offsetTop;
                        const offsetPosition = elementPosition + offset;
                        
                        window.scrollTo({
                            top: offsetPosition,
                            behavior: 'smooth'
                        });
                    }
                }, 150);
            }
            
            // Also set the parent category as active in the main navigation
            const categoryNavLink = document.querySelector(`[data-section="${category}"]`);
            if (categoryNavLink) {
                categoryNavLink.classList.add('active');
                categoryNavLink.setAttribute('data-persistent-active', 'true');
            }
        });
    });
});

// ========================================
// AWARDS PAGE FUNCTIONALITY
// ========================================

// Year filtering for awards
document.addEventListener('DOMContentLoaded', function() {
    const yearBtns = document.querySelectorAll('.year-btn');
    const awardCards = document.querySelectorAll('.award-card');
    
    if (yearBtns.length > 0 && awardCards.length > 0) {
        yearBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                // Remove active class from all buttons
                yearBtns.forEach(b => b.classList.remove('active'));
                // Add active class to clicked button
                this.classList.add('active');
                
                const selectedYear = this.getAttribute('data-year');
                
                awardCards.forEach(card => {
                    const cardYear = card.getAttribute('data-year');
                    
                    if (selectedYear === 'all' || cardYear === selectedYear) {
                        card.style.display = 'block';
                        card.style.animation = 'fadeIn 0.5s ease';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        });
    }
});

// ========================================
// WHO'S WHO PAGE FUNCTIONALITY
// ========================================

// Alphabet filtering for who's who
document.addEventListener('DOMContentLoaded', function() {
    const alphabetBtns = document.querySelectorAll('.alphabet-btn');
    const personCards = document.querySelectorAll('.person-card');
    const searchInput = document.getElementById('search-input');
    
    // Show all cards by default
    if (personCards.length > 0) {
        personCards.forEach(card => {
            card.classList.add('show');
        });
    }
    
    // Alphabet filtering
    if (alphabetBtns.length > 0 && personCards.length > 0) {
        alphabetBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                // Remove active class from all buttons
                alphabetBtns.forEach(b => b.classList.remove('active'));
                // Add active class to clicked button
                this.classList.add('active');
                
                const selectedLetter = this.getAttribute('data-letter');
                
                personCards.forEach(card => {
                    const cardLetter = card.getAttribute('data-letter');
                    
                    if (selectedLetter === 'all' || cardLetter === selectedLetter) {
                        card.classList.add('show');
                        card.style.animation = 'fadeIn 0.5s ease';
                    } else {
                        card.classList.remove('show');
                    }
                });
            });
        });
    }
    
    // Search functionality
    if (searchInput && personCards.length > 0) {
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase().trim();
            
            personCards.forEach(card => {
                const personName = card.getAttribute('data-name');
                const personInfo = card.querySelector('.person-info');
                const personBio = personInfo ? personInfo.textContent.toLowerCase() : '';
                
                if (searchTerm === '' || 
                    personName.includes(searchTerm) || 
                    personBio.includes(searchTerm)) {
                    card.classList.add('show');
                    card.style.animation = 'fadeIn 0.5s ease';
                } else {
                    card.classList.remove('show');
                }
            });
            
            // Update alphabet buttons based on search results
            updateAlphabetButtons();
        });
    }
    
    function updateAlphabetButtons() {
        const visibleCards = Array.from(personCards).filter(card => 
            card.classList.contains('show')
        );
        
        const visibleLetters = new Set();
        visibleCards.forEach(card => {
            visibleLetters.add(card.getAttribute('data-letter'));
        });
        
        alphabetBtns.forEach(btn => {
            const letter = btn.getAttribute('data-letter');
            if (letter === 'all') {
                btn.style.display = 'inline-block';
            } else if (visibleLetters.has(letter)) {
                btn.style.display = 'inline-block';
                btn.style.opacity = '1';
            } else {
                btn.style.opacity = '0.3';
            }
        });
    }
});

// ========================================
// LIGHTBOX FUNCTIONALITY
// ========================================

// Lightbox functionality for ceremony photos
function openLightbox(imageSrc) {
    const lightbox = document.getElementById('lightbox');
    const lightboxImg = document.getElementById('lightbox-img');
    
    if (lightbox && lightboxImg) {
        lightboxImg.src = imageSrc;
        lightbox.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }
}

function closeLightbox() {
    const lightbox = document.getElementById('lightbox');
    
    if (lightbox) {
        lightbox.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
}

// Close lightbox when clicking outside the image
document.addEventListener('click', function(e) {
    const lightbox = document.getElementById('lightbox');
    if (lightbox && e.target === lightbox) {
        closeLightbox();
    }
});

// Close lightbox when pressing Escape key
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeLightbox();
    }
});

// ========================================
// SMOOTH SCROLLING FOR INTERNAL LINKS
// ========================================

document.addEventListener('DOMContentLoaded', function() {
    // Smooth scrolling for anchor links within the same page
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const href = this.getAttribute('href');
            
            // Skip if href is just '#' (invalid selector)
            if (href === '#') {
                e.preventDefault();
                return;
            }
            
            e.preventDefault();
            const target = document.querySelector(href);
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
});

// ========================================
// CARD ANIMATIONS
// ========================================

// Add fade-in animation for cards
document.addEventListener('DOMContentLoaded', function() {
    const cards = document.querySelectorAll('.award-card, .person-card');
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.animation = 'fadeInUp 0.6s ease forwards';
                observer.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.1
    });
    
    cards.forEach(card => {
        observer.observe(card);
    });
});

// ========================================
// MOBILE OPTIMIZATIONS
// ========================================

// Touch-friendly interactions for mobile
document.addEventListener('DOMContentLoaded', function() {
    // Add touch feedback for buttons
    const buttons = document.querySelectorAll('.year-btn, .alphabet-btn, .btn');
    
    buttons.forEach(btn => {
        btn.addEventListener('touchstart', function() {
            this.style.transform = 'scale(0.95)';
        });
        
        btn.addEventListener('touchend', function() {
            this.style.transform = 'scale(1)';
        });
    });
    
    // Prevent zoom on double tap for filter buttons only (not action buttons)
    const filterButtons = document.querySelectorAll('.year-btn, .alphabet-btn');
    filterButtons.forEach(btn => {
        btn.addEventListener('touchend', function(e) {
            e.preventDefault();
        });
    });
});

// ========================================
// PERFORMANCE OPTIMIZATIONS
// ========================================

// Debounced search for better performance
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

// Apply debouncing to search input
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('search-input');
    
    if (searchInput) {
        const debouncedSearch = debounce(function() {
            // Search functionality is already handled above
        }, 300);
        
        searchInput.addEventListener('input', debouncedSearch);
    }
});

// ========================================
// ACCESSIBILITY IMPROVEMENTS
// ========================================

// Keyboard navigation for filters
document.addEventListener('DOMContentLoaded', function() {
    const filterButtons = document.querySelectorAll('.year-btn, .alphabet-btn');
    
    filterButtons.forEach((btn, index) => {
        btn.addEventListener('keydown', function(e) {
            if (e.key === 'ArrowRight' || e.key === 'ArrowDown') {
                e.preventDefault();
                const nextBtn = filterButtons[index + 1] || filterButtons[0];
                nextBtn.focus();
            } else if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') {
                e.preventDefault();
                const prevBtn = filterButtons[index - 1] || filterButtons[filterButtons.length - 1];
                prevBtn.focus();
            } else if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                this.click();
            }
        });
    });
});

// Focus management for lightbox
function openLightbox(imageSrc) {
    const lightbox = document.getElementById('lightbox');
    const lightboxImg = document.getElementById('lightbox-img');
    
    if (lightbox && lightboxImg) {
        lightboxImg.src = imageSrc;
        lightbox.style.display = 'flex';
        document.body.style.overflow = 'hidden';
        
        // Focus on the close button for accessibility
        const closeBtn = document.querySelector('.lightbox-close');
        if (closeBtn) {
            closeBtn.focus();
        }
    }
}

// ========================================
// ERROR HANDLING
// ========================================

// Graceful error handling for missing elements
document.addEventListener('DOMContentLoaded', function() {
    // Check if required elements exist before adding event listeners
    const requiredElements = [
        '.year-btn',
        '.alphabet-btn',
        '.award-card',
        '.person-card',
        '#search-input'
    ];
    
    requiredElements.forEach(selector => {
        const elements = document.querySelectorAll(selector);
        if (elements.length === 0) {
            console.warn(`Element with selector "${selector}" not found. Some functionality may not work.`);
        }
    });
});

// ========================================
// GALLERY CAROUSEL FUNCTIONALITY
// ========================================

let currentSlideIndex = 0;
const slides = document.querySelectorAll('.carousel-slide');
const dots = document.querySelectorAll('.dot');

function showSlide(index) {
    // Hide all slides
    slides.forEach(slide => slide.classList.remove('active'));
    dots.forEach(dot => dot.classList.remove('active'));
    
    // Show current slide
    if (slides[index]) {
        slides[index].classList.add('active');
    }
    if (dots[index]) {
        dots[index].classList.add('active');
    }
}

function changeSlide(direction) {
    currentSlideIndex += direction;
    
    // Wrap around if at the beginning or end
    if (currentSlideIndex >= slides.length) {
        currentSlideIndex = 0;
    } else if (currentSlideIndex < 0) {
        currentSlideIndex = slides.length - 1;
    }
    
    showSlide(currentSlideIndex);
}

function currentSlide(index) {
    currentSlideIndex = index - 1; // Convert to 0-based index
    showSlide(currentSlideIndex);
}

// Auto-advance carousel every 5 seconds
let carouselInterval;

function startCarousel() {
    carouselInterval = setInterval(() => {
        changeSlide(1);
    }, 5000);
}

function stopCarousel() {
    clearInterval(carouselInterval);
}

// Initialize carousel when page loads
document.addEventListener('DOMContentLoaded', function() {
    if (slides.length > 0) {
        showSlide(0);
        startCarousel();
        
        // Pause carousel on hover
        const carouselContainer = document.querySelector('.carousel-container');
        if (carouselContainer) {
            carouselContainer.addEventListener('mouseenter', stopCarousel);
            carouselContainer.addEventListener('mouseleave', startCarousel);
        }
    }
});