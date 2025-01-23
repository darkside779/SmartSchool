<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class StudentAttendance extends Model
{
    protected $fillable = [
        'student_id',
        'class_id',
        'section_id',
        'date',
        'status', // present, absent, late
        'time_in',
        'time_out',
        'remark',
        'created_by'
    ];

    protected $dates = ['date'];

    public function student()
    {
        return $this->belongsTo(StudentRecord::class, 'student_id');
    }

    public function class()
    {
        return $this->belongsTo(MyClass::class, 'class_id');
    }

    public function section()
    {
        return $this->belongsTo(Section::class, 'section_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'created_by');
    }
}
