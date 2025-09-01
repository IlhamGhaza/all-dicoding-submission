from django.db.models import Q
from rest_framework import viewsets, permissions, status
from rest_framework.exceptions import PermissionDenied, ValidationError
from rest_framework.response import Response

from .models import Event, Ticket, Registration, Payment
from .serializers import (
    EventSerializer,
    TicketSerializer,
    RegistrationSerializer,
    PaymentSerializer,
)
from .permissions import IsOrganizerOwnerOrAdmin, IsOwnerOrAdmin


class EventViewSet(viewsets.ModelViewSet):
    queryset = Event.objects.all()
    serializer_class = EventSerializer
    permission_classes = [IsOrganizerOwnerOrAdmin]
    filterset_fields = ['location', 'is_published']
    search_fields = ['name', 'description', 'location']
    ordering_fields = ['start_time', 'end_time', 'name']

    def perform_create(self, serializer):
        user = self.request.user
        if not (user.is_superuser or getattr(user, 'role', None) in ['admin', 'organizer']):
            raise PermissionDenied('Only admin or organizer can create events')
        serializer.save(organizer=user)


class TicketViewSet(viewsets.ModelViewSet):
    queryset = Ticket.objects.select_related('event', 'event__organizer').all()
    serializer_class = TicketSerializer
    permission_classes = [IsOrganizerOwnerOrAdmin]
    filterset_fields = ['event']
    search_fields = ['name', 'code']
    ordering_fields = ['price', 'name', 'created_at']

    def perform_create(self, serializer):
        user = self.request.user
        event = serializer.validated_data.get('event')
        if user.is_superuser or getattr(user, 'role', None) == 'admin':
            serializer.save()
            return
        if getattr(user, 'role', None) == 'organizer' and event.organizer == user:
            serializer.save()
            return
        raise PermissionDenied('Only admin or the organizer who owns the event can create tickets')


class RegistrationViewSet(viewsets.ModelViewSet):
    serializer_class = RegistrationSerializer
    permission_classes = [permissions.IsAuthenticated, IsOwnerOrAdmin]
    filterset_fields = ['status', 'ticket']
    ordering_fields = ['created_at']

    def get_queryset(self):
        user = self.request.user
        if user.is_superuser or getattr(user, 'role', None) == 'admin':
            return Registration.objects.select_related('ticket', 'ticket__event', 'user').all()
        if getattr(user, 'role', None) == 'organizer':
            return Registration.objects.select_related('ticket', 'ticket__event', 'user').filter(
                ticket__event__organizer=user
            )
        return Registration.objects.select_related('ticket', 'ticket__event', 'user').filter(user=user)

    def perform_create(self, serializer):
        quantity = serializer.validated_data.get('quantity', 1)
        if quantity <= 0:
            raise ValidationError({'quantity': 'Must be positive'})
        serializer.save(user=self.request.user)


class PaymentViewSet(viewsets.ModelViewSet):
    serializer_class = PaymentSerializer
    permission_classes = [permissions.IsAuthenticated, IsOwnerOrAdmin]
    filterset_fields = ['status', 'method']
    ordering_fields = ['created_at', 'amount']

    def get_queryset(self):
        user = self.request.user
        if user.is_superuser or getattr(user, 'role', None) == 'admin':
            return Payment.objects.select_related('registration', 'registration__user').all()
        if getattr(user, 'role', None) == 'organizer':
            return Payment.objects.select_related('registration', 'registration__user').filter(
                registration__ticket__event__organizer=user
            )
        return Payment.objects.select_related('registration', 'registration__user').filter(
            registration__user=user
        )

    def perform_create(self, serializer):
        registration = serializer.validated_data.get('registration')
        if registration.user != self.request.user and not (
            self.request.user.is_superuser or getattr(self.request.user, 'role', None) == 'admin'
        ):
            raise PermissionDenied('You can only pay for your own registration')
        serializer.save()
