from rest_framework.permissions import BasePermission, SAFE_METHODS


class IsAdminOrSuperuser(BasePermission):
    def has_permission(self, request, view):
        user = request.user
        return bool(user and user.is_authenticated and (getattr(user, 'role', None) == 'admin' or user.is_superuser))


class AllowAnyReadAuthenticatedWrite(BasePermission):
    def has_permission(self, request, view):
        if request.method in SAFE_METHODS:
            return True
        return bool(request.user and request.user.is_authenticated)


class IsSuperuserOnly(BasePermission):
    def has_permission(self, request, view):
        user = request.user
        return bool(user and user.is_authenticated and user.is_superuser)
