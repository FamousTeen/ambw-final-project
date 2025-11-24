<?php

namespace App\Http\Controllers;

use App\Models\Post;
use App\Models\Comment;
use App\Models\PostLike;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PostController extends Controller
{
    public function index()
    {
        try {
            $posts = Post::with(['user', 'likes'])->latest()->get();
            return response()->json($posts);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function store(Request $request)
    {
        try {
            $request->validate([
                'content' => 'required|string'
            ]);

            $post = Post::create([
                'user_id' => auth()->id() ?? 1, // Temporary fallback to user_id 1
                'content' => $request->content
            ]);

            return response()->json($post->load('user'));
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function getComments($postId)
    {
        try {
            $post = Post::findOrFail($postId);
            
            $comments = Comment::with(['user' => function($query) {
                $query->select('id', 'nama_lengkap', 'email');
            }])
            ->where('post_id', $postId)
            ->latest()
            ->get()
            ->map(function ($comment) {
                if (!$comment->user) {
                    return [
                        'id' => $comment->id,
                        'body' => $comment->body,
                        'created_at' => $comment->created_at->format('Y-m-d H:i:s'),
                        'user' => [
                            'id' => 0,
                            'username' => 'Deleted User',
                            'email' => ''
                        ]
                    ];
                }

                return [
                    'id' => $comment->id,
                    'body' => $comment->body,
                    'created_at' => $comment->created_at->format('Y-m-d H:i:s'),
                    'user' => [
                        'id' => $comment->user->id,
                        'username' => $comment->user->nama_lengkap,
                        'email' => $comment->user->email
                    ]
                ];
            });

            \Log::info('Comments for post ' . $postId, [
                'count' => $comments->count(),
                'data' => $comments
            ]);

            return response()->json($comments);
        } catch (\Exception $e) {
            \Log::error('Error getting comments: ' . $e->getMessage());
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function storeComment(Request $request, $postId)
    {
        try {
            $request->validate([
                'body' => 'required|string'
            ]);

            $user = auth()->user();
            if (!$user) {
                return response()->json(['error' => 'Unauthorized'], 401);
            }

            $comment = Comment::create([
                'user_id' => $user->id,
                'post_id' => $postId,
                'body' => $request->body
            ]);

            $comment->load(['user' => function($query) {
                $query->select('id', 'nama_lengkap', 'email');
            }]);

            $response = [
                'id' => $comment->id,
                'body' => $comment->body,
                'created_at' => $comment->created_at->format('Y-m-d H:i:s'),
                'user' => [
                    'id' => $comment->user->id,
                    'username' => $comment->user->nama_lengkap,
                    'email' => $comment->user->email
                ]
            ];

            \Log::info('Comment created', $response);

            return response()->json($response);
        } catch (\Exception $e) {
            \Log::error('Error creating comment: ' . $e->getMessage());
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function toggleLike($postId)
    {
        try {
            $userId = auth()->id() ?? 1; // Temporary fallback to user_id 1
            
            // Verify post exists
            $post = Post::findOrFail($postId);
            
            $existing = PostLike::where('user_id', $userId)
                ->where('post_id', $postId)
                ->first();

            if ($existing) {
                $existing->delete();
                return response()->json([
                    'liked' => false,
                    'likes_count' => $post->fresh()->likes_count
                ]);
            }

            PostLike::create([
                'user_id' => $userId,
                'post_id' => $postId
            ]);

            return response()->json([
                'liked' => true,
                'likes_count' => $post->fresh()->likes_count
            ]);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function destroy($postId)
    {
        try {
            $user = auth()->user();
            if (!$user) {
                return response()->json(['error' => 'Unauthorized'], 401);
            }

            $post = Post::findOrFail($postId);

            // Check if user is the owner of the post
            if ($post->user_id !== $user->id) {
                return response()->json(['error' => 'You are not authorized to delete this post'], 403);
            }

            // Delete associated comments and likes first
            $post->comments()->delete();
            $post->likes()->delete();
            $post->delete();

            return response()->json(['message' => 'Post deleted successfully']);
        } catch (\Exception $e) {
            \Log::error('Error deleting post: ' . $e->getMessage());
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
} 