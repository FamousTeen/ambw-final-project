<?php

namespace App\Http\Controllers;

use App\Models\DonationType;
use App\Http\Requests\DonationTypeRequest;
use Illuminate\Http\Request;

class DonationTypeController extends Controller
{
    public function index()
    {
        $types = DonationType::all();
        return response()->json(['data' => $types]);
    }

    public function store(DonationTypeRequest $request)
    {
        try {
            $type = DonationType::create($request->validated());
            return response()->json([
                'message' => 'Donation type created successfully',
                'data' => $type
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to create donation type',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function update(DonationTypeRequest $request, DonationType $type)
    {
        try {
            $type->update($request->validated());
            return response()->json([
                'message' => 'Donation type updated successfully',
                'data' => $type
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to update donation type',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy(DonationType $type)
    {
        try {
            $type->delete();
            return response()->json([
                'message' => 'Donation type deleted successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to delete donation type',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
