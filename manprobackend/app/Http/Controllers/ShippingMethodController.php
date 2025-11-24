<?php

namespace App\Http\Controllers;

use App\Models\ShippingMethod;
use App\Http\Requests\ShippingMethodRequest;
use Illuminate\Http\Request;

class ShippingMethodController extends Controller
{
    public function index()
    {
        $methods = ShippingMethod::all();
        return response()->json(['data' => $methods]);
    }

    public function store(ShippingMethodRequest $request)
    {
        try {
            $method = ShippingMethod::create($request->validated());
            return response()->json([
                'message' => 'Shipping method created successfully',
                'data' => $method
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to create shipping method',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function update(ShippingMethodRequest $request, ShippingMethod $method)
    {
        try {
            $method->update($request->validated());
            return response()->json([
                'message' => 'Shipping method updated successfully',
                'data' => $method
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to update shipping method',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy(ShippingMethod $method)
    {
        try {
            $method->delete();
            return response()->json([
                'message' => 'Shipping method deleted successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to delete shipping method',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
