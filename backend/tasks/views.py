from django.core.cache import cache
from rest_framework import status, viewsets, pagination
from rest_framework.response import Response

from .models import Task
from .serializers import TaskSerializer


class SmallResultsSetPagination(pagination.PageNumberPagination):
    page_size = 20
    page_size_query_param = 'page_size'
    max_page_size = 100


class TaskView(viewsets.ModelViewSet):
    """ViewSet for managing tasks.

    List endpoint is cached for short duration to reduce DB load. Create/update/delete
    operations invalidate the cache.
    """
    serializer_class = TaskSerializer
    queryset = Task.objects.all().only('id', 'title', 'completed', 'created_at')
    pagination_class = SmallResultsSetPagination

    def list(self, request, *args, **kwargs):
        cache_key = 'tasks:list:page:%s' % request.query_params.get('page', '1')
        data = cache.get(cache_key)
        if data is not None:
            return Response(data)

        response = super().list(request, *args, **kwargs)
        cache.set(cache_key, response.data, 5)  # short cache (5s)
        return response

    def perform_create(self, serializer):
        obj = serializer.save()
        cache.clear()
        return obj

    def perform_update(self, serializer):
        obj = serializer.save()
        cache.clear()
        return obj

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        self.perform_destroy(instance)
        cache.clear()
        return Response(serializer.data, status=status.HTTP_200_OK)
