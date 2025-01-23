<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Helpers\Qs;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => 'required|email',
            'password' => 'required'
        ]);

        if (Auth::attempt($credentials)) {
            $user = Auth::user();
            $token = $user->createToken('auth_token')->plainTextToken;
            
            return response()->json([
                'status' => true,
                'token' => $token,
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'user_type' => $user->user_type,
                    'is_admin' => Qs::userIsAdmin(),
                    'is_teacher' => Qs::userIsTeacher(),
                    'is_student' => Qs::userIsStudent(),
                    'is_parent' => Qs::userIsParent(),
                ]
            ]);
        }

        return response()->json([
            'status' => false,
            'message' => 'Invalid credentials'
        ], 401);
    }

    public function logout()
    {
        Auth::user()->tokens()->delete();
        return response()->json([
            'status' => true,
            'message' => 'Successfully logged out'
        ]);
    }

    public function user()
    {
        $user = Auth::user();
        return response()->json([
            'status' => true,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'user_type' => $user->user_type,
                'is_admin' => Qs::userIsAdmin(),
                'is_teacher' => Qs::userIsTeacher(),
                'is_student' => Qs::userIsStudent(),
                'is_parent' => Qs::userIsParent(),
            ]
        ]);
    }
}
