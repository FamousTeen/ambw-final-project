<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Auth\AuthenticationController;
use App\Http\Controllers\DonationController;
use App\Http\Controllers\EventController;
use App\Http\Controllers\ArticleController;
use App\Http\Controllers\EventCategoryController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\ContactController;
use App\Http\Controllers\DonationTypeController;
use App\Http\Controllers\ShippingMethodController;
use App\Http\Controllers\DonationGoalController;
use App\Http\Controllers\API\DonationGalleryController;
use App\Http\Controllers\FoundationProfileController;
use App\Http\Controllers\PostController;

// Public test routes
Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::get('/test', function () {
    return response([
        'message' => 'Api is working'
    ], 200);
});

// Authentication routes
Route::post('/register', [AuthenticationController::class, 'register']);
Route::post('/login', [AuthenticationController::class, 'login']);
Route::get('/get/login/{id}', [AuthenticationController::class, 'getLogin']);
Route::post('/forget-password', [AuthenticationController::class, 'forgetPassword']);

// Protected authentication routes
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthenticationController::class, 'logout']);
});

// Public event routes
Route::get('/events/list', [EventController::class, 'index']);
Route::get('/events/{event}', [EventController::class, 'show']);
Route::post('/validate-email', [EventController::class, 'validateEmail']);
Route::get('/event-categories', [EventCategoryController::class, 'index']);

// Protected event routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/event/history', [EventController::class, 'history']);
    Route::post('/events/register', [EventController::class, 'register']);
    Route::delete('/events/registration/{registration}', [EventController::class, 'cancelRegistration']);
    Route::post('/events/{event}/toggle-reminder', [EventController::class, 'toggleReminder']);
    Route::get('/events/{event}/share', [EventController::class, 'generateShareUrl']);
    Route::put('/events/{event}', [EventController::class, 'update']);
});

// Admin event routes
Route::post('/events', [EventController::class, 'store']);

// Protected event category routes (admin only)
Route::middleware(['auth:sanctum'])->group(function () {
    Route::post('/event-categories', [EventCategoryController::class, 'store']);
    Route::put('/event-categories/{category}', [EventCategoryController::class, 'update']);
    Route::delete('/event-categories/{category}', [EventCategoryController::class, 'destroy']);
});

// Public article routes
Route::get('/articles/list', [ArticleController::class, 'index']);
Route::get('/articles/{article}', [ArticleController::class, 'show']);

// Admin article routes
Route::post('/articles', [ArticleController::class, 'store']);

// Protected donation routes
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/donations', [DonationController::class, 'donasi']);
    Route::get('/donations/history', [DonationController::class, 'history']);
    Route::patch('/donations/{donation}/status', [DonationController::class, 'updateStatus']);
    Route::patch('/donations/{donation}/cancel', [DonationController::class, 'cancel']);
});

// Public donation type routes
Route::get('/donation-types', [DonationTypeController::class, 'index']);

// Protected donation type routes (admin only)
Route::middleware(['auth:sanctum'])->group(function () {
    Route::post('/donation-types', [DonationTypeController::class, 'store']);
    Route::put('/donation-types/{type}', [DonationTypeController::class, 'update']);
    Route::delete('/donation-types/{type}', [DonationTypeController::class, 'destroy']);
});

// Protected profile routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/profile', [ProfileController::class, 'show']);
    Route::post('/profile/update', [ProfileController::class, 'update']);
});

// Public contact routes
Route::get('/contact', [ContactController::class, 'show']);

// Protected contact routes (admin only)
Route::middleware(['auth:sanctum'])->group(function () {
    Route::post('/contact', [ContactController::class, 'update']);
});

// Public shipping method routes
Route::get('/shipping-methods', [ShippingMethodController::class, 'index']);

// Protected shipping method routes (admin only)
Route::middleware(['auth:sanctum'])->group(function () {
    Route::post('/shipping-methods', [ShippingMethodController::class, 'store']);
    Route::put('/shipping-methods/{method}', [ShippingMethodController::class, 'update']);
    Route::delete('/shipping-methods/{method}', [ShippingMethodController::class, 'destroy']);
});

// Public donation goals routes
Route::get('/donation-goals', [DonationGoalController::class, 'index']);

// Donation Gallery
Route::get('/donation-gallery', [App\Http\Controllers\DonationGalleryController::class, 'index']);

// Foundation Profile
Route::get('/foundation-profile', [FoundationProfileController::class, 'index']);

// Forum Routes
Route::middleware('auth:sanctum')->group(function () {
    Route::prefix('posts')->group(function () {
        Route::get('/', [PostController::class, 'index']);
        Route::post('/', [PostController::class, 'store']);
        Route::get('/{postId}/comments', [PostController::class, 'getComments']);
        Route::post('/{postId}/comments', [PostController::class, 'storeComment']);
        Route::post('/{postId}/toggle-like', [PostController::class, 'toggleLike']);
        Route::delete('/{postId}', [PostController::class, 'destroy']);
    });
});
