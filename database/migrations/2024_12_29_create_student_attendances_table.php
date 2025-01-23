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
            $table->unsignedBigInteger('student_id');
            $table->unsignedBigInteger('class_id');
            $table->unsignedBigInteger('section_id');
            $table->date('date');
            $table->enum('status', ['present', 'absent', 'late']);
            $table->time('time_in');
            $table->time('time_out')->nullable();
            $table->string('remark')->nullable();
            $table->unsignedBigInteger('created_by');
            $table->timestamps();

            $table->foreign('student_id')->references('id')->on('student_records')->onDelete('cascade');
            $table->foreign('class_id')->references('id')->on('my_classes')->onDelete('cascade');
            $table->foreign('section_id')->references('id')->on('sections')->onDelete('cascade');
            $table->foreign('created_by')->references('id')->on('users')->onDelete('cascade');
        });
    }

    public function down()
    {
        Schema::dropIfExists('student_attendances');
    }
}
