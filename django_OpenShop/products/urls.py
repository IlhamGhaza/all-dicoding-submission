from django.urls import path

from .views import ProductListCreateView, ProductDetailUpdateDeleteView

urlpatterns = [
    path('products/', ProductListCreateView.as_view(), name='product-list-create'),
    path('products/<uuid:pk>/', ProductDetailUpdateDeleteView.as_view(), name='product-detail'),
]
