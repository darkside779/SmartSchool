<html>
<head>
    <title>Attendance Report - {{ $my_class->name.' - '.$section->name }}</title>
    <style>
        @media print {
            td, th {
                padding: 15px 5px;
                text-align: center;
                font-size: 14px;
            }

            @page {
                size: landscape;
                margin: 0;
            }

            html {
                background-color: #FFFFFF;
                margin: 0;
            }

            body {
                margin: 0 10mm;
            }

            .present { color: #28a745; }
            .absent { color: #dc3545; }
            .late { color: #ffc107; }
        }

        td {
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <div id="print">
        {{-- School Details --}}
        <table width="100%">
            <tr>
                <td>
                    <strong><span style="color: #1b0c80; font-size: 25px;">{{ strtoupper(config('app.name')) }}</span></strong><br/>
                    <strong><span style="color: #000; font-size: 15px;"><i>{{ ucwords($s['address']) }}</i></span></strong><br/>
                    <strong><span style="color: #000; text-decoration: underline; font-size: 15px;"><i>{{ config('app.url') }}</i></span></strong>
                    <br /> <br />
                    <strong><span style="color: #000; font-size: 15px;">
                        ATTENDANCE REPORT FOR {{ strtoupper($my_class->name.' '.$section->name) }}
                        ({{ $date }})
                    </span></strong>
                </td>
            </tr>
        </table>

        {{-- Background Logo --}}
        <div style="position: relative; text-align: center;">
            <img src="{{ $s['logo'] }}"
                 style="max-width: 500px; max-height:600px; margin-top: 60px; position:absolute; opacity: 0.2; margin-left: auto; margin-right: auto; left: 0; right: 0;" />
        </div>

        {{-- Attendance Table --}}
        <table cellpadding="20" style="width:100%; border-collapse:collapse; border: 1px solid #000; margin: 10px auto;" border="1">
            <thead>
                <tr>
                    <th>S/N</th>
                    <th>Name</th>
                    <th>Admission No</th>
                    <th>Status</th>
                    <th>Time In</th>
                    <th>Time Out</th>
                    <th>Remark</th>
                </tr>
            </thead>

            <tbody>
                @foreach($students as $k => $student)
                    @php
                        $attendance = $attendances->where('student_id', $student->id)->first();
                    @endphp
                    <tr>
                        <td>{{ $k + 1 }}</td>
                        <td>{{ $student->user->name }}</td>
                        <td>{{ $student->adm_no }}</td>
                        <td class="{{ $attendance ? strtolower($attendance->status) : '' }}">
                            {{ $attendance ? ucfirst($attendance->status) : 'N/A' }}
                        </td>
                        <td>{{ $attendance ? date('h:i A', strtotime($attendance->time_in)) : 'N/A' }}</td>
                        <td>{{ $attendance && $attendance->time_out ? date('h:i A', strtotime($attendance->time_out)) : 'N/A' }}</td>
                        <td>{{ $attendance ? $attendance->remark : '' }}</td>
                    </tr>
                @endforeach
            </tbody>

            {{-- Summary --}}
            <tfoot>
                <tr>
                    <td colspan="7" style="text-align: left; padding: 10px;">
                        <strong>Summary:</strong><br>
                        Present: {{ $attendances->where('status', 'present')->count() }} |
                        Absent: {{ $attendances->where('status', 'absent')->count() }} |
                        Late: {{ $attendances->where('status', 'late')->count() }}
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
</div>

<script>
    window.print();
</script>
</body>
</html>
