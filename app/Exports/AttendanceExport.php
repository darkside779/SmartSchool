<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use Maatwebsite\Excel\Concerns\WithTitle;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;

class AttendanceExport implements FromCollection, WithHeadings, WithMapping, WithStyles, WithTitle, ShouldAutoSize
{
    protected $my_class;
    protected $section;
    protected $students;
    protected $attendances;
    protected $start_date;
    protected $end_date;

    public function __construct($my_class, $section, $students, $attendances, $start_date, $end_date)
    {
        $this->my_class = $my_class;
        $this->section = $section;
        $this->students = $students;
        $this->attendances = $attendances;
        $this->start_date = $start_date;
        $this->end_date = $end_date;
    }

    public function collection()
    {
        return $this->attendances;
    }

    public function headings(): array
    {
        return [
            'S/N',
            'Name',
            'Admission No',
            'Date',
            'Status',
            'Time In',
            'Time Out',
            'Remark'
        ];
    }

    public function map($attendance): array
    {
        return [
            $this->attendances->search($attendance) + 1,
            $attendance->student->user->name,
            $attendance->student->adm_no,
            date('d/m/Y', strtotime($attendance->date)),
            ucfirst($attendance->status),
            date('h:i A', strtotime($attendance->time_in)),
            $attendance->time_out ? date('h:i A', strtotime($attendance->time_out)) : 'N/A',
            $attendance->remark
        ];
    }

    public function styles(Worksheet $sheet)
    {
        // Add title
        $sheet->mergeCells('A1:H1');
        $sheet->setCellValue('A1', 'Attendance Report for ' . $this->my_class->name . ' ' . $this->section->name);
        
        // Add date range
        $sheet->mergeCells('A2:H2');
        $sheet->setCellValue('A2', 'Period: ' . date('d/m/Y', strtotime($this->start_date)) . ' to ' . date('d/m/Y', strtotime($this->end_date)));
        
        // Style the title and date range
        $sheet->getStyle('A1:A2')->applyFromArray([
            'font' => [
                'bold' => true,
                'size' => 14
            ],
            'alignment' => [
                'horizontal' => 'center'
            ]
        ]);

        // Style the headers
        $sheet->getStyle('A3:H3')->applyFromArray([
            'font' => [
                'bold' => true
            ],
            'fill' => [
                'fillType' => 'solid',
                'startColor' => [
                    'rgb' => 'CCCCCC'
                ]
            ]
        ]);

        // Add summary at the bottom
        $lastRow = $sheet->getHighestRow() + 2;
        $present = $this->attendances->where('status', 'present')->count();
        $absent = $this->attendances->where('status', 'absent')->count();
        $late = $this->attendances->where('status', 'late')->count();
        $total = $present + $absent + $late;

        $sheet->mergeCells('A' . $lastRow . ':B' . $lastRow);
        $sheet->setCellValue('A' . $lastRow, 'Summary:');
        $sheet->mergeCells('C' . $lastRow . ':H' . $lastRow);
        $sheet->setCellValue('C' . $lastRow, "Total Records: $total | Present: $present | Absent: $absent | Late: $late");

        // Style the summary
        $sheet->getStyle('A' . $lastRow . ':H' . $lastRow)->applyFromArray([
            'font' => [
                'bold' => true
            ]
        ]);

        return [
            3 => ['font' => ['bold' => true]],
        ];
    }

    public function title(): string
    {
        return 'Attendance Report';
    }
}
