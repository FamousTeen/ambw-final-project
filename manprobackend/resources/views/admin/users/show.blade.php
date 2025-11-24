@extends('base.base')

@section('content')
<div class="container mx-auto px-4 py-6">
    <div class="bg-white rounded-lg shadow-lg p-6">
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-2xl font-bold text-gray-800">User Details</h2>
            <a href="{{ route('admin.users.index') }}" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">
                Back to List
            </a>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="space-y-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700">Full Name</label>
                    <div class="mt-1 text-lg">{{ $user->nama_lengkap }}</div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700">Username</label>
                    <div class="mt-1 text-lg">{{ $user->username }}</div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700">Email</label>
                    <div class="mt-1 text-lg">{{ $user->email }}</div>
                </div>
            </div>

            <div class="space-y-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700">City</label>
                    <div class="mt-1 text-lg">{{ $user->kota_asal }}</div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700">Phone Number</label>
                    <div class="mt-1 text-lg">{{ $user->no_telpon }}</div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700">Role</label>
                    <div class="mt-1">
                        <span class="px-2 inline-flex text-sm font-semibold rounded-full {{ $user->is_admin ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800' }}">
                            {{ $user->is_admin ? 'Admin' : 'Regular User' }}
                        </span>
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700">Member Since</label>
                    <div class="mt-1 text-lg">{{ $user->created_at->format('F j, Y') }}</div>
                </div>
            </div>
        </div>

        @if($user->id !== auth()->id())
        <div class="mt-8 pt-6 border-t">
            <form action="{{ route('admin.users.toggle-admin', $user->id) }}" method="POST" class="inline">
                @csrf
                @method('PUT')
                <button type="submit" 
                    class="bg-{{ $user->is_admin ? 'red' : 'green' }}-600 text-white px-4 py-2 rounded hover:bg-{{ $user->is_admin ? 'red' : 'green' }}-700"
                    onclick="return confirm('Are you sure you want to {{ $user->is_admin ? 'remove' : 'grant' }} admin privileges for this user?')">
                    {{ $user->is_admin ? 'Remove Admin Privileges' : 'Grant Admin Privileges' }}
                </button>
            </form>
        </div>
        @endif
    </div>
</div>
@endsection 