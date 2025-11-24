<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests\ProfileRequest;

class ProfileController extends Controller
{
    public function show(Request $request)
    {
        return response()->json([
            'user' => $request->user()
        ]);
    }

    public function update(ProfileRequest $request)
    {
        $user = $request->user();
        $user->update($request->validated());

        return response()->json([
            'user' => $user,
            'message' => 'Profile updated successfully'
        ]);
    }
}
