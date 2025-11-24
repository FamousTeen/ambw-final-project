@extends('base.base')

@section('content')
<div class="container mx-auto px-4 py-6">
    <div class="bg-white rounded-lg shadow-lg p-6">
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-2xl font-bold text-gray-800">Donation Gallery</h2>
        </div>

        <!-- Upload Form -->
        <form action="{{ route('admin.donation-gallery.store') }}" method="POST" enctype="multipart/form-data" class="mb-8 p-4 border rounded-lg">
            @csrf
            <div class="mb-4">
                <label class="block text-gray-700 text-sm font-bold mb-2" for="image">
                    Upload Image
                </label>
                <input type="file" name="image" id="image" accept="image/*" class="border rounded w-full py-2 px-3">
            </div>
            <div class="mb-4">
                <label class="block text-gray-700 text-sm font-bold mb-2" for="caption">
                    Caption (Optional)
                </label>
                <input type="text" name="caption" id="caption" class="border rounded w-full py-2 px-3">
            </div>
            <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
                Upload Image
            </button>
        </form>

        <!-- Gallery Grid -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            @foreach($images as $image)
            <div class="relative group">
                <img src="{{ asset('storage/' . $image->image_path) }}" 
                     alt="Donation Gallery Image" 
                     class="w-full h-48 object-cover rounded-lg">
                @if($image->caption)
                <div class="absolute bottom-0 left-0 right-0 bg-black bg-opacity-50 text-white p-2 rounded-b-lg">
                    {{ $image->caption }}
                </div>
                @endif
                <form action="{{ route('admin.donation-gallery.destroy', $image->id) }}" method="POST" 
                      class="absolute top-2 right-2 hidden group-hover:block">
                    @csrf
                    @method('DELETE')
                    <button type="submit" 
                            class="bg-red-500 text-white p-2 rounded-full hover:bg-red-600"
                            onclick="return confirm('Are you sure you want to delete this image?')">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                        </svg>
                    </button>
                </form>
            </div>
            @endforeach
        </div>
    </div>
</div>
@endsection 