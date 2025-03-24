<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Repositories\TimeTableRepo;
use App\Repositories\StudentRepo;
use App\Helpers\Qs;
use Illuminate\Http\Request;

class TimeTableController extends Controller
{
    protected $tt, $student;

    public function __construct(TimeTableRepo $tt, StudentRepo $student)
    {
        $this->tt = $tt;
        $this->student = $student;
    }

    public function childrenTimetables()
    {
        if (!Qs::userIsParent()) {
            return response()->json([
                'status' => false,
                'message' => 'Access Denied'
            ], 403);
        }

        $parent_id = auth()->user()->id;
        
        // Get all children of the parent
        $children = $this->student->getRecord(['my_parent_id' => $parent_id])
            ->with(['user', 'my_class', 'section'])
            ->get();

        return response()->json([
            'status' => true,
            'children' => $children
        ]);
    }

    public function childTimetable($student_id)
    {
        if (!Qs::userIsParent()) {
            return response()->json([
                'status' => false,
                'message' => 'Access Denied'
            ], 403);
        }

        $parent_id = auth()->user()->id;
        
        // Get the student record and verify parent relationship
        $student = $this->student->getRecord(['my_parent_id' => $parent_id, 'id' => $student_id])
            ->with(['user', 'my_class', 'section'])
            ->firstOrFail();

        // Get timetable records for the student's class
        $tt_records = $this->tt->getRecord(['my_class_id' => $student->my_class_id]);
        
        return response()->json([
            'status' => true,
            'student' => $student,
            'timetables' => $tt_records
        ]);
    }
}
