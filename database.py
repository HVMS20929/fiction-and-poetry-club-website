from supabase import create_client, Client
from config import Config
import os
from typing import List, Dict, Optional, Any
from datetime import datetime
import uuid

class DatabaseService:
    def __init__(self):
        if not Config.SUPABASE_URL or not Config.SUPABASE_KEY:
            raise ValueError("Supabase credentials not configured. Please set SUPABASE_URL and SUPABASE_KEY environment variables.")
        
        self.supabase: Client = create_client(Config.SUPABASE_URL, Config.SUPABASE_KEY)
    
    # Magazine Issues
    def get_all_issues(self) -> List[Dict[str, Any]]:
        """Get all magazine issues"""
        try:
            response = self.supabase.table(Config.ISSUES_TABLE).select('*').order('release_date', desc=True).execute()
            return response.data
        except Exception as e:
            print(f"Error fetching issues: {e}")
            return []
    
    def get_issues_by_type(self, journal_type: str) -> List[Dict[str, Any]]:
        """Get magazine issues by journal type (literary or research)"""
        try:
            response = self.supabase.table(Config.ISSUES_TABLE).select('*').eq('journal_type', journal_type).order('release_date', desc=True).execute()
            return response.data
        except Exception as e:
            print(f"Error fetching {journal_type} issues: {e}")
            return []
    
    def get_issue_by_id(self, issue_id: int) -> Optional[Dict[str, Any]]:
        """Get a specific issue by ID"""
        try:
            response = self.supabase.table(Config.ISSUES_TABLE).select('*').eq('id', issue_id).single().execute()
            return response.data
        except Exception as e:
            print(f"Error fetching issue {issue_id}: {e}")
            return None
    
    def create_issue(self, issue_data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """Create a new magazine issue"""
        try:
            response = self.supabase.table(Config.ISSUES_TABLE).insert(issue_data).execute()
            return response.data[0] if response.data else None
        except Exception as e:
            print(f"Error creating issue: {e}")
            return None
    
    def update_issue(self, issue_id: int, issue_data: Dict[str, Any]) -> bool:
        """Update an existing issue"""
        try:
            response = self.supabase.table(Config.ISSUES_TABLE).update(issue_data).eq('id', issue_id).execute()
            return bool(response.data)
        except Exception as e:
            print(f"Error updating issue {issue_id}: {e}")
            return False
    
    def delete_issue(self, issue_id: int) -> bool:
        """Delete an issue"""
        try:
            response = self.supabase.table(Config.ISSUES_TABLE).delete().eq('id', issue_id).execute()
            return bool(response.data)
        except Exception as e:
            print(f"Error deleting issue {issue_id}: {e}")
            return False
    
    # Articles
    def get_articles_by_issue(self, issue_id: int) -> List[Dict[str, Any]]:
        """Get all articles for a specific issue"""
        try:
            response = self.supabase.table(Config.ARTICLES_TABLE).select('*').eq('issue_id', issue_id).order('created_at', desc=True).execute()
            return response.data
        except Exception as e:
            print(f"Error fetching articles for issue {issue_id}: {e}")
            return []
    
    def get_article_by_id(self, article_id: int) -> Optional[Dict[str, Any]]:
        """Get a specific article by ID"""
        try:
            response = self.supabase.table(Config.ARTICLES_TABLE).select('*').eq('id', article_id).single().execute()
            return response.data
        except Exception as e:
            print(f"Error fetching article {article_id}: {e}")
            return None
    
    def create_article(self, article_data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """Create a new article"""
        try:
            response = self.supabase.table(Config.ARTICLES_TABLE).insert(article_data).execute()
            return response.data[0] if response.data else None
        except Exception as e:
            print(f"Error creating article: {e}")
            return None
    
    # Photos
    def get_photos_by_issue(self, issue_id: int) -> List[Dict[str, Any]]:
        """Get all photos for a specific issue"""
        try:
            response = self.supabase.table(Config.PHOTOS_TABLE).select('*').eq('issue_id', issue_id).order('created_at', desc=True).execute()
            return response.data
        except Exception as e:
            print(f"Error fetching photos for issue {issue_id}: {e}")
            return []
    
    def upload_photo(self, photo_data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """Upload a new photo"""
        try:
            response = self.supabase.table(Config.PHOTOS_TABLE).insert(photo_data).execute()
            return response.data[0] if response.data else None
        except Exception as e:
            print(f"Error uploading photo: {e}")
            return None
    
    # Contributors
    def get_contributors_by_issue(self, issue_id: int) -> Dict[str, List[Dict[str, Any]]]:
        """Get all contributors for a specific issue"""
        try:
            response = self.supabase.table(Config.CONTRIBUTORS_TABLE).select('*').eq('issue_id', issue_id).execute()
            
            contributors = {
                'editorial_team': [],
                'featured_writers': [],
                'photographers': []
            }
            
            for contributor in response.data:
                role_type = contributor.get('role_type', 'featured_writers')
                if role_type in contributors:
                    contributors[role_type].append(contributor)
            
            return contributors
        except Exception as e:
            print(f"Error fetching contributors for issue {issue_id}: {e}")
            return {'editorial_team': [], 'featured_writers': [], 'photographers': []}
    
    # Moments
    def get_all_moments(self) -> List[Dict[str, Any]]:
        """Get all moments and milestones"""
        try:
            response = self.supabase.table(Config.MOMENTS_TABLE).select('*').order('date', desc=True).execute()
            return response.data
        except Exception as e:
            print(f"Error fetching moments: {e}")
            return []
    
    def create_moment(self, moment_data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """Create a new moment"""
        try:
            response = self.supabase.table(Config.MOMENTS_TABLE).insert(moment_data).execute()
            return response.data[0] if response.data else None
        except Exception as e:
            print(f"Error creating moment: {e}")
            return None
    
    # File Storage (Supabase Storage)
    def upload_file(self, file_path: str, bucket_name: str = 'magazine-assets') -> Optional[str]:
        """Upload a file to Supabase Storage"""
        try:
            file_name = os.path.basename(file_path)
            with open(file_path, 'rb') as f:
                response = self.supabase.storage.from_(bucket_name).upload(
                    path=file_name,
                    file=f,
                    file_options={"content-type": "image/jpeg"}
                )
            return f"{self.supabase.storage.from_(bucket_name).get_public_url(file_name)}"
        except Exception as e:
            print(f"Error uploading file {file_path}: {e}")
            return None
    
    def delete_file(self, file_name: str, bucket_name: str = 'magazine-assets') -> bool:
        """Delete a file from Supabase Storage"""
        try:
            self.supabase.storage.from_(bucket_name).remove([file_name])
            return True
        except Exception as e:
            print(f"Error deleting file {file_name}: {e}")
            return False
    
    # Editorial Team
    def get_editorial_team(self, team_type: str = None) -> List[Dict[str, Any]]:
        """Get editorial team members"""
        try:
            query = self.supabase.table('editorial_team').select('*')
            if team_type:
                query = query.eq('team_type', team_type)
            response = query.order('display_order', desc=False).execute()
            return response.data
        except Exception as e:
            print(f"Error fetching editorial team: {e}")
            return []
    
    def create_team_member(self, member_data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """Create a new team member"""
        try:
            response = self.supabase.table('editorial_team').insert(member_data).execute()
            return response.data[0] if response.data else None
        except Exception as e:
            print(f"Error creating team member: {e}")
            return None
    
    # Awards
    def get_all_awards(self) -> List[Dict[str, Any]]:
        """Get all awards ordered by year (descending)"""
        try:
            response = self.supabase.table('awards').select('*').order('year', desc=True).execute()
            return response.data
        except Exception as e:
            print(f"Error fetching awards: {e}")
            return []
    
    def get_awards_by_year(self, year: int) -> List[Dict[str, Any]]:
        """Get awards for a specific year"""
        try:
            response = self.supabase.table('awards').select('*').eq('year', year).execute()
            return response.data
        except Exception as e:
            print(f"Error fetching awards for year {year}: {e}")
            return []
    
    def get_award_by_id(self, award_id: int) -> Optional[Dict[str, Any]]:
        """Get a specific award by ID"""
        try:
            response = self.supabase.table('awards').select('*').eq('id', award_id).single().execute()
            return response.data
        except Exception as e:
            print(f"Error fetching award {award_id}: {e}")
            return None
    
    def get_awards_years(self) -> List[int]:
        """Get all years that have awards"""
        try:
            response = self.supabase.table('awards').select('year').execute()
            years = list(set([award['year'] for award in response.data]))
            return sorted(years, reverse=True)
        except Exception as e:
            print(f"Error fetching award years: {e}")
            return []
    
    def create_award(self, award_data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """Create a new award"""
        try:
            response = self.supabase.table('awards').insert(award_data).execute()
            return response.data[0] if response.data else None
        except Exception as e:
            print(f"Error creating award: {e}")
            return None
    
    # Who's Who
    def get_all_whos_who(self) -> List[Dict[str, Any]]:
        """Get all who's who entries ordered by name"""
        try:
            response = self.supabase.table('whos_who').select('*').order('name').execute()
            return response.data
        except Exception as e:
            print(f"Error fetching who's who: {e}")
            return []
    
    def get_whos_who_by_letter(self, letter: str) -> List[Dict[str, Any]]:
        """Get who's who entries starting with a specific letter"""
        try:
            response = self.supabase.table('whos_who').select('*').ilike('name', f'{letter}%').order('name').execute()
            return response.data
        except Exception as e:
            print(f"Error fetching who's who for letter {letter}: {e}")
            return []
    
    def get_whos_who_by_id(self, person_id: int) -> Optional[Dict[str, Any]]:
        """Get a specific who's who entry by ID"""
        try:
            response = self.supabase.table('whos_who').select('*').eq('id', person_id).single().execute()
            return response.data
        except Exception as e:
            print(f"Error fetching who's who entry {person_id}: {e}")
            return None
    
    def get_whos_who_letters(self) -> List[str]:
        """Get all first letters that have who's who entries"""
        try:
            response = self.supabase.table('whos_who').select('name').execute()
            letters = list(set([person['name'][0].upper() for person in response.data]))
            return sorted(letters)
        except Exception as e:
            print(f"Error fetching who's who letters: {e}")
            return []
    
    def create_whos_who(self, person_data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """Create a new who's who entry"""
        try:
            response = self.supabase.table('whos_who').insert(person_data).execute()
            return response.data[0] if response.data else None
        except Exception as e:
            print(f"Error creating who's who entry: {e}")
            return None

# Create a global instance
db_service = None

def get_db_service() -> DatabaseService:
    """Get or create the database service instance"""
    global db_service
    if db_service is None:
        try:
            db_service = DatabaseService()
        except ValueError as e:
            print(f"Database service not available: {e}")
            return None
    return db_service
