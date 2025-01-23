@extends('layouts.master')
@section('page_title', __('attendance.student_attendance'))
@section('content')

<div class="card">
    <div class="card-header header-elements-inline">
        <h6 class="card-title">{{ __('attendance.manage_attendance') }}</h6>
    </div>

    <div class="card-body">
        <div class="row">
            <div class="col-md-3">
                <div class="form-group">
                    <label for="class_id">{{ __('attendance.class') }}:</label>
                    <select class="form-control select" id="class_id" required onchange="getClassSections(this.value)">
                        <option value="">{{ __('attendance.select_class') }}</option>
                        @foreach($my_classes as $class)
                            <option value="{{ $class->id }}">{{ $class->name }}</option>
                        @endforeach
                    </select>
                </div>
            </div>

            <div class="col-md-3">
                <div class="form-group">
                    <label for="section_id">{{ __('attendance.section') }}:</label>
                    <select class="form-control select" id="section_id" required>
                        <option value="">{{ __('attendance.select_section') }}</option>
                    </select>
                </div>
            </div>

            <div class="col-md-3">
                <div class="form-group">
                    <label for="date">{{ __('attendance.date') }}:</label>
                    <input type="date" id="date" class="form-control" value="{{ date('Y-m-d') }}" required>
                </div>
            </div>

            <div class="col-md-3 mt-4">
                <button type="button" onclick="manageAttendance()" class="btn btn-primary">{{ __('attendance.manage_btn') }}</button>
            </div>
        </div>
    </div>
</div>

@endsection
