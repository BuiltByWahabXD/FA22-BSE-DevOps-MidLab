@extends('layouts.app')

@section('title', $note->title)

@section('content')
<div class="max-w-4xl mx-auto">
    <div class="bg-white rounded-lg shadow-md overflow-hidden">
        <div class="p-6 border-b border-gray-200">
            <div class="flex justify-between items-start mb-2">
                <h1 class="text-3xl font-bold text-gray-800">{{ $note->title }}</h1>
                <div class="flex gap-2">
                    <a href="{{ route('notes.edit', $note->id) }}" class="bg-yellow-500 hover:bg-yellow-600 text-white py-2 px-4 rounded-lg transition duration-200">
                        Edit
                    </a>
                    <form action="{{ route('notes.destroy', $note->id) }}" method="POST" onsubmit="return confirm('Are you sure you want to delete this note?')">
                        @csrf
                        @method('DELETE')
                        <button type="submit" class="bg-red-500 hover:bg-red-600 text-white py-2 px-4 rounded-lg transition duration-200">
                            Delete
                        </button>
                    </form>
                </div>
            </div>
            <div class="text-sm text-gray-500">
                <p>Created: {{ $note->created_at->format('F d, Y \a\t h:i A') }}</p>
                <p>Last updated: {{ $note->updated_at->diffForHumans() }}</p>
            </div>
        </div>
        
        <div class="p-6">
            <div class="prose max-w-none">
                <p class="text-gray-700 whitespace-pre-wrap leading-relaxed">{{ $note->content }}</p>
            </div>
        </div>

        <div class="p-6 border-t border-gray-200">
            <a href="{{ route('notes.index') }}" class="inline-block bg-gray-300 hover:bg-gray-400 text-gray-700 font-semibold py-2 px-6 rounded-lg transition duration-200">
                ← Back to Notes
            </a>
        </div>
    </div>
</div>
@endsection
