<?php

namespace App\Models;

use App\User;
use Eloquent;

class Mark extends Eloquent
{
    protected $fillable = ['t1', 't2', 't3', 't4', 'tca', 'exm', 'tex1', 'tex2', 'tex3', 'sub_pos', 'cum', 'cum_ave', 'grade_id', 'year', 'exam_id', 'subject_id', 'my_class_id', 'student_id', 'section_id'];

    protected $casts = [
        't1' => 'float',
        't2' => 'float',
        't3' => 'float',
        't4' => 'float',
        'tca' => 'float',
        'exm' => 'float',
        'tex1' => 'float',
        'tex2' => 'float',
        'tex3' => 'float',
        'cum' => 'float',
        'cum_ave' => 'float',
    ];

    public function exam()
    {
        return $this->belongsTo(Exam::class);
    }

    public function section()
    {
        return $this->belongsTo(Section::class);
    }

    public function my_class()
    {
        return $this->belongsTo(MyClass::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'student_id');
    }

    public function subject()
    {
        return $this->belongsTo(Subject::class);
    }

    public function grade()
    {
        return $this->belongsTo(Grade::class);
    }
}
