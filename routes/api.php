<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\UserController;
use App\Http\Controllers\API\TimeTableController;
use App\Http\Controllers\API\ParentController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Test route to check if API is working
Route::get('/', function () {
    return response()->json([
        'message' => 'SmartSchool API is working!',
        'status' => 'success'
    ]);
});

// Auth routes
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    // Auth routes
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);

    // User routes
    Route::get('/users', [UserController::class, 'getUsers']);
    Route::get('/students', [UserController::class, 'getStudents']);

    // Timetable routes
    Route::get('/timetables/children', [TimeTableController::class, 'childrenTimetables']);
    Route::get('/timetables/child/{student_id}', [TimeTableController::class, 'childTimetable']);

    // Parent Routes
    Route::middleware(['role:parent'])->prefix('parent')->group(function () {
        Route::get('/children', [ParentController::class, 'children']);
        Route::get('/children/{student}/attendance', [ParentController::class, 'childAttendance']);
        Route::get('/children/{student}/grades', [ParentController::class, 'childGrades']);
        Route::get('/children/{student}/exams', [ParentController::class, 'childExams']);
        Route::get('/children/{student}/timetable', [ParentController::class, 'childTimetable']);
        Route::get('/children/{student}/payments', [ParentController::class, 'childPayments']);
    });
});
