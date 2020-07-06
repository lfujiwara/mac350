from django.urls import path

from . import views

urlpatterns = [
    path('',  views.index),
    path('query1', views.query1),
    path('query2', views.query2),
    path('query3', views.query3),
    path('query4', views.query4),
    path('query5', views.query5)
]
