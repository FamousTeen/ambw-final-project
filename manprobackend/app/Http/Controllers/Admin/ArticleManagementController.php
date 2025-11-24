<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Article;
use App\Http\Requests\ArticleRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ArticleManagementController extends Controller
{
    public function index(Request $request)
    {
        $query = Article::query();

        // Search by title
        if ($request->has('search')) {
            $search = $request->search;
            $query->where('title', 'LIKE', "%{$search}%");
        }

        $articles = $query->latest()->paginate(10);
        return view('admin.articles.index', compact('articles'));
    }

    public function create()
    {
        return view('admin.articles.create');
    }

    public function store(ArticleRequest $request)
    {
        try {
            \Log::info('Article store method called');
            \Log::info('Request data:', $request->all());

            // Handle main image upload
            $imagePath = $request->file('image')->store('articles', 'public');
            \Log::info('Main image uploaded:', ['path' => $imagePath]);

            // Handle additional images
            $additionalImages = [];
            if ($request->hasFile('additional_images')) {
                foreach ($request->file('additional_images') as $image) {
                    $additionalImages[] = $image->store('articles', 'public');
                }
                \Log::info('Additional images uploaded:', $additionalImages);
            }

            // Create article
            $article = Article::create([
                'title' => $request->title,
                'content' => $request->content,
                'image' => $imagePath,
                'additional_images' => !empty($additionalImages) ? json_encode($additionalImages) : null,
                'date' => now()->toDateString()
            ]);

            \Log::info('Article created:', $article->toArray());

            return redirect()->route('admin.articles.index')
                ->with('success', 'Article created successfully.');
        } catch (\Exception $e) {
            \Log::error('Error creating article:', [
                'message' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            // Clean up uploaded files if there's an error
            if (isset($imagePath)) {
                Storage::disk('public')->delete($imagePath);
            }
            if (!empty($additionalImages)) {
                foreach ($additionalImages as $image) {
                    Storage::disk('public')->delete($image);
                }
            }

            return back()->with('error', 'Error creating article: ' . $e->getMessage())
                ->withInput();
        }
    }

    public function edit(Article $article)
    {
        return view('admin.articles.edit', compact('article'));
    }

    public function update(ArticleRequest $request, Article $article)
    {
        try {
            $data = [
                'title' => $request->title,
                'content' => $request->content,
                'date' => $request->date ?? $article->date
            ];

            // Handle main image update
            if ($request->hasFile('image')) {
                // Delete old image
                if ($article->image) {
                    Storage::disk('public')->delete($article->image);
                }
                $data['image'] = $request->file('image')->store('articles', 'public');
            }

            // Handle additional images
            $currentAdditionalImages = $article->additional_images ? json_decode($article->additional_images, true) : [];
            
            // Remove images that were marked for deletion
            if ($request->removed_images) {
                $removedImages = json_decode($request->removed_images, true);
                foreach ($removedImages as $image) {
                    Storage::disk('public')->delete($image);
                    $currentAdditionalImages = array_diff($currentAdditionalImages, [$image]);
                }
            }

            // Add new additional images
            if ($request->hasFile('additional_images')) {
                foreach ($request->file('additional_images') as $image) {
                    $currentAdditionalImages[] = $image->store('articles', 'public');
                }
            }

            $data['additional_images'] = !empty($currentAdditionalImages) ? 
                json_encode(array_values($currentAdditionalImages)) : null;

            // Update article
            $article->update($data);

            return redirect()->route('admin.articles.index')
                ->with('success', 'Article updated successfully.');
        } catch (\Exception $e) {
            return back()->with('error', 'Error updating article: ' . $e->getMessage())
                ->withInput();
        }
    }

    public function destroy(Article $article)
    {
        try {
            // Delete main image
            if ($article->image) {
                Storage::disk('public')->delete($article->image);
            }

            // Delete additional images
            if ($article->additional_images) {
                $additionalImages = json_decode($article->additional_images, true);
                foreach ($additionalImages as $image) {
                    Storage::disk('public')->delete($image);
                }
            }

            // Delete article
            $article->delete();

            return redirect()->route('admin.articles.index')
                ->with('success', 'Article deleted successfully.');
        } catch (\Exception $e) {
            return back()->with('error', 'Error deleting article: ' . $e->getMessage());
        }
    }
} 