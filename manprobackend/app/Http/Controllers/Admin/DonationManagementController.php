<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Donation;
use App\Models\DonationType;
use App\Models\ShippingMethod;
use Illuminate\Http\Request;

class DonationManagementController extends Controller
{
    public function index(Request $request)
    {
        $query = Donation::with('user');

        // Apply filters
        if ($request->status) {
            $query->where('status', $request->status);
        }
        if ($request->type) {
            $query->where('type', $request->type);
        }
        if ($request->shipping_method) {
            $query->where('shipping_method', $request->shipping_method);
        }

        $donations = $query->latest()->paginate(10);
        $donationTypes = DonationType::all();
        $shippingMethods = ShippingMethod::all();

        return view('admin.donations.index', compact('donations', 'donationTypes', 'shippingMethods'));
    }

    public function updateStatus(Request $request, Donation $donation)
    {
        $request->validate([
            'status' => 'required|in:pending,accepted,success,failed'
        ]);

        $donation->update(['status' => $request->status]);

        return back()->with('success', 'Donation status updated successfully');
    }

    // Donation Types Management
    public function types()
    {
        $donationTypes = DonationType::all();
        return view('admin.donations.types', compact('donationTypes'));
    }

    public function storeType(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:donation_types'
        ]);

        DonationType::create($request->only('name'));

        return back()->with('success', 'Donation type created successfully');
    }

    public function updateType(Request $request, DonationType $type)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:donation_types,name,' . $type->id
        ]);

        $type->update($request->only('name'));

        return back()->with('success', 'Donation type updated successfully');
    }

    public function destroyType(DonationType $type)
    {
        // Check if type is being used by any donations
        if (Donation::where('type', $type->name)->exists()) {
            return back()->with('error', 'Cannot delete donation type that is being used');
        }

        $type->delete();
        return back()->with('success', 'Donation type deleted successfully');
    }

    // Shipping Methods Management
    public function shippingMethods()
    {
        $shippingMethods = ShippingMethod::all();
        return view('admin.donations.shipping-methods', compact('shippingMethods'));
    }

    public function storeShippingMethod(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:shipping_methods'
        ]);

        ShippingMethod::create($request->only('name'));

        return back()->with('success', 'Shipping method created successfully');
    }

    public function updateShippingMethod(Request $request, ShippingMethod $method)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:shipping_methods,name,' . $method->id
        ]);

        $method->update($request->only('name'));

        return back()->with('success', 'Shipping method updated successfully');
    }

    public function destroyShippingMethod(ShippingMethod $method)
    {
        // Check if method is being used by any donations
        if (Donation::where('shipping_method', $method->name)->exists()) {
            return back()->with('error', 'Cannot delete shipping method that is being used');
        }

        $method->delete();
        return back()->with('success', 'Shipping method deleted successfully');
    }
} 