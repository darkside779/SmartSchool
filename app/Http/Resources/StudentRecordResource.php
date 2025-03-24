<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class StudentRecordResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'user' => new UserResource($this->whenLoaded('user')),
            'admission_number' => $this->adm_no,
            'class' => [
                'id' => $this->my_class->id,
                'name' => $this->my_class->name,
                'section' => [
                    'id' => $this->section->id,
                    'name' => $this->section->name,
                ],
            ],
            'dormitory' => $this->whenLoaded('dorm', function() {
                return [
                    'id' => $this->dorm->id,
                    'name' => $this->dorm->name,
                    'room_number' => $this->dorm_room_no,
                ];
            }),
            'year_admitted' => $this->year_admitted,
            'house' => $this->house,
            'age' => $this->age,
            'session' => $this->session,
            'graduation_status' => [
                'graduated' => (bool)$this->grad,
                'graduation_date' => $this->grad_date,
            ],
            'created_at' => $this->created_at->format('Y-m-d H:i:s'),
            'updated_at' => $this->updated_at->format('Y-m-d H:i:s'),
        ];
    }
}
