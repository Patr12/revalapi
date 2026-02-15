from django.shortcuts import render
# Create your views here.
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.utils import timezone
from .models import AdminProfile, Advertisement
from rest_framework import generics, permissions
from rest_framework.authtoken.models import Token
from rest_framework.authtoken.views import ObtainAuthToken
from django.contrib.auth import logout
from .serializers import AdvertisementSerializer, RegistrationSerializer, LoginSerializer, AdminProfileSerializer,UserSerializer
from django.db.models import Q
import logging
from rest_framework.authentication import TokenAuthentication
from ads import models
from django.db.models import Sum


logger = logging.getLogger(__name__)

class LoginAPIView(APIView):
    """API ya login"""
    
    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        
        if serializer.is_valid():
            user = serializer.validated_data['user']
            
            # Create or get token
            token, created = Token.objects.get_or_create(user=user)
            
            # Get user data
            user_serializer = UserSerializer(user)
            
            return Response({
                'success': True,
                'token': token.key,
                'user': user_serializer.data,
                'message': 'Login successful'
            })
        
        return Response({
            'success': False,
            'errors': serializer.errors
        }, status=status.HTTP_400_BAD_REQUEST)


class LogoutAPIView(APIView):
    """API ya logout"""
    
    permission_classes = [permissions.IsAuthenticated]
    
    def post(self, request):
        try:
            # Delete token
            request.user.auth_token.delete()
            
            # Django logout
            logout(request)
            
            return Response({
                'success': True,
                'message': 'Logout successful'
            })
        except:
            return Response({
                'success': True,
                'message': 'Logout successful'
            })


class RegisterAPIView(APIView):
    """API ya kusajili admin mpya"""
    
    def post(self, request):
        serializer = RegistrationSerializer(data=request.data)
        
        if serializer.is_valid():
            user = serializer.save()
            
            # Create token
            token = Token.objects.create(user=user)
            
            # Create admin profile
            AdminProfile.objects.create(
                user=user,
                department=request.data.get('department', 'Marketing')
            )
            
            return Response({
                'success': True,
                'token': token.key,
                'user': UserSerializer(user).data,
                'message': 'Registration successful'
            }, status=status.HTTP_201_CREATED)
        
        return Response({
            'success': False,
            'errors': serializer.errors
        }, status=status.HTTP_400_BAD_REQUEST)


class UserProfileAPIView(APIView):
    """API ya kupata user profile"""
    
    permission_classes = [permissions.IsAuthenticated]
    
    def get(self, request):
        user_serializer = UserSerializer(request.user)
        try:
            profile = AdminProfile.objects.get(user=request.user)
            profile_serializer = AdminProfileSerializer(profile)
            profile_data = profile_serializer.data
        except AdminProfile.DoesNotExist:
            profile_data = None
        
        return Response({
            'success': True,
            'user': user_serializer.data,
            'profile': profile_data
        })


from rest_framework import generics, permissions
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from .models import Advertisement
from .serializers import AdvertisementSerializer


class AdvertisementListCreateAPIView(generics.ListCreateAPIView):
    """API ya kupata na kuunda matangazo (kwa admin)"""
    authentication_classes = [TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    serializer_class = AdvertisementSerializer
    queryset = Advertisement.objects.all()

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context['request'] = self.request   # 🔥 muhimu kwa image_display
        return context

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)

    def list(self, request, *args, **kwargs):
        response = super().list(request, *args, **kwargs)
        return Response({
            'success': True,
            'count': len(response.data),
            'ads': response.data
        })


