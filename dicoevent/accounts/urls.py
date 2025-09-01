from django.urls import path
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from .views import RegisterView, MeView, UsersViewSet, GroupViewSet

router = DefaultRouter()
router.register(r'users', UsersViewSet, basename='user')
router.register(r'groups', GroupViewSet, basename='group')

urlpatterns = router.urls + [
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('me/', MeView.as_view(), name='me'),
]
