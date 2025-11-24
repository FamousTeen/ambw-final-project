<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DonationGallery extends Model
{
    protected $fillable = [
        'image_path',
        'caption'
    ];
} 