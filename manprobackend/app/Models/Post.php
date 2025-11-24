<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Post extends Model
{
    protected $fillable = [
        'user_id',
        'content'
    ];

    protected $appends = ['liked', 'likes_count'];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class)->select('id', 'nama_lengkap', 'email', 'username');
    }

    public function comments()
    {
        return $this->hasMany(Comment::class);
    }

    public function likes()
    {
        return $this->hasMany(PostLike::class);
    }

    public function getLikedAttribute()
    {
        if (auth()->check()) {
            return $this->likes()->where('user_id', auth()->id())->exists();
        }
        // For testing without auth
        return $this->likes()->where('user_id', 1)->exists();
    }

    public function getLikesCountAttribute()
    {
        return $this->likes()->count();
    }
} 