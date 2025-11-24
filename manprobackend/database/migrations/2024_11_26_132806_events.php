<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Create event categories table
        Schema::create('event_categories', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('slug');
            $table->timestamps();
        });

        // Create events table with all features
        Schema::create('events', function (Blueprint $table) {
            $table->id();
            $table->foreignId('category_id')->nullable()->constrained('event_categories')->onDelete('set null');
            $table->string('title');
            $table->text('content');
            $table->string('image');
            $table->json('additional_images')->nullable();
            $table->date('date');
            $table->enum('status', ['upcoming', 'ongoing', 'completed'])->default('upcoming');
            $table->integer('capacity')->default(0);
            $table->boolean('enable_reminder')->default(true);
            $table->timestamp('reminder_at')->nullable();
            $table->string('share_url')->nullable();
            $table->timestamp('registration_end_date')->nullable();
            $table->timestamps();
        });

        // Create event registrations table
        Schema::create('event_registrations', function (Blueprint $table) {
            $table->id();
            $table->foreignId('event_id')->constrained()->onDelete('cascade');
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('name');
            $table->string('email');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('event_registrations');
        Schema::dropIfExists('events');
        Schema::dropIfExists('event_categories');
    }
};
