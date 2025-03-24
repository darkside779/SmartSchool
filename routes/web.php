<?php

use App\Http\Controllers\HomeController;
use App\Http\Controllers\MyAccountController;
use App\Http\Controllers\LanguageController;
use App\Http\Controllers\SupportTeam\StudentRecordController;
use App\Http\Controllers\SupportTeam\PromotionController;
use App\Http\Controllers\SupportTeam\UserController;
use App\Http\Controllers\SupportTeam\TimeTableController;
use App\Http\Controllers\SupportTeam\PaymentController;
use App\Http\Controllers\SupportTeam\PinController;
use App\Http\Controllers\SupportTeam\MarkController;
use App\Http\Controllers\SupportTeam\AttendanceController;
use App\Http\Controllers\AjaxController;
use App\Http\Controllers\SupportTeam\MyClassController;
use App\Http\Controllers\SupportTeam\SectionController;
use App\Http\Controllers\SupportTeam\SubjectController;
use App\Http\Controllers\SupportTeam\GradeController;
use App\Http\Controllers\SupportTeam\ExamController;
use App\Http\Controllers\SupportTeam\DormController;

Auth::routes();

Route::get('/privacy-policy', [HomeController::class, 'privacy_policy'])->name('privacy_policy');
Route::get('/terms-of-use', [HomeController::class, 'terms_of_use'])->name('terms_of_use');

Route::get('lang/{lang}', [LanguageController::class, 'switchLang'])->name('lang.switch');

