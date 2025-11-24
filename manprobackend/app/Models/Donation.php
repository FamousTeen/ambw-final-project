<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Donation extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'type',
        'quantity',
        'shipping_method',
        'status',
        'notes'
    ];

    protected $attributes = [
        'status' => 'pending'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public static function getAllowedStatuses()
    {
        return ['pending', 'accepted', 'success', 'failed'];
    }
}
