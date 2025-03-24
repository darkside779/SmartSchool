<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class PaymentResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'student' => new StudentRecordResource($this->whenLoaded('student')),
            'amount' => $this->amount,
            'description' => $this->description,
            'year' => $this->year,
            'ref_no' => $this->ref_no,
            'status' => $this->status,
            'payment_date' => $this->created_at->format('Y-m-d'),
            'created_at' => $this->created_at->format('Y-m-d H:i:s'),
            'updated_at' => $this->updated_at->format('Y-m-d H:i:s'),
        ];
    }
}
