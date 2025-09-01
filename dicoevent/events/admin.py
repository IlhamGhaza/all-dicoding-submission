from django.contrib import admin
from .models import Event, Ticket, Registration, Payment


@admin.register(Event)
class EventAdmin(admin.ModelAdmin):
    list_display = ('name', 'organizer', 'start_time', 'end_time', 'location', 'is_published')
    list_filter = ('is_published', 'start_time', 'location')
    search_fields = ('name', 'description', 'location')


@admin.register(Ticket)
class TicketAdmin(admin.ModelAdmin):
    list_display = ('name', 'event', 'price', 'quota', 'code')
    search_fields = ('name', 'code')
    list_filter = ('event',)


@admin.register(Registration)
class RegistrationAdmin(admin.ModelAdmin):
    list_display = ('user', 'ticket', 'quantity', 'status', 'created_at')
    list_filter = ('status', 'created_at')
    search_fields = ('user__username', 'ticket__name')


@admin.register(Payment)
class PaymentAdmin(admin.ModelAdmin):
    list_display = ('invoice_id', 'registration', 'amount', 'method', 'status', 'paid_at')
    list_filter = ('status', 'method')
    search_fields = ('invoice_id',)
