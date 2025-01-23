<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TeacherAttendance extends Model
{
    protected $fillable = [
        'teacher_id',
        'date',
        'status', // present, absent, late
        'time_in',
        'time_out',
        'remark',
        'created_by'
    ];

    protected $dates = ['date'];

    public function teacher()
    {
        return $this->belongsTo(StaffRecord::class, 'teacher_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'created_by');
    }
}
