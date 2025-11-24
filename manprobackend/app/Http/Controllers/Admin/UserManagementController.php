<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;

class UserManagementController extends Controller
{
    public function index()
    {
        $users = User::latest()->get();
        $totalUsers = User::count();
        $totalAdmins = User::where('is_admin', true)->count();
        $totalRegularUsers = User::where('is_admin', false)->count();

        return view('admin.users.index', compact('users', 'totalUsers', 'totalAdmins', 'totalRegularUsers'));
    }

    public function show($id)
    {
        $user = User::findOrFail($id);
        return view('admin.users.show', compact('user'));
    }

    public function toggleAdmin($id)
    {
        $user = User::findOrFail($id);
        
        // Prevent self-demotion
        if ($user->id === auth()->id()) {
            return redirect()->back()->with('error', 'You cannot change your own admin status.');
        }

        $user->update([
            'is_admin' => !$user->is_admin
        ]);

        $actionText = $user->is_admin ? 'promoted to admin' : 'demoted from admin';
        return redirect()->back()->with('success', "User has been {$actionText} successfully.");
    }
} 