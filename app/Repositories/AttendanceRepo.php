<?php

namespace App\Repositories;

use App\Models\StudentAttendance;
use App\Helpers\Qs;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Carbon\Carbon;

class AttendanceRepo
{
    public function getStudentAttendance($student_id)
    {
        try {
            // Get raw data from database to see actual format
            Log::info('Fetching attendance for student: ' . $student_id);
            
            $attendances = DB::table('student_attendances')
                ->join('my_classes', 'student_attendances.class_id', '=', 'my_classes.id')
                ->leftJoin('sections', 'student_attendances.section_id', '=', 'sections.id')
                ->where('student_attendances.student_id', $student_id)
                ->select(
                    'student_attendances.*',
                    'my_classes.name as class_name',
                    'sections.name as section_name'
                )
                ->orderBy('student_attendances.date', 'desc')
                ->get();

            Log::info('Found ' . $attendances->count() . ' attendance records');
            
            return $attendances->map(function ($attendance) {
                // Get the date value
                $dateValue = $attendance->date;
                
                // Convert to proper format regardless of input type
                try {
                    $formattedDate = is_string($dateValue) 
                        ? Carbon::parse($dateValue)->format('Y-m-d')
                        : $dateValue->format('Y-m-d');
                } catch (\Exception $e) {
                    Log::error('Error formatting date: ' . $e->getMessage());
                    Log::error('Date value: ' . print_r($dateValue, true));
                    $formattedDate = date('Y-m-d'); // Fallback to current date
                }

                return [
                    'id' => $attendance->id,
                    'date' => $formattedDate,
                    'status' => $attendance->status ?? 'unknown',
                    'time_in' => $attendance->time_in,
                    'time_out' => $attendance->time_out,
                    'remark' => $attendance->remark,
                    'class' => $attendance->class_name,
                    'section' => $attendance->section_name,
                    'session' => Qs::getCurrentSession(),
                ];
            });
        } catch (\Exception $e) {
            Log::error('Error in getStudentAttendance: ' . $e->getMessage());
            Log::error($e->getTraceAsString());
            Log::error('Student ID: ' . $student_id);
            return collect([]);
        }
    }
}
