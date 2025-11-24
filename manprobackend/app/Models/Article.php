<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Article extends Model
{
    protected $fillable = [
        'title',
        'content',
        'image',
        'additional_images',
        'date'
    ];

    protected $casts = [
        'additional_images' => 'array',
        'date' => 'date'
    ];
}