Route::group(['middleware' => 'auth'], function () {

    Route::get('/', [HomeController::class, 'dashboard'])->name('home');
    Route::get('/home', [HomeController::class, 'dashboard'])->name('home');
    Route::get('/dashboard', [HomeController::class, 'dashboard'])->name('dashboard');

    Route::group(['prefix' => 'my_account'], function() {
        Route::get('/', [MyAccountController::class, 'edit_profile'])->name('my_account');
        Route::put('/', [MyAccountController::class, 'update_profile'])->name('my_account.update');
        Route::put('/change_password', [MyAccountController::class, 'change_pass'])->name('my_account.change_pass');
    });

    /*************** Support Team *****************/
    Route::group(['namespace' => 'SupportTeam'], function(){

        /*************** Students *****************/
        Route::group(['prefix' => 'students'], function(){
            Route::get('reset_pass/{st_id}', [StudentRecordController::class, 'reset_pass'])->name('st.reset_pass');
            Route::get('graduated', [StudentRecordController::class, 'graduated'])->name('students.graduated');
            Route::put('not_graduated/{id}', [StudentRecordController::class, 'not_graduated'])->name('st.not_graduated');
            Route::get('list/{class_id}', [StudentRecordController::class, 'listByClass'])->name('students.list')->middleware('teamSAT');

            /* Promotions */
            Route::post('promote_selector', [PromotionController::class, 'selector'])->name('students.promote_selector');
            Route::get('promotion/manage', [PromotionController::class, 'manage'])->name('students.promotion_manage');
            Route::delete('promotion/reset/{pid}', [PromotionController::class, 'reset'])->name('students.promotion_reset');
            Route::delete('promotion/reset_all', [PromotionController::class, 'reset_all'])->name('students.promotion_reset_all');
            Route::get('promotion/{fc?}/{fs?}/{tc?}/{ts?}', [PromotionController::class, 'promotion'])->name('students.promotion');
            Route::post('promote/{fc}/{fs}/{tc}/{ts}', [PromotionController::class, 'promote'])->name('students.promote');

        });

        /*************** Users *****************/
        Route::group(['prefix' => 'users'], function(){
            Route::get('reset_pass/{id}', [UserController::class, 'reset_pass'])->name('users.reset_pass');
        });

        /*************** TimeTables *****************/
        Route::group(['prefix' => 'timetables'], function(){
            Route::get('/', [TimeTableController::class, 'index'])->name('tt.index');

            // Parent Timetable Routes
            Route::get('children', [TimeTableController::class, 'childrenTimetables'])->name('timetables.children');
            Route::get('child/{student_id}', [TimeTableController::class, 'childTimetable'])->name('timetables.child.show');

            Route::group(['middleware' => 'teamSA'], function() {
                Route::post('/', [TimeTableController::class, 'store'])->name('tt.store');
                Route::put('/{tt}', [TimeTableController::class, 'update'])->name('tt.update');
                Route::delete('/{tt}', [TimeTableController::class, 'delete'])->name('tt.delete');
            });

            /*************** TimeTable Records *****************/
            Route::group(['prefix' => 'records'], function(){

                Route::group(['middleware' => 'teamSA'], function(){
                    Route::get('manage/{ttr}', [TimeTableController::class, 'manage'])->name('ttr.manage');
                    Route::post('/', [TimeTableController::class, 'store_record'])->name('ttr.store');
                    Route::get('edit/{ttr}', [TimeTableController::class, 'edit_record'])->name('ttr.edit');
                    Route::put('/{ttr}', [TimeTableController::class, 'update_record'])->name('ttr.update');
                });

                Route::get('show/{ttr}', [TimeTableController::class, 'show_record'])->name('ttr.show');
                Route::get('print/{ttr}', [TimeTableController::class, 'print_record'])->name('ttr.print');
                Route::delete('/{ttr}', [TimeTableController::class, 'delete_record'])->name('ttr.destroy');

            });

            /*************** Time Slots *****************/
            Route::group(['prefix' => 'time_slots', 'middleware' => 'teamSA'], function(){
                Route::post('/', [TimeTableController::class, 'store_time_slot'])->name('ts.store');
                Route::post('/use/{ttr}', [TimeTableController::class, 'use_time_slot'])->name('ts.use');
                Route::get('edit/{ts}', [TimeTableController::class, 'edit_time_slot'])->name('ts.edit');
                Route::delete('/{ts}', [TimeTableController::class, 'delete_time_slot'])->name('ts.destroy');
                Route::put('/{ts}', [TimeTableController::class, 'update_time_slot'])->name('ts.update');
            });

        });

        /*************** Payments *****************/
        Route::group(['prefix' => 'payments'], function(){
            // Parent Payment Routes
            Route::get('children', [PaymentController::class, 'childrenPayments'])->name('payments.children');
            Route::get('child/{student_id}', [PaymentController::class, 'childPaymentShow'])->name('payments.child.show');
            Route::get('pdf_receipts/{id}', [PaymentController::class, 'pdf_receipts'])->name('payments.pdf_receipts');

            // Admin Payment Routes
            Route::middleware(['teamAccount'])->group(function() {
                Route::get('manage/{class_id?}', [PaymentController::class, 'manage'])->name('payments.manage');
                Route::get('invoice/{id}/{year?}', [PaymentController::class, 'invoice'])->name('payments.invoice');
                Route::get('receipts/{id}', [PaymentController::class, 'receipts'])->name('payments.receipts');
                Route::post('select_year', [PaymentController::class, 'select_year'])->name('payments.select_year');
                Route::post('select_class', [PaymentController::class, 'select_class'])->name('payments.select_class');
                Route::delete('reset_record/{id}', [PaymentController::class, 'reset_record'])->name('payments.reset_record');
                Route::post('pay_now/{id}', [PaymentController::class, 'pay_now'])->name('payments.pay_now');
            });
        });

        /*************** Pins *****************/
        Route::group(['prefix' => 'pins'], function(){
            Route::get('create', [PinController::class, 'create'])->name('pins.create');
            Route::get('/', [PinController::class, 'index'])->name('pins.index');
            Route::post('/', [PinController::class, 'store'])->name('pins.store');
            Route::get('enter/{id}', [PinController::class, 'enter_pin'])->name('pins.enter');
            Route::post('verify/{id}', [PinController::class, 'verify'])->name('pins.verify');
            Route::delete('/', [PinController::class, 'destroy'])->name('pins.destroy');
        });

        /*************** Marks *****************/
        Route::group(['prefix' => 'marks'], function(){

           // FOR teamSA
            Route::group(['middleware' => 'teamSA'], function(){
                Route::get('batch_fix', [MarkController::class, 'batch_fix'])->name('marks.batch_fix');
                Route::put('batch_update', [MarkController::class, 'batch_update'])->name('marks.batch_update');
                Route::get('tabulation/{exam?}/{class?}/{sec_id?}', [MarkController::class, 'tabulation'])->name('marks.tabulation');
                Route::post('tabulation', [MarkController::class, 'tabulation_select'])->name('marks.tabulation_select');
                Route::get('tabulation/print/{exam}/{class}/{sec_id}', [MarkController::class, 'print_tabulation'])->name('marks.print_tabulation');
            });

            // FOR teamSAT
            Route::group(['middleware' => 'teamSAT'], function(){
                Route::get('/', [MarkController::class, 'index'])->name('marks.index');
                Route::get('manage/{exam}/{class}/{section}/{subject}', [MarkController::class, 'manage'])->name('marks.manage');
                Route::put('update/{exam}/{class}/{section}/{subject}', [MarkController::class, 'update'])->name('marks.update');
                Route::put('comment_update/{exr_id}', [MarkController::class, 'comment_update'])->name('marks.comment_update');
                Route::put('skills_update/{skill}/{exr_id}', [MarkController::class, 'skills_update'])->name('marks.skills_update');
                Route::post('selector', [MarkController::class, 'selector'])->name('marks.selector');
                Route::get('bulk/{class?}/{section?}', [MarkController::class, 'bulk'])->name('marks.bulk');
                Route::post('bulk', [MarkController::class, 'bulk_select'])->name('marks.bulk_select');
            });

            Route::get('select_year/{id}', [MarkController::class, 'year_selector'])->name('marks.year_selector');
            Route::post('select_year/{id}', [MarkController::class, 'year_selected'])->name('marks.year_select');
            Route::get('show/{id}/{year}', [MarkController::class, 'show'])->name('marks.show');
            Route::get('print/{id}/{exam_id}/{year}', [MarkController::class, 'print_view'])->name('marks.print');

        });

        // Attendance Routes
        Route::group(['prefix' => 'attendance'], function() {
            Route::get('student', [AttendanceController::class, 'studentIndex'])->name('attendance.student');
            Route::get('teacher', [AttendanceController::class, 'teacherIndex'])->name('attendance.teacher');
            Route::get('student/manage/{class_id}/{section_id}/{date}', [AttendanceController::class, 'studentManage'])->name('attendance.student.manage');
            Route::get('teacher/manage/{date}', [AttendanceController::class, 'teacherManage'])->name('attendance.teacher.manage');
            Route::post('student/save', [AttendanceController::class, 'studentStore'])->name('attendance.student.save');
            Route::post('teacher/save', [AttendanceController::class, 'teacherStore'])->name('attendance.teacher.save');
            Route::get('student/edit/{attendance_id}', [AttendanceController::class, 'studentEdit'])->name('attendance.student.edit');
            Route::post('student/update/{attendance_id}', [AttendanceController::class, 'studentUpdate'])->name('attendance.student.update');
            Route::get('teacher/edit/{attendance_id}', [AttendanceController::class, 'teacherEdit'])->name('attendance.teacher.edit');
            Route::post('teacher/update/{attendance_id}', [AttendanceController::class, 'teacherUpdate'])->name('attendance.teacher.update');
            Route::get('report', [AttendanceController::class, 'showReport'])->name('attendance.report');
            Route::post('report/generate', [AttendanceController::class, 'generateReport'])->name('attendance.report.generate');
            Route::get('children', [AttendanceController::class, 'childrenAttendance'])->name('attendance.children');
            Route::get('child/{student_id}', [AttendanceController::class, 'childAttendanceShow'])->name('attendance.child.show');
            Route::get('student/download/{class_id}/{section_id}/{start_date}/{end_date}', [AttendanceController::class, 'studentDownload'])->name('attendance.student.download');
            Route::get('teacher/report', [AttendanceController::class, 'teacherReport'])->name('attendance.teacher.report');
            Route::post('teacher/report/generate', [AttendanceController::class, 'teacherReportGenerate'])->name('attendance.teacher.report.generate');
            Route::get('teacher/download/{start_date}/{end_date}', [AttendanceController::class, 'teacherDownload'])->name('attendance.teacher.download');
        });

        Route::resource('students', StudentRecordController::class);
        Route::resource('users', UserController::class);
        Route::resource('classes', MyClassController::class);
        Route::resource('sections', SectionController::class);
        Route::resource('subjects', SubjectController::class);
        Route::resource('grades', GradeController::class);
        Route::resource('exams', ExamController::class);
        Route::resource('dorms', DormController::class);
        Route::resource('payments', PaymentController::class);

    });

    /************************ AJAX ****************************/
    Route::group(['prefix' => 'ajax'], function() {
        Route::get('get_lga/{state_id}', [AjaxController::class, 'get_lga'])->name('get_lga');
        Route::get('get_class_sections/{class_id}', [AjaxController::class, 'get_class_sections'])->name('get_class_sections');
        Route::get('get_class_subjects/{class_id}', [AjaxController::class, 'get_class_subjects'])->name('get_class_subjects');
        Route::get('get_sections/{class_id}', [AjaxController::class, 'getSections'])->name('sections.get');
    });

    /************************ SUPER ADMIN ****************************/
    Route::group(['namespace' => 'SuperAdmin','middleware' => 'super_admin', 'prefix' => 'super_admin'], function(){

        Route::get('/settings', [App\Http\Controllers\SuperAdmin\SettingController::class, 'index'])->name('settings');
        Route::put('/settings', [App\Http\Controllers\SuperAdmin\SettingController::class, 'update'])->name('settings.update');

    });

    /************************ PARENT ****************************/
    Route::group(['namespace' => 'MyParent','middleware' => 'my_parent',], function(){

        Route::get('/my_children', [App\Http\Controllers\MyParent\MyController::class, 'children'])->name('my_children');

    });
});