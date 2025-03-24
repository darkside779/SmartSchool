<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Helpers\Qs;
use App\Repositories\UserRepo;
use App\Repositories\StudentRepo;

class UserController extends Controller
{
    protected $user, $student;

    public function __construct(UserRepo $user, StudentRepo $student)
    {
        $this->user = $user;
        $this->student = $student;
    }

    public function getUsers()
    {
        if (!Qs::userIsAdmin()) {
            return response()->json([
                'status' => false,
                'message' => 'Access Denied'
            ], 403);
        }

        $users = $this->user->getAllUsers();
        return response()->json([
            'status' => true,
            'users' => $users
        ]);
    }

    public function getStudents()
    {
        if (!Qs::userIsTeacher() && !Qs::userIsAdmin()) {
            return response()->json([
                'status' => false,
                'message' => 'Access Denied'
            ], 403);
        }

        $students = $this->student->getAllStudents();
        return response()->json([
            'status' => true,
            'students' => $students
        ]);
    }
}
