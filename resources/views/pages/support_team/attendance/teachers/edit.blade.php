@extends('layouts.master')
@section('page_title', 'Edit Teacher Attendance')
@section('content')

<div class="card">
    <div class="card-header header-elements-inline">
        <h6 class="card-title">Edit Attendance for {{ $attendance->teacher->user->name }}</h6>
        <div class="header-elements">
            <a href="{{ route('attendance.teacher.manage', ['date' => $attendance->date]) }}" class="btn btn-secondary">Go Back</a>
        </div>
    </div>

    <div class="card-body">
        <form method="post" action="{{ route('attendance.teacher.update', $attendance->id) }}">
            @csrf
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label>Teacher Name:</label>
                        <input type="text" class="form-control" value="{{ $attendance->teacher->user->name }}" readonly>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label>Staff ID:</label>
                        <input type="text" class="form-control" value="{{ $attendance->teacher->code }}" readonly>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label>Date:</label>
                        <input type="text" class="form-control" value="{{ date('d/m/Y', strtotime($attendance->date)) }}" readonly>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="status">Status:</label>
                        <select name="status" id="status" class="form-control" required>
                            <option value="present" {{ $attendance->status == 'present' ? 'selected' : '' }}>Present</option>
                            <option value="absent" {{ $attendance->status == 'absent' ? 'selected' : '' }}>Absent</option>
                            <option value="late" {{ $attendance->status == 'late' ? 'selected' : '' }}>Late</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="remark">Remark:</label>
                        <input type="text" name="remark" id="remark" class="form-control" value="{{ $attendance->remark }}">
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="time_in">Time In:</label>
                        <input type="time" name="time_in" id="time_in" class="form-control" value="{{ $attendance->time_in }}" required>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="time_out">Time Out:</label>
                        <input type="time" name="time_out" id="time_out" class="form-control" value="{{ $attendance->time_out }}">
                    </div>
                </div>
            </div>

            <div class="text-right mt-3">
                <button type="submit" class="btn btn-primary">Update Attendance <i class="icon-paperplane ml-2"></i></button>
            </div>
        </form>
    </div>
</div>

@endsection
