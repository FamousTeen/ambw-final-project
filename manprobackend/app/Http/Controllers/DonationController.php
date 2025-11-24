<?php

namespace App\Http\Controllers;

use App\Http\Requests\DonationRequest;
use App\Models\Donation;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

class DonationController extends Controller
{
    public function donasi(DonationRequest $request)
    {
        $validated = $request->validated();
        
        $donation = Donation::create([
            'user_id' => Auth::id(),
            'type' => $validated['type'],
            'quantity' => $validated['quantity'],
            'shipping_method' => $validated['shipping_method'],
            'status' => 'pending',
            'notes' => $validated['notes'] ?? null
        ]);

        return response()->json([
            'message' => 'Donation created successfully',
            'data' => $donation
        ], 201);
    }

    public function history()
    {
        $donations = Donation::where('user_id', Auth::id())
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function ($donation) {
                return [
                    'id' => $donation->id,
                    'type' => $donation->type,
                    'quantity' => $donation->quantity,
                    'shippingMethod' => $donation->shipping_method,
                    'notes' => $donation->notes ?? '-',
                    'status' => $donation->status,
                    'created_at' => $donation->created_at->format('Y-m-d H:i:s')
                ];
            });

        return response()->json([
            'message' => 'Donation history retrieved successfully',
            'data' => $donations
        ]);
    }

    public function updateStatus(Request $request, Donation $donation)
    {
        $request->validate([
            'status' => 'required|in:pending,accepted,success,failed'
        ]);

        // Only allow status changes in the correct flow
        if ($donation->status === 'pending' && $request->status !== 'accepted') {
            return response()->json([
                'message' => 'Pending donations can only be accepted'
            ], 422);
        }

        if ($donation->status === 'accepted' && !in_array($request->status, ['success', 'failed'])) {
            return response()->json([
                'message' => 'Accepted donations can only be marked as success or failed'
            ], 422);
        }

        if (in_array($donation->status, ['success', 'failed'])) {
            return response()->json([
                'message' => 'Cannot update status of completed donations'
            ], 422);
        }

        $donation->status = $request->status;
        $donation->save();

        return response()->json([
            'message' => 'Status updated successfully',
            'data' => $donation
        ]);
    }

    public function cancel(Donation $donation)
    {
        try {
            // Check if donation belongs to authenticated user
            if ($donation->user_id !== auth()->id()) {
                return response()->json([
                    'message' => 'Unauthorized to cancel this donation'
                ], 403);
            }

            // Check if donation can be cancelled (only pending donations)
            if ($donation->status !== 'pending') {
                return response()->json([
                    'message' => 'Only pending donations can be cancelled'
                ], 422);
            }

            $donation->update(['status' => 'cancelled']);

            return response()->json([
                'message' => 'Donation cancelled successfully',
                'data' => $donation
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to cancel donation',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
