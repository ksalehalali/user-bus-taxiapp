<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Libraries\Myfatoorahv2;
use Illuminate\Http\Request;


class MyFatoorahController extends Controller
{
    public function MyFatoorahWalletPaymentSuccess(Request $request){
        $model = new Myfatoorahv2();
        $data =$model->paymentdetails($request->paymentId);
        dd($data);
    }

    public function MyFatoorahWalletPaymentError(Request $request){

    }
}