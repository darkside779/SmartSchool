<?php

namespace App\Http\Controllers\SupportTeam;

use App\Helpers\Qs;
use App\Http\Controllers\Controller;
use App\Models\StudentAttendance;
use App\Models\TeacherAttendance;
use App\Models\StudentRecord;
use App\Models\StaffRecord;
use App\Models\MyClass;
use App\Models\Section;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Maatwebsite\Excel\Facades\Excel;

class AttendanceController extends Controller
{
    public function studentIndex()
    {
        $d['my_classes'] = MyClass::orderBy('name')->get();
        return view('pages.support_team.attendance.students.index', $d);
    }

    public function teacherIndex()
    {
        $d['teachers'] = StaffRecord::with('user')
            ->whereHas('user', function($query) {
                $query->where('user_type', 'teacher');
            })
            ->join('users', 'staff_records.user_id', '=', 'users.id')
            ->orderBy('users.name')
            ->select('staff_records.*')
            ->get();
        return view('pages.support_team.attendance.teachers.index', $d);
    }

    public function studentManage($class_id, $section_id, $date)
    {
        $d['my_class'] = MyClass::find($class_id);
        $d['section'] = Section::find($section_id);
        $d['students'] = StudentRecord::where(['my_class_id' => $class_id, 'section_id' => $section_id])->get();
        $d['date'] = $date;
        $d['attendances'] = StudentAttendance::where(['class_id' => $class_id, 'section_id' => $section_id, 'date' => $date])->get();

        return view('pages.support_team.attendance.students.manage', $d);
    }

    public function teacherManage($date)
    {
        $d['date'] = $date;
        $d['teachers'] = StaffRecord::with('user')
            ->whereHas('user', function($query) {
                $query->where('user_type', 'teacher');
            })
            ->join('users', 'staff_records.user_id', '=', 'users.id')
            ->orderBy('users.name')
            ->select('staff_records.*')
            ->get();
        $d['attendances'] = TeacherAttendance::where('date', $date)->get();

        return view('pages.support_team.attendance.teachers.manage', $d);
    }

    public function studentStore(Request $req)
    {
        $data = $req->validate([
            'student_id' => 'required|array',
            'class_id' => 'required',
            'section_id' => 'required',
            'date' => 'required|date',
            'status' => 'required|array',
            'time_in' => 'required|array',
            'time_out' => 'nullable|array',
            'remark' => 'nullable|array',
        ]);

        foreach($data['student_id'] as $k => $student_id) {
            StudentAttendance::updateOrCreate(
                [
                    'student_id' => $student_id,
                    'class_id' => $data['class_id'],
                    'section_id' => $data['section_id'],
                    'date' => $data['date'],
                ],
                [
                    'status' => $data['status'][$k],
                    'time_in' => $data['time_in'][$k],
                    'time_out' => $data['time_out'][$k] ?? null,
                    'remark' => $data['remark'][$k] ?? null,
                    'created_by' => Auth::user()->id,
                ]
            );
        }

        return back()->with('flash_success', __('msg.update_ok'));
    }

    public function teacherStore(Request $req)
    {
        $data = $req->validate([
            'teacher_id' => 'required|array',
            'date' => 'required|date',
            'status' => 'required|array',
            'time_in' => 'required|array',
            'time_out' => 'required|array',
            'remark' => 'nullable|array',
        ]);

        foreach($data['teacher_id'] as $k => $teacher_id) {
            TeacherAttendance::updateOrCreate(
                [
                    'teacher_id' => $teacher_id,
                    'date' => $data['date'],
                ],
                [
                    'status' => $data['status'][$k],
                    'time_in' => $data['time_in'][$k],
                    'time_out' => $data['time_out'][$k],
                    'remark' => $data['remark'][$k] ?? null,
                    'created_by' => Auth::user()->id,
                ]
            );
        }

        return back()->with('flash_success', __('msg.update_ok'));
    }

    public function studentReport()
    {
        $d['my_classes'] = MyClass::orderBy('name')->get();
        return view('pages.support_team.attendance.students.report', $d);
    }

    public function teacherReport()
    {
        return view('pages.support_team.attendance.teachers.report');
    }

    public function teacherReportGenerate(Request $request)
    {
        $data = $request->validate([
            'start_date' => 'required|date',
            'end_date' => 'required|date|after_or_equal:start_date',
        ]);

        $d['teachers'] = StaffRecord::with('user')
            ->whereHas('user', function($query) {
                $query->where('user_type', 'teacher');
            })
            ->join('users', 'staff_records.user_id', '=', 'users.id')
            ->orderBy('users.name')
            ->select('staff_records.*')
            ->get();
        $d['start_date'] = $data['start_date'];
        $d['end_date'] = $data['end_date'];
        $d['attendances'] = TeacherAttendance::whereBetween('date', [$data['start_date'], $data['end_date']])->get();

        return view('pages.support_team.attendance.teachers.report_view', $d);
    }

    public function teacherDownload($start_date, $end_date)
    {
        $teachers = StaffRecord::with('user')
            ->whereHas('user', function($query) {
                $query->where('user_type', 'teacher');
            })
            ->join('users', 'staff_records.user_id', '=', 'users.id')
            ->orderBy('users.name')
            ->select('staff_records.*')
            ->get();
            
        $attendances = TeacherAttendance::whereBetween('date', [$start_date, $end_date])->get();

        return Excel::download(new TeacherAttendanceExport($teachers, $attendances, $start_date, $end_date), 'teacher_attendance_report.xlsx');
    }

    public function studentPrint($class_id, $section_id, $date)
    {
        $data['my_class'] = $my_class = MyClass::find($class_id);
        $data['section'] = $section = Section::find($section_id);
        $data['students'] = $students = StudentRecord::where(['my_class_id' => $class_id, 'section_id' => $section_id])->get();
        $data['attendances'] = StudentAttendance::where(['class_id' => $class_id, 'section_id' => $section_id, 'date' => $date])->get();
        $data['date'] = $date;
        $data['s'] = Setting::all()->flatMap(function($s){
            return [$s->type => $s->description];
        });

        return view('pages.support_team.attendance.students.print', $data);
    }

    public function studentDownload($class_id, $section_id, $start_date, $end_date)
    {
        $my_class = MyClass::find($class_id);
        $section = Section::find($section_id);
        $students = StudentRecord::where(['my_class_id' => $class_id, 'section_id' => $section_id])->get();
        $attendances = StudentAttendance::where([
            'class_id' => $class_id, 
            'section_id' => $section_id
        ])
        ->whereBetween('date', [$start_date, $end_date])
        ->orderBy('date', 'asc')
        ->get();

        return Excel::download(new AttendanceExport($my_class, $section, $students, $attendances, $start_date, $end_date), 'attendance_report.xlsx');
    }

    public function showReport(Request $request)
    {
        $d['my_classes'] = MyClass::orderBy('name')->get();
        return view('pages.support_team.attendance.students.report', $d);
    }

    public function generateReport(Request $request)
    {
        $data = $request->validate([
            'class_id' => 'required',
            'section_id' => 'required',
            'start_date' => 'required|date',
            'end_date' => 'required|date|after_or_equal:start_date',
        ]);

        $d['my_class'] = MyClass::find($data['class_id']);
        $d['section'] = Section::find($data['section_id']);
        $d['students'] = StudentRecord::where([
            'my_class_id' => $data['class_id'], 
            'section_id' => $data['section_id']
        ])->get();
        
        $d['attendances'] = StudentAttendance::where([
            'class_id' => $data['class_id'], 
            'section_id' => $data['section_id']
        ])
        ->whereBetween('date', [$data['start_date'], $data['end_date']])
        ->orderBy('date', 'asc')
        ->get();

        $d['start_date'] = $data['start_date'];
        $d['end_date'] = $data['end_date'];

        return view('pages.support_team.attendance.students.report_view', $d);
    }

    public function studentEdit($attendance_id)
    {
        $attendance = StudentAttendance::with(['student.user', 'class', 'section'])->findOrFail($attendance_id);
        return view('pages.support_team.attendance.students.edit', compact('attendance'));
    }

    public function studentUpdate(Request $request, $attendance_id)
    {
        $attendance = StudentAttendance::findOrFail($attendance_id);
        
        $data = $request->validate([
            'status' => 'required|in:present,absent,late',
            'time_in' => 'required',
            'time_out' => 'nullable',
            'remark' => 'nullable',
        ]);

        $attendance->update([
            'status' => $data['status'],
            'time_in' => $data['time_in'],
            'time_out' => $data['time_out'],
            'remark' => $data['remark'],
            'updated_by' => Auth::user()->id,
        ]);

        return redirect()->route('attendance.student.manage', [
            'class_id' => $attendance->class_id,
            'section_id' => $attendance->section_id,
            'date' => $attendance->date
        ])->with('flash_success', __('msg.update_ok'));
    }

    public function teacherEdit($attendance_id)
    {
        $attendance = TeacherAttendance::with(['teacher.user'])->findOrFail($attendance_id);
        return view('pages.support_team.attendance.teachers.edit', compact('attendance'));
    }

    public function teacherUpdate(Request $request, $attendance_id)
    {
        $attendance = TeacherAttendance::findOrFail($attendance_id);
        
        $data = $request->validate([
            'status' => 'required|in:present,absent,late',
            'time_in' => 'required',
            'time_out' => 'nullable',
            'remark' => 'nullable',
        ]);

        $attendance->update([
            'status' => $data['status'],
            'time_in' => $data['time_in'],
            'time_out' => $data['time_out'],
            'remark' => $data['remark'],
            'updated_by' => Auth::user()->id,
        ]);

        return redirect()->route('attendance.teacher.manage', [
            'date' => $attendance->date
        ])->with('flash_success', __('msg.update_ok'));
    }

    public function childrenAttendance()
    {
        if (!Qs::userIsParent()) {
            return redirect()->route('dashboard')->with('pop_error', 'Access Denied');
        }

        $parent_id = Auth::user()->id;
        $children = StudentRecord::whereHas('user', function($query) use ($parent_id) {
            $query->where('my_parent_id', $parent_id);
        })->with(['my_class', 'section', 'user'])->get();

        return view('pages.support_team.attendance.parent.children_attendance', ['children' => $children]);
    }

    public function childAttendanceShow($student_id)
    {
        if (!Qs::userIsParent()) {
            return redirect()->route('dashboard')->with('pop_error', 'Access Denied');
        }

        $parent_id = Auth::user()->id;
        $student = StudentRecord::with(['user', 'my_class', 'section'])
            ->whereHas('user', function($query) use ($parent_id) {
                $query->where('my_parent_id', $parent_id);
            })
            ->findOrFail($student_id);

        // Get all attendance records for this student
        $attendances = StudentAttendance::where('student_id', $student_id)
            ->orderBy('date', 'desc')
            ->get();

        // Calculate statistics
        $total_days = $attendances->count();
        $present_days = $attendances->where('status', 'present')->count();
        $absent_days = $attendances->where('status', 'absent')->count();
        $late_days = $attendances->where('status', 'late')->count();
        
        // Calculate attendance percentage
        $attendance_percentage = $total_days > 0 
            ? round((($present_days + $late_days) / $total_days) * 100, 1) 
            : 0;

        return view('pages.support_team.attendance.parent.child_attendance', compact(
            'student',
            'attendances',
            'total_days',
            'present_days',
            'absent_days',
            'attendance_percentage'
        ));
    }
}
