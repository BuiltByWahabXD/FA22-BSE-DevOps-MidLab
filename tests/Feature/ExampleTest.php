<?php

namespace Tests\Feature;

// use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ExampleTest extends TestCase
{
    /**
     * A basic test example.
     *
     * This test verifies that the application home page redirects properly.
     * The root route (/) redirects to the notes index page.
     */
    public function test_the_application_returns_a_successful_response(): void
    {
        $response = $this->get('/');

        // The root route redirects to notes.index, so we expect a 302 redirect
        $response->assertStatus(302);
        $response->assertRedirect(route('notes.index'));
    }
}
