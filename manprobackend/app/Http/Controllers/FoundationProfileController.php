<?php

namespace App\Http\Controllers;

use App\Models\FoundationProfile;

class FoundationProfileController extends Controller
{
    public function index()
    {
        $profile = FoundationProfile::first();
        
        return response()->json([
            'status' => 'success',
            'data' => [
                'description' => $profile ? $profile->description : ''
            ]
        ]);
    }
} 