<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\StudentRecord;
use App\Models\Mark;
use App\Models\TimeTable;
use App\Models\StudentAttendance;
use App\Models\Payment;
use App\Models\PaymentRecord;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;

class ParentController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    /**
     * Get all children for the authenticated parent
     */
    public function children()
    {
        try {
            $parent = Auth::user();
            Log::info('Fetching children for parent ID: ' . $parent->id);
            
            if (!$parent || $parent->user_type !== 'parent') {
                Log::warning('Unauthorized parent access attempt');
                return response()->json([
                    'status' => false,
                    'message' => 'Unauthorized. Parent access required.'
                ], 403);
            }

            $children = StudentRecord::where('my_parent_id', $parent->id)
                ->with(['user', 'my_class', 'section'])
                ->get();

            Log::info('Found ' . $children->count() . ' children records');

            if ($children->isEmpty()) {
                Log::info('No children found for parent ID: ' . $parent->id);
                return response()->json([
                    'status' => true,
                    'data' => []
                ]);
            }

            $formattedChildren = $children->map(function ($record) use ($parent) {
                return [
                    'id' => $record->id,
                    'user' => [
                        'id' => $record->user->id,
                        'name' => $record->user->name,
                        'email' => $record->user->email,
                        'user_type' => 'student',
                        'phone' => $record->user->phone,
                        'gender' => $record->user->gender,
                        'dob' => $record->user->dob,
                    ],
                    'admission_number' => $record->adm_no,
                    'roll_number' => null, // Add if available in your system
                    'current_class' => optional($record->my_class)->name,
                    'section' => optional($record->section)->name,
                    'admission_date' => $record->year_admitted,
                    'parent_name' => $parent->name,
                    'parent_phone' => $parent->phone,
                    'parent_email' => $parent->email,
                    'address' => $record->user->address,
                    'blood_group' => optional($record->user->blood_group)->name,
                    'date_of_birth' => $record->user->dob,
                    'gender' => $record->user->gender,
                    'is_active' => true
                ];
            });

            return response()->json([
                'status' => true,
                'data' => $formattedChildren
            ]);

        } catch (\Exception $e) {
            Log::error('Error fetching children: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Failed to fetch children: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get attendance records for a specific child
     */
    public function childAttendance($student_id)
    {
        try {
            $parent = Auth::user();
            Log::info('Parent ' . $parent->id . ' requesting attendance for student ' . $student_id);
            
            // Check if the student belongs to this parent
            $student = StudentRecord::where('id', $student_id)
                ->where('my_parent_id', $parent->id)
                ->with('user')  // Eager load the user relationship
                ->first();

            if (!$student) {
                Log::warning('Unauthorized attendance access attempt by parent ' . $parent->id . ' for student ' . $student_id);
                return response()->json([
                    'status' => false,
                    'message' => 'Unauthorized access to student records'
                ], 403);
            }

            $attendance = StudentAttendance::where('student_id', $student_id)
                ->with(['student.user', 'class', 'section'])
                ->orderBy('date', 'desc')
                ->get();

            Log::info('Found ' . $attendance->count() . ' attendance records for student ' . $student_id);

            $formattedAttendance = $attendance->map(function ($record) {
                return [
                    'id' => $record->id,
                    'student_id' => $record->student_id,
                    'class_id' => $record->class_id,
                    'section_id' => $record->section_id,
                    'date' => $record->date,
                    'status' => ucfirst(strtolower($record->status)),
                    'time_in' => $record->time_in,
                    'time_out' => $record->time_out,
                    'remark' => $record->remark,
                    'class' => optional($record->class)->name,
                    'section' => optional($record->section)->name,
                ];
            });

            return response()->json([
                'status' => true,
                'data' => $formattedAttendance
            ]);

        } catch (\Exception $e) {
            Log::error('Error fetching attendance: ' . $e->getMessage(), ['student_id' => $student_id, 'trace' => $e->getTraceAsString()]);
            return response()->json([
                'status' => false,
                'message' => 'Failed to fetch attendance records'
            ], 500);
        }
    }

    /**
     * Get grades for a specific child
     */
    public function childGrades($student_id)
    {
        try {
            $parent = Auth::user();
            Log::info('Parent ' . $parent->id . ' requesting grades for student ' . $student_id);
            
            // Check if the student belongs to this parent
            $student = StudentRecord::where('id', $student_id)
                ->where('my_parent_id', $parent->id)
                ->with('user')
                ->first();

            if (!$student) {
                Log::warning('Unauthorized grades access attempt by parent ' . $parent->id . ' for student ' . $student_id);
                return response()->json([
                    'status' => false,
                    'message' => 'Unauthorized access to student records'
                ], 403);
            }

            $grades = Mark::where('student_id', $student->user->id)
                ->with(['subject', 'exam', 'grade'])
                ->orderBy('created_at', 'desc')
                ->get();

            Log::info('Found ' . $grades->count() . ' grade records for student ' . $student_id);

            $formattedGrades = $grades->map(function ($record) {
                // Calculate final mark
                $finalMark = $record->exm ?? 0; // Use exam mark if available
                
                // Add term marks if available
                $termMarks = array_filter([
                    $record->t1,
                    $record->t2,
                    $record->t3,
                    $record->t4
                ], function ($mark) {
                    return !is_null($mark);
                });
                
                if (!empty($termMarks)) {
                    $finalMark = array_sum($termMarks) / count($termMarks);
                }

                return [
                    'id' => $record->id,
                    'student_id' => $record->student_id,
                    'subject_id' => $record->subject_id,
                    'exam_id' => $record->exam_id,
                    'marks' => $finalMark,
                    'grade' => $record->grade ? [
                        'id' => $record->grade->id,
                        'name' => $record->grade->name,
                        'remark' => $record->grade->remark,
                        'mark_from' => $record->grade->mark_from,
                        'mark_to' => $record->grade->mark_to,
                    ] : null,
                    'subject' => $record->subject ? [
                        'id' => $record->subject->id,
                        'name' => $record->subject->name,
                        'slug' => $record->subject->slug,
                    ] : null,
                    'exam' => $record->exam ? [
                        'id' => $record->exam->id,
                        'name' => $record->exam->name,
                        'term' => $record->exam->term,
                        'year' => $record->exam->year,
                    ] : null,
                ];
            });

            return response()->json([
                'status' => true,
                'data' => $formattedGrades
            ]);

        } catch (\Exception $e) {
            Log::error('Error fetching grades: ' . $e->getMessage(), [
                'student_id' => $student_id,
                'trace' => $e->getTraceAsString()
            ]);
            return response()->json([
                'status' => false,
                'message' => 'Failed to fetch grades: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get timetable for a specific child
     */
    public function childTimetable($student_id)
    {
        try {
            $student = StudentRecord::findOrFail($student_id);
            
            // Get all timetables
            $timetables = TimeTable::join('time_table_records', 'time_tables.ttr_id', '=', 'time_table_records.id')
                ->with(['subject', 'time_slot'])
                ->select([
                    'time_tables.*',
                ])
                ->orderBy('time_tables.timestamp_from')
                ->get();

            // Map day names to numbers
            $dayMap = [
                'Monday' => 1,
                'Tuesday' => 2,
                'Wednesday' => 3,
                'Thursday' => 4,
                'Friday' => 5,
                'Saturday' => 6,
                'Sunday' => 7,
            ];

            // Add day information to timetables
            $timetables = $timetables->map(function ($timetable) use ($dayMap) {
                // If it's an exam, we don't need day/day_num
                if ($timetable->exam_date) {
                    $timetable->is_exam = true;
                    return $timetable;
                }

                // For class schedules, handle day mapping
                $timetable->is_exam = false;
                
                // If day is not set, use Monday as default
                if (!$timetable->day) {
                    $timetable->day = 'Monday';
                    $timetable->day_num = 1;
                }
                // If day_num is not set but day is, use the map
                else if (!$timetable->day_num && isset($dayMap[$timetable->day])) {
                    $timetable->day_num = $dayMap[$timetable->day];
                }
                // If day is not set but day_num is, reverse lookup the day name
                else if (!$timetable->day && $timetable->day_num) {
                    $timetable->day = array_search($timetable->day_num, $dayMap) ?? 'Monday';
                }

                // Ensure day_num is a string
                $timetable->day_num = (string)$timetable->day_num;
                return $timetable;
            });

            return response()->json([
                'status' => 'success',
                'data' => $timetables
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Could not retrieve timetable: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get payments for a specific child
     */
    public function childPayments($student_id)
    {
        try {
            $student = StudentRecord::findOrFail($student_id);
            
            // Get payment records for the student
            $paymentRecords = PaymentRecord::where('student_id', $student_id)
                ->with(['payment', 'receipts'])
                ->orderBy('created_at', 'desc')
                ->get()
                ->map(function ($record) {
                    return [
                        'id' => $record->payment->id,
                        'title' => $record->payment->title,
                        'amount' => $record->payment->amount,
                        'ref_no' => $record->payment->ref_no,
                        'method' => $record->payment->method,
                        'description' => $record->payment->description,
                        'year' => $record->payment->year,
                        'receipts' => $record->receipts->map(function ($receipt) {
                            return [
                                'id' => $receipt->id,
                                'amount_paid' => $receipt->amt_paid,
                                'balance' => $receipt->balance,
                                'year' => $receipt->year,
                                'created_at' => $receipt->created_at,
                                'updated_at' => $receipt->updated_at,
                            ];
                        }),
                        'created_at' => $record->payment->created_at,
                        'updated_at' => $record->payment->updated_at,
                    ];
                });

            return response()->json([
                'status' => true,
                'data' => $paymentRecords
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Error fetching payments: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get exams for a specific child
     */
    public function childExams($student_id)
    {
        try {
            $parent = Auth::user();
            Log::info('Parent ' . $parent->id . ' requesting exams for student ' . $student_id);
            
            // Check if the student belongs to this parent
            $student = StudentRecord::where('id', $student_id)
                ->where('my_parent_id', $parent->id)
                ->with('user')
                ->first();

            if (!$student) {
                Log::warning('Unauthorized exams access attempt by parent ' . $parent->id . ' for student ' . $student_id);
                return response()->json([
                    'status' => false,
                    'message' => 'Unauthorized access to student records'
                ], 403);
            }

            // Get all exams for the student's class
            $exams = Mark::where('student_id', $student->user->id)
                ->with('exam')
                ->get()
                ->pluck('exam')
                ->unique('id')
                ->values();

            Log::info('Found ' . $exams->count() . ' exam records for student ' . $student_id);

            $formattedExams = $exams->map(function ($exam) {
                return [
                    'id' => $exam->id,
                    'name' => $exam->name,
                    'term' => (string)$exam->term, // Convert term to string
                    'year' => $exam->year,
                ];
            });

            return response()->json([
                'status' => true,
                'data' => $formattedExams
            ]);

        } catch (\Exception $e) {
            Log::error('Error fetching exams: ' . $e->getMessage(), [
                'student_id' => $student_id,
                'trace' => $e->getTraceAsString()
            ]);
            return response()->json([
                'status' => false,
                'message' => 'Failed to fetch exams: ' . $e->getMessage()
            ], 500);
        }
    }
}
