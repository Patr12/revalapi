from django.contrib import admin
# Register your models here.
from django.contrib import admin
from .models import Advertisement

@admin.register(Advertisement)
class AdvertisementAdmin(admin.ModelAdmin):
    list_display = ('title', 'advertiser', 'target_program', 'status', 'is_active', 'impressions', 'clicks')
    list_filter = ('status', 'target_program', 'start_date', 'end_date')
    search_fields = ('title', 'advertiser', 'description')
    readonly_fields = ('impressions', 'clicks', 'created_at', 'updated_at')
    fieldsets = (
        ('Advertisement Info', {
            'fields': ('title', 'description', 'image_url')
        }),
        ('Targeting', {
            'fields': ('target_program', 'start_date', 'end_date', 'display_duration')
        }),
        ('Advertiser Info', {
            'fields': ('advertiser', 'advertiser_contact', 'advertiser_email')
        }),
        ('Call to Action', {
            'fields': ('call_to_action', 'external_link')
        }),
        ('Status & Tracking', {
            'fields': ('status', 'impressions', 'clicks')
        }),
        ('Metadata', {
            'fields': ('created_at', 'updated_at')
        }),
    )
    
    def is_active(self, obj):
        return obj.is_active
    is_active.boolean = True
    is_active.short_description = 'Active Now'