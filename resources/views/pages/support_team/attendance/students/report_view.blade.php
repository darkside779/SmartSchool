@extends('layouts.master')
@section('page_title', 'Student Attendance Report')
@section('content')

<div class="card">
    <div class="card-header header-elements-inline">
        <h6 class="card-title">Attendance Report for {{ $my_class->name }} {{ $section->name }}</h6>
        <div class="header-elements">
            <a href="{{ route('attendance.report') }}" class="btn btn-secondary mr-2">Go Back</a>
            <a href="#" onclick="window.print(); return false;" class="btn btn-primary"><i class="icon-printer mr-2"></i> Print</a>
        </div>
    </div>
    <div class="card-body">
        <div class="row mb-3">
            <div class="col-md-6">
                <p><strong>Period:</strong> {{ date('d/m/Y', strtotime($start_date)) }} - {{ date('d/m/Y', strtotime($end_date)) }}</p>
            </div>
            <div class="col-md-6 text-right">
                <p><strong>Total Records:</strong> {{ count($attendances) }}</p>
            </div>
        </div>
        <div id="print-content">
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

            <div class="row mt-4">
                <div class="col-md-12">
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th colspan="4" class="text-center">Summary</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><strong>Present:</strong> {{ $attendances->where('status', 'present')->count() }}</td>
                                    <td><strong>Absent:</strong> {{ $attendances->where('status', 'absent')->count() }}</td>
                                    <td><strong>Late:</strong> {{ $attendances->where('status', 'late')->count() }}</td>
                                    <td><strong>Total:</strong> {{ count($attendances) }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

@endsection

@section('page_styles')
    <link href="{{ asset('global_assets/css/extras/datatables.min.css') }}" rel="stylesheet" type="text/css">
    <style media="print">
        @page {
            size: landscape;
            margin: 1cm;
        }
        
        body {
            visibility: hidden;
        }
        
        #print-content {
            visibility: visible;
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
        }
        
        .no-print, .sidebar, .navbar, .header-elements, footer, .datatable-header, .datatable-footer {
            display: none !important;
        }
        
        .card {
            border: none !important;
            box-shadow: none !important;
            margin: 0 !important;
            padding: 0 !important;
        }
        
        .card-body {
            padding: 0 !important;
        }
        
        table {
            width: 100% !important;
            margin: 0 !important;
        }
        
        table th, table td {
            padding: 5px !important;
        }
    </style>
@endsection

@section('page_scripts')
    <script src="{{ asset('global_assets/js/plugins/tables/datatables/datatables.min.js') }}"></script>
    <script src="{{ asset('global_assets/js/plugins/tables/datatables/extensions/jszip/jszip.min.js') }}"></script>
    <script src="{{ asset('global_assets/js/plugins/tables/datatables/extensions/pdfmake/pdfmake.min.js') }}"></script>
    <script src="{{ asset('global_assets/js/plugins/tables/datatables/extensions/pdfmake/vfs_fonts.min.js') }}"></script>
    <script src="{{ asset('global_assets/js/plugins/tables/datatables/extensions/buttons.min.js') }}"></script>

    <script>
        $(document).ready(function() {
            $('.datatable-button-html5-columns').DataTable({
                dom: 'Bfrtip',
                buttons: [
                    {
                        extend: 'copyHtml5',
                        text: '<i class="icon-copy3 mr-2"></i> Copy',
                        className: 'btn btn-light no-print',
                        exportOptions: {
                            columns: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
                        }
                    },
                    {
                        extend: 'excelHtml5',
                        text: '<i class="icon-file-excel mr-2"></i> Excel',
                        className: 'btn btn-light no-print',
                        exportOptions: {
                            columns: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
                        },
                        title: function() {
                            return 'Attendance Report - {{ $my_class->name }} {{ $section->name }}\n' +
                                   'Period: {{ date("d/m/Y", strtotime($start_date)) }} - {{ date("d/m/Y", strtotime($end_date)) }}';
                        },
                        customize: function(xlsx) {
                            var sheet = xlsx.xl.worksheets['sheet1.xml'];
                            
                            // Add summary at the bottom
                            var lastRow = $('row', sheet).length;
                            var summaryRow = lastRow + 2;
                            
                            // Add summary title
                            $('row:last', sheet).after('<row r="' + summaryRow + '">' +
                                '<c t="inlineStr" s="2"><is><t>Summary</t></is></c>' +
                                '</row>');
                            
                            // Add summary data
                            $('row:last', sheet).after('<row r="' + (summaryRow + 1) + '">' +
                                '<c t="inlineStr"><is><t>Present: {{ $attendances->where("status", "present")->count() }}</t></is></c>' +
                                '<c t="inlineStr"><is><t>Absent: {{ $attendances->where("status", "absent")->count() }}</t></is></c>' +
                                '<c t="inlineStr"><is><t>Late: {{ $attendances->where("status", "late")->count() }}</t></is></c>' +
                                '<c t="inlineStr"><is><t>Total: {{ count($attendances) }}</t></is></c>' +
                                '</row>');
                        }
                    },
                    {
                        extend: 'pdfHtml5',
                        text: '<i class="icon-file-pdf mr-2"></i> PDF',
                        className: 'btn btn-light no-print',
                        exportOptions: {
                            columns: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
                        },
                        title: 'Attendance Report - {{ $my_class->name }} {{ $section->name }}\n' +
                               'Period: {{ date("d/m/Y", strtotime($start_date)) }} - {{ date("d/m/Y", strtotime($end_date)) }}',
                        customize: function(doc) {
                            // Add summary at the bottom
                            doc.content.push({
                                text: '\nSummary',
                                style: 'subheader',
                                margin: [0, 10, 0, 5]
                            });
                            doc.content.push({
                                columns: [
                                    { text: 'Present: {{ $attendances->where("status", "present")->count() }}', width: 'auto' },
                                    { text: 'Absent: {{ $attendances->where("status", "absent")->count() }}', width: 'auto' },
                                    { text: 'Late: {{ $attendances->where("status", "late")->count() }}', width: 'auto' },
                                    { text: 'Total: {{ count($attendances) }}', width: 'auto' }
                                ],
                                columnGap: 20,
                                margin: [0, 0, 0, 20]
                            });
                        }
                    }
                ]
            });
        });
    </script>
@endsection
