<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Carbon;

class Event extends Model
{
    protected $fillable = [
        'title',
        'content',
        'image',
        'additional_images',
        'date',
        'category_id',
        'status',
        'capacity',
        'enable_reminder',
        'reminder_at',
        'share_url',
        'registration_end_date'
    ];

    protected $casts = [
        'additional_images' => 'array',
        'date' => 'datetime',
        'reminder_at' => 'datetime',
        'registration_end_date' => 'datetime',
        'enable_reminder' => 'boolean'
    ];

    public function category()
    {
        return $this->belongsTo(EventCategory::class, 'category_id');
    }

    public function registrations()
    {
        return $this->hasMany(EventRegistration::class);
    }

    public function getAvailableSpotsAttribute()
    {
        return $this->capacity - $this->registrations()->count();
    }

    public function getTimeAttribute()
    {
        return $this->date ? $this->date->format('H:i') : null;
    }

    public function scopeFilter($query, array $filters)
    {
        $query->when($filters['search'] ?? false, fn($query, $search) =>
            $query->where('title', 'like', '%' . $search . '%')
        );

        $query->when($filters['category'] ?? false, fn($query, $category) =>
            $query->whereHas('category', fn($query) =>
                $query->where('slug', $category)
            )
        );

        $query->when($filters['status'] ?? false, fn($query, $status) =>
            $query->where('status', $status)
        );

        $query->when($filters['date'] ?? false, fn($query, $date) =>
            $query->whereDate('date', $date)
        );
    }

    public function updateStatus()
    {
        $now = Carbon::now();
        
        if ($this->date->isPast()) {
            $this->status = 'completed';
        } elseif ($this->date->isToday()) {
            $this->status = 'ongoing';
        } else {
            $this->status = 'upcoming';
        }
        
        $this->save();
    }
}
