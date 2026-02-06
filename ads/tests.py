from django.test import TestCase

# Create your tests here.
from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APITestCase
from rest_framework import status
from .models import Advertisement  # Assuming you have this model

class AdvertisementAPITestCase(APITestCase):
    
    def setUp(self):
        """Set up test data"""
        self.ad1 = Advertisement.objects.create(
            title="Ad 1",
            program_name="tech",
            is_active=True,
            clicks=0
        )
        self.ad2 = Advertisement.objects.create(
            title="Ad 2",
            program_name="business",
            is_active=False,
            clicks=0
        )
    
    def test_active_ads_endpoint(self):
        """Test /ads/active/ endpoint"""
        url = reverse('active_ads')
        response = self.client.get(url)
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)  # Only one active ad
    
    def test_program_ads_endpoint(self):
        """Test /ads/program/{program_name}/ endpoint"""
        url = reverse('program_ads', kwargs={'program_name': 'tech'})
        response = self.client.get(url)
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Should return ads with program_name='tech'
    
    def test_track_click_endpoint(self):
        """Test /ads/track-click/{ad_id}/ endpoint"""
        url = reverse('track_click', kwargs={'ad_id': self.ad1.id})
        response = self.client.post(url)
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        
        # Refresh from database
        self.ad1.refresh_from_db()
        self.assertEqual(self.ad1.clicks, 1)  # Click should increment
    
    def test_statistics_endpoint(self):
        """Test /ads/statistics/ endpoint"""
        url = reverse('ad_statistics')
        response = self.client.get(url)
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Add assertions based on what statistics returns

    def test_invalid_ad_id_track_click(self):
        """Test tracking click for non-existent ad"""
        url = reverse('track_click', kwargs={'ad_id': 999})
        response = self.client.post(url)
        
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)