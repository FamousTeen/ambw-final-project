<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title') - Admin Panel</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Add Heroicons (Optional but recommended for icons) -->
    <script src="https://unpkg.com/@heroicons/v2@1.0.0/24/outline/index.min.js"></script>
</head>

<body class="bg-gray-100">
    @auth
        <div class="min-h-screen flex">
            <!-- Sidebar -->
            <div class="bg-indigo-800 text-white w-64 flex flex-col h-screen sticky top-0">
                <div class="px-6 py-6">
                    <h1 class="text-2xl font-bold">Admin Panel</h1>
                </div>

                <!-- Navigation - Now Scrollable -->
                <nav class="flex-1 px-4 space-y-2 overflow-y-auto">
                    <div class="space-y-2">
                        <a href="{{ route('admin.dashboard') }}"
                            class="block px-4 py-2 rounded-lg hover:bg-indigo-700 {{ request()->routeIs('admin.dashboard') ? 'bg-indigo-900' : '' }}">
                            <div class="flex items-center">
                                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
                                </svg>
                                <span>Dashboard</span>
                            </div>
                        </a>

                        <!-- Events Management -->
                        <div class="space-y-2">
                            <p class="px-4 text-xs text-indigo-300 uppercase tracking-wider mt-4">Events</p>
                            <a href="{{ route('admin.events.index') }}"
                                class="block px-4 py-2 rounded-lg hover:bg-indigo-700 {{ request()->routeIs('admin.events.*') ? 'bg-indigo-900' : '' }}">
                                <div class="flex items-center">
                                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                    </svg>
                                    <span>All Events</span>
                                </div>
                            </a>
                            <a href="{{ route('admin.events.categories') }}"
                                class="block px-4 py-2 rounded-lg hover:bg-indigo-700 {{ request()->routeIs('admin.events.categories') ? 'bg-indigo-900' : '' }}">
                                <div class="flex items-center">
                                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
                                    </svg>
                                    <span>Event Categories</span>
                                </div>
                            </a>
                            <a href="{{ route('admin.events.registrations') }}"
                                class="block px-4 py-2 rounded-lg hover:bg-indigo-700 {{ request()->routeIs('admin.events.registrations') ? 'bg-indigo-900' : '' }}">
                                <div class="flex items-center">
                                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                                    </svg>
                                    <span>Event Registrations</span>
                                </div>
                            </a>
                        </div>

                        <!-- Articles Management -->
                        <div class="space-y-2">
                            <p class="px-4 text-xs text-indigo-300 uppercase tracking-wider mt-4">Content</p>
                            <a href="{{ route('admin.articles.index') }}"
                                class="block px-4 py-2 rounded-lg hover:bg-indigo-700 {{ request()->routeIs('admin.articles.*') ? 'bg-indigo-900' : '' }}">
                                <div class="flex items-center">
                                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m2 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9a2 2 0 00-2-2h-2m-4-3H9M7 16h6M7 8h6v4H7V8z" />
                                    </svg>
                                    <span>Articles</span>
                                </div>
                            </a>
                        </div>

                        <!-- Donations Management -->
                        <div class="space-y-2">
                            <p class="px-4 text-xs text-indigo-300 uppercase tracking-wider mt-4">Donations</p>
                            <a href="{{ route('admin.donations.index') }}"
                                class="block px-4 py-2 rounded-lg hover:bg-indigo-700 {{ request()->routeIs('admin.donations.index') ? 'bg-indigo-900' : '' }}">
                                <div class="flex items-center">
                                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    <span>All Donations</span>
                                </div>
                            </a>
                            <a href="{{ route('admin.donations.types') }}"
                                class="block px-4 py-2 rounded-lg hover:bg-indigo-700 {{ request()->routeIs('admin.donations.types') ? 'bg-indigo-900' : '' }}">
                                <div class="flex items-center">
                                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                                    </svg>
                                    <span>Donation Types</span>
                                </div>
                            </a>
                            <a href="{{ route('admin.donations.goals') }}"
                                class="block px-4 py-2 rounded-lg hover:bg-indigo-700 {{ request()->routeIs('admin.donations.goals') ? 'bg-indigo-900' : '' }}">
                                <div class="flex items-center">
                                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                                    </svg>
                                    <span>Donation Goals</span>
                                </div>
                            </a>
                            <a href="{{ route('admin.shipping-methods.index') }}"
                                class="block px-4 py-2 rounded-lg hover:bg-indigo-700 {{ request()->routeIs('admin.shipping-methods.index') ? 'bg-indigo-900' : '' }}">
                                <div class="flex items-center">
                                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M13 16V6a1 1 0 00-1-1H4a1 1 0 00-1 1v10a1 1 0 001 1h1m8-1a1 1 0 01-1 1H9m4-1V8a1 1 0 011-1h2.586a1 1 0 01.707.293l3.414 3.414a1 1 0 01.293.707V16a1 1 0 01-1 1h-1m-6-1a1 1 0 001 1h1M5 17a2 2 0 104 0m-4 0a2 2 0 114 0m6 0a2 2 0 104 0m-4 0a2 2 0 114 0" />
                                    </svg>
                                    <span>Shipping Methods</span>
                                </div>
                            </a>
                        </div>

                        <!-- Donation Gallery -->
                        <a href="{{ route('admin.donation-gallery.index') }}"
                            class="block px-4 py-2 rounded-lg hover:bg-indigo-700 {{ request()->routeIs('admin.donation-gallery.*') ? 'bg-indigo-900' : '' }}">
                            <div class="flex items-center">
                                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                </svg>
                                <span>Donation Gallery</span>
                            </div>
                        </a>

                        <!-- Settings -->
                        <div class="space-y-2">
                            <p class="px-4 text-xs text-indigo-300 uppercase tracking-wider mt-4">Settings</p>
                            <a href="{{ route('admin.contact.index') }}"
                                class="block px-4 py-2 rounded-lg hover:bg-indigo-700 {{ request()->routeIs('admin.contact.*') ? 'bg-indigo-900' : '' }}">
                                <div class="flex items-center">
                                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                                    </svg>
                                    <span>Contact Info</span>
                                </div>
                            </a>
                            <a href="{{ route('admin.users.index') }}"
                                class="block px-4 py-2 rounded-lg hover:bg-indigo-700 {{ request()->routeIs('admin.users.*') ? 'bg-indigo-900' : '' }}">
                                <div class="flex items-center">
                                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                                    </svg>
                                    <span>User Management</span>
                                </div>
                            </a>
                        </div>

                        <!-- Foundation Profile -->
                        <a href="{{ route('admin.foundation.profile') }}" class="block px-4 py-2 rounded-lg hover:bg-indigo-700 {{ request()->routeIs('admin.foundation.profile') ? 'bg-indigo-900' : '' }}">
                            <div class="flex items-center">
                                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                                </svg>
                                <span>Foundation Profile</span>
                            </div>
                        </a>

                        <!-- Forum Management -->
                        <a href="{{ route('admin.forum.index') }}" 
                           class="block px-4 py-2 rounded-lg hover:bg-indigo-700 {{ request()->routeIs('admin.forum.*') ? 'bg-indigo-900' : '' }}">
                            <div class="flex items-center">
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8h2a2 2 0 012 2v6a2 2 0 01-2 2h-2v4l-4-4H9a1.994 1.994 0 01-1.414-.586m0 0L11 14h4a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2v4l.586-.586z" />
                                </svg>
                                <span>Forum Management</span>
                            </div>
                        </a>
                    </div>
                </nav>

                <!-- User Menu - Fixed at Bottom -->
                <div class="px-6 py-4 border-t border-indigo-700 bg-indigo-800">
                    <div class="flex items-center">
                        <div class="flex-1">
                            <p class="text-sm">{{ Auth::user()->nama_lengkap ?? 'Admin' }}</p>
                            <p class="text-xs text-indigo-300">Administrator</p>
                        </div>
                        <form action="{{ route('admin.logout') }}" method="POST" class="inline">
                            @csrf
                            <button type="submit" class="text-sm text-indigo-300 hover:text-white">
                                Logout
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="flex-1">
                <!-- Top Navigation -->
                <div class="bg-white shadow-sm">
                    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                        <div class="flex justify-between h-16">
                            <div class="flex items-center">
                                <h2 class="text-2xl font-semibold text-gray-800">@yield('header', 'Dashboard')</h2>
                            </div>
                            <div class="flex items-center">
                                <!-- Add any top navigation items here -->
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Page Content -->
                <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
                    @if(session('success'))
                        <div class="mb-4 bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative"
                            role="alert">
                            <span class="block sm:inline">{{ session('success') }}</span>
                        </div>
                    @endif

                    @if(session('error'))
                        <div class="mb-4 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
                            <span class="block sm:inline">{{ session('error') }}</span>
                        </div>
                    @endif

                    @yield('content')
                </main>
            </div>
        </div>
    @else
        @yield('content')
    @endauth

    <!-- Scripts -->
    @stack('scripts')
</body>

</html>