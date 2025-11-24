@extends('base.base')

@section('title', 'Admin Dashboard')

@section('content')
<div class="min-h-screen bg-gray-100">
    <!-- Navigation -->
    <nav class="bg-white shadow-lg">
        <div class="max-w-7xl mx-auto px-4">
            <div class="flex justify-between h-16">
                <div class="flex items-center">
                    <span class="text-xl font-semibold text-gray-800">Admin Dashboard</span>
                </div>
                <div class="flex items-center">
                    <span class="text-gray-600 mr-4">Welcome, {{ Auth::user()->nama_lengkap }}</span>
                    <form action="{{ route('admin.logout') }}" method="POST" class="inline">
                        @csrf
                        <button type="submit" class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded">
                            Logout
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <!-- Statistics Cards -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                <div class="bg-white overflow-hidden shadow-sm rounded-lg p-6">
                    <div class="text-gray-900 text-xl">Total Events</div>
                    <div class="mt-2 text-3xl font-semibold">{{ $totalEvents }}</div>
                </div>
                <div class="bg-white overflow-hidden shadow-sm rounded-lg p-6">
                    <div class="text-gray-900 text-xl">Total Articles</div>
                    <div class="mt-2 text-3xl font-semibold">{{ $totalArticles }}</div>
                </div>
                <div class="bg-white overflow-hidden shadow-sm rounded-lg p-6">
                    <div class="text-gray-900 text-xl">Total Donations</div>
                    <div class="mt-2 text-3xl font-semibold">{{ $totalDonations }}</div>
                </div>
                <div class="bg-white overflow-hidden shadow-sm rounded-lg p-6">
                    <div class="text-gray-900 text-xl">Total Users</div>
                    <div class="mt-2 text-3xl font-semibold">{{ $totalUsers }}</div>
                </div>
            </div>

            <!-- Recent Activities -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Recent Events -->
                <div class="bg-white overflow-hidden shadow-sm rounded-lg p-6">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">Recent Events</h3>
                    <div class="space-y-4">
                        @foreach($recentEvents as $event)
                        <div class="border-b pb-2">
                            <div class="font-medium">{{ $event->title }}</div>
                            <div class="text-sm text-gray-600">{{ $event->date->format('d M Y') }}</div>
                        </div>
                        @endforeach
                    </div>
                </div>

                <!-- Recent Donations -->
                <div class="bg-white overflow-hidden shadow-sm rounded-lg p-6">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">Recent Donations</h3>
                    <div class="space-y-4">
                        @foreach($recentDonations as $donation)
                        <div class="border-b pb-2">
                            <div class="font-medium">{{ $donation->user->nama_lengkap }}</div>
                            <div class="text-sm text-gray-600">
                                {{ $donation->type }} - {{ $donation->quantity }} items
                            </div>
                        </div>
                        @endforeach
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection 