# Laravel Notes App - Complete Project Structure

## Project Overview
A simple CRUD (Create, Read, Update, Delete) Notes application built with Laravel and MySQL, containerized with Docker.

---

## Technology Stack
- **Framework**: Laravel 12.x
- **PHP Version**: 8.2
- **Database**: MySQL 8.0
- **Web Server**: Nginx
- **Containerization**: Docker & Docker Compose

---

## Complete Folder Structure

```
FA22-BSE-DevOps-MidLab/
│
├── app/                                    # Application core files
│   ├── Http/
│   │   └── Controllers/
│   │       └── NoteController.php          # Handles all CRUD operations for notes
│   ├── Models/
│   │   ├── Note.php                        # Note model (represents notes table)
│   │   └── User.php                        # Default Laravel user model (not used)
│   └── Providers/
│       └── AppServiceProvider.php          # Service provider configuration
│
├── bootstrap/                              # Laravel bootstrap files
│   ├── app.php                            # Application bootstrap
│   ├── providers.php                       # Provider bootstrap
│   └── cache/                             # Bootstrap cache files
│       ├── config.php
│       ├── packages.php
│       ├── routes-v7.php
│       └── services.php
│
├── config/                                 # All configuration files
│   ├── app.php                            # Application configuration
│   ├── auth.php                           # Authentication config (not used)
│   ├── cache.php                          # Cache configuration
│   ├── database.php                       # Database connections
│   ├── filesystems.php                    # File storage configuration
│   ├── logging.php                        # Logging configuration
│   ├── mail.php                           # Mail configuration
│   ├── queue.php                          # Queue configuration
│   ├── services.php                       # Third-party services
│   └── session.php                        # Session configuration
│
├── database/                               # Database files
│   ├── factories/
│   │   └── UserFactory.php                # User factory (not used)
│   ├── migrations/                        # Database migrations
│   │   ├── 0001_01_01_000000_create_users_table.php
│   │   ├── 0001_01_01_000001_create_cache_table.php
│   │   ├── 0001_01_01_000002_create_jobs_table.php
│   │   └── 2025_10_29_213238_create_notes_table.php  # Notes table structure
│   └── seeders/
│       └── DatabaseSeeder.php             # Database seeding
│
├── docker/                                 # Docker configuration files
│   ├── nginx/
│   │   └── default.conf                   # Nginx server configuration
│   └── php/
│       └── Dockerfile                     # PHP container image definition
│
├── public/                                 # Publicly accessible files
│   ├── index.php                          # Application entry point
│   └── robots.txt                         # Search engine crawling rules
│
├── resources/                              # Frontend resources
│   ├── css/
│   │   └── app.css                        # Application styles
│   ├── js/
│   │   ├── app.js                         # Application JavaScript
│   │   └── bootstrap.js                   # Bootstrap JavaScript
│   └── views/                             # Blade templates (HTML views)
│       ├── welcome.blade.php              # Default welcome page (not used)
│       ├── layouts/
│       │   └── app.blade.php              # Main layout template
│       └── notes/                         # Notes-related views
│           ├── index.blade.php            # List all notes
│           ├── create.blade.php           # Create new note form
│           ├── edit.blade.php             # Edit note form
│           └── show.blade.php             # View single note
│
├── routes/                                 # Application routes
│   ├── console.php                        # Console routes
│   └── web.php                            # Web routes (contains notes CRUD routes)
│
├── storage/                                # Storage for logs, cache, uploads
│   ├── app/
│   │   ├── private/                       # Private files
│   │   └── public/                        # Public files
│   ├── framework/                         # Framework generated files
│   │   ├── cache/                         # Application cache
│   │   ├── sessions/                      # Session files
│   │   ├── testing/                       # Testing files
│   │   └── views/                         # Compiled blade views
│   └── logs/                              # Application logs
│
├── tests/                                  # Test files
│   ├── TestCase.php                       # Base test case
│   ├── Feature/
│   │   └── ExampleTest.php                # Feature tests
│   └── Unit/
│       └── ExampleTest.php                # Unit tests
│
├── vendor/                                 # Composer dependencies (auto-generated)
│
├── .env                                    # Environment variables (database credentials)
├── .env.example                           # Example environment file
├── .gitignore                             # Git ignore rules
├── artisan                                # Laravel command-line tool
├── composer.json                          # PHP dependencies
├── composer.lock                          # Locked PHP dependencies
├── docker-compose.yml                     # Docker services configuration
├── package.json                           # Node.js dependencies
├── phpunit.xml                            # PHPUnit testing configuration
├── README.md                              # Project documentation
└── vite.config.js                         # Vite build configuration

```

