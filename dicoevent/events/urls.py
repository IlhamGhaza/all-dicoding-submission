from rest_framework.routers import DefaultRouter
from .views import EventViewSet, TicketViewSet, RegistrationViewSet, PaymentViewSet

router = DefaultRouter()
router.register(r'events', EventViewSet, basename='event')
router.register(r'tickets', TicketViewSet, basename='ticket')
router.register(r'registrations', RegistrationViewSet, basename='registration')
router.register(r'payments', PaymentViewSet, basename='payment')

urlpatterns = router.urls
