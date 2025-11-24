<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\AdminController;
use App\Http\Controllers\Admin\EventManagementController;
use App\Http\Controllers\Admin\DonationManagementController;
use App\Http\Controllers\Admin\ArticleManagementController;
use App\Http\Controllers\Admin\ContactManagementController;
use App\Http\Controllers\Admin\DonationGoalController;
use App\Http\Controllers\Admin\DonationGalleryController;
use App\Http\Controllers\Admin\FoundationProfileController;
use App\Http\Controllers\Admin\UserManagementController;
use App\Http\Controllers\Admin\ForumManagementController;

/*
|--------------------------------------------------------------------------
| Website Routes
|--------------------------------------------------------------------------
|
| Di sini adalah tempat untuk mendaftarkan route website utama.
| Route-route ini bisa diakses oleh semua pengunjung website.
|
*/

Route::get('/', function () {
    return view('welcome');
})->name('home');

/*
|--------------------------------------------------------------------------
| Admin Panel Routes
|--------------------------------------------------------------------------
|
| Semua route untuk admin panel dimulai dengan prefix 'admin'
| Contoh: /admin/login, /admin/dashboard, dll
|
*/
Route::prefix('admin')->name('admin.')->group(function () {

    /*
    |--------------------------------------------------------------------------
    | Admin Authentication Routes
    |--------------------------------------------------------------------------
    |
    | Route untuk login, register, dan logout admin
    | - GET  /admin/login    -> Halaman login
    | - POST /admin/login    -> Proses login
    | - GET  /admin/register -> Halaman register
    | - POST /admin/register -> Proses register
    | - POST /admin/logout   -> Proses logout
    |
    */
    Route::controller(AdminController::class)->group(function () {
        // Authentication Routes
        Route::get('/login', 'login')->name('login');
        Route::post('/login', 'doLogin')->name('doLogin');
        Route::get('/register', 'register')->name('register');
        Route::post('/register', 'doRegister')->name('doRegister');
        Route::post('/logout', 'logout')->name('logout');

        // Dashboard Route
        Route::get('/dashboard', 'dashboard')->name('dashboard');
    });

    /*
    |--------------------------------------------------------------------------
    | Event Management Routes
    |--------------------------------------------------------------------------
    |
    | Route untuk mengelola event
    | - CRUD Event
    | - Kategori Event
    | - Pendaftaran Event
    |
    */
    Route::prefix('events')->name('events.')->controller(EventManagementController::class)->group(function () {
        // Event CRUD
        // Daftar event
        Route::get('/', 'index')->name('index');
        // Form tambah event
        Route::get('/create', 'create')->name('create');
        // Simpan event baru
        Route::post('/', 'store')->name('store');
        // Form edit event
        Route::get('/{event}/edit', 'edit')->name('edit');
        // Update event
        Route::put('/{event}', 'update')->name('update');
        // Hapus event
        Route::delete('/{event}', 'destroy')->name('destroy');
        // Update status event
        Route::post('/{event}/update-status', 'updateStatus')->name('update-status');

        // Event Categories
        // Daftar kategori
        Route::get('/categories', 'categories')->name('categories');
        // Tambah kategori
        Route::post('/categories', 'storeCategory')->name('categories.store');
        // Update kategori
        Route::put('/categories/{category}', 'updateCategory')
            ->name('categories.update');
        // Hapus kategori
        Route::delete('/categories/{category}', 'destroyCategory')
            ->name('categories.destroy');

        // Event Registrations
        // Daftar pendaftaran
        Route::get('/registrations', 'registrations')->name('registrations');
        // Update status pendaftaran
        Route::post('/registrations/{registration}/update-status', 'updateRegistrationStatus')
            ->name('registrations.update-status');
    });

    /*
    |--------------------------------------------------------------------------
    | Donation Management Routes
    |--------------------------------------------------------------------------
    |
    | Route untuk mengelola donasi
    | - Daftar & Status Donasi
    | - Jenis Donasi
    |
    */
    Route::prefix('donations')->name('donations.')->controller(DonationManagementController::class)->group(function () {
        // Donation Management
        Route::get('/', 'index')->name('index');
        // Update status donasi
        Route::put('/{donation}/update-status', 'updateStatus')->name('update-status');

        // Donation Types
        Route::get('/types', 'types')->name('types');
        // Tambah jenis donasi
        Route::post('/types', 'storeType')->name('types.store');
        // Update jenis donasi
        Route::put('/types/{type}', 'updateType')->name('types.update');
        // Hapus jenis donasi
        Route::delete('/types/{type}', 'destroyType')->name('types.destroy');
    });

    /*
    |--------------------------------------------------------------------------
    | Shipping Methods Routes
    |--------------------------------------------------------------------------
    |
    | Route untuk mengelola metode pengiriman donasi
    |
    */
    Route::prefix('shipping-methods')->name('shipping-methods.')
        ->controller(DonationManagementController::class)->group(function () {
            // Daftar metode pengiriman
            Route::get('/', 'shippingMethods')->name('index');
            // Tambah metode pengiriman
            Route::post('/', 'storeShippingMethod')->name('store');
            // Update metode pengiriman
            Route::put('/{method}', 'updateShippingMethod')->name('update');
            // Hapus metode pengiriman
            Route::delete('/{method}', 'destroyShippingMethod')->name('destroy');
        });

    /*
    |--------------------------------------------------------------------------
    | Article Management Routes
    |--------------------------------------------------------------------------
    |
    */
    Route::prefix('articles')->name('articles.')->group(function () {
        Route::get('/', [ArticleManagementController::class, 'index'])->name('index');
        Route::get('/create', [ArticleManagementController::class, 'create'])->name('create');
        Route::post('/', [ArticleManagementController::class, 'store'])->name('store');
        Route::get('/{article}/edit', [ArticleManagementController::class, 'edit'])->name('edit');
        Route::put('/{article}', [ArticleManagementController::class, 'update'])->name('update');
        Route::delete('/{article}', [ArticleManagementController::class, 'destroy'])->name('destroy');
    });

    /*
    |--------------------------------------------------------------------------
    | Contact Management Routes
    |--------------------------------------------------------------------------
    |
    */
    Route::get('/contact', [ContactManagementController::class, 'index'])->name('contact.index');
    Route::put('/contact', [ContactManagementController::class, 'update'])->name('contact.update');

    // Donation Goals Routes
    Route::get('/donations/goals', [DonationGoalController::class, 'index'])->name('donations.goals');
    Route::post('/donations/goals', [DonationGoalController::class, 'store'])->name('donations.goals.store');
    Route::put('/donations/goals/{goal}', [DonationGoalController::class, 'update'])->name('donations.goals.update');
    Route::delete('/donations/goals/{goal}', [DonationGoalController::class, 'destroy'])->name('donations.goals.destroy');

    // Donation Gallery Management
    Route::get('/donation-gallery', [DonationGalleryController::class, 'index'])->name('donation-gallery.index');
    Route::post('/donation-gallery', [DonationGalleryController::class, 'store'])->name('donation-gallery.store');
    Route::delete('/donation-gallery/{id}', [DonationGalleryController::class, 'destroy'])->name('donation-gallery.destroy');

    // Foundation Profile Management
    Route::get('/foundation/profile', [FoundationProfileController::class, 'index'])->name('foundation.profile');
    Route::put('/foundation/profile', [FoundationProfileController::class, 'update'])->name('foundation.profile.update');

    // User Management
    Route::get('/users', [UserManagementController::class, 'index'])->name('users.index');
    Route::get('/users/{id}', [UserManagementController::class, 'show'])->name('users.show');
    Route::put('/users/{id}/toggle-admin', [UserManagementController::class, 'toggleAdmin'])->name('users.toggle-admin');

    // Forum Management
    Route::prefix('forum')->name('forum.')->group(function () {
        Route::get('/', [ForumManagementController::class, 'index'])->name('index');
        Route::get('/{id}', [ForumManagementController::class, 'show'])->name('show');
        Route::delete('/{id}', [ForumManagementController::class, 'destroyPost'])->name('destroy-post');
        Route::delete('/comment/{id}', [ForumManagementController::class, 'destroyComment'])->name('destroy-comment');
    });
});
