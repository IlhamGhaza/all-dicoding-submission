from django.shortcuts import get_object_or_404
from django.urls import reverse
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.conf import settings
from django.core.validators import URLValidator
from django.core.exceptions import ValidationError

from .models import Product
from .serializers import ProductSerializer

JSON_MIME = 'application/json'
NOT_FOUND_DETAIL = 'Not found.'
ALLOWED_INPUT_FIELDS = {
    'name', 'sku', 'description', 'shop', 'location', 'price', 'discount',
    'category', 'stock', 'is_available', 'picture'
}

# Accept alternative (Indonesian) client field names and map them to model fields
INPUT_FIELD_ALIASES = {
    'nama': 'name',
    'lokasi': 'location',
    'kategori': 'category',
    'gambar': 'picture',
    'toko': 'shop',
    'deskripsi': 'description',
    'harga': 'price',
    'diskon': 'discount',
    'stok': 'stock',
    'isAvailable': 'is_available',
}

def normalize_input(data):
    """Return a dict containing only allowed fields, mapping known aliases.

    Unknown fields are ignored. This function supports clients sending
    Indonesian keys like 'nama', 'lokasi', 'kategori', 'gambar'.
    """
    normalized = {}
    for k, v in getattr(data, 'items', lambda: [])():
        # Map alias -> canonical field name if applicable
        canonical = INPUT_FIELD_ALIASES.get(k, k)
        if canonical in ALLOWED_INPUT_FIELDS:
            normalized[canonical] = v
    return normalized


def product_links(request, product_id):
    base = request.build_absolute_uri('/')[:-1]
    detail_path = reverse('product-detail', kwargs={'pk': product_id})
    return [
        {
            'rel': 'self',
            'href': f"{base}/products/",
            'action': 'POST',
            'types': [JSON_MIME],
        },
        {
            'rel': 'self',
            'href': f"{base}{detail_path}",
            'action': 'GET',
            'types': [JSON_MIME],
        },
        {
            'rel': 'self',
            'href': f"{base}{detail_path}",
            'action': 'PUT',
            'types': [JSON_MIME],
        },
        {
            'rel': 'self',
            'href': f"{base}{detail_path}",
            'action': 'DELETE',
            'types': [JSON_MIME],
        },
    ]


@method_decorator(csrf_exempt, name='dispatch')
class ProductListCreateView(APIView):
    def get(self, request):
        # For consistency, don't show soft-deleted products in list
        queryset = Product.objects.filter(is_delete=False)
        # Support Indonesian query parameter aliases as well
        name_kw = request.query_params.get('name') or request.query_params.get('nama')
        location_kw = request.query_params.get('location') or request.query_params.get('lokasi')
        if name_kw:
            queryset = queryset.filter(name__icontains=name_kw)
        if location_kw:
            queryset = queryset.filter(location__icontains=location_kw)

        products = []
        for p in queryset:
            data = ProductSerializer(p).data
            data['_links'] = product_links(request, p.id)
            products.append(data)

        return Response({'products': products}, status=status.HTTP_200_OK)

    def post(self, request):
        # Normalize/whitelist incoming payload keys
        payload = normalize_input(request.data)
        serializer = ProductSerializer(data=payload)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        product = serializer.save()
        data = ProductSerializer(product).data
        data['_links'] = product_links(request, product.id)
        return Response(data, status=status.HTTP_201_CREATED)


@method_decorator(csrf_exempt, name='dispatch')
class ProductDetailUpdateDeleteView(APIView):
    def get_object(self, pk):
        return get_object_or_404(Product, pk=pk, is_delete=False)

    def get(self, request, pk):
        if settings.OPENSHOP_SOFT_DELETE:
            # In soft delete mode, detail returns even if product is soft-deleted
            try:
                product = Product.objects.get(pk=pk)
            except Product.DoesNotExist:
                return Response({'detail': NOT_FOUND_DETAIL}, status=status.HTTP_404_NOT_FOUND)
        else:
            # In hard delete mode, return 404 if not found or soft-deleted
            try:
                product = self.get_object(pk)
            except Exception:
                return Response({'detail': NOT_FOUND_DETAIL}, status=status.HTTP_404_NOT_FOUND)
        data = ProductSerializer(product).data
        data['_links'] = product_links(request, product.id)
        return Response(data, status=status.HTTP_200_OK)

    def put(self, request, pk):
        # Allow update even if the product is soft-deleted; 404 only if it truly doesn't exist
        try:
            product = Product.objects.get(pk=pk)
        except Product.DoesNotExist:
            return Response({'detail': NOT_FOUND_DETAIL}, status=status.HTTP_404_NOT_FOUND)
        # Normalize/whitelist incoming payload keys
        payload = normalize_input(request.data)
        # If picture is empty, non-string, or invalid URL in PUT, ignore it to keep current value
        if 'picture' in payload:
            val = payload['picture']
            if val is None or not isinstance(val, str) or val.strip() == '':
                payload.pop('picture')
            else:
                try:
                    URLValidator()(val)
                except ValidationError:
                    payload.pop('picture')
        serializer = ProductSerializer(product, data=payload, partial=True)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        product = serializer.save()
        data = ProductSerializer(product).data
        data['_links'] = product_links(request, product.id)
        return Response(data, status=status.HTTP_200_OK)

    def delete(self, request, pk):
        try:
            product = self.get_object(pk)
        except Exception:
            return Response({'detail': NOT_FOUND_DETAIL}, status=status.HTTP_404_NOT_FOUND)
        if settings.OPENSHOP_SOFT_DELETE:
            product.is_delete = True
            product.save(update_fields=['is_delete'])
        else:
            product.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
