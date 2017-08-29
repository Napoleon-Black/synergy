import json

from django.core.paginator import Paginator
from django.shortcuts import render
from django.http import HttpResponse
from .procedures import UsersDB


# Create your views here.
def users_list(request):
    udb = UsersDB()
    if request.method == 'GET':
        order_by = 'name'

        if request.GET.get('limit', False):
            limit = int(request.GET.get('limit'))
            limit = limit if limit >= 10 and limit <= 20 else 10
        else:
            limit = 10

        if request.GET.get('page', False):
            page = int(request.GET.get('page'))
        else:
            page = 1

        if request.GET.get('search', False):
            users_filter = request.GET.get('search')
        else:
            users_filter = None

        if users_filter:
            users_list = udb.search_users([users_filter, order_by])
        else:
            users_list = udb.get_users_list([order_by])
        paginator = Paginator(users_list, limit)
        users_list = paginator.page(page)
        del udb
        return render(request, 'users_list.html',
                      {'users': users_list, 'limit': limit,
                       'users_filter': users_filter})

    if request.method == 'POST' and request.is_ajax():
        if request.POST.get('remove_user', False):
            user_id = request.POST.get('remove_user')
            udb.remove_user([user_id])
            del udb
            return HttpResponse(status=204)


def courses_list(request):
    udb = UsersDB()
    courses_list = udb.get_courses_list()
    del udb
    return render(request, 'courses_list.html', {'courses': courses_list})


def create_user(request):
    if request.method == 'POST' and request.is_ajax():
        if request.POST.get('name', False)\
           and request.POST.get('email', False):
            user_name = request.POST.get('name')
            user_email = request.POST.get('email')

            user_phone = request.POST.get('phone_no')
            user_phone = user_phone if user_phone else None

            user_mobile = request.POST.get('mobile_no')
            user_mobile = user_mobile if user_mobile else None

            user_status = request.POST.get('status')
            user_status = True if user_status == 'active' else False

            udb = UsersDB()
            udb.add_user([user_name, user_email, user_status,
                          user_phone, user_mobile])
            del udb
            return HttpResponse(status=204)
    return render(request, 'create_user.html')


def change_user(request, uid):
    udb = UsersDB()
    if request.method == 'POST' and request.is_ajax():
        if request.POST.get('name', False)\
           and request.POST.get('email', False):
            user_name = request.POST.get('name')
            user_email = request.POST.get('email')

            user_phone = request.POST.get('phone_no')
            user_phone = user_phone if user_phone else None

            user_mobile = request.POST.get('mobile_no')
            user_mobile = user_mobile if user_mobile else None

            user_status = request.POST.get('status')
            user_status = True if user_status == 'active' else False
            udb.change_user([uid, user_name, user_email, user_status,
                             user_phone, user_mobile])
            del udb
            return HttpResponse(status=204)

        if request.POST.get('1'):
            udb.remove_users_course([uid])
            for i in request.POST.items():
                if request.POST.get(i[0]) == 'true':
                    udb.add_users_course([uid, i[0]])

            return HttpResponse(status=204)
        return HttpResponse(status=204)

    if request.method == 'GET':
        user = udb.get_user([uid])
        courses = udb.get_courses_list()
        user_courses = udb.get_users_courses([uid])

        show_courses = []

        courses_status = []

        for course in courses:
            if course not in user_courses\
               and course not in show_courses:
                course_status = list(course)
                course_status.append(False)
                courses_status.append(course_status)
                show_courses.append(course)
            elif course not in show_courses:
                course_status = list(course)
                course_status.append(True)
                courses_status.append(course_status)
        del udb
        return render(request, 'change_user.html',
                      {'user': user, 'courses': show_courses,
                       'user_courses': user_courses,
                       'js_courses': json.dumps(courses_status)})
