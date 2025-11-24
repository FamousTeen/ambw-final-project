<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Post;
use App\Models\Comment;
use Illuminate\Http\Request;

class ForumManagementController extends Controller
{
    public function index()
    {
        $posts = Post::select('id', 'user_id', 'content', 'created_at', 'updated_at')
            ->with([
                'user' => function ($query) {
                    $query->select('id', 'nama_lengkap', 'email', 'username');
                },
                'comments',
                'likes'
            ])
            ->latest()
            ->paginate(10);

        return view('admin.forum.index', compact('posts'));
    }

    public function show($id)
    {
        $post = Post::select('id', 'user_id', 'content', 'created_at', 'updated_at')
            ->with([
                'user' => function ($query) {
                    $query->select('id', 'nama_lengkap', 'email', 'username');
                },
                'comments.user' => function ($query) {
                    $query->select('id', 'nama_lengkap', 'email', 'username');
                },
                'likes.user' => function ($query) {
                    $query->select('id', 'nama_lengkap', 'email', 'username');
                }
            ])
            ->findOrFail($id);

        return view('admin.forum.show', compact('post'));
    }

    public function destroyPost($id)
    {
        try {
            $post = Post::findOrFail($id);
            $post->delete();

            return back()->with('success', 'Post deleted successfully');
        } catch (\Exception $e) {
            return back()->with('error', 'Error deleting post: ' . $e->getMessage());
        }
    }

    public function destroyComment($id)
    {
        try {
            $comment = Comment::findOrFail($id);
            $comment->delete();

            return back()->with('success', 'Comment deleted successfully');
        } catch (\Exception $e) {
            return back()->with('error', 'Error deleting comment: ' . $e->getMessage());
        }
    }
}