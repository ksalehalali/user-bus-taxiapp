<?php

namespace App\Http\Controllers\Web\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Libraries\Myfatoorahv2;


class MyFatoorahController extends Controller
{
    public function index(Request $request){
        $myfatoorah_event = new Myfatoorahv2();
        dd($myfatoorah_event->Init(10));
    }
}