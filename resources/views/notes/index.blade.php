@extends('layouts.app')

@section('title', 'All Notes')

@section('content')
<div class="mb-6">
    <h1 class="text-3xl font-bold text-gray-800">All Notes</h1>
    <p class="text-gray-600 mt-1">Manage your notes with ease</p>
</div>

@if($notes->isEmpty())
    <div class="bg-white rounded-lg shadow-md p-12 text-center">
        <div class="text-6xl mb-4">📝</div>
        <h2 class="text-2xl font-semibold text-gray-700 mb-2">No notes yet</h2>
        <p class="text-gray-500 mb-6">Get started by creating your first note!</p>
        <a href="{{ route('notes.create') }}" class="inline-block bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-6 rounded-lg transition duration-200">
            Create Your First Note
        </a>
    </div>
@else
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        @foreach($notes as $note)
            <div class="bg-white rounded-lg shadow-md hover:shadow-lg transition duration-200 overflow-hidden">
                <div class="p-6">
                    <h2 class="text-xl font-semibold text-gray-800 mb-2 truncate">{{ $note->title }}</h2>
                    <p class="text-gray-600 mb-4 line-clamp-3">{{ $note->content }}</p>
                    <div class="text-sm text-gray-400 mb-4">
                        {{ $note->updated_at->diffForHumans() }}
                    </div>
                    <div class="flex gap-2">
                        <a href="{{ route('notes.show', $note->id) }}" class="flex-1 bg-blue-500 hover:bg-blue-600 text-white text-center py-2 px-4 rounded-lg transition duration-200">
                            View
                        </a>
                        <a href="{{ route('notes.edit', $note->id) }}" class="flex-1 bg-yellow-500 hover:bg-yellow-600 text-white text-center py-2 px-4 rounded-lg transition duration-200">
                            Edit
                        </a>
                        <form action="{{ route('notes.destroy', $note->id) }}" method="POST" class="flex-1" onsubmit="return confirm('Are you sure you want to delete this note?')">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="w-full bg-red-500 hover:bg-red-600 text-white py-2 px-4 rounded-lg transition duration-200">
                                Delete
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        @endforeach
    </div>
@endif
@endsection
