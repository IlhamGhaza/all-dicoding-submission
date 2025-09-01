from django.contrib.auth import get_user_model
from django.contrib.auth.models import Group
from rest_framework import generics, permissions, viewsets
from rest_framework.response import Response
from rest_framework.exceptions import PermissionDenied
from .serializers import (
    RegisterSerializer,
    UserSerializer,
    UserCreateUpdateSerializer,
    GroupSerializer,
)
from .permissions import IsSuperuserOnly

User = get_user_model()


class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    permission_classes = [permissions.AllowAny]


class MeView(generics.RetrieveAPIView):
    serializer_class = UserSerializer

    def get_object(self):
        return self.request.user


class UsersViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    permission_classes = [permissions.IsAuthenticated]

    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return UserCreateUpdateSerializer
        return UserSerializer

    def get_permissions(self):
        if self.action == 'create':
            return [permissions.AllowAny()]
        return super().get_permissions()

    def list(self, request, *args, **kwargs):
        user = request.user
        if not (user.is_authenticated and (user.is_superuser or getattr(user, 'role', None) == 'admin')):
            raise PermissionDenied('Only admin or superuser can list users')
        queryset = self.filter_queryset(self.get_queryset())
        serializer = UserSerializer(queryset, many=True)
        return Response({'users': serializer.data})

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        user = request.user
        if not (user.is_superuser or getattr(user, 'role', None) == 'admin' or instance == user):
            raise PermissionDenied('You can only view your own profile')
        serializer = UserSerializer(instance)
        return Response(serializer.data)

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        user = request.user
        if not (user.is_superuser or getattr(user, 'role', None) == 'admin' or instance == user):
            raise PermissionDenied('You can only update your own profile')
        return super().update(request, *args, **kwargs)

    def partial_update(self, request, *args, **kwargs):
        instance = self.get_object()
        user = request.user
        if not (user.is_superuser or getattr(user, 'role', None) == 'admin' or instance == user):
            raise PermissionDenied('You can only update your own profile')
        return super().partial_update(request, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        user = request.user
        if not (user.is_superuser or getattr(user, 'role', None) == 'admin'):
            raise PermissionDenied('Only admin or superuser can delete users')
        return super().destroy(request, *args, **kwargs)


class GroupViewSet(viewsets.ModelViewSet):
    queryset = Group.objects.all()
    serializer_class = GroupSerializer
    permission_classes = [IsSuperuserOnly]

    def list(self, request, *args, **kwargs):
        queryset = self.filter_queryset(self.get_queryset())
        serializer = self.get_serializer(queryset, many=True)
        return Response({'groups': serializer.data})
