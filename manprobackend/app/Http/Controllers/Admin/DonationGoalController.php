<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\DonationGoal;
use App\Models\DonationType;
use Illuminate\Http\Request;

class DonationGoalController extends Controller
{
    public function index()
    {
        $goals = DonationGoal::with('donationType')->get();
        $donationTypes = DonationType::all();
        return view('admin.donations.goals', compact('goals', 'donationTypes'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'donation_type_id' => 'required|exists:donation_types,id',
            'target_quantity' => 'required|integer|min:1'
        ]);

        // Check if goal already exists for this type
        $existingGoal = DonationGoal::where('donation_type_id', $request->donation_type_id)->first();
        if ($existingGoal) {
            return back()->with('error', 'A goal for this donation type already exists');
        }

        DonationGoal::create($request->only(['donation_type_id', 'target_quantity']));
        return back()->with('success', 'Donation goal created successfully');
    }

    public function update(Request $request, DonationGoal $goal)
    {
        $request->validate([
            'target_quantity' => 'required|integer|min:1'
        ]);

        $goal->update($request->only(['target_quantity']));
        return back()->with('success', 'Donation goal updated successfully');
    }

    public function destroy(DonationGoal $goal)
    {
        $goal->delete();
        return back()->with('success', 'Donation goal deleted successfully');
    }
} 