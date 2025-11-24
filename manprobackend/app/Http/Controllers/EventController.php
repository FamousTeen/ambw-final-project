<?php

namespace App\Http\Controllers;

use App\Models\Event;
use App\Models\EventRegistration;
use App\Http\Requests\EventRequest;
use App\Http\Requests\EventRegistrationRequest;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class EventController extends Controller
{
    public function index(Request $request)
    {
        $events = Event::with('category')
            ->filter($request->only(['search', 'category', 'status', 'date']))
            ->latest()
            ->get()
            ->map(function ($event) {
                $imageUrl = $event->image;
                if (!filter_var($event->image, FILTER_VALIDATE_URL)) {
                    $imageUrl = asset('storage/' . $event->image);
                }

                $registrationsCount = $event->registrations()->count();

                return [
                    'id' => $event->id,
                    'title' => $event->title,
                    'content' => $event->content,
                    'image' => $imageUrl,
                    'date' => $event->date->format('d F Y'),
                    'time' => $event->date->format('H:i'),
                    'category' => $event->category ? [
                        'id' => $event->category->id,
                        'name' => $event->category->name,
                        'slug' => $event->category->slug,
                    ] : null,
                    'status' => $event->status,
                    'registrations_count' => $registrationsCount,
                    'capacity' => $event->capacity,
                    'share_url' => $event->share_url,
                    'created_at' => $event->created_at->format('Y-m-d H:i:s')
                ];
            });

        return response()->json([
            'message' => 'Events retrieved successfully',
            'data' => $events
        ]);
    }

    public function show(Event $event)
    {
        $event->load('category');
        
        $imageUrl = $event->image;
        if (!filter_var($event->image, FILTER_VALIDATE_URL)) {
            $imageUrl = asset('storage/' . $event->image);
        }

        $registrationsCount = $event->registrations()->count();

        return response()->json([
            'message' => 'Event details retrieved successfully',
            'data' => [
                'id' => $event->id,
                'title' => $event->title,
                'content' => $event->content,
                'image' => $imageUrl,
                'date' => $event->date->format('d F Y'),
                'time' => $event->date->format('H:i'),
                'category' => $event->category ? [
                    'id' => $event->category->id,
                    'name' => $event->category->name,
                    'slug' => $event->category->slug,
                ] : null,
                'status' => $event->status,
                'registrations_count' => $registrationsCount,
                'capacity' => $event->capacity,
                'created_at' => $event->created_at->format('Y-m-d H:i:s'),
                'additional_images' => $event->additional_images ?
                    collect($event->additional_images)->map(function ($image) {
                        return asset('storage/' . $image);
                    }) : null
            ]
        ]);
    }

    public function register(EventRegistrationRequest $request)
    {
        $registration = EventRegistration::create([
            'event_id' => $request->event_id,
            'user_id' => Auth::id(),
            'name' => $request->name,
            'email' => $request->email
        ]);

        return response()->json([
            'message' => 'Registration successful',
            'data' => $registration
        ], 201);
    }

    public function history()
    {
        $registrations = EventRegistration::with('event')
            ->where('user_id', Auth::id())
            ->latest()
            ->get();

        return response()->json(['data' => $registrations]);
    }

    // Admin only methods
    public function store(EventRequest $request)
    {
        $imagePath = $request->file('image')->store('events', 'public');

        $event = Event::create([
            'title' => $request->title,
            'content' => $request->content,
            'image' => $imagePath,
            'date' => $request->date
        ]);

        return response()->json([
            'message' => 'Event created successfully',
            'data' => $event
        ], 201);
    }

    public function validateEmail(Request $request)
    {
        $user = User::where('email', $request->email)->first();

        if ($user) {
            return response()->json([
                'message' => 'Email found',
                'valid' => true
            ], 200);
        }

        return response()->json([
            'message' => 'Email not found in database. Please use your registered email.',
            'valid' => false
        ], 404);
    }

    public function cancelRegistration(EventRegistration $registration)
    {
        try {
            // Verifikasi bahwa user yang request adalah pemilik registrasi
            if ($registration->user_id != auth()->id()) {
                return response()->json([
                    'message' => 'Unauthorized to cancel this registration'
                ], 403);
            }

            $registration->delete();

            return response()->json([
                'message' => 'Registration cancelled successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to cancel registration',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function toggleReminder($eventId)
    {
        $event = Event::findOrFail($eventId);
        $event->enable_reminder = !$event->enable_reminder;
        $event->save();

        return response()->json([
            'message' => 'Reminder settings updated',
            'enable_reminder' => $event->enable_reminder
        ]);
    }

    public function update(Request $request, Event $event)
    {
        $request->validate([
            'category_id' => 'exists:event_categories,id',
            'title' => 'string|min:3|max:255',
            'content' => 'string|min:10',
            'image' => 'nullable|image|mimes:jpg,png,jpeg',
            'additional_images.*' => 'nullable|image|mimes:jpg,png,jpeg',
            'date' => 'date',
            'capacity' => 'integer|min:0'
        ]);

        $data = $request->only([
            'category_id',
            'title',
            'content',
            'date',
            'capacity'
        ]);

        if ($request->hasFile('image')) {
            // Hapus gambar lama jika ada
            if ($event->image) {
                Storage::disk('public')->delete($event->image);
            }
            $data['image'] = $request->file('image')->store('events', 'public');
        }

        if ($request->hasFile('additional_images')) {
            $additionalImages = [];
            foreach ($request->file('additional_images') as $image) {
                $additionalImages[] = $image->store('events', 'public');
            }
            $data['additional_images'] = $additionalImages;
        }

        $event->update($data);

        return response()->json([
            'message' => 'Event updated successfully',
            'data' => $event
        ]);
    }

    public function generateShareUrl($eventId)
    {
        $event = Event::findOrFail($eventId);
        // Generate unique share URL
        $shareUrl = url("/events/{$event->id}");
        $event->share_url = $shareUrl;
        $event->save();

        return response()->json([
            'message' => 'Share URL generated',
            'share_url' => $shareUrl
        ]);
    }
}
