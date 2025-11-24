@extends('base.base')

@section('title', 'Donation Goals')

@section('content')
<div class="py-12">
    <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
        <div class="bg-white overflow-hidden shadow-sm rounded-lg">
            <!-- Header -->
            <div class="p-6 bg-white border-b border-gray-200">
                <h2 class="text-2xl font-semibold text-gray-800">Donation Goals</h2>
            </div>

            <!-- Add New Goal Form -->
            <div class="p-6 bg-white border-b border-gray-200">
                <form action="{{ route('admin.donations.goals.store') }}" method="POST" class="space-y-4">
                    @csrf
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Donation Type</label>
                            <select name="donation_type_id"
                                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                                <option value="">Select Type</option>
                                @foreach($donationTypes as $type)
                                    <option value="{{ $type->id }}">{{ $type->name }}</option>
                                @endforeach
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Target Quantity</label>
                            <input type="number" name="target_quantity" min="1"
                                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                        </div>
                        <div class="flex items-end">
                            <button type="submit"
                                class="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700">
                                Add Goal
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Goals List -->
            <div class="p-6">
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th
                                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Type</th>
                                <th
                                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Target</th>
                                <th
                                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Current</th>
                                <th
                                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Progress</th>
                                <th
                                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            @forelse($goals as $goal)
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap">{{ $goal->donationType->name }}</td>
                                    <td class="px-6 py-4 whitespace-nowrap">{{ $goal->target_quantity }}</td>
                                    <td class="px-6 py-4 whitespace-nowrap">{{ $goal->current_quantity }}</td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="w-full bg-gray-200 rounded-full h-2.5">
                                            <div class="bg-indigo-600 h-2.5 rounded-full"
                                                style="width: {{ $goal->percentage }}%"></div>
                                        </div>
                                        <span class="text-sm text-gray-600">{{ $goal->percentage }}%</span>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <button onclick="openEditModal({{ $goal->id }}, {{ $goal->target_quantity }})"
                                            class="text-indigo-600 hover:text-indigo-900 mr-3">Edit</button>
                                        <form action="{{ route('admin.donations.goals.destroy', $goal) }}" method="POST"
                                            class="inline">
                                            @csrf
                                            @method('DELETE')
                                            <button type="submit" class="text-red-600 hover:text-red-900">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            @empty
                                <tr>
                                    <td colspan="5" class="px-6 py-4 text-center text-gray-500">No donation goals set</td>
                                </tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Edit Modal -->
<div id="editModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden overflow-y-auto h-full w-full">
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
        <div class="mt-3">
            <h3 class="text-lg font-medium text-gray-900">Edit Goal</h3>
            <form id="editForm" method="POST" class="mt-4">
                @csrf
                @method('PUT')
                <div class="mt-2">
                    <label class="block text-sm font-medium text-gray-700">Target Quantity</label>
                    <input type="number" name="target_quantity" id="editTargetQuantity" min="1"
                        class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                </div>
                <div class="mt-4 flex justify-end">
                    <button type="button" onclick="closeEditModal()"
                        class="mr-2 px-4 py-2 text-gray-500 hover:text-gray-700">Cancel</button>
                    <button type="submit"
                        class="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700">Update</button>
                </div>
            </form>
        </div>
    </div>
</div>

@push('scripts')
    <script>
        function openEditModal(goalId, currentTarget) {
            document.getElementById('editModal').classList.remove('hidden');
            document.getElementById('editTargetQuantity').value = currentTarget;
            document.getElementById('editForm').action = `/admin/donations/goals/${goalId}`;
        }

        function closeEditModal() {
            document.getElementById('editModal').classList.add('hidden');
        }
    </script>
@endpush
@endsection