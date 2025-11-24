@extends('base.base')

@section('content')
<div class="container mx-auto px-4 py-6">
    <div class="bg-white rounded-lg shadow-lg p-6">
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-2xl font-bold text-gray-800">Foundation Profile</h2>
        </div>

        @if(session('success'))
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4" role="alert">
                <span class="block sm:inline">{{ session('success') }}</span>
            </div>
        @endif

        <form action="{{ route('admin.foundation.profile.update') }}" method="POST" class="space-y-6">
            @csrf
            @method('PUT')

            <div>
                <label for="description" class="block text-sm font-medium text-gray-700 mb-2">
                    Foundation Description
                </label>
                <textarea id="description" name="description" rows="15"
                    class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
                    placeholder="Enter foundation description...">{{ old('description', $profile->description) }}</textarea>
                @error('description')
                    <p class="mt-2 text-sm text-red-600">{{ $message }}</p>
                @enderror
            </div>

            <div class="flex justify-end">
                <button type="submit"
                    class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    Save Changes
                </button>
            </div>
        </form>

        <div class="mt-8">
            <h3 class="text-lg font-medium text-gray-900 mb-4">Preview:</h3>
            <div class="bg-gray-50 rounded-lg p-6">
                <div class="prose max-w-none whitespace-normal break-words">
                    {!! nl2br(e($profile->description)) !!}
                </div>
            </div>
        </div>
    </div>
</div>
@endsection