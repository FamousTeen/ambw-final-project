<?php

namespace App\Http\Controllers;

use App\Models\DonationGoal;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class DonationGoalController extends Controller
{
    public function index()
    {
        try {
            $goals = DonationGoal::with('donationType')
                ->get()
                ->map(function ($goal) {
                    return [
                        'id' => $goal->id,
                        'type' => $goal->donationType ? $goal->donationType->name : 'Unknown',
                        'target_quantity' => (int) $goal->target_quantity,
                        'current_quantity' => (int) $goal->current_quantity,
                        'percentage' => (int) $goal->percentage
                    ];
                });

            return response()->json([
                'status' => 'success',
                'data' => $goals
            ]);
        } catch (\Exception $e) {
            Log::error('Error fetching donation goals: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to fetch donation goals',
                'debug_message' => config('app.debug') ? $e->getMessage() : null
            ], 500);
        }
    }
} 