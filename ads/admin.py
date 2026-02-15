from django.contrib import admin
from .models import Advertisement, AdminProfile


@admin.register(Advertisement)
class AdvertisementAdmin(admin.ModelAdmin):
    list_display = (
        'title',
        'advertiser',
        'target_program',
        'status',
        'is_active_display',
        'impressions',
        'clicks',
    )

    list_filter = ('status', 'target_program', 'start_date', 'end_date')
    search_fields = ('title', 'advertiser', 'description')

    readonly_fields = ('impressions', 'clicks', 'created_at', 'updated_at')

    fieldsets = (
        ('Advertisement Info', {
            'fields': ('title', 'description', 'image')
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
            'fields': ('created_at', 'updated_at', 'created_by')
        }),
    )

    def is_active_display(self, obj):
        return obj.is_active

    is_active_display.boolean = True
    is_active_display.short_description = 'Active Now'


@admin.register(AdminProfile)
class AdminProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'department', 'phone')
    search_fields = ('user__username', 'department')
