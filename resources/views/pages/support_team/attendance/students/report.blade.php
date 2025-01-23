@extends('layouts.master')
@section('page_title', 'Student Attendance Report')
@section('content')

<div class="card">
    <div class="card-header header-elements-inline">

    <div class="card-body">
        <form method="post" action="{{ route('attendance.report.generate') }}" id="attendance-form">
            @csrf
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group">
                        <label for="class_id">Class:</label>
                        <select class="form-control select" name="class_id" id="class_id" required>
                            <option value="">Select Class</option>
                            @foreach($my_classes as $class)
                                <option value="{{ $class->id }}">{{ $class->name }}</option>
                            @endforeach
                        </select>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="form-group">
                        <label for="section_id">Section:</label>
                        <select class="form-control select" name="section_id" id="section_id" required>
                            <option value="">Select Section</option>
                        </select>
                    </div>
                </div>

                <div class="col-md-2">
                    <div class="form-group">
                        <label for="start_date">Start Date:</label>
                        <input type="date" name="start_date" id="start_date" class="form-control" required>
                    </div>
                </div>

                <div class="col-md-2">
                    <div class="form-group">
                        <label for="end_date">End Date:</label>
                        <input type="date" name="end_date" id="end_date" class="form-control" required>
                    </div>
                </div>

                <div class="col-md-2 mt-4">
                    <button type="submit" class="btn btn-primary">Generate Report</button>
                </div>
            </div>
        </form>
    </div>
</div>

@if(isset($attendances))
<div class="card">
    <div class="card-header header-elements-inline">
        <h6 class="card-title">Attendance Report for {{ $my_class->name }} {{ $section->name }}</h6>
    </div>
    <div class="card-body">
        <table class="table datatable-button-html5-columns">
            <thead>
                <tr>
                    <th>S/N</th>
                    <th>Name</th>
                    <th>Admission No</th>
                    <th>Status</th>
                    <th>Time In</th>
                    <th>Time Out</th>
                    <th>Date</th>
                    <th>Remark</th>
                </tr>
            </thead>
            <tbody>
                @foreach($attendances as $k => $attendance)
                <tr>
                    <td>{{ $k + 1 }}</td>
                    <td>{{ $attendance->student->user->name }}</td>
                    <td>{{ $attendance->student->adm_no }}</td>
                    <td>{{ ucfirst($attendance->status) }}</td>
                    <td>{{ date('h:i A', strtotime($attendance->time_in)) }}</td>
                    <td>{{ $attendance->time_out ? date('h:i A', strtotime($attendance->time_out)) : 'N/A' }}</td>
                    <td>{{ date('d/m/Y', strtotime($attendance->date)) }}</td>
                    <td>{{ $attendance->remark }}</td>
                </tr>
                @endforeach
            </tbody>
        </table>
    </div>
</div>
@endif

@endsection

@section('page_scripts')
<script>
    function generateExcel() {
        var class_id = $('#class_id').val();
        var section_id = $('#section_id').val();
        var start_date = $('#start_date').val();
        var end_date = $('#end_date').val();

        if(!class_id || !section_id || !start_date || !end_date) {
            alert('Please select all fields first');
            return;
        }

        var url = '{{ route("attendance.student.download", [":class_id", ":section_id", ":start_date", ":end_date"]) }}';
        url = url.replace(':class_id', class_id)
                 .replace(':section_id', section_id)
                 .replace(':start_date', start_date)
                 .replace(':end_date', end_date);

        window.location.href = url;
    }
</script>
@endsection
