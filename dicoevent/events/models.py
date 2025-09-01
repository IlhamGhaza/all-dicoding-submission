import uuid
from django.conf import settings
from django.db import models


class TimeStampedModel(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True


class Event(TimeStampedModel):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    organizer = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='events'
    )
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    location = models.CharField(max_length=255)
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()
    capacity = models.PositiveIntegerField(default=0)
    is_published = models.BooleanField(default=True)

    class Meta:
        ordering = ["start_time"]

    def __str__(self) -> str:
        return f"{self.name}"


class Ticket(TimeStampedModel):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    event = models.ForeignKey(Event, on_delete=models.CASCADE, related_name='tickets')
    name = models.CharField(max_length=120)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    quota = models.PositiveIntegerField(default=0)
    code = models.CharField(max_length=50, unique=True)

    class Meta:
        ordering = ["price", "name"]

    def __str__(self) -> str:
        return f"{self.name} - {self.event.name}"


class Registration(TimeStampedModel):
    STATUS_CHOICES = (
        ("pending", "Pending"),
        ("confirmed", "Confirmed"),
        ("cancelled", "Cancelled"),
    )
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='registrations')
    ticket = models.ForeignKey(Ticket, on_delete=models.CASCADE, related_name='registrations')
    quantity = models.PositiveIntegerField(default=1)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['user', 'ticket'], name='uniq_user_ticket'),
        ]
        ordering = ["-created_at"]

    def __str__(self) -> str:
        return f"{self.user.username} -> {self.ticket.name} ({self.quantity})"


class Payment(TimeStampedModel):
    METHOD_CHOICES = (
        ("wallet", "Wallet"),
        ("bank_transfer", "Bank Transfer"),
        ("credit_card", "Credit Card"),
    )
    STATUS_CHOICES = (
        ("pending", "Pending"),
        ("paid", "Paid"),
        ("failed", "Failed"),
        ("refunded", "Refunded"),
    )

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    registration = models.OneToOneField(Registration, on_delete=models.CASCADE, related_name='payment')
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    method = models.CharField(max_length=20, choices=METHOD_CHOICES)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    invoice_id = models.CharField(max_length=100, unique=True)
    paid_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self) -> str:
        return f"Payment {self.invoice_id} - {self.status}"
