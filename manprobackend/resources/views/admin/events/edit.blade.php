@extends('base.base')

@section('title', 'Edit Event')

@section('content')
<div class="min-h-screen bg-gray-100 py-6">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="bg-white overflow-hidden shadow-sm rounded-lg">
            <div class="p-6">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-2xl font-semibold text-gray-900">Edit Event</h2>
                    <div class="flex items-center space-x-4">
                        <!-- Status Update -->
                        <div class="flex items-center space-x-2">
                            <label for="status" class="text-sm font-medium text-gray-700">Status:</label>
                            <select name="status" id="status" 
                                    class="rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                                <option value="upcoming" {{ $event->status == 'upcoming' ? 'selected' : '' }}>Upcoming</option>
                                <option value="ongoing" {{ $event->status == 'ongoing' ? 'selected' : '' }}>Ongoing</option>
                                <option value="completed" {{ $event->status == 'completed' ? 'selected' : '' }}>Completed</option>
                            </select>
                        </div>
                        <span id="statusMessage" class="text-sm"></span>
                    </div>
                </div>

                @if($errors->any())
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                        <ul class="list-disc list-inside">
                            @foreach($errors->all() as $error)
                                <li>{{ $error }}</li>
                            @endforeach
                        </ul>
                    </div>
                @endif

                <form action="{{ route('admin.events.update', $event->id) }}" method="POST" enctype="multipart/form-data">
                    @csrf
                    @method('PUT')
                    
                    <!-- Hidden status field that will be updated by JavaScript -->
                    <input type="hidden" name="status" id="hiddenStatus" value="{{ $event->status }}">
                    
                    <div class="space-y-6">
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Title</label>
                            <input type="text" name="title" value="{{ old('title', $event->title) }}" required
                                   class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700">Content</label>
                            <textarea name="content" rows="4" required
                                      class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">{{ old('content', $event->content) }}</textarea>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700">Date</label>
                            <input type="date" name="date" value="{{ old('date', date('Y-m-d', strtotime($event->date))) }}" required
                                   class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700">Category</label>
                            <select name="category_id" required
                                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                                @foreach($categories as $category)
                                    <option value="{{ $category->id }}" {{ old('category_id', $event->category_id) == $category->id ? 'selected' : '' }}>
                                        {{ $category->name }}
                                    </option>
                                @endforeach
                            </select>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700">Main Image</label>
                            @if($event->image)
                                <div class="mt-2 mb-4">
                                    <img src="{{ $event->image }}" alt="Current event image" class="h-32 w-auto">
                                </div>
                            @endif
                            <input type="file" name="image" 
                                   class="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700">Additional Images</label>
                            @if($event->additional_images)
                                <div class="mt-2 mb-4 grid grid-cols-4 gap-4">
                                    @foreach($event->additional_images as $image)
                                        <img src="{{ $image }}" alt="Additional event image" class="h-24 w-auto">
                                    @endforeach
                                </div>
                            @endif
                            <input type="file" name="additional_images[]" multiple 
                                   class="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100">
                        </div>

                        <div class="flex justify-end space-x-4">
                            <a href="{{ route('admin.events.index') }}" 
                               class="inline-flex justify-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50">
                                Cancel
                            </a>
                            <button type="submit" 
                                    class="inline-flex justify-center rounded-md border border-transparent bg-indigo-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-700">
                                Update Event
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

@push('scripts')
<script>
document.addEventListener('DOMContentLoaded', function() {
    const statusSelect = document.getElementById('status');
    const hiddenStatus = document.getElementById('hiddenStatus');
    const statusMessage = document.getElementById('statusMessage');

    // Update hidden status field when status select changes
    statusSelect.addEventListener('change', function() {
        const newStatus = this.value;
        hiddenStatus.value = newStatus;
        
        // Also update via AJAX
        fetch(`/admin/events/${@json($event->id)}/update-status`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
            },
            body: JSON.stringify({ status: newStatus })
        })
        .then(response => response.json())
        .then(data => {
            statusMessage.textContent = 'Status updated successfully';
            statusMessage.className = 'text-sm text-green-600';
            setTimeout(() => {
                statusMessage.textContent = '';
            }, 3000);
        })
        .catch(error => {
            statusMessage.textContent = 'Error updating status';
            statusMessage.className = 'text-sm text-red-600';
            this.value = hiddenStatus.value; // Revert select to previous value
        });
    });
});
</script>
@endpush
@endsection 