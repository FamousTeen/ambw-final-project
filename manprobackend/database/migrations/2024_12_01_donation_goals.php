<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('donation_goals', function (Blueprint $table) {
            $table->id();
            $table->foreignId('donation_type_id')->constrained('donation_types')->onDelete('cascade');
            $table->integer('target_quantity');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('donation_goals');
    }
}; 