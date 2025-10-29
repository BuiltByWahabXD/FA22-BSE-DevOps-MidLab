@extends('layouts.app')

@section('title', 'All Notes')

@section('content')
    <h2 style="margin-bottom: 20px; color: #1f2937;">All Notes</h2>

    @if(session('success'))
        <div class="alert">
            {{ session('success') }}
        </div>
    @endif

    @if($notes->count() > 0)
        <div style="display: grid; gap: 20px;">
            @foreach($notes as $note)
                <div style="border: 1px solid #e5e7eb; padding: 20px; border-radius: 8px; background: #f9fafb;">
                    <div style="display: flex; justify-content: space-between; align-items: start;">
                        <div style="flex: 1;">
                            <h3 style="margin-bottom: 10px; color: #1f2937;">
                                <a href="{{ route('notes.show', $note) }}" style="color: #667eea; text-decoration: none;">
                                    {{ $note->title }}
                                </a>
                            </h3>
                            <p style="color: #6b7280; margin-bottom: 10px;">
                                {{ Str::limit($note->content, 150) }}
                            </p>
                            <small style="color: #9ca3af;">
                                Created: {{ $note->created_at->format('M d, Y') }}
                            </small>
                        </div>
                        <div style="display: flex; gap: 10px; margin-left: 20px;">
                            <a href="{{ route('notes.show', $note) }}" class="btn" style="padding: 8px 15px; font-size: 12px;">View</a>
                            <a href="{{ route('notes.edit', $note) }}" class="btn btn-secondary" style="padding: 8px 15px; font-size: 12px;">Edit</a>
                            <form action="{{ route('notes.destroy', $note) }}" method="POST" style="display: inline;">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-danger" style="padding: 8px 15px; font-size: 12px;" 
                                    onclick="return confirm('Are you sure you want to delete this note?')">
                                    Delete
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            @endforeach
        </div>

        <div style="margin-top: 30px;">
            {{ $notes->links() }}
        </div>
    @else
        <div style="text-align: center; padding: 60px 20px; color: #6b7280;">
            <p style="font-size: 18px; margin-bottom: 20px;">No notes yet!</p>
            <a href="{{ route('notes.create') }}" class="btn btn-success">Create Your First Note</a>
        </div>
    @endif
@endsection
