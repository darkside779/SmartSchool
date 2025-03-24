@extends('layouts.master')
@section('page_title', 'Children Timetables')
@section('content')

<div class="card">
    <div class="card-header header-elements-inline">
        <h6 class="card-title">My Children's Timetables</h6>
    </div>

    <div class="card-body">
        <div class="row">
            @foreach($children as $child)
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="mr-3">
                                    <img class="rounded-circle" style="width: 50px; height: 50px;" src="{{ $child->user->photo }}" alt="Student Photo">
                                </div>
                                <div>
                                    <h5 class="card-title mb-0">{{ $child->user->name }}</h5>
                                    <p class="card-text text-muted">
                                        Class: {{ $child->my_class->name }} - 
                                        Section: {{ $child->section->name }}
                                    </p>
                                </div>
                            </div>
                            <div class="mt-3">
                                <a href="{{ route('timetables.child.show', $child->id) }}" class="btn btn-primary">
                                    <i class="icon-calendar mr-2"></i>
                                    View Timetable
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            @endforeach
        </div>
    </div>
</div>

@endsection
