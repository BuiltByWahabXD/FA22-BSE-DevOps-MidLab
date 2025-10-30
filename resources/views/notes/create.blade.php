@extends('layouts.app')

@section('title', 'Create New Note')

@section('content')
    <h2 style="margin-bottom: 20px; color: #1f2937;">Create New Note</h2>

    <form action="{{ route('notes.store') }}" method="POST">
        @csrf
        
        <div class="form-group">
            <label for="title">Title</label>
            <input type="text" name="title" id="title" value="{{ old('title') }}" required>
            @error('title')
                <div class="error">{{ $message }}</div>
            @enderror
        </div>

        <div class="form-group">
            <label for="content">Content</label>
            <textarea name="content" id="content" required>{{ old('content') }}</textarea>
            @error('content')
                <div class="error">{{ $message }}</div>
            @enderror
        </div>

        <div style="display: flex; gap: 10px;">
            <button type="submit" class="btn btn-success">Save Note</button>
            <a href="{{ route('notes.index') }}" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
@endsection
