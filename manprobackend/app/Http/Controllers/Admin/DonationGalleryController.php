<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\DonationGallery;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class DonationGalleryController extends Controller
{
    public function index()
    {
        $images = DonationGallery::latest()->get();
        return view('admin.donations.gallery', compact('images'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'image' => 'required|image|mimes:jpeg,png,jpg|max:2048',
            'caption' => 'nullable|string|max:255'
        ]);

        if ($request->hasFile('image')) {
            $image = $request->file('image');
            $path = $image->store('donation-gallery', 'public');

            DonationGallery::create([
                'image_path' => $path,
                'caption' => $request->caption
            ]);

            return redirect()->back()->with('success', 'Image uploaded successfully');
        }

        return redirect()->back()->with('error', 'No image uploaded');
    }

    public function destroy($id)
    {
        $image = DonationGallery::findOrFail($id);
        Storage::disk('public')->delete($image->image_path);
        $image->delete();

        return redirect()->back()->with('success', 'Image deleted successfully');
    }
} 