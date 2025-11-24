from rest_framework import serializers

from .models import Task


class TaskSerializer(serializers.ModelSerializer):
    title = serializers.CharField(max_length=120)

    class Meta:
        model = Task
        fields = ('id', 'title', 'description', 'completed', 'created_at', 'updated_at')
        read_only_fields = ('created_at', 'updated_at')

    def validate_title(self, value):
        if not value.strip():
            raise serializers.ValidationError('Title must not be blank')
        return value.strip()
