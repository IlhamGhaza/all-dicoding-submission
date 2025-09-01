import uuid
from django.contrib.auth.models import AbstractUser
from django.db import models


class Roles(models.TextChoices):
    USER = 'user', 'User'
    ADMIN = 'admin', 'Admin'
    ORGANIZER = 'organizer', 'Organizer'


class User(AbstractUser):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    role = models.CharField(max_length=20, choices=Roles.choices, default=Roles.USER)

    def save(self, *args, **kwargs):
        # Ensure admin role has staff privileges
        if self.role == Roles.ADMIN:
            self.is_staff = True
        super().save(*args, **kwargs)
