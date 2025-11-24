<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Event;
use App\Models\EventCategory;
use App\Models\EventRegistration;
use App\Http\Requests\EventRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class EventManagementController extends Controller
{
    public function index(Request $request)
    {
        $query = Event::with('category');

        // Apply filters
        if ($request->status) {
            $query->where('status', $request->status);
        }
        if ($request->category) {
            $query->where('category_id', $request->category);
        }
        if ($request->date) {
            $query->whereDate('date', $request->date);
        }

        $events = $query->latest()->paginate(10);
        $categories = EventCategory::all();

        return view('admin.events.index', compact('events', 'categories'));
    }

    public function create()
    {
        $categories = EventCategory::all();
        return view('admin.events.create', compact('categories'));
    }

    public function store(EventRequest $request)
    {
        try {
            $data = $request->validated();
            
            // Combine date and time
            $data['date'] = date('Y-m-d H:i:s', strtotime($data['date'] . ' ' . $data['time']));
            unset($data['time']); // Remove separate time field
            
            // Handle image upload
            if ($request->hasFile('image')) {
                $data['image'] = $request->file('image')->store('events', 'public');
            }

            // Handle additional images
            if ($request->hasFile('additional_images')) {
                $additionalImages = [];
                foreach ($request->file('additional_images') as $image) {
                    $additionalImages[] = $image->store('events', 'public');
                }
                $data['additional_images'] = $additionalImages;
            }

            $event = Event::create($data);

            return redirect()->route('admin.events.index')
                ->with('success', 'Event created successfully');
        } catch (\Exception $e) {
            return back()->with('error', 'Error creating event: ' . $e->getMessage())
                ->withInput();
        }
    }

    public function edit(Event $event)
    {
        $categories = EventCategory::all();
        return view('admin.events.edit', compact('event', 'categories'));
    }

    public function update(EventRequest $request, Event $event)
    {
        try {
            $data = $request->validated();
            
            // Combine date and time
            $data['date'] = date('Y-m-d H:i:s', strtotime($data['date'] . ' ' . $data['time']));
            unset($data['time']); // Remove separate time field

            // Handle image upload
            if ($request->hasFile('image')) {
                // Delete old image
                if ($event->image) {
                    Storage::disk('public')->delete($event->image);
                }
                $data['image'] = $request->file('image')->store('events', 'public');
            }

            // Handle additional images
            if ($request->hasFile('additional_images')) {
                // Delete old additional images
                if ($event->additional_images) {
                    foreach ($event->additional_images as $image) {
                        Storage::disk('public')->delete($image);
                    }
                }
                
                $additionalImages = [];
                foreach ($request->file('additional_images') as $image) {
                    $additionalImages[] = $image->store('events', 'public');
                }
                $data['additional_images'] = $additionalImages;
            }

            $event->update($data);

            return redirect()->route('admin.events.index')
                ->with('success', 'Event updated successfully');
        } catch (\Exception $e) {
            return back()->with('error', 'Error updating event: ' . $e->getMessage())
                ->withInput();
        }
    }

    public function destroy(Event $event)
    {
        try {
            // Delete main image
            if ($event->image) {
                Storage::disk('public')->delete($event->image);
            }

            // Delete additional images
            if ($event->additional_images) {
                foreach ($event->additional_images as $image) {
                    Storage::disk('public')->delete($image);
                }
            }

            $event->delete();

            return redirect()->route('admin.events.index')
                ->with('success', 'Event deleted successfully');
        } catch (\Exception $e) {
            return back()->with('error', 'Error deleting event: ' . $e->getMessage());
        }
    }

    public function categories()
    {
        $categories = EventCategory::withCount('events')->paginate(10);
        return view('admin.events.categories', compact('categories'));
    }

    public function storeCategory(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:event_categories'
        ]);

        try {
            EventCategory::create([
                'name' => $request->name
            ]);

            return response()->json([
                'message' => 'Category created successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error creating category: ' . $e->getMessage()
            ], 500);
        }
    }

    public function updateCategory(Request $request, EventCategory $category)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:event_categories,name,' . $category->id
        ]);

        try {
            $category->update([
                'name' => $request->name
            ]);

            return response()->json([
                'message' => 'Category updated successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error updating category: ' . $e->getMessage()
            ], 500);
        }
    }

    public function destroyCategory(EventCategory $category)
    {
        try {
            if ($category->events()->exists()) {
                return response()->json([
                    'message' => 'Cannot delete category that is being used by events'
                ], 422);
            }

            $category->delete();

            return response()->json([
                'message' => 'Category deleted successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error deleting category: ' . $e->getMessage()
            ], 500);
        }
    }

    public function registrations()
    {
        $registrations = EventRegistration::with('event')
            ->latest()
            ->paginate(10);

        return view('admin.events.registrations', compact('registrations'));
    }

    public function updateRegistrationStatus(EventRegistration $registration)
    {
        try {
            $validated = request()->validate([
                'status' => 'required|in:approved,rejected'
            ]);

            $registration->update([
                'status' => $validated['status']
            ]);

            return response()->json([
                'message' => 'Registration status updated successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to update registration status',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function updateStatus(Request $request, Event $event)
    {
        try {
            $validated = $request->validate([
                'status' => 'required|in:upcoming,ongoing,completed'
            ]);

            $event->update([
                'status' => $validated['status']
            ]);

            return response()->json([
                'message' => 'Event status updated successfully',
                'status' => $validated['status']
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error updating event status: ' . $e->getMessage()
            ], 500);
        }
    }
} 