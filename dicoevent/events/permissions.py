from rest_framework.permissions import BasePermission, SAFE_METHODS


class IsAdminOrSuperuser(BasePermission):
    def has_permission(self, request, view):
        user = request.user
        return bool(user and user.is_authenticated and (getattr(user, 'role', None) == 'admin' or user.is_superuser))


class IsOrganizerOwnerOrAdmin(BasePermission):
    """
    Allow organizers to manage only their own Events and related resources.
    Admin/superuser can manage all.
    Read-only allowed if authenticated.
    """

    def has_permission(self, request, view):
        if request.method in SAFE_METHODS:
            return bool(request.user and request.user.is_authenticated)
        user = request.user
        if not user or not user.is_authenticated:
            return False
        if user.is_superuser or getattr(user, 'role', None) == 'admin':
            return True
        # For create, organizer allowed; object-level checked in has_object_permission
        return getattr(user, 'role', None) == 'organizer'

    def has_object_permission(self, request, view, obj):
        if request.method in SAFE_METHODS:
            return bool(request.user and request.user.is_authenticated)
        user = request.user
        if user.is_superuser or getattr(user, 'role', None) == 'admin':
            return True
        organizer = getattr(obj, 'organizer', None)
        if organizer is None and hasattr(obj, 'event'):
            organizer = getattr(obj.event, 'organizer', None)
        return getattr(user, 'role', None) == 'organizer' and organizer == user


class IsOwnerOrAdmin(BasePermission):
    """For Registration and Payment resources owned by a user."""

    def has_object_permission(self, request, view, obj):
        user = request.user
        if not user or not user.is_authenticated:
            return False
        if user.is_superuser or getattr(user, 'role', None) == 'admin':
            return True
        owner = getattr(obj, 'user', None)
        if owner is None and hasattr(obj, 'registration'):
            owner = getattr(obj.registration, 'user', None)
        return owner == user
