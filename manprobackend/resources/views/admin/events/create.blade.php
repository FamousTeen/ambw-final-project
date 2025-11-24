@extends('base.base')

@section('title', 'Create Event')
@section('header', 'Create New Event')

@section('content')
<div class="bg-white shadow-sm rounded-lg">
    <form action="{{ route('admin.events.store') }}" method="POST" enctype="multipart/form-data" class="space-y-6 p-6">
        @csrf

        <!-- Title -->
        <div>
            <label for="title" class="block text-sm font-medium text-gray-700">Title</label>
            <input type="text" name="title" id="title" value="{{ old('title') }}" required
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
            @error('title')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
            @enderror
        </div>

        <!-- Content -->
        <div>
            <label for="content" class="block text-sm font-medium text-gray-700">Content</label>
            <textarea name="content" id="content" rows="5" required
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">{{ old('content') }}</textarea>
            @error('content')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
            @enderror
        </div>

        <!-- Category -->
        <div>
            <label for="category_id" class="block text-sm font-medium text-gray-700">Category</label>
            <select name="category_id" id="category_id" required
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                <option value="">Select a category</option>
                @foreach($categories as $category)
                    <option value="{{ $category->id }}" {{ old('category_id') == $category->id ? 'selected' : '' }}>
                        {{ $category->name }}
                    </option>
                @endforeach
            </select>
            @error('category_id')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
            @enderror
        </div>

        <!-- Date -->
        <div class="col-span-1">
            <label for="date" class="block text-sm font-medium text-gray-700 mb-1">Date</label>
            <input type="date" name="date" id="date" required
                class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-sm">
        </div>

        <!-- Time -->
        <div class="col-span-1">
            <label for="time" class="block text-sm font-medium text-gray-700 mb-1">Time</label>
            <input type="time" name="time" id="time" required
                class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-sm">
        </div>

        <!-- Capacity -->
        <div>
            <label for="capacity" class="block text-sm font-medium text-gray-700">Capacity</label>
            <input type="number" name="capacity" id="capacity" value="{{ old('capacity') }}" required min="1"
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
            @error('capacity')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
            @enderror
        </div>

        <!-- Main Image -->
        <div>
            <label for="image" class="block text-sm font-medium text-gray-700">Main Image</label>
            <div class="mt-1 flex items-center">
                <input type="file" name="image" id="image" accept="image/*" required
                    class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100">
            </div>
            <div class="mt-2" id="imagePreview"></div>
            @error('image')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
            @enderror
        </div>

        <!-- Additional Images -->
        <div>
            <label for="additional_images" class="block text-sm font-medium text-gray-700">Additional Images</label>
            <div class="mt-1 flex items-center">
                <input type="file" name="additional_images[]" id="additional_images" accept="image/*" multiple
                    class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100">
            </div>
            <div class="mt-2 grid grid-cols-3 gap-4" id="additionalImagesPreview"></div>
            @error('additional_images')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
            @enderror
        </div>

        <!-- Registration End Date -->
        <div>
            <label for="registration_end_date" class="block text-sm font-medium text-gray-700">Registration End Date</label>
            <input type="datetime-local" name="registration_end_date" id="registration_end_date" value="{{ old('registration_end_date') }}"
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
            @error('registration_end_date')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
            @enderror
        </div>

        <!-- Enable Reminder -->
        <div class="flex items-start">
            <div class="flex items-center h-5">
                <input type="checkbox" name="enable_reminder" id="enable_reminder" value="1" {{ old('enable_reminder') ? 'checked' : '' }}
                    class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded">
            </div>
            <div class="ml-3 text-sm">
                <label for="enable_reminder" class="font-medium text-gray-700">Enable Reminder</label>
                <p class="text-gray-500">Send reminder to registered participants before the event</p>
            </div>
        </div>

        <!-- Reminder Time -->
        <div id="reminderTimeContainer">
            <label for="reminder_at" class="block text-sm font-medium text-gray-700">Reminder Time</label>
            <input type="datetime-local" name="reminder_at" id="reminder_at" value="{{ old('reminder_at') }}"
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
            @error('reminder_at')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
            @enderror
        </div>

        <!-- Submit Button -->
        <div class="flex justify-end space-x-3">
            <a href="{{ route('admin.events.index') }}" 
                class="bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                Cancel
            </a>
            <button type="submit"
                class="inline-flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                Create Event
            </button>
        </div>
    </form>
</div>

@push('scripts')
<script>
    // Image Preview
    const imageInput = document.getElementById('image');
    const imagePreview = document.getElementById('imagePreview');
    const additionalImagesInput = document.getElementById('additional_images');
    const additionalImagesPreview = document.getElementById('additionalImagesPreview');
    const enableReminderCheckbox = document.getElementById('enable_reminder');
    const reminderTimeContainer = document.getElementById('reminderTimeContainer');
    const reminderAtInput = document.getElementById('reminder_at');

    // Main Image Preview
    imageInput.addEventListener('change', function(e) {
        imagePreview.innerHTML = '';
        if (this.files && this.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const img = document.createElement('img');
                img.src = e.target.result;
                img.classList.add('h-32', 'w-32', 'object-cover', 'rounded-lg');
                imagePreview.appendChild(img);
            }
            reader.readAsDataURL(this.files[0]);
        }
    });

    // Additional Images Preview
    additionalImagesInput.addEventListener('change', function(e) {
        additionalImagesPreview.innerHTML = '';
        if (this.files) {
            Array.from(this.files).forEach(file => {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const div = document.createElement('div');
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.classList.add('h-24', 'w-full', 'object-cover', 'rounded-lg');
                    div.appendChild(img);
                    additionalImagesPreview.appendChild(div);
                }
                reader.readAsDataURL(file);
            });
        }
    });

    // Toggle Reminder Time
    function toggleReminderTime() {
        reminderTimeContainer.style.display = enableReminderCheckbox.checked ? 'block' : 'none';
        if (!enableReminderCheckbox.checked) {
            reminderAtInput.value = '';
        }
    }

    enableReminderCheckbox.addEventListener('change', toggleReminderTime);
    toggleReminderTime(); // Initial state
</script>
@endpush
@endsection 