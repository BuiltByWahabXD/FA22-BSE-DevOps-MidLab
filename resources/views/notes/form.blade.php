@extends('layouts.app')

@section('title', isset($note) ? 'Edit Note' : 'Create Note')

@section('content')
<div class="max-w-2xl mx-auto">
    <div class="mb-6">
        <h1 class="text-3xl font-bold text-gray-800">{{ isset($note) ? 'Edit Note' : 'Create New Note' }}</h1>
        <p class="text-gray-600 mt-1">{{ isset($note) ? 'Update your note' : 'Add a new note to your collection' }}</p>
    </div>

    <div class="bg-white rounded-lg shadow-md p-6">
        <form action="{{ isset($note) ? route('notes.update', $note->id) : route('notes.store') }}" method="POST">
            @csrf
            @if(isset($note))
                @method('PUT')
            @endif

            <div class="mb-4">
                <label for="title" class="block text-gray-700 text-sm font-semibold mb-2">
                    Title <span class="text-red-500">*</span>
                </label>
                <input 
                    type="text" 
                    name="title" 
                    id="title" 
                    value="{{ old('title', $note->title ?? '') }}"
                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent @error('title') border-red-500 @enderror"
                    placeholder="Enter note title"
                    required
                >
                @error('title')
                    <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
                @enderror
            </div>

            <div class="mb-6">
                <label for="content" class="block text-gray-700 text-sm font-semibold mb-2">
                    Content <span class="text-red-500">*</span>
                </label>
                <textarea 
                    name="content" 
                    id="content" 
                    rows="8"
                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent @error('content') border-red-500 @enderror"
                    placeholder="Write your note content here..."
                    required
                >{{ old('content', $note->content ?? '') }}</textarea>
                @error('content')
                    <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
                @enderror
            </div>

            <div class="flex gap-3">
                <button 
                    type="submit" 
                    class="flex-1 bg-blue-500 hover:bg-blue-600 text-white font-semibold py-3 px-6 rounded-lg transition duration-200"
                >
                    {{ isset($note) ? 'Update Note' : 'Create Note' }}
                </button>
                <a 
                    href="{{ route('notes.index') }}" 
                    class="flex-1 bg-gray-300 hover:bg-gray-400 text-gray-700 font-semibold py-3 px-6 rounded-lg text-center transition duration-200"
                >
                    Cancel
                </a>
            </div>
        </form>
    </div>
</div>
@endsection
