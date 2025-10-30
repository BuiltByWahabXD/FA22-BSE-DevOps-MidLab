<?php

namespace Tests\Feature;

use App\Models\Note;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

/**
 * NoteTest - Feature Test for Note CRUD Operations
 *
 * This test class demonstrates CRUD (Create, Read, Update, Delete) operations
 * for the Note model using PHPUnit and Laravel's testing framework.
 *
 * The RefreshDatabase trait ensures the database is migrated and refreshed
 * before each test, providing a clean slate for testing.
 */
class NoteTest extends TestCase
{
    /**
     * The RefreshDatabase trait will:
     * 1. Run all migrations before each test
     * 2. Rollback all migrations after each test
     * 3. Ensure test isolation (tests don't affect each other)
     */
    use RefreshDatabase;

    /**
     * Test: Create a new note and verify it's saved in the database
     *
     * This test demonstrates the CREATE operation of CRUD.
     * It creates a new note and verifies that:
     * 1. The note exists in the database
     * 2. The saved data matches the input data
     */
    public function test_can_create_a_note(): void
    {
        // Arrange: Prepare test data
        $noteData = [
            'title' => 'Test Note Title',
            'content' => 'This is a test note content for PHPUnit testing.',
        ];

        // Act: Create a new note using the Note model
        $note = Note::create($noteData);

        // Assert: Verify the note was created and saved correctly
        // 1. Check that the note exists in the database
        $this->assertDatabaseHas('notes', [
            'title' => 'Test Note Title',
            'content' => 'This is a test note content for PHPUnit testing.',
        ]);

        // 2. Verify the note object has the correct attributes
        $this->assertEquals('Test Note Title', $note->title);
        $this->assertEquals('This is a test note content for PHPUnit testing.', $note->content);

        // 3. Ensure the note has an ID (was persisted to database)
        $this->assertNotNull($note->id);
    }

    /**
     * Test: Retrieve a note from the database
     *
     * This test demonstrates the READ operation of CRUD.
     * It creates a note, then retrieves it from the database to verify
     * that data can be read correctly.
     */
    public function test_can_read_a_note(): void
    {
        // Arrange: Create a note in the database
        $note = Note::create([
            'title' => 'Sample Note',
            'content' => 'Sample content for reading test.',
        ]);

        // Act: Retrieve the note from the database by its ID
        $retrievedNote = Note::find($note->id);

        // Assert: Verify the retrieved note matches the original
        $this->assertNotNull($retrievedNote);
        $this->assertEquals($note->id, $retrievedNote->id);
        $this->assertEquals('Sample Note', $retrievedNote->title);
        $this->assertEquals('Sample content for reading test.', $retrievedNote->content);
    }

    /**
     * Test: Update an existing note in the database
     *
     * This test demonstrates the UPDATE operation of CRUD.
     * It creates a note, updates its content, and verifies the changes
     * were saved correctly.
     */
    public function test_can_update_a_note(): void
    {
        // Arrange: Create a note with initial data
        $note = Note::create([
            'title' => 'Original Title',
            'content' => 'Original content.',
        ]);

        // Act: Update the note's title and content
        $note->update([
            'title' => 'Updated Title',
            'content' => 'Updated content after modification.',
        ]);

        // Refresh the note from the database to get the latest data
        $note->refresh();

        // Assert: Verify the note was updated in the database
        $this->assertDatabaseHas('notes', [
            'id' => $note->id,
            'title' => 'Updated Title',
            'content' => 'Updated content after modification.',
        ]);

        // Verify the note object reflects the changes
        $this->assertEquals('Updated Title', $note->title);
        $this->assertEquals('Updated content after modification.', $note->content);
    }

    /**
     * Test: Delete a note from the database
     *
     * This test demonstrates the DELETE operation of CRUD.
     * It creates a note, deletes it, and verifies it no longer exists
     * in the database.
     */
    public function test_can_delete_a_note(): void
    {
        // Arrange: Create a note
        $note = Note::create([
            'title' => 'Note to Delete',
            'content' => 'This note will be deleted.',
        ]);

        // Store the note ID before deletion
        $noteId = $note->id;

        // Act: Delete the note
        $note->delete();

        // Assert: Verify the note no longer exists in the database
        $this->assertDatabaseMissing('notes', [
            'id' => $noteId,
        ]);

        // Attempt to find the deleted note should return null
        $deletedNote = Note::find($noteId);
        $this->assertNull($deletedNote);
    }

    /**
     * Test: Create multiple notes and retrieve all of them
     *
     * This test verifies that multiple notes can be created
     * and retrieved correctly, testing bulk operations.
     */
    public function test_can_list_multiple_notes(): void
    {
        // Arrange: Create multiple notes
        $note1 = Note::create([
            'title' => 'First Note',
            'content' => 'Content of first note.',
        ]);

        $note2 = Note::create([
            'title' => 'Second Note',
            'content' => 'Content of second note.',
        ]);

        $note3 = Note::create([
            'title' => 'Third Note',
            'content' => 'Content of third note.',
        ]);

        // Act: Retrieve all notes from the database
        $allNotes = Note::all();

        // Assert: Verify all three notes exist
        $this->assertCount(3, $allNotes);

        // Verify each note exists in the collection
        $this->assertTrue($allNotes->contains('id', $note1->id));
        $this->assertTrue($allNotes->contains('id', $note2->id));
        $this->assertTrue($allNotes->contains('id', $note3->id));
    }

    /**
     * Test: Verify note validation and required fields
     *
     * This test ensures that the Note model has the expected
     * fillable attributes for mass assignment.
     */
    public function test_note_has_fillable_attributes(): void
    {
        // Arrange & Act: Create a note using mass assignment
        $note = new Note([
            'title' => 'Fillable Test',
            'content' => 'Testing fillable attributes.',
        ]);

        // Assert: Verify the attributes were set correctly
        $this->assertEquals('Fillable Test', $note->title);
        $this->assertEquals('Testing fillable attributes.', $note->content);
    }
}