class AdvertisementDetailAPIView(generics.RetrieveUpdateDestroyAPIView):
    """API ya kuhudumia tangazo moja moja (kwa admin)"""
    authentication_classes = [TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    serializer_class = AdvertisementSerializer
    queryset = Advertisement.objects.all()

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context['request'] = self.request   # 🔥 muhimu pia hapa
        return context

    def retrieve(self, request, *args, **kwargs):
        response = super().retrieve(request, *args, **kwargs)
        return Response({
            'success': True,
            'ad': response.data
        })

    def update(self, request, *args, **kwargs):
        response = super().update(request, *args, **kwargs)
        return Response({
            'success': True,
            'message': 'Advertisement updated successfully',
            'ad': response.data
        })

    def destroy(self, request, *args, **kwargs):
        super().destroy(request, *args, **kwargs)
        return Response({
            'success': True,
            'message': 'Advertisement deleted successfully'
        })
 

class DashboardStatisticsAPIView(APIView):
    """API ya takwimu za dashboard"""
    authentication_classes = [TokenAuthentication]

    permission_classes = [permissions.IsAuthenticated]
    
    def get(self, request):
        try:
            total_ads = Advertisement.objects.count()
            active_ads = Advertisement.objects.filter(
                status='active',
                start_date__lte=timezone.now(),
                end_date__gte=timezone.now()
            ).count()
            inactive_ads = Advertisement.objects.filter(status='inactive').count()
            scheduled_ads = Advertisement.objects.filter(status='scheduled').count()
            
            # Today's statistics
            today = timezone.now().date()
            today_clicks = Advertisement.objects.filter(
                updated_at__date=today
            ).aggregate(Sum('clicks'))['clicks__sum'] or 0
            
            today_impressions = Advertisement.objects.filter(
                updated_at__date=today
            ).aggregate(Sum('impressions'))['impressions__sum'] or 0
            
            # Ads by program
            program_stats = []
            for program in Advertisement.PROGRAM_CHOICES:
                count = Advertisement.objects.filter(target_program=program[0]).count()
                program_stats.append({
                    'program': program[0],
                    'count': count
                })
            
            # Recent activity
            recent_ads = Advertisement.objects.order_by('-created_at')[:5]
            recent_serializer = AdvertisementSerializer(recent_ads, many=True)
            
            return Response({
                'success': True,
                'statistics': {
                    'total_ads': total_ads,
                    'active_ads': active_ads,
                    'inactive_ads': inactive_ads,
                    'scheduled_ads': scheduled_ads,
                    'today_clicks': today_clicks,
                    'today_impressions': today_impressions,
                    'program_stats': program_stats
                },
                'recent_ads': recent_serializer.data
            })
            
        except Exception as e:
            logger.error(f"Error fetching dashboard stats: {str(e)}")
            return Response({
                'success': False,
                'error': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
        
class ActiveAdvertisementsAPIView(APIView):
    """API ya kupata matangazo yanayofanya kazi kwa wakati huo"""
    authentication_classes = [TokenAuthentication]

    
    def get(self, request):
        try:
            # Get current time
            now = timezone.now()
            
            # Filter active ads
            active_ads = Advertisement.objects.filter(
                status='active',
                start_date__lte=now,
                end_date__gte=now
            ).order_by('?')  # Random order for rotation
            
            # Increment impressions for each ad
            for ad in active_ads:
                ad.impressions += 1
                ad.save(update_fields=['impressions'])
            
            serializer = AdvertisementSerializer(active_ads, many=True)
            
            return Response({
                'success': True,
                'count': active_ads.count(),
                'ads': serializer.data,
                'timestamp': now.isoformat(),
            })
            
        except Exception as e:
            logger.error(f"Error fetching ads: {str(e)}")
            return Response({
                'success': False,
                'error': str(e),
                'ads': []
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class ProgramAdvertisementsAPIView(APIView):
    authentication_classes = [TokenAuthentication]

    """API ya kupata matangazo kwa kipindi maalum"""
    
    def get(self, request, program_name):
        try:
            now = timezone.now()
            
            # Get ads for specific program OR general ads
            program_ads = Advertisement.objects.filter(
                Q(target_program=program_name) | Q(target_program='General'),
                status='active',
                start_date__lte=now,
                end_date__gte=now
            ).order_by('?')
            
            # Increment impressions
            for ad in program_ads:
                ad.impressions += 1
                ad.save(update_fields=['impressions'])
            
            serializer = AdvertisementSerializer(program_ads, many=True)
            
            return Response({
                'success': True,
                'program': program_name,
                'count': program_ads.count(),
                'ads': serializer.data,
                'timestamp': now.isoformat(),
            })
            
        except Exception as e:
            logger.error(f"Error fetching program ads: {str(e)}")
            return Response({
                'success': False,
                'error': str(e),
                'ads': []
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class TrackClickAPIView(APIView):
    """API ya kufuatilia clicks za matangazo"""
    
    def post(self, request, ad_id):
        try:
            ad = Advertisement.objects.get(id=ad_id)
            ad.clicks += 1
            ad.save(update_fields=['clicks'])
            
            return Response({
                'success': True,
                'message': 'Click tracked successfully',
                'ad_id': ad_id,
                'new_click_count': ad.clicks
            })
            
        except Advertisement.DoesNotExist:
            return Response({
                'success': False,
                'error': 'Advertisement not found'
            }, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            logger.error(f"Error tracking click: {str(e)}")
            return Response({
                'success': False,
                'error': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class AdvertisementStatisticsAPIView(APIView):
    """API ya takwimu za matangazo"""
    
    def get(self, request):
        try:
            total_ads = Advertisement.objects.count()
            active_ads = Advertisement.objects.filter(
                status='active',
                start_date__lte=timezone.now(),
                end_date__gte=timezone.now()
            ).count()
            
            total_impressions = Advertisement.objects.aggregate(
                total=models.Sum('impressions')
            )['total'] or 0
            
            total_clicks = Advertisement.objects.aggregate(
                total=models.Sum('clicks')
            )['total'] or 0
            
            # Click-through rate
            ctr = (total_clicks / total_impressions * 100) if total_impressions > 0 else 0
            
            return Response({
                'success': True,
                'statistics': {
                    'total_ads': total_ads,
                    'active_ads': active_ads,
                    'total_impressions': total_impressions,
                    'total_clicks': total_clicks,
                    'click_through_rate': round(ctr, 2),
                }
            })
            
        except Exception as e:
            logger.error(f"Error fetching statistics: {str(e)}")
            return Response({
                'success': False,
                'error': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)