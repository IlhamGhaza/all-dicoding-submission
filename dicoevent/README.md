# DicoEvent API (Django 4.2, Python 3.10)

RESTful API untuk manajemen event dengan PostgreSQL, JWT Auth (3 jam akses), Custom User + RBAC (user, admin, organizer, superuser), dan UUID sebagai primary key.

## Fitur Utama
- PostgreSQL via env vars (DATABASE_NAME, DATABASE_USER, DATABASE_PASSWORD, DATABASE_HOST, DATABASE_PORT)
- Custom User dengan `role` (user, admin, organizer)
- Entitas: Event, Ticket, Registration, Payment (UUID PKs)
- JWT (SimpleJWT) sebagai default auth, Access Token 3 jam
- RBAC: superuser full, admin manage semua, organizer manage event miliknya, user manage registrations/payments miliknya
- Query lanjutan: filter, ordering, limit (pagination)
- ERD: file akan disediakan sebagai `ERD-DicoEvent-versi-1.png`

## Setup

1. Python 3.10 & Pipenv
2. Install dependencies:
   ```bash
   pipenv install
   ```
3. Salin `.env.example` menjadi `.env` dan isi kredensial PostgreSQL.
4. Migrasi database:
   ```bash
   pipenv run python manage.py makemigrations
   pipenv run python manage.py migrate
   ```
5. Buat superuser (opsional):
   ```bash
   pipenv run python manage.py createsuperuser
   ```
6. Jalankan server:
   ```bash
   pipenv run python manage.py runserver
   ```

## Endpoints
- Auth: `/api/register/`, `/api/login/`, `/api/refresh/`, `/api/me/`
- Users: `/api/users/` CRUD (list restricted to admin/superuser; detail self/admin/superuser)
- Groups: `/api/groups/` CRUD (superuser only)
- Events: `/api/events/` CRUD
- Tickets: `/api/tickets/` CRUD
- Registrations: `/api/registrations/` CRUD (tergantung role)
- Payments: `/api/payments/` CRUD (tergantung role)

