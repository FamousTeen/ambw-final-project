<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\FoundationProfile;
use Illuminate\Http\Request;

class FoundationProfileController extends Controller
{
    public function index()
    {
        $profile = FoundationProfile::first() ?? new FoundationProfile();
        return view('admin.foundation.profile', compact('profile'));
    }

    public function update(Request $request)
    {
        $request->validate([
            'description' => 'required|string'
        ]);

        $profile = FoundationProfile::first();
        if ($profile) {
            $profile->update([
                'description' => $request->description
            ]);
        } else {
            FoundationProfile::create([
                'description' => $request->description
            ]);
        }

        return redirect()->back()->with('success', 'Foundation profile has been updated successfully');
    }
} 