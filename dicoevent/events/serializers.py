from django.contrib.auth import get_user_model
from rest_framework import serializers

from .models import Event, Ticket, Registration, Payment

User = get_user_model()


class EventSerializer(serializers.ModelSerializer):
    organizer = serializers.PrimaryKeyRelatedField(read_only=True)

    class Meta:
        model = Event
        fields = [
            'id', 'organizer', 'name', 'description', 'location',
            'start_time', 'end_time', 'capacity', 'is_published',
            'created_at', 'updated_at',
        ]
        read_only_fields = ['id', 'organizer', 'created_at', 'updated_at']


class TicketSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ticket
        fields = [
            'id', 'event', 'name', 'price', 'quota', 'code',
            'created_at', 'updated_at',
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class RegistrationSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(read_only=True)

    class Meta:
        model = Registration
        fields = [
            'id', 'user', 'ticket', 'quantity', 'status',
            'created_at', 'updated_at',
        ]
        read_only_fields = ['id', 'user', 'status', 'created_at', 'updated_at']


class PaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payment
        fields = [
            'id', 'registration', 'amount', 'method', 'status', 'invoice_id', 'paid_at',
            'created_at', 'updated_at',
        ]
        read_only_fields = ['id', 'status', 'created_at', 'updated_at']