---

## Key Files Explained

### 1. **docker-compose.yml**
Defines 3 Docker services:
- **app**: PHP 8.2-FPM container (runs Laravel)
- **nginx**: Web server (port 8080)
- **mysql**: Database server (port 3306)

### 2. **docker/php/Dockerfile**
Builds the PHP container with:
- PHP 8.2-FPM base image
- Required PHP extensions (pdo_mysql, mbstring, gd, zip, etc.)
- Composer (dependency manager)
- User permissions setup

### 3. **docker/nginx/default.conf**
Nginx configuration:
- Listens on port 80 (mapped to 8080 on host)
- Routes requests to PHP-FPM container
- Serves files from `/var/www/public`

### 4. **.env**
Environment configuration:
```
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=notes_db
DB_USERNAME=laravel_user
DB_PASSWORD=password
```

### 5. **routes/web.php**
Application routes:
```php
Route::get('/', function () {
    return redirect()->route('notes.index');
});
Route::resource('notes', NoteController::class);
```

### 6. **app/Http/Controllers/NoteController.php**
Contains 7 methods:
- `index()` - List all notes
- `create()` - Show create form
- `store()` - Save new note
- `show()` - Display single note
- `edit()` - Show edit form
- `update()` - Update existing note
- `destroy()` - Delete note

### 7. **app/Models/Note.php**
Note model with fillable fields:
```php
protected $fillable = ['title', 'content'];
```

### 8. **database/migrations/2025_10_29_213238_create_notes_table.php**
Creates `notes` table with:
- `id` (primary key)
- `title` (string)
- `content` (text)
- `created_at` (timestamp)
- `updated_at` (timestamp)

---

## Database Structure

### MySQL Database: `notes_db`

**Table: notes**
| Column | Type | Description |
|--------|------|-------------|
| id | BIGINT UNSIGNED | Primary key (auto-increment) |
| title | VARCHAR(255) | Note title |
| content | TEXT | Note content |
| created_at | TIMESTAMP | Creation timestamp |
| updated_at | TIMESTAMP | Last update timestamp |

---

## Docker Services

### Service 1: app (PHP Application)
- **Image**: Custom built from `docker/php/Dockerfile`
- **Container Name**: laravel-app
- **Purpose**: Runs PHP-FPM and Laravel application
- **Port**: 9000 (internal)
- **Volume**: `.:/var/www` (project mounted)

### Service 2: nginx (Web Server)
- **Image**: nginx:alpine
- **Container Name**: laravel-nginx
- **Purpose**: Web server, handles HTTP requests
- **Port**: 8080 (external) → 80 (internal)
- **Volumes**: 
  - Project files: `.:/var/www`
  - Config: `./docker/nginx/default.conf`

### Service 3: mysql (Database)
- **Image**: mysql:8.0
- **Container Name**: laravel-mysql
- **Purpose**: MySQL database server
- **Port**: 3306 (exposed)
- **Environment Variables**:
  - MYSQL_DATABASE=notes_db
  - MYSQL_USER=laravel_user
  - MYSQL_PASSWORD=password
  - MYSQL_ROOT_PASSWORD=root
- **Volume**: mysql-data (persistent storage)

---

## Application Flow

1. **User Request** → Browser opens `http://localhost:8080`
2. **Nginx** → Receives request on port 80
3. **PHP-FPM** → Nginx forwards to PHP container on port 9000
4. **Laravel Router** → Routes request to NoteController
5. **Controller** → Processes request, interacts with Note model
6. **Model** → Queries MySQL database
7. **Database** → Returns data
8. **View** → Blade template renders HTML
9. **Response** → Sent back through Nginx to user's browser

---

## Available Routes

