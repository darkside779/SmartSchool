@extends('layouts.master')
@section('page_title', 'Student Timetable')
@section('content')

<div class="card">
    <div class="card-header header-elements-inline">
        <h6 class="card-title">
            Timetable for {{ $student->user->name }}
            <br>
            <small class="text-muted">Class: {{ $student->my_class->name }} - Section: {{ $student->section->name }}</small>
        </h6>
        <div class="header-elements">
            <a href="{{ route('timetables.children') }}" class="btn btn-secondary">Go Back</a>
        </div>
    </div>

    <div class="card-body">
        @if($tt_records->count() > 0)
            @foreach($tt_records as $ttr)
                <div class="card mb-3">
                    <div class="card-header header-elements-inline">
                        <h6 class="card-title">
                            {{ $ttr->name }}
                            @if($ttr->exam_id)
                                <span class="ml-2 badge badge-info">Exam Timetable</span>
                            @endif
                        </h6>
                        <div class="header-elements">
                            <a href="{{ route('ttr.show', $ttr->id) }}" class="btn btn-info">View Detailed Timetable</a>
                            <a href="{{ route('ttr.print', $ttr->id) }}" target="_blank" class="btn btn-primary ml-2">Print</a>
                        </div>
                    </div>
                </div>
            @endforeach
        @else
            <div class="alert alert-info">No timetable records available for this class.</div>
        @endif
    </div>
</div>

@endsection
