<?php

namespace App\Http\Controllers;

use App\Models\EventCategory;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class EventCategoryController extends Controller
{
    public function index()
    {
        $categories = EventCategory::all();
        return response()->json([
            'message' => 'Categories retrieved successfully',
            'data' => $categories
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:event_categories'
        ]);

        $category = EventCategory::create([
            'name' => $request->name,
            'slug' => Str::slug($request->name)
        ]);

        return response()->json([
            'message' => 'Category created successfully',
            'data' => $category
        ], 201);
    }

    public function update(Request $request, EventCategory $category)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:event_categories,name,' . $category->id
        ]);

        $category->update([
            'name' => $request->name,
            'slug' => Str::slug($request->name)
        ]);

        return response()->json([
            'message' => 'Category updated successfully',
            'data' => $category
        ]);
    }

    public function destroy(EventCategory $category)
    {
        // Cek apakah kategori masih digunakan oleh event
        if ($category->events()->exists()) {
            return response()->json([
                'message' => 'Cannot delete category that is still being used by events'
            ], 422);
        }

        $category->delete();

        return response()->json([
            'message' => 'Category deleted successfully'
        ]);
    }
}