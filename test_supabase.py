#!/usr/bin/env python3
"""
Test script to verify Supabase connection
"""

import os
from dotenv import load_dotenv
from supabase import create_client, Client

# Load environment variables
load_dotenv()

def test_supabase_connection():
    """Test the Supabase connection and database access"""
    
    # Get credentials from environment
    supabase_url = os.environ.get('SUPABASE_URL')
    supabase_key = os.environ.get('SUPABASE_KEY')
    
    print("🔍 Testing Supabase Connection...")
    print(f"URL: {supabase_url}")
    print(f"Key: {supabase_key[:20]}..." if supabase_key else "Key: NOT SET")
    
    if not supabase_url or not supabase_key:
        print("❌ Missing Supabase credentials in .env file")
        return False
    
    if supabase_key == "your-anon-key-here":
        print("❌ Supabase key is still set to placeholder value")
        print("Please update your .env file with the actual API key from Supabase dashboard")
        return False
    
    try:
        # Create Supabase client
        supabase: Client = create_client(supabase_url, supabase_key)
        print("✅ Supabase client created successfully")
        
        # Test database connection by fetching issues
        print("🔍 Testing database connection...")
        response = supabase.table('magazine_issues').select('*').limit(5).execute()
        
        print(f"✅ Database connection successful!")
        print(f"📊 Found {len(response.data)} issues in database")
        
        if response.data:
            print("📚 Sample issues:")
            for issue in response.data[:3]:
                print(f"  - {issue.get('title', 'No title')} ({issue.get('journal_type', 'No type')})")
        else:
            print("⚠️  No issues found in database")
            
        # Test other tables
        print("\n🔍 Testing other tables...")
        
        # Test moments table
        moments_response = supabase.table('moments').select('*').limit(3).execute()
        print(f"📸 Moments: {len(moments_response.data)} found")
        
        # Test editorial team table
        team_response = supabase.table('editorial_team').select('*').limit(3).execute()
        print(f"👥 Editorial Team: {len(team_response.data)} found")
        
        return True
        
    except Exception as e:
        print(f"❌ Database connection failed: {e}")
        return False

if __name__ == "__main__":
    success = test_supabase_connection()
    
    if success:
        print("\n🎉 Supabase connection is working! Your website should now display data.")
    else:
        print("\n💡 Please check your Supabase credentials and try again.")
