<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    protected $fillable = [
        'user_id',
        'post_id',
        'body'
    ];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    protected $hidden = [
        'updated_at'
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