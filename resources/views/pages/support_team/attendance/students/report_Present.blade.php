@extends('layouts.master')
@section('page_title', 'Student Attendance Report')
@section('content')

<div class="card">
    <div class="card-header header-elements-inline">
        <h6 class="card-title">
            Student Attendance Report for {{ $my_class->name }} - {{ $section->name }}
            <br>
            <small class="text-muted">Period: {{ $start_date }} to {{ $end_date }}</small>
        </h6>
        <div class="header-elements">
            <button onclick="window.print()" class="btn btn-primary">Print Report</button>
        </div>
    </div>

    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th rowspan="2">S/N</th>
                        <th rowspan="2">Name</th>
                        <th rowspan="2">Admission No</th>
                        <th colspan="3" class="text-center">Attendance Summary</th>
                        <th rowspan="2">Total Days</th>
                        <th rowspan="2">Present %</th>
                    </tr>
                    <tr>
                        <th>Present</th>
                        <th>Absent</th>
                        <th>Late</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($students as $k => $student)
                        @php
                            $total_days = 0;
                            $present_count = 0;
                            $absent_count = 0;
                            $late_count = 0;
                            
                            $student_attendance = $attendances->where('student_id', $student->id);
                            foreach($student_attendance as $attendance) {
                                $total_days++;
                                switch($attendance->status) {
                                    case 'present':
                                        $present_count++;
                                        break;
                                    case 'absent':
                                        $absent_count++;
                                        break;
                                    case 'late':
                                        $late_count++;
                                        break;
                                }
                            }
                            
                            $present_percentage = $total_days > 0 ? round(($present_count / $total_days) * 100, 2) : 0;
                        @endphp
                        <tr>
                            <td>{{ $k + 1 }}</td>
                            <td>{{ $student->user->name }}</td>
                            <td>{{ $student->adm_no }}</td>
                            <td class="text-center">{{ $present_count }}</td>
                            <td class="text-center">{{ $absent_count }}</td>
                            <td class="text-center">{{ $late_count }}</td>
                            <td class="text-center">{{ $total_days }}</td>
                            <td class="text-center">{{ $present_percentage }}%</td>
                        </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    </div>
</div>

@endsection

@section('page_styles')
<style type="text/css" media="print">
    @media print {
        .sidebar, .navbar, .header-elements, footer {
            display: none !important;
        }
        .content-wrapper {
            padding: 0 !important;
        }
        .card {
            box-shadow: none !important;
        }
    }
</style>
@endsection
