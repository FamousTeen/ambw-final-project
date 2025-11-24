@extends('base.base')

@section('title', 'Donation Types')
@section('header', 'Donation Types Management')

@section('content')
<div class="bg-white shadow-sm rounded-lg">
    <!-- Header -->
    <div class="py-6 px-6 border-b border-gray-200">
        <div class="flex items-center justify-between">
            <h2 class="text-xl font-semibold text-gray-800">Donation Types</h2>
            <div class="flex space-x-3">
                <a href="{{ route('admin.donations.index') }}" 
                    class="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    Back to Donations
                </a>
            </div>
        </div>
    </div>

    <!-- Add New Form -->
    <div class="p-6 border-b border-gray-200">
        <h3 class="text-lg font-medium text-gray-900 mb-4">Add New Donation Type</h3>
        <form action="{{ route('admin.donations.types.store') }}" method="POST">
            @csrf
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
                <div class="col-span-3">
                    <label for="name" class="block text-sm font-medium text-gray-700 mb-1">Type Name</label>
                    <input type="text" name="name" id="name" required
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-sm">
                </div>
                <div class="col-span-1 flex items-end">
                    <button type="submit" 
                        class="w-full inline-flex justify-center items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                        Add Type
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Types List -->
    <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
                <tr>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
                @forelse($donationTypes as $type)
                    <tr>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm font-medium text-gray-900">{{ $type->id }}</div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm text-gray-900">{{ $type->name }}</div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                            <button onclick="editType({{ $type->id }}, '{{ $type->name }}')"
                                class="text-indigo-600 hover:text-indigo-900 mr-3">Edit</button>
                            <form action="{{ route('admin.donations.types.destroy', $type) }}" method="POST" 
                                class="inline-block"
                                onsubmit="return confirm('Are you sure you want to delete this type?');">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="text-red-600 hover:text-red-900">Delete</button>
                            </form>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="3" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                            No donation types found.
                        </td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>
</div>

<!-- Edit Modal -->
<div id="editModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden overflow-y-auto h-full w-full">
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
        <div class="mt-3">
            <h3 class="text-lg font-medium text-gray-900 mb-4">Edit Donation Type</h3>
            <form id="editForm" method="POST" class="space-y-4">
                @csrf
                @method('PUT')
                <div>
                    <label for="edit_name" class="block text-sm font-medium text-gray-700 mb-1">Type Name</label>
                    <input type="text" name="name" id="edit_name" required
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-sm">
                </div>
                <div class="flex justify-end space-x-3">
                    <button type="button" onclick="closeEditModal()"
                        class="inline-flex justify-center items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                        Cancel
                    </button>
                    <button type="submit"
                        class="inline-flex justify-center items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                        Update
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

@push('scripts')
<script>
    function editType(id, name) {
        document.getElementById('editModal').classList.remove('hidden');
        document.getElementById('edit_name').value = name;
        document.getElementById('editForm').action = `/admin/donations/types/${id}`;
    }

    function closeEditModal() {
        document.getElementById('editModal').classList.add('hidden');
    }
</script>
@endpush
@endsection 