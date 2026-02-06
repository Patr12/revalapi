from rest_framework import serializers
from .models import Advertisement, AdminProfile
from django.utils import timezone
from django.contrib.auth.models import User
from django.contrib.auth import authenticate

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name']

class AdminProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    
    class Meta:
        model = AdminProfile
        fields = ['user', 'department', 'phone', 'profile_picture']

class LoginSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField(write_only=True)
    
    def validate(self, data):
        username = data.get('username')
        password = data.get('password')
        
        if username and password:
            user = authenticate(username=username, password=password)
            if user:
                if user.is_active:
                    data['user'] = user
                else:
                    raise serializers.ValidationError("Account is disabled")
            else:
                raise serializers.ValidationError("Invalid username or password")
        else:
            raise serializers.ValidationError("Must include username and password")
        
        return data

class RegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=6)
    confirm_password = serializers.CharField(write_only=True, min_length=6)
    email = serializers.EmailField(required=True)
    
    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'confirm_password', 'first_name', 'last_name']
    
    def validate(self, data):
        if data['password'] != data['confirm_password']:
            raise serializers.ValidationError("Passwords do not match")
        return data
    
    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
            first_name=validated_data.get('first_name', ''),
            last_name=validated_data.get('last_name', '')
        )
        return user
    
class AdvertisementSerializer(serializers.ModelSerializer):
    is_active = serializers.BooleanField(read_only=True)
    image_display = serializers.SerializerMethodField()

    class Meta:
        model = Advertisement
        fields = [
            'id',
            'title',
            'description',

            # picha
            'image',        # upload
            'image_url',    # link
            'image_display',

            'target_program',
            'start_date',
            'end_date',
            'display_duration',

            'advertiser',
            'advertiser_contact',
            'advertiser_email',

            'call_to_action',
            'external_link',

            'status',
            'impressions',
            'clicks',

            'is_active',
            'created_at',
            'updated_at',
        ]
        read_only_fields = ['impressions', 'clicks', 'created_at', 'updated_at']

    def get_image_display(self, obj):
        if obj.image:
            return obj.image.url
        return obj.image_url

    def validate(self, data):
        if data['start_date'] > data['end_date']:
            raise serializers.ValidationError(
                "End date must be after start date"
            )
        return data

    