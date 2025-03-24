<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use App\Helpers\Qs;
use Illuminate\Support\Facades\Auth;

class CheckRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, string $role): Response
    {
        if (!Auth::check()) {
            return response()->json([
                'status' => false,
                'message' => 'Unauthenticated'
            ], 401);
        }

        // Check if user has the required role
        if (strtolower($role) === 'parent' && !Qs::userIsParent()) {
            return response()->json([
                'status' => false,
                'message' => 'Unauthorized. Parent access required.'
            ], 403);
        }

        if (strtolower($role) === 'teacher' && !Qs::userIsTeacher()) {
            return response()->json([
                'status' => false,
                'message' => 'Unauthorized. Teacher access required.'
            ], 403);
        }

        if (strtolower($role) === 'admin' && !Qs::userIsAdmin()) {
            return response()->json([
                'status' => false,
                'message' => 'Unauthorized. Admin access required.'
            ], 403);
        }

        return $next($request);
    }
}
