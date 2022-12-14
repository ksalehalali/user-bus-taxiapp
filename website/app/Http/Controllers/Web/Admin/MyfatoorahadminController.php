<?php

namespace App\Http\Controllers\Web\Admin;

use App\Http\Controllers\Controller;


class MyfatoorahadminController extends Controller
{
    public function index(){
        $page = trans('pages_names.myfatoorah');

        $main_menu = 'myfatoorah';
        $sub_menu = null;

        return view('admin.myfatoorah.index', compact('page', 'main_menu', 'sub_menu'));
    }
}
