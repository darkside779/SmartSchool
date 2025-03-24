<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class ExamResultResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'exam' => [
                'id' => $this->exam->id,
                'name' => $this->exam->name,
                'term' => $this->exam->term,
                'year' => $this->exam->year,
            ],
            'subject' => [
                'id' => $this->subject->id,
                'name' => $this->subject->name,
                'code' => $this->subject->code,
            ],
            'marks' => [
                't1' => $this->t1,
                't2' => $this->t2,
                't3' => $this->t3,
                't4' => $this->t4,
                'exam' => $this->exam_score,
                'total' => $this->total,
                'grade' => $this->grade,
                'remark' => $this->remark,
            ],
            'year' => $this->year,
            'created_at' => $this->created_at->format('Y-m-d H:i:s'),
            'updated_at' => $this->updated_at->format('Y-m-d H:i:s'),
        ];
    }
}
