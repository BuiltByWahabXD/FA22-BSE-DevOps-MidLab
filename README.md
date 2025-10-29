# FA22-BSE-DevOps-MidLab

Laravel 10 Notes App using MySQL (Docker host db). A fully functional, minimal, and production-ready notes application with CRUD operations.

## Features

- **Full CRUD Operations**: Create, Read, Update, and Delete notes
- **Clean Tailwind UI**: Modern, responsive interface using Tailwind CSS
- **MySQL Database**: Running in Docker container for easy setup
- **RESTful API**: Proper resource routes and controller methods
- **Laravel 10**: Built on the latest Laravel framework

## Tech Stack

- **Laravel 10**: PHP framework
- **MySQL 8.0**: Database (via Docker)
- **Tailwind CSS**: Styling (via CDN)
- **PHP 8.1+**: Programming language

## Prerequisites

- PHP >= 8.1
- Composer
- Docker & Docker Compose
- Node.js & NPM (optional, for asset compilation)

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd FA22-BSE-DevOps-MidLab
```

2. Install PHP dependencies:
```bash
composer install
```

3. Copy environment file:
```bash
cp .env.example .env
```

4. Generate application key:
```bash
php artisan key:generate
```

5. Start MySQL with Docker:
```bash
docker-compose up -d
```

6. Wait for MySQL to be ready (about 30 seconds), then run migrations:
```bash
php artisan migrate
```

7. Start the development server:
```bash
php artisan serve
```

8. Visit `http://localhost:8000` in your browser

## Application Structure

### Models
- `Note` model with fillable fields: `title`, `content`

### Controllers
- `NoteController` with 7 RESTful methods:
  - `index()` - Display all notes
  - `create()` - Show create form
  - `store()` - Store new note
  - `show($id)` - Display single note
  - `edit($id)` - Show edit form
  - `update($id)` - Update note
  - `destroy($id)` - Delete note

### Routes
- Resource routes in `routes/web.php`:
  - `GET /notes` - List all notes
  - `GET /notes/create` - Show create form
  - `POST /notes` - Store new note
  - `GET /notes/{id}` - Show single note
  - `GET /notes/{id}/edit` - Show edit form
  - `PUT/PATCH /notes/{id}` - Update note
  - `DELETE /notes/{id}` - Delete note

### Views
- `layouts/app.blade.php` - Main layout with Tailwind CSS
- `notes/index.blade.php` - List all notes with grid layout
- `notes/form.blade.php` - Create/Edit form (shared)
- `notes/show.blade.php` - Single note view

### Database
- Migration: `create_notes_table` with fields:
  - `id` (primary key)
  - `title` (string)
  - `content` (text)
  - `created_at` (timestamp)
  - `updated_at` (timestamp)

## Docker Configuration

The `docker-compose.yml` file provides:
- MySQL 8.0 database
- Persistent data volume
- Port 3306 exposed for local connection

## Usage

### Creating a Note
1. Click "+ New Note" button
2. Enter title and content
3. Click "Create Note"

### Viewing Notes
- All notes are displayed on the home page in a grid layout
- Click "View" to see full note details

### Editing a Note
1. Click "Edit" on any note
2. Modify title or content
3. Click "Update Note"

### Deleting a Note
1. Click "Delete" on any note
2. Confirm deletion in the popup

## Testing

Run the test suite:
```bash
php artisan test
```

## Production Deployment

For production deployment:

1. Set `APP_ENV=production` in `.env`
2. Set `APP_DEBUG=false` in `.env`
3. Configure your production database in `.env`
4. Run migrations: `php artisan migrate --force`
5. Optimize: `php artisan optimize`
6. Set proper permissions on `storage` and `bootstrap/cache` directories

## License

Open source - MIT License
