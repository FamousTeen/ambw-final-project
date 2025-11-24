@extends('base.base')

@section('title', 'Donations')
@section('header', 'Donations Management')

@section('content')
<div class="bg-white shadow-sm rounded-lg">
    <!-- Header -->
    <div class="py-6 px-6 border-b border-gray-200">
        <div class="flex flex-col md:flex-row md:items-center md:justify-between space-y-4 md:space-y-0">
            <h2 class="text-xl font-semibold text-gray-800">All Donations</h2>
            <div class="flex flex-col sm:flex-row space-y-2 sm:space-y-0 sm:space-x-3">
                <a href="{{ route('admin.donations.types') }}" 
                    class="inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    <svg class="h-4 w-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                    </svg>
                    Manage Types
                </a>
                <a href="{{ route('admin.shipping-methods.index') }}" 
                    class="inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    <svg class="h-4 w-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4"/>
                    </svg>
                    Manage Shipping
                </a>
            </div>
        </div>
    </div>

    <!-- Filters -->
    <div class="p-6 border-b border-gray-200">
        <h3 class="text-lg font-medium text-gray-900 mb-4">Filter Donations</h3>
        <form action="{{ route('admin.donations.index') }}" method="GET">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
                <div class="col-span-1">
                    <label for="status" class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                    <select name="status" id="status" class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-sm">
                        <option value="">All Status</option>
                        <option value="pending" {{ request('status') == 'pending' ? 'selected' : '' }}>Pending</option>
                        <option value="accepted" {{ request('status') == 'accepted' ? 'selected' : '' }}>Accepted</option>
                        <option value="success" {{ request('status') == 'success' ? 'selected' : '' }}>Success</option>
                        <option value="failed" {{ request('status') == 'failed' ? 'selected' : '' }}>Failed</option>
                    </select>
                </div>
                <div class="col-span-1">
                    <label for="type" class="block text-sm font-medium text-gray-700 mb-1">Donation Type</label>
                    <select name="type" id="type" class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-sm">
                        <option value="">All Types</option>
                        @foreach($donationTypes as $type)
                            <option value="{{ $type->id }}" {{ request('type') == $type->id ? 'selected' : '' }}>
                                {{ $type->name }}
                            </option>
                        @endforeach
                    </select>
                </div>
                <div class="col-span-1">
                    <label for="shipping_method" class="block text-sm font-medium text-gray-700 mb-1">Shipping Method</label>
                    <select name="shipping_method" id="shipping_method" class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-sm">
                        <option value="">All Methods</option>
                        @foreach($shippingMethods as $method)
                            <option value="{{ $method->id }}" {{ request('shipping_method') == $method->id ? 'selected' : '' }}>
                                {{ $method->name }}
                            </option>
                        @endforeach
                    </select>
                </div>
                <div class="col-span-1 flex items-end">
                    <button type="submit" 
                        class="w-full inline-flex justify-center items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                        <svg class="h-4 w-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z"/>
                        </svg>
                        Apply Filters
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Table -->
    <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
                <tr>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Donor</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Type</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Quantity</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Shipping</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
                @forelse($donations as $donation)
                    <tr>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm font-medium text-gray-900">#{{ $donation->id }}</div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm font-medium text-gray-900">{{ $donation->user->nama_lengkap }}</div>
                            <div class="text-sm text-gray-500">{{ $donation->user->email }}</div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm text-gray-900">{{ $donation->type }}</div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm text-gray-900">{{ $donation->quantity }} items</div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm text-gray-900">{{ $donation->shipping_method }}</div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full 
                                {{ $donation->status === 'success' ? 'bg-green-100 text-green-800' : 
                                   ($donation->status === 'failed' ? 'bg-red-100 text-red-800' : 
                                   ($donation->status === 'accepted' ? 'bg-blue-100 text-blue-800' : 'bg-yellow-100 text-yellow-800')) }}">
                                {{ ucfirst($donation->status) }}
                            </span>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                            @if($donation->status === 'pending')
                                <div class="flex space-x-3">
                                    <form action="{{ route('admin.donations.update-status', $donation) }}" method="POST" class="inline-block">
                                        @csrf
                                        @method('PUT')
                                        <input type="hidden" name="status" value="accepted">
                                        <button type="submit" class="inline-flex items-center px-3 py-1 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                                            <svg class="h-4 w-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                            </svg>
                                            Accept
                                        </button>
                                    </form>
                                </div>
                            @elseif($donation->status === 'accepted')
                                <div class="flex space-x-3">
                                    <form action="{{ route('admin.donations.update-status', $donation) }}" method="POST" class="inline-block">
                                        @csrf
                                        @method('PUT')
                                        <input type="hidden" name="status" value="success">
                                        <button type="submit" class="inline-flex items-center px-3 py-1 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                                            <svg class="h-4 w-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                                            </svg>
                                            Success
                                        </button>
                                    </form>
                                    <form action="{{ route('admin.donations.update-status', $donation) }}" method="POST" class="inline-block">
                                        @csrf
                                        @method('PUT')
                                        <input type="hidden" name="status" value="failed">
                                        <button type="submit" class="inline-flex items-center px-3 py-1 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
                                            <svg class="h-4 w-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                                            </svg>
                                            Reject
                                        </button>
                                    </form>
                                </div>
                            @else
                                <span class="text-gray-500">No actions available</span>
                            @endif
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="7" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                            No donations found.
                        </td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    <!-- Pagination -->
    @if($donations->hasPages())
        <div class="px-6 py-4 border-t border-gray-200">
            {{ $donations->links() }}
        </div>
    @endif
</div>
@endsection