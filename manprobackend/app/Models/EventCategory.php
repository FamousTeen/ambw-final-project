<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class EventCategory extends Model
{
    protected $fillable = ['name', 'slug'];

    protected static function boot()
    {
        parent::boot();
        
        // Auto-generate slug from name when creating/updating
        static::saving(function ($category) {
            $category->slug = Str::slug($category->name);
        });
    }

    public function events()
    {
        return $this->hasMany(Event::class, 'category_id');
    }
}