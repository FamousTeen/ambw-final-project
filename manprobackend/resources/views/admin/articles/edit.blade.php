@extends('base.base')

@section('title', 'Edit Article')

@section('content')
<div class="min-h-screen bg-gray-100 py-6">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="bg-white overflow-hidden shadow-sm rounded-lg">
            <div class="p-6">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-2xl font-semibold text-gray-900">Edit Article</h2>
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

                <form action="{{ route('admin.articles.update', $article->id) }}" method="POST" enctype="multipart/form-data">
                    @csrf
                    @method('PUT')
                    
                    <div class="space-y-6">
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Title</label>
                            <input type="text" name="title" value="{{ old('title', $article->title) }}" required
                                   class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700">Content</label>
                            <textarea name="content" rows="4" required
                                      class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">{{ old('content', $article->content) }}</textarea>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700">Main Image</label>
                            @if($article->image)
                                <div class="mt-2 mb-4">
                                    <img src="{{ Storage::url($article->image) }}" alt="Current article image" class="h-32 w-auto">
                                </div>
                            @endif
                            <input type="file" name="image" 
                                   class="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100">
                            <p class="mt-1 text-sm text-gray-500">Leave empty to keep current image</p>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700">Additional Images</label>
                            @if($article->additional_images)
                                <div class="mt-2 mb-4 grid grid-cols-4 gap-4">
                                    @foreach(json_decode($article->additional_images) as $image)
                                        <div class="relative group">
                                            <img src="{{ Storage::url($image) }}" alt="Additional article image" class="h-24 w-full object-cover rounded-lg">
                                            <input type="hidden" name="existing_images[]" value="{{ $image }}">
                                        </div>
                                    @endforeach
                                </div>
                            @endif
                            <input type="file" name="additional_images[]" multiple 
                                   class="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100">
                            <p class="mt-1 text-sm text-gray-500">You can select multiple additional images</p>
                        </div>

                        <div class="flex justify-end space-x-4">
                            <a href="{{ route('admin.articles.index') }}" 
                               class="inline-flex justify-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50">
                                Cancel
                            </a>
                            <button type="submit" 
                                    class="inline-flex justify-center rounded-md border border-transparent bg-indigo-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-700">
                                Update Article
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection