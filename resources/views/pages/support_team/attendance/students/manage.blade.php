@extends('layouts.master')
@section('page_title', 'Manage Student Attendance')
@section('content')

<div class="card">
    <div class="card-header header-elements-inline">
        <h6 class="card-title">Student Attendance for {{ $my_class->name }} - {{ $section->name }} ({{ $date }})</h6>
        <!-- <div class="header-elements">
            <button type="button" onclick="makeAllPresent()" class="btn btn-success ml-2">Make All Present</button>
        </div> -->
    </div>

    <div class="card-body">
        <form method="post" action="{{ route('attendance.student.save') }}">
            @csrf
            <input type="hidden" name="class_id" value="{{ $my_class->id }}">
            <input type="hidden" name="section_id" value="{{ $section->id }}">
            <input type="hidden" name="date" value="{{ $date }}">

            <div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>S/N</th>
                            <th>Name</th>
                            <th>Admission No</th>
                            <th>Status</th>
                            <th>Time In</th>
                            <th>Time Out</th>
                            <!-- <th>Remark</th> -->
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($students as $k => $student)
                            @php
                                $attendance = $attendances->where('student_id', $student->id)->first();
                            @endphp
                            <tr>
                                <td>{{ $k + 1 }}</td>
                                <td>{{ $student->user->name }}</td>
                                <td>{{ $student->adm_no }}</td>
                                <td>
                                    <input type="hidden" name="student_id[]" value="{{ $student->id }}">
                                    <select name="status[]" class="form-control" required>
                                        <option value="present" {{ $attendance && $attendance->status == 'present' ? 'selected' : '' }}>Present</option>
                                        <option value="absent" {{ $attendance && $attendance->status == 'absent' ? 'selected' : '' }}>Absent</option>
                                        <option value="late" {{ $attendance && $attendance->status == 'late' ? 'selected' : '' }}>Late</option>
                                    </select>
                                </td>
                                <td>
                                    <input type="time" name="time_in[]" class="form-control" value="{{ $attendance ? $attendance->time_in : '07:00' }}" required>
                                </td>
                                <td>
                                    <input type="time" name="time_out[]" class="form-control" value="{{ $attendance ? $attendance->time_out : '14:00' }}">
                                </td>
                                <!-- <td>
                                    <input type="text" name="remark[]" class="form-control" value="{{ $attendance ? $attendance->remark : '' }}">
                                </td> -->
                                <td>
                                    @if($attendance)
                                        <a href="{{ route('attendance.student.edit', $attendance->id) }}" class="btn btn-sm btn-info">Edit</a>
                                    @endif
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>

            <div class="text-right mt-3">
                <button type="submit" class="btn btn-primary">Save Attendance <i class="icon-paperplane ml-2"></i></button>
            </div>
        </form>
    </div>
</div>

@endsection
