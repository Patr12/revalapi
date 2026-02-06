from django.db import models
from django.contrib.auth.models import User
# Create your models here.
from django.utils import timezone
from django.core.exceptions import ValidationError

class Advertisement(models.Model):
    PROGRAM_CHOICES = [
    ('SUN RISE', 'SUN RISE'),
    ('KR MORNING', 'KR MORNING'),
    ('HABARI KWA UFUPI', 'HABARI KWA UFUPI'),
    ('JAMVI LETU', 'JAMVI LETU'),
    ('HABARI KAMILI MCHANA', 'HABARI KAMILI MCHANA'),
    ('GOSPEL REVIVAL HUB', 'GOSPEL REVIVAL HUB'),
    ('SUN SET DRIVE TIME', 'SUN SET DRIVE TIME'),
    ('SPORTS COUNTER', 'SPORTS COUNTER'),
    ('HABARI ZA USIKU', 'HABARI ZA USIKU'),
    ('TUJIFUNZE BIBLIA', 'TUJIFUNZE BIBLIA'),
    ('USIKU WA USHINDI', 'USIKU WA USHINDI'),
    ('HABARI ZA USIKU (MARUDIO)', 'HABARI ZA USIKU (MARUDIO)'),
    ('General', 'General (All Programs)'),
]

    
    STATUS_CHOICES = [
        ('active', 'Active'),
        ('inactive', 'Inactive'),
        ('scheduled', 'Scheduled'),
    ]
    
    title = models.CharField(max_length=200)
    description = models.TextField()
    image = models.ImageField(upload_to='ads_images/', blank=True, null=True)
    image_url = models.URLField(max_length=500, help_text="URL ya picha ya tangazo")
    
    # Program targeting
    target_program = models.CharField(
        max_length=50, 
        choices=PROGRAM_CHOICES,
        default='General',
        help_text="Kipindi ambacho tangazo linaonyeshwa"
    )
    
    # Scheduling
    start_date = models.DateTimeField(default=timezone.now)
    end_date = models.DateTimeField()
    display_duration = models.IntegerField(
        default=30,
        help_text="Muda wa kuonyesha tangazo (sekunde)"
    )
    
    # Advertiser info
    advertiser = models.CharField(max_length=200)
    advertiser_contact = models.CharField(max_length=100, blank=True, null=True)
    advertiser_email = models.EmailField(blank=True, null=True)
    
    # Call to action
    call_to_action = models.CharField(max_length=100, blank=True, null=True)
    external_link = models.URLField(max_length=500, blank=True, null=True)
    
    # Status & tracking
    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default='active'
    )
    impressions = models.IntegerField(default=0, help_text="Idadi ya kuonyeshwa")
    clicks = models.IntegerField(default=0, help_text="Idadi ya kubofya")
    # created_by field
    created_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='ads_created')
    
    # Metadata
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.title} - {self.advertiser}"
    
    @property
    def is_active(self):
        """Check if ad is currently active"""
        now = timezone.now()
        return (
            self.status == 'active' and
            self.start_date <= now <= self.end_date
        )
    
    class Meta:
        ordering = ['-created_at']
        verbose_name = "Advertisement"
        verbose_name_plural = "Advertisements"

    def clean(self):
        if not self.image and not self.image_url:
            raise ValidationError("Lazima uweke picha (upload) AU link ya picha.")
    

        
class AdminProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    department = models.CharField(max_length=100, default='Marketing')
    phone = models.CharField(max_length=20, blank=True, null=True)
    profile_picture = models.ImageField(upload_to='profiles/', blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.user.username} - {self.department}"        