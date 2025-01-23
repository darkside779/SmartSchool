@extends('layouts.master')
@section('page_title', 'Teacher Attendance')
@section('content')

<div class="card">
    <div class="card-header header-elements-inline">
        <h6 class="card-title">Manage Teacher Attendance</h6>
    </div>

    <div class="card-body">
        <form method="get" action="{{ route('attendance.teacher.manage', ['date' => date('Y-m-d')]) }}" id="attendance-form">
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="date">Date:</label>
                        <input type="date" name="date" id="date" class="form-control" value="{{ date('Y-m-d') }}" required>
                    </div>
                </div>

                <div class="col-md-2 mt-4">
                    <button type="submit" class="btn btn-primary">Manage Attendance</button>
                </div>
            </div>
        </form>
    </div>
</div>

@endsection

@section('page_scripts')
<script>
    $(document).ready(function() {
        $('#attendance-form').on('submit', function(e) {
            e.preventDefault();
            var date = $('#date').val();
            var url = "{{ route('attendance.teacher.manage', ':date') }}";
            url = url.replace(':date', date);
            window.location.href = url;
        });
    });
</script>
@endsection
