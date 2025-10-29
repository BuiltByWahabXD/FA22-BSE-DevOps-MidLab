@extends('layouts.app')

@section('title', $note->title)

@section('content')
    <div style="margin-bottom: 20px;">
        <a href="{{ route('notes.index') }}" class="btn btn-secondary">← Back to Notes</a>
    </div>

    <div style="background: #f9fafb; padding: 30px; border-radius: 8px; border: 1px solid #e5e7eb;">
        <h2 style="color: #1f2937; margin-bottom: 15px;">{{ $note->title }}</h2>
        
        <div style="margin-bottom: 20px; color: #6b7280; font-size: 14px;">
            <p>Created: {{ $note->created_at->format('F d, Y \a\t h:i A') }}</p>
            <p>Last Updated: {{ $note->updated_at->format('F d, Y \a\t h:i A') }}</p>
        </div>

        <div style="color: #374151; line-height: 1.6; white-space: pre-wrap;">{{ $note->content }}</div>
    </div>

    <div style="margin-top: 20px; display: flex; gap: 10px;">
        <a href="{{ route('notes.edit', $note) }}" class="btn btn-secondary">Edit Note</a>
        <form action="{{ route('notes.destroy', $note) }}" method="POST" style="display: inline;">
            @csrf
            @method('DELETE')
            <button type="submit" class="btn btn-danger" 
                onclick="return confirm('Are you sure you want to delete this note?')">
                Delete Note
            </button>
        </form>
    </div>
@endsection
