<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DonationGoal extends Model
{
    protected $fillable = [
        'donation_type_id',
        'target_quantity'
    ];

    protected $appends = ['current_quantity', 'percentage'];

    public function donationType()
    {
        return $this->belongsTo(DonationType::class);
    }

    public function getCurrentQuantityAttribute()
    {
        return Donation::where('type', $this->donationType->name)
            ->where('status', 'success')
            ->sum('quantity');
    }

    public function getPercentageAttribute()
    {
        if ($this->target_quantity == 0) return 0;
        return min(100, round(($this->current_quantity / $this->target_quantity) * 100));
    }
} 