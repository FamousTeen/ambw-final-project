<?php

namespace App\Http\Controllers;

use App\Models\Contact;
use App\Http\Requests\ContactRequest;
use Illuminate\Http\JsonResponse;

class ContactController extends Controller
{
    /**
     * Get contact information
     * @return JsonResponse
     */
    public function show(): JsonResponse
    {
        $contact = Contact::first();

        if (!$contact) {
            return response()->json([
                'message' => 'Contact information not found'
            ], 404);
        }

        return response()->json([
            'data' => $contact
        ], 200);
    }

    /**
     * Update contact information (Admin only)
     * @param ContactRequest $request
     * @return JsonResponse
     */
    public function update(ContactRequest $request): JsonResponse
    {
        try {
            $contact = Contact::first();

            if (!$contact) {
                $contact = Contact::create($request->validated());
                $message = 'Contact information created successfully';
            } else {
                $contact->update($request->validated());
                $message = 'Contact information updated successfully';
            }

            return response()->json([
                'message' => $message,
                'data' => $contact
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error updating contact information',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
