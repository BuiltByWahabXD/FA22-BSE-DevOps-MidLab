@extends('layouts.app')

@section('title', 'Edit Note')

@section('content')
    <h2 style="margin-bottom: 20px; color: #1f2937;">Edit Note</h2>

    <form action="{{ route('notes.update', $note) }}" method="POST">
        @csrf
        @method('PUT')
        
        <div class="form-group">
            <label for="title">Title</label>
            <input type="text" name="title" id="title" value="{{ old('title', $note->title) }}" required>
            @error('title')
                <div class="error">{{ $message }}</div>
            @enderror
        </div>

        <div class="form-group">
            <label for="content">Content</label>
            <textarea name="content" id="content" required>{{ old('content', $note->content) }}</textarea>
            @error('content')
                <div class="error">{{ $message }}</div>
            @enderror
        </div>

        <div style="display: flex; gap: 10px;">
            <button type="submit" class="btn btn-success">Update Note</button>
            <a href="{{ route('notes.show', $note) }}" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
@endsection
