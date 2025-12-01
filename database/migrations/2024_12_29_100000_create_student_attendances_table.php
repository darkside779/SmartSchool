<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateStudentAttendancesTable extends Migration
{
    public function up()
    {
        Schema::create('student_attendances', function (Blueprint $table) {
            $table->id();
            $table->unsignedInteger('student_id');
            $table->unsignedInteger('class_id');
            $table->unsignedInteger('section_id');
            $table->date('date');
            $table->enum('status', ['present', 'absent', 'late']);
            $table->time('time_in');
            $table->time('time_out')->nullable();
            $table->string('remark')->nullable();
            $table->unsignedInteger('created_by');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('student_attendances');
    }
}
