<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Libraries\Myfatoorahv2;
use App\Models\Myfatoorah;
use App\Models\Payment\UserWalletHistory;
use App\Models\User;
use Illuminate\Http\Request;


class MyFatoorahController extends Controller
{
    public function MyFatoorahWalletPaymentSuccess(Request $request){
        $model = new Myfatoorahv2();
        $data =$model->paymentdetails($request->paymentId);
        $InvoiceId = $data['InvoiceId'];
        $myfatoorah_model = Myfatoorah::Where('InvoiceId',$InvoiceId)->first();
        $myfatoorah_model->InvoiceStatus = $data['InvoiceStatus'];
        $myfatoorah_model->InvoiceReference= $data['InvoiceReference'];
        $myfatoorah_model->CustomerReference= $data['CustomerReference'];
        $myfatoorah_model->payment_status= $data['InvoiceStatus'];
        $myfatoorah_model->myfatoorah_transactions_response = json_encode($data);
        $myfatoorah_model->save();
        $user_wallet_check = UserWalletHistory::Where('transaction_id',$InvoiceId)->Where('merchant','Myfatoorah')->first();
        if (empty($user_wallet_check)){
            $amount_to_transfer = $data['InvoiceValue'];
            $receiver_user = User::Where('id',$myfatoorah_model->user_id)->first();
            $receiver_wallet = $receiver_user->userWallet;
            $receiver_wallet->amount_added += $amount_to_transfer;
            $receiver_wallet->amount_balance += $amount_to_transfer;
            $receiver_wallet->save();
            $receiver_user->userWalletHistory()->create([
                'transaction_id' => $InvoiceId,
                'amount' => $amount_to_transfer,
                'merchant' => 'Myfatoorah',
                'is_credit' => true,
                'remarks' => 'Wallet Top Up from MyFatoorh'
            ]);
        } else {
            echo "duplicate entry";
        }
        die;
    }

    public function MyFatoorahWalletPaymentError(Request $request){
        $model = new Myfatoorahv2();
        $data =$model->paymentdetails($request->paymentId);
        $InvoiceId = $data['InvoiceId'];
        $myfatoorah_model = Myfatoorah::Where('InvoiceId',$InvoiceId)->first();
        $myfatoorah_model->InvoiceStatus = $data['InvoiceStatus'];
        $myfatoorah_model->InvoiceReference= $data['InvoiceReference'];
        $myfatoorah_model->CustomerReference= $data['CustomerReference'];
        $myfatoorah_model->payment_status= $data['InvoiceStatus'];
        $myfatoorah_model->myfatoorah_transactions_response = json_encode($data);
        $myfatoorah_model->save();


    }
}