@extends('layouts.master')
@section('page_title', 'Manage Teacher Attendance')
@section('content')

<div class="card">
    <div class="card-header header-elements-inline">
        <h6 class="card-title">Teacher Attendance for {{ $date }}</h6>
        <!-- <div class="header-elements">
            <button type="button" onclick="makeAllPresent()" class="btn btn-success">Make All Present</button>
        </div> -->
    </div>

    <div class="card-body">
        <form method="post" action="{{ route('attendance.teacher.save') }}">
            @csrf
            <input type="hidden" name="date" value="{{ $date }}">

            <div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>S/N</th>
                            <th>Name</th>
                            <th>Staff ID</th>
                            <th>Status</th>
                            <th>Time In</th>
                            <th>Time Out</th>
                            <!-- <th>Remark</th> -->
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($teachers as $k => $teacher)
                            @php
                                $attendance = $attendances->where('teacher_id', $teacher->id)->first();
                            @endphp
                            <tr>
                                <td>{{ $k + 1 }}</td>
                                <td>{{ $teacher->user->name }}</td>
                                <td>{{ $teacher->code }}</td>
                                <td>
                                    <input type="hidden" name="teacher_id[]" value="{{ $teacher->id }}">
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
                                    <input type="time" name="time_out[]" class="form-control" value="{{ $attendance ? $attendance->time_out : '14:00' }}"required>
                                </td>
                                <!-- <td>
                                    <input type="text" name="remark[]" class="form-control" value="{{ $attendance ? $attendance->remark : '' }}">
                                </td> -->
                                <td>
                                    @if($attendance)
                                        <a href="{{ route('attendance.teacher.edit', $attendance->id) }}" class="btn btn-sm btn-info">Edit</a>
                                    @endif
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>

            <div class="text-center mt-3">
                <button type="submit" class="btn btn-primary">Save Attendance</button>
            </div>
        </form>
    </div>
</div>

@endsection

@section('page_scripts')
<script>
    function makeAllPresent() {
        $('select[name="status[]"]').val('present');
    }
</script>
@endsection
