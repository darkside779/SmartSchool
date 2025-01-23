<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Session;

class LanguageController extends Controller
{
    public function switchLang($lang)
    {
        if (array_key_exists($lang, ['en' => 'English', 'ar' => 'Arabic'])) {
            Session::put('locale', $lang);
        }
        return redirect()->back();
    }
}
