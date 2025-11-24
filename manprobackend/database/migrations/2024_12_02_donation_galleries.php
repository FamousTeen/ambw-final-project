<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('donation_galleries', function (Blueprint $table) {
            $table->id();
            $table->string('image_path');
            $table->string('caption')->nullable();
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('donation_galleries');
    }
}; 