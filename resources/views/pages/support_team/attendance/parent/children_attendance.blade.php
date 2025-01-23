@extends('layouts.master')
@section('page_title', 'Children Attendance')
@section('content')

<div class="card">
    <div class="card-header header-elements-inline">
        <h6 class="card-title">My Children's Attendance</h6>
    </div>

    <div class="card-body">
        @if($children->count() > 0)
            <div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>S/N</th>
                            <th>Name</th>
                            <th>Admission No</th>
                            <th>Class</th>
                            <th>Section</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($children as $k => $child)
                            <tr>
                                <td>{{ $k + 1 }}</td>
                                <td>{{ $child->user->name }}</td>
                                <td>{{ $child->adm_no }}</td>
                                <td>{{ $child->my_class->name }}</td>
                                <td>{{ $child->section->name }}</td>
                                <td>
                                    <a href="{{ route('attendance.child.show', $child->id) }}" class="btn btn-info btn-sm">
                                        View Attendance
                                    </a>
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        @else
            <div class="alert alert-info">
                No children found.
            </div>
        @endif
    </div>
</div>

@endsection
