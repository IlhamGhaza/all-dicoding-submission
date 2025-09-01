from rest_framework import serializers

from .models import Product


class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = [
            'id',
            'name',
            'sku',
            'description',
            'shop',
            'location',
            'price',
            'discount',
            'category',
            'stock',
            'is_available',
            'picture',
            'is_delete',
        ]
        extra_kwargs = {
            'id': {'read_only': True},
            'is_delete': {'read_only': True},
        }

    def validate_price(self, value):
        if value < 0:
            raise serializers.ValidationError('Price must be >= 0.')
        return value

    def validate_discount(self, value):
        if value < 0:
            raise serializers.ValidationError('Discount must be >= 0.')
        return value

    def validate_stock(self, value):
        if value < 0:
            raise serializers.ValidationError('Stock must be >= 0.')
        return value
