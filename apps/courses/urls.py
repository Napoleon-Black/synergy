from django.conf.urls import url
from .views import *


urlpatterns = [
    url(r'^$', users_list, name='users_list'),
    url(r'^add-user/$', create_user, name='create_user'),
    url(r'^change-user/(?P<uid>\d+)/$', change_user, name='change_user'),
    url(r'^courses-list/$', courses_list, name='courses_list'),
]
