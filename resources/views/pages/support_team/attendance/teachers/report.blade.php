@extends('layouts.master')
@section('page_title', 'Teacher Attendance Report')
@section('content')

<div class="card">
    <div class="card-header header-elements-inline">
        <h6 class="card-title">Generate Teacher Attendance Report</h6>
    </div>

    <div class="card-body">
        <form method="post" action="{{ route('attendance.teacher.report.generate') }}">
            @csrf
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="start_date">Start Date:</label>
                        <input type="date" name="start_date" id="start_date" class="form-control" required>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="form-group">
                        <label for="end_date">End Date:</label>
                        <input type="date" name="end_date" id="end_date" class="form-control" required>
                    </div>
                </div>

                <div class="col-md-4 mt-4">
                    <button type="submit" class="btn btn-primary">Generate Report</button>
                </div>
            </div>
        </form>
    </div>
</div>

@endsection

@section('page_scripts')
<script>
    $(document).ready(function() {
        // Validate date range
        $('#end_date').change(function() {
            let start_date = new Date($('#start_date').val());
            let end_date = new Date($(this).val());
            
            if(end_date < start_date) {
                alert('End date cannot be before start date');
                $(this).val('');
            }
        });
    });
</script>
@endsection
