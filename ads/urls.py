# ads/urls.py
from django.urls import path
from .views import (
    # Existing views
    ActiveAdvertisementsAPIView,
    ProgramAdvertisementsAPIView,
    TrackClickAPIView,
    AdvertisementStatisticsAPIView,
    
    # New authentication views
    LoginAPIView,
    LogoutAPIView,
    RegisterAPIView,
    UserProfileAPIView,
    
    # New dashboard views
    AdvertisementListCreateAPIView,
    AdvertisementDetailAPIView,
    DashboardStatisticsAPIView,
)

urlpatterns = [
    # Public APIs (for mobile app)
    path('active/', ActiveAdvertisementsAPIView.as_view(), name='active_ads'),
    path('program/<str:program_name>/', ProgramAdvertisementsAPIView.as_view(), name='program_ads'),
    path('track-click/<int:ad_id>/', TrackClickAPIView.as_view(), name='track_click'),
    path('statistics/', AdvertisementStatisticsAPIView.as_view(), name='ad_statistics'),
    
    # Authentication URLs
    path('auth/login/', LoginAPIView.as_view(), name='login'),
    path('auth/logout/', LogoutAPIView.as_view(), name='logout'),
    path('auth/register/', RegisterAPIView.as_view(), name='register'),
    path('auth/profile/', UserProfileAPIView.as_view(), name='user_profile'),
    
    # Dashboard Management URLs (require authentication)
    path('dashboard/ads/', AdvertisementListCreateAPIView.as_view(), name='ad_list_create'),
    path('dashboard/ads/<int:pk>/', AdvertisementDetailAPIView.as_view(), name='ad_detail'),
    path('dashboard/stats/', DashboardStatisticsAPIView.as_view(), name='dashboard_stats'),
]