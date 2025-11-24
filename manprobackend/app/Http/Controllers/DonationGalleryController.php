<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\DonationGallery;

class DonationGalleryController extends Controller
{
    public function index()
    {
        $images = DonationGallery::latest()->get()->map(function ($image) {
            return [
                'id' => $image->id,
                'image_url' => asset('storage/' . $image->image_path),
                'caption' => $image->caption
            ];
        });

        return response()->json([
            'status' => 'success',
            'data' => $images
        ]);
    }
} 