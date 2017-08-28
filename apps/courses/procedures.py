from mysql.connector import MySQLConnection, Error


def conn_cursor(func):
    def wrapper(self, data=None):
        try:
            cursor = self._db_connection.cursor()
            return func(self, cursor, data)
        except Error as e:
            print(e)
        finally:
            cursor.close()
    return wrapper


class UsersDB:
    _db_connection = None

    def __init__(self):
        self._db_connection = MySQLConnection(
            host='127.0.0.1', user='Users_user',
            password='1511256515qQ', database='Users')

    def __del__(self):
        self._db_connection.close()

    @conn_cursor
    def add_user(self, cursor, data):
        cursor.callproc('add_user', data)
        self._db_connection.commit()
        return True

    @conn_cursor
    def get_user(self, cursor, data):
        cursor.callproc('get_user', data)
        result = [x.fetchall() for x in cursor.stored_results()]
        if len(result) > 0:
            result = result[0][0] if len(result[0]) > 0 else None
            return result
        else:
            return None

    @conn_cursor
    def search_users(self, cursor, data):
        cursor.callproc('search_users', data)
        result = [x.fetchall() for x in cursor.stored_results()]
        if len(result) > 0:
            return result[0]
        else:
            return None

    @conn_cursor
    def change_user(self, cursor, data):
        cursor.callproc('change_user', data)
        self._db_connection.commit()

    @conn_cursor
    def remove_user(self, cursor, data):
        cursor.callproc('remove_user', data)
        self._db_connection.commit()

    @conn_cursor
    def get_users_list(self, cursor, data):
        cursor.callproc('get_users_list', data)
        result = [x.fetchall() for x in cursor.stored_results()]
        if len(result) > 0:
            return result[0]
        else:
            return None

    @conn_cursor
    def get_courses_list(self, cursor, data):
        cursor.callproc('get_courses_list')
        result = [x.fetchall() for x in cursor.stored_results()]
        if len(result) > 0:
            return result[0]
        else:
            return None

    @conn_cursor
    def get_users_courses(self, cursor, data):
        cursor.callproc('get_users_courses', data)
        result = [x.fetchall() for x in cursor.stored_results()]
        if len(result) > 0:
            return result[0]
        else:
            return None

    @conn_cursor
    def add_users_course(self, cursor, data):
        cursor.callproc('add_users_course', data)
        self._db_connection.commit()

    @conn_cursor
    def remove_users_course(self, cursor, data):
        cursor.callproc('remove_users_course', data)
        self._db_connection.commit()


if __name__ == '__main__':
    udb = UsersDB()
    udb.get_users_list(['name', 3])
    # udb.get_courses_list()
    # udb.get_user([1])
    # udb.add_user(['Name', 'some_mail@mail.com', True, None, None])
    # udb.add_users_course([2, 1])
    # udb.change_user([15, 'Name', 'so_mail2@gmail.com', True, None, None])
    # udb.remove_users_course([2, 1])
