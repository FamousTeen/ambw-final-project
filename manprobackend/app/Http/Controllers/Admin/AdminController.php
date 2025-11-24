<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Event;
use App\Models\Article;
use App\Models\Donation;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Session;

class AdminController extends Controller
{
    public function login()
    {
        if (Auth::check() && Auth::user()->is_admin) {
            return redirect()->route('admin.dashboard');
        }
        return view('admin.auth.login');
    }

    public function register()
    {
        if (Auth::check() && Auth::user()->is_admin) {
            return redirect()->route('admin.dashboard');
        }
        return view('admin.auth.register');
    }

    public function dashboard()
    {
        try {
            // Get statistics for dashboard
            $totalEvents = Event::count();
            $totalArticles = Article::count();
            $totalDonations = Donation::count();
            $totalUsers = User::count();

            // Get recent events
            $recentEvents = Event::latest()->take(5)->get();

            // Get recent donations
            $recentDonations = Donation::with('user')->latest()->take(5)->get();

            return view('admin.dashboard', compact(
                'totalEvents',
                'totalArticles',
                'totalDonations',
                'totalUsers',
                'recentEvents',
                'recentDonations'
            ));
        } catch (\Exception $e) {
            return back()->with('error', 'Error loading dashboard data: ' . $e->getMessage());
        }
    }

    public function doLogin(Request $request)
    {
        $credentials = $request->validate([
            'username' => 'required|string',
            'password' => 'required|string',
        ]);

        if (Auth::attempt($credentials)) {
            $user = Auth::user();
            if ($user->is_admin) {
                $request->session()->regenerate();
                return redirect()->route('admin.dashboard');
            }
            
            Auth::logout();
            return back()->withErrors([
                'username' => 'This account does not have admin access.',
            ])->onlyInput('username');
        }

        return back()->withErrors([
            'username' => 'The provided credentials do not match our records.',
        ])->onlyInput('username');
    }

    public function doRegister(Request $request)
    {
        $validated = $request->validate([
            'nama_lengkap' => 'required|string|min:3|max:255',
            'username' => 'required|string|min:3|max:255|unique:users',
            'email' => 'required|string|email|max:255|unique:users',
            'kota_asal' => 'required|string|min:3|max:255',
            'no_telpon' => ['required', 'string', 'min:2', 'max:15', 'regex:/^08[0-9]{1,13}$/'],
            'password' => 'required|string|min:3',
        ]);

        try {
            $user = User::create([
                'nama_lengkap' => $validated['nama_lengkap'],
                'username' => $validated['username'],
                'email' => $validated['email'],
                'kota_asal' => $validated['kota_asal'],
                'no_telpon' => $validated['no_telpon'],
                'password' => Hash::make($validated['password']),
                'is_admin' => true
            ]);

            Auth::login($user);
            return redirect()->route('admin.dashboard');
        } catch (\Exception $e) {
            return back()->withInput()
                ->with('error', 'Error creating admin account: ' . $e->getMessage());
        }
    }

    public function logout(Request $request)
    {
        Session::flush();
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();
        
        return redirect()->route('admin.login')
            ->with('success', 'You have been successfully logged out.');
    }
} 