<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PostLike extends Model
{
    protected $fillable = [
        'user_id',
        'post_id'
    ];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class)->select(['id', 'nama_lengkap', 'email', 'username']);
    }

    public function post()
    {
        return $this->belongsTo(Post::class);
    }
} 