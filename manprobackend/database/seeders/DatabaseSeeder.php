<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Create two users
        $user1 = User::factory()->create([
            'nama_lengkap' => 'Test User',
            'username' => 'user',
            'email' => 'test@example.com',
            'kota_asal' => 'Easterton',
            'no_telpon' => '9408900758',
            'password' => "user1",
        ]);

        $user2 = User::factory()->create([
            'nama_lengkap' => 'Another User',
            'username' => 'user2',
            'email' => 'test2@example.com',
            'kota_asal' => 'Rivertown',
            'no_telpon' => '9412345678',
            'password' => "user2",
        ]);

        $user2 = User::factory()->create([
            'nama_lengkap' => 'Another User',
            'username' => 'user3',
            'email' => 'test3@example.com',
            'kota_asal' => 'Rivertown',
            'no_telpon' => '9412345678',
            'password' => "user2",
            'is_admin' => true,
        ]);

        // Donation types
        $dt1 = DB::table('donation_types')->insertGetId([
            'name' => 'Clothes',
            'created_at' => now(), 'updated_at' => now(),
        ]);
        $dt2 = DB::table('donation_types')->insertGetId([
            'name' => 'Food',
            'created_at' => now(), 'updated_at' => now(),
        ]);

        // Donation galleries
        DB::table('donation_galleries')->insert([
            ['image_path' => 'images/don1.jpg', 'caption' => 'Donasi 1', 'created_at' => now(), 'updated_at' => now()],
            ['image_path' => 'images/don2.jpg', 'caption' => 'Donasi 2', 'created_at' => now(), 'updated_at' => now()],
        ]);

        // Donation goals
        DB::table('donation_goals')->insert([
            ['donation_type_id' => $dt1, 'target_quantity' => 100, 'created_at' => now(), 'updated_at' => now()],
            ['donation_type_id' => $dt2, 'target_quantity' => 200, 'created_at' => now(), 'updated_at' => now()],
        ]);

        // Shipping methods
        $ship1 = DB::table('shipping_methods')->insertGetId(['name' => 'Pickup', 'created_at' => now(), 'updated_at' => now()]);
        $ship2 = DB::table('shipping_methods')->insertGetId(['name' => 'Courier', 'created_at' => now(), 'updated_at' => now()]);

        // Contacts
        DB::table('contacts')->insert([
            ['alamat' => 'Jl. Example 1', 'email' => 'contact1@example.com', 'no_telp' => '081234567890', 'created_at' => now(), 'updated_at' => now()],
            ['alamat' => 'Jl. Example 2', 'email' => 'contact2@example.com', 'no_telp' => '089876543210', 'created_at' => now(), 'updated_at' => now()],
        ]);

        // Articles
        DB::table('articles')->insert([
            ['title' => 'Welcome', 'content' => 'First article content', 'image' => 'images/art1.jpg', 'additional_images' => json_encode([]), 'date' => now()->toDateString(), 'created_at' => now(), 'updated_at' => now()],
            ['title' => 'News', 'content' => 'Second article content', 'image' => 'images/art2.jpg', 'additional_images' => json_encode([]), 'date' => now()->toDateString(), 'created_at' => now(), 'updated_at' => now()],
        ]);

        // Event categories and events
        $cat1 = DB::table('event_categories')->insertGetId(['name' => 'Seminar', 'slug' => 'seminar', 'created_at' => now(), 'updated_at' => now()]);
        $cat2 = DB::table('event_categories')->insertGetId(['name' => 'Workshop', 'slug' => 'workshop', 'created_at' => now(), 'updated_at' => now()]);

        $event1 = DB::table('events')->insertGetId([
            'category_id' => $cat1,
            'title' => 'Seminar A',
            'content' => 'Seminar content A',
            'image' => 'images/event1.jpg',
            'additional_images' => json_encode([]),
            'date' => now()->addDays(7)->toDateString(),
            'status' => 'upcoming',
            'capacity' => 100,
            'enable_reminder' => true,
            'created_at' => now(), 'updated_at' => now(),
        ]);

        $event2 = DB::table('events')->insertGetId([
            'category_id' => $cat2,
            'title' => 'Workshop B',
            'content' => 'Workshop content B',
            'image' => 'images/event2.jpg',
            'additional_images' => json_encode([]),
            'date' => now()->addDays(14)->toDateString(),
            'status' => 'upcoming',
            'capacity' => 50,
            'enable_reminder' => true,
            'created_at' => now(), 'updated_at' => now(),
        ]);

        // Event registrations
        DB::table('event_registrations')->insert([
            ['event_id' => $event1, 'user_id' => $user1->id, 'name' => $user1->nama_lengkap ?? $user1->name ?? 'User One', 'email' => $user1->email, 'created_at' => now(), 'updated_at' => now()],
            ['event_id' => $event2, 'user_id' => $user2->id, 'name' => $user2->nama_lengkap ?? $user2->name ?? 'User Two', 'email' => $user2->email, 'created_at' => now(), 'updated_at' => now()],
        ]);

        // Donations
        DB::table('donations')->insert([
            ['user_id' => $user1->id, 'type' => 'Clothes', 'quantity' => 5, 'shipping_method' => 'Pickup', 'status' => 'pending', 'notes' => 'No notes', 'created_at' => now(), 'updated_at' => now()],
            ['user_id' => $user2->id, 'type' => 'Food', 'quantity' => 10, 'shipping_method' => 'Courier', 'status' => 'pending', 'notes' => 'Handle with care', 'created_at' => now(), 'updated_at' => now()],
        ]);

        // Foundation profiles
        DB::table('foundation_profiles')->insert([
            ['description' => 'Foundation description 1', 'created_at' => now(), 'updated_at' => now()],
            ['description' => 'Foundation description 2', 'created_at' => now(), 'updated_at' => now()],
        ]);

        // Posts, comments, likes
        $post1 = DB::table('posts')->insertGetId(['user_id' => $user1->id, 'content' => 'First post', 'created_at' => now(), 'updated_at' => now()]);
        $post2 = DB::table('posts')->insertGetId(['user_id' => $user2->id, 'content' => 'Second post', 'created_at' => now(), 'updated_at' => now()]);

        DB::table('comments')->insert([
            ['user_id' => $user2->id, 'post_id' => $post1, 'body' => 'Nice post!', 'created_at' => now(), 'updated_at' => now()],
            ['user_id' => $user1->id, 'post_id' => $post2, 'body' => 'Thanks!', 'created_at' => now(), 'updated_at' => now()],
        ]);

        DB::table('post_likes')->insert([
            ['user_id' => $user1->id, 'post_id' => $post2, 'created_at' => now(), 'updated_at' => now()],
            ['user_id' => $user2->id, 'post_id' => $post1, 'created_at' => now(), 'updated_at' => now()],
        ]);

        // Optionally seed personal_access_tokens for testing (not storing token string here)
        DB::table('personal_access_tokens')->insert([
            ['tokenable_type' => 'App\\Models\\User', 'tokenable_id' => $user1->id, 'name' => 'token1', 'token' => Hash::make(Str::random(40)), 'abilities' => json_encode(['*']), 'created_at' => now(), 'updated_at' => now()],
            ['tokenable_type' => 'App\\Models\\User', 'tokenable_id' => $user2->id, 'name' => 'token2', 'token' => Hash::make(Str::random(40)), 'abilities' => json_encode(['*']), 'created_at' => now(), 'updated_at' => now()],
        ]);
    }
}
