@extends('layouts.master')
@section('page_title', 'Child Attendance Details')
@section('content')

<div class="card">
    <div class="card-header header-elements-inline">
        <h6 class="card-title">
            Attendance Record for {{ $student->user->name }}
            <br>
            <small class="text-muted">Class: {{ $student->my_class->name }} - Section: {{ $student->section->name }}</small>
        </h6>
        <div class="header-elements">
            <a href="{{ route('attendance.children') }}" class="btn btn-secondary">Go Back</a>
        </div>
    </div>

    <div class="card-body">
        <div class="row mb-3">
            <div class="col-md-3">
                <div class="card bg-primary text-white">
                    <div class="card-body text-center">
                        <h3 class="mb-0">{{ $total_days }}</h3>
                        <p class="mb-0">Total Days</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body text-center">
                        <h3 class="mb-0">{{ $present_days }}</h3>
                        <p class="mb-0">Present Days</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-danger text-white">
                    <div class="card-body text-center">
                        <h3 class="mb-0">{{ $absent_days }}</h3>
                        <p class="mb-0">Absent Days</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-info text-white">
                    <div class="card-body text-center">
                        <h3 class="mb-0">{{ $attendance_percentage }}%</h3>
                        <p class="mb-0">Attendance Rate</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table table-bordered datatable-button-html5-columns">
                <thead>
                    <tr>
                        <th>S/N</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Time In</th>
                        <th>Time Out</th>
                        <th>Remark</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($attendances as $k => $attendance)
                        <tr>
                            <td>{{ $k + 1 }}</td>
                            <td>{{ date('d/m/Y', strtotime($attendance->date)) }}</td>
                            <td>
                                @if($attendance->status == 'present')
                                    <span class="badge badge-success">Present</span>
                                @elseif($attendance->status == 'absent')
                                    <span class="badge badge-danger">Absent</span>
                                @else
                                    <span class="badge badge-warning">Late</span>
                                @endif
                            </td>
                            <td>{{ $attendance->time_in ? date('h:i A', strtotime($attendance->time_in)) : 'N/A' }}</td>
                            <td>{{ $attendance->time_out ? date('h:i A', strtotime($attendance->time_out)) : 'N/A' }}</td>
                            <td>{{ $attendance->remark ?: 'N/A' }}</td>
                        </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    </div>
</div>

@endsection

@section('page_scripts')
<script src="{{ asset('global_assets/js/plugins/tables/datatables/datatables.min.js') }}"></script>
<script src="{{ asset('global_assets/js/plugins/tables/datatables/extensions/buttons.min.js') }}"></script>
<script src="{{ asset('global_assets/js/plugins/tables/datatables/extensions/html5/html5.min.js') }}"></script>
<script src="{{ asset('global_assets/js/plugins/tables/datatables/extensions/print.min.js') }}"></script>
<script>
    $('.datatable-button-html5-columns').DataTable({
        dom: 'Bfrtip',
        buttons: {
            buttons: [
                {
                    extend: 'copyHtml5',
                    className: 'btn btn-light',
                    exportOptions: {
                        columns: [ 0, ':visible' ]
                    }
                },
                {
                    extend: 'excelHtml5',
                    className: 'btn btn-light',
                    exportOptions: {
                        columns: ':visible'
                    }
                },
                {
                    extend: 'pdfHtml5',
                    className: 'btn btn-light',
                    exportOptions: {
                        columns: [ 0, 1, 2, 3, 4, 5 ]
                    }
                },
                {
                    extend: 'print',
                    className: 'btn btn-light',
                    exportOptions: {
                        columns: ':visible'
                    }
                }
            ]
        }
    });
</script>
@endsection
