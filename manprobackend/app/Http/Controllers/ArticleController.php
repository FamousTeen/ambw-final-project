<?php

namespace App\Http\Controllers;

use App\Models\Article;
use App\Http\Requests\ArticleRequest;
use Illuminate\Support\Facades\Storage;
use Illuminate\Http\Request;

class ArticleController extends Controller
{
    public function index(Request $request)
    {
        try {
            $query = Article::latest();
            
            // Handle search
            if ($request->has('search')) {
                $searchTerm = $request->search;
                $query->where(function($q) use ($searchTerm) {
                    $q->where('title', 'like', "%{$searchTerm}%")
                      ->orWhere('content', 'like', "%{$searchTerm}%");
                });
            }
            
            // Handle pagination
            $perPage = $request->get('per_page', 10);
            $articles = $query->paginate($perPage);
            
            \Log::info('Fetching articles: ' . $articles->count());
            
            $articlesData = $articles->map(function ($article) {
                // Add full URL for images
                $imageUrl = $article->image;
                if (!filter_var($article->image, FILTER_VALIDATE_URL)) {
                    $imageUrl = asset('storage/' . $article->image);
                }
                
                // Process additional images if they exist
                $additionalImages = null;
                if ($article->additional_images) {
                    $additionalImages = collect($article->additional_images)->map(function ($image) {
                        if (!filter_var($image, FILTER_VALIDATE_URL)) {
                            return asset('storage/' . $image);
                        }
                        return $image;
                    })->toArray();
                }
                
                return [
                    'id' => $article->id,
                    'title' => $article->title,
                    'date' => $article->date->format('d F Y'),
                    'image' => $imageUrl,
                    'content' => $article->content,
                    'isAsset' => 'false',
                    'additional_images' => $additionalImages
                ];
            });

            return response()->json([
                'message' => 'Articles retrieved successfully',
                'data' => $articlesData,
                'meta' => [
                    'current_page' => $articles->currentPage(),
                    'last_page' => $articles->lastPage(),
                    'per_page' => $articles->perPage(),
                    'total' => $articles->total()
                ]
            ]);
        } catch (\Exception $e) {
            \Log::error('Error fetching articles: ' . $e->getMessage());
            return response()->json([
                'message' => 'Error fetching articles',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show(Article $article)
    {
        $imageUrl = $article->image;
        if (!filter_var($article->image, FILTER_VALIDATE_URL)) {
            $imageUrl = asset('storage/' . $article->image);
        }

        // Process additional images if they exist
        $additionalImages = null;
        if ($article->additional_images) {
            $additionalImages = collect($article->additional_images)->map(function ($image) {
                if (!filter_var($image, FILTER_VALIDATE_URL)) {
                    return asset('storage/' . $image);
                }
                return $image;
            })->toArray();
        }

        $articleData = [
            'id' => $article->id,
            'title' => $article->title,
            'date' => $article->date->format('d F Y'),
            'image' => $imageUrl,
            'content' => $article->content,
            'isAsset' => 'false',
            'additional_images' => $additionalImages
        ];

        return response()->json([
            'message' => 'Article details retrieved successfully',
            'data' => $articleData
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'content' => 'required|string',
            'image' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
            'additional_images.*' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'date' => 'required|date'
        ]);

        try {
            // Simpan gambar utama
            $imagePath = $request->file('image')->store('articles', 'public');
            
            // Simpan additional images jika ada
            $additionalImages = [];
            if ($request->hasFile('additional_images')) {
                foreach ($request->file('additional_images') as $image) {
                    $path = $image->store('articles', 'public');
                    $additionalImages[] = $path;
                }
            }
            
            $article = Article::create([
                'title' => $request->title,
                'content' => $request->content,
                'image' => $imagePath,
                'date' => $request->date,
                'additional_images' => $additionalImages
            ]);

            return response()->json([
                'message' => 'Article created successfully',
                'data' => $article
            ], 201);
        } catch (\Exception $e) {
            \Log::error('Error creating article: ' . $e->getMessage());
            return response()->json([
                'message' => 'Error creating article',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
