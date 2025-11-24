@extends('base.base')

@section('title', 'Create Article')
@section('header', 'Create New Article')

@section('content')
<div class="bg-white shadow-sm rounded-lg">
    <form action="{{ route('admin.articles.store') }}" method="POST" enctype="multipart/form-data" class="space-y-6 p-6">
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

        <!-- Submit Button -->
        <div class="flex justify-end space-x-3">
            <a href="{{ route('admin.articles.index') }}" 
                class="bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                Cancel
            </a>
            <button type="submit"
                class="inline-flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                Create Article
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
</script>
@endpush
@endsection