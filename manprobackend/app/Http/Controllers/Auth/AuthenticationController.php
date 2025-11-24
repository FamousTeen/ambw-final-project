<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\RegisterRequest;
use App\Http\Requests\LoginRequest;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Response;
use App\Http\Requests\ForgetPassRequest;

class AuthenticationController extends Controller
{
    public function register(RegisterRequest $request)
    {
        $request->validated();

        $userData = [
            'nama_lengkap' => $request->nama_lengkap,
            'username' => $request->username,
            'email' => $request->email,
            'kota_asal' => $request->kota_asal,
            'no_telpon' => $request->no_telpon,
            'password' => Hash::make($request->password),
        ];

        $user = User::create($userData);
        $token = $user->createToken('manprobackend')->plainTextToken;

        return response([
            'user' => $user,
            'token' => $token
        ], 201);
    }

    public function login(LoginRequest $request)
    {
        $request->validated();

        $user = User::whereUsername($request->username)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response([
                'message' => 'Username atau password salah'
            ], 422);
        }

        $token = $user->createToken('manprobackend')->plainTextToken;

        return response([
            'user' => $user,
            'token' => $token
        ], 200);
    }

    public function forgetPassword(ForgetPassRequest $request)
    {
        $request->validated();

        $user = User::where('email', $request->email)->first();
        
        if (!$user) {
            return response([
                'message' => 'Email tidak ditemukan'
            ], 404);
        }

        $user->password = Hash::make($request->password);
        $user->save();

        $token = $user->createToken('manprobackend')->plainTextToken;
        
        return response([
            'user' => $user,
            'token' => $token,
            'message' => 'Password berhasil diubah'
        ], 200);
    }

    public function getLogin(Request $r)
    {
        $data = User::find($r->id);
        if (isset($data)) {
            return Response::json(['data' => $data], 200);
        } else return abort(404);
    }

    public function logout(Request $request)
    {
        try {
            // Revoke the user's current token
            $request->user()->currentAccessToken()->delete();

            return response()->json([
                'message' => 'Successfully logged out'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error during logout',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