| Method | URI | Action | Purpose |
|--------|-----|--------|---------|
| GET | / | Redirect | Redirects to /notes |
| GET | /notes | index | Display all notes |
| GET | /notes/create | create | Show create form |
| POST | /notes | store | Save new note |
| GET | /notes/{id} | show | Display single note |
| GET | /notes/{id}/edit | edit | Show edit form |
| PUT/PATCH | /notes/{id} | update | Update note |
| DELETE | /notes/{id} | destroy | Delete note |

---

## Important Commands

### Docker Commands
```powershell
# Start all containers
docker-compose up -d

# Stop all containers
docker-compose down

# View running containers
docker-compose ps

# View logs
docker-compose logs -f

# Restart containers
docker-compose restart

# Rebuild containers
docker-compose up -d --build
```

### Laravel Artisan Commands
```powershell
# Run migrations
docker-compose exec app php artisan migrate

# Fresh migration (drop all tables and recreate)
docker-compose exec app php artisan migrate:fresh

# Clear cache
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan route:clear
docker-compose exec app php artisan view:clear

# Cache for performance
docker-compose exec app php artisan config:cache
docker-compose exec app php artisan route:cache
docker-compose exec app php artisan view:cache

# Access container bash
docker-compose exec app bash

# Check routes
docker-compose exec app php artisan route:list
```

### Database Commands
```powershell
# Access MySQL CLI
docker-compose exec mysql mysql -ularavel_user -ppassword notes_db

# Show databases
docker-compose exec mysql mysql -ularavel_user -ppassword -e "SHOW DATABASES;"

# Show tables
docker-compose exec mysql mysql -ularavel_user -ppassword notes_db -e "SHOW TABLES;"

# View notes data
docker-compose exec mysql mysql -ularavel_user -ppassword notes_db -e "SELECT * FROM notes;"
```

---

## How to Run the Project

1. **Prerequisites**: Docker Desktop installed and running

2. **Start containers**:
   ```powershell
   docker-compose up -d
   ```

3. **Wait for containers** to be ready (20-30 seconds)

4. **Run migrations** (first time only):
   ```powershell
   docker-compose exec app php artisan migrate
   ```

5. **Access application**: Open browser and go to `http://localhost:8080`

---

## Troubleshooting

### Issue: Port already in use
**Solution**: Stop other services using ports 8080 or 3306

### Issue: Permission errors
**Solution**: 
```powershell
docker-compose exec app chmod -R 775 storage bootstrap/cache
```

### Issue: Database connection failed
**Solution**: 
- Check if MySQL container is running: `docker-compose ps`
- Verify .env database credentials match docker-compose.yml

### Issue: Slow performance
**Solution**: Cache configuration
```powershell
docker-compose exec app php artisan config:cache
docker-compose exec app php artisan route:cache
docker-compose exec app php artisan view:cache
```

---

## Project Features

✅ Create new notes with title and content  
✅ View all notes in a paginated list  
✅ View individual note details  
✅ Edit existing notes  
✅ Delete notes with confirmation  
✅ Responsive design with gradient background  
✅ Form validation  
✅ Success messages after actions  
✅ Timestamps (created_at, updated_at)  

---

## For CI/CD Pipeline (Future Use)

This project is ready for:
- **GitHub Actions**: Automated testing and deployment
- **Docker Hub**: Container image registry
- **Unit Testing**: PHPUnit framework included
- **Feature Testing**: Laravel testing tools available

Test files location: `tests/Feature/` and `tests/Unit/`

---

## Notes for Viva/Presentation

1. **What is this project?**
   - A simple Notes CRUD application using Laravel and MySQL

2. **Why Docker?**
   - No need to install PHP, MySQL, or Nginx locally
   - Consistent environment across different machines
   - Easy to deploy and scale

3. **How many containers?**
   - 3 containers: PHP app, Nginx web server, MySQL database

4. **Database details?**
   - MySQL 8.0 in Docker container
   - Database: notes_db
   - One main table: notes (id, title, content, timestamps)

5. **Key technologies?**
   - Laravel (PHP framework)
   - MySQL (relational database)
   - Docker Compose (container orchestration)
   - Nginx (web server)

---

**Project Complete and Ready for DevOps Lab! 🚀**
