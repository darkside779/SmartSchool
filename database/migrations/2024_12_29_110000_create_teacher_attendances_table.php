<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateTeacherAttendancesTable extends Migration
{
    public function up()
    {
        Schema::create('teacher_attendances', function (Blueprint $table) {
            $table->id();
            $table->unsignedInteger('teacher_id');
            $table->date('date');
            $table->enum('status', ['present', 'absent', 'late']);
            $table->time('time_in');
            $table->time('time_out')->nullable();
            $table->string('remark')->nullable();
            $table->unsignedInteger('created_by');
            $table->timestamps();

            $table->foreign('teacher_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('created_by')->references('id')->on('users')->onDelete('cascade');
        });
    }

    public function down()
    {
        Schema::dropIfExists('teacher_attendances');
    }
}
