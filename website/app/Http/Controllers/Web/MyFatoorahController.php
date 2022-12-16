<?php

namespace App\Http\Controllers\Web;

use App\Base\Constants\Masters\WalletRemarks;
use App\Http\Controllers\Controller;
use App\Jobs\Notifications\SendPushNotification;
use App\Libraries\Myfatoorahv2;
use App\Models\Myfatoorah;
use App\Models\Payment\DriverWallet;
use App\Models\Payment\DriverWalletHistory;
use App\Models\Payment\UserWalletHistory;
use App\Models\Request\Request as RequestModel;
use App\Models\User;
use Illuminate\Http\Request;
use Kreait\Firebase\Contract\Database;


class MyFatoorahController extends Controller
{
    public function __construct(Database $database)
    {
        $this->database = $database;
    }

    public function MyFatoorahWalletPaymentSuccess(Request $request){
        $model = new Myfatoorahv2();
        $data =$model->paymentdetails($request->paymentId);
        $InvoiceId = $data['InvoiceId'];
        $myfatoorah_model = $this->updata_transaction_status($data);
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
            return $this->respondSuccess(null,'payment_completed_successfully');
        } else {
            return $this->respondFailed('duplicate_entry');
        }
    }

    public function MyFatoorahWalletPaymentError(Request $request){
        $model = new Myfatoorahv2();
        $data =$model->paymentdetails($request->paymentId);
        $this->updata_transaction_status($data);
        return $this->respondFailed('payment_failed');
    }

    public function MyfatoorahRidePaymentSuccess(Request $request){
        $model = new Myfatoorahv2();
        $data = $model->paymentdetails($request->paymentId);
        $InvoiceId = $data['InvoiceId'];
        $myfatoorah_model = $this->updata_transaction_status($data);
        $request_detail = RequestModel::find($myfatoorah_model->order_id);
        $driver = $request_detail->driverDetail;

        $request_detail->is_paid = 1;
        $request_detail->save();

        $driver_commision = $request_detail->requestBill->driver_commision;

        $drvier_wallet_history = DriverWalletHistory::Where('user_id',$driver->id)->Where('transaction_id',$InvoiceId)->Where('request_id',$request_detail->id)->first();
        if (!empty($drvier_wallet_history)){
            return $this->respondFailed('duplicate_entry');
        }

        $user_wallet = DriverWallet::firstOrCreate([
            'user_id'=>$driver->id]);

        $user_wallet->amount_added += $driver_commision;
        $user_wallet->amount_balance += $driver_commision;
        $user_wallet->save();
        $user_wallet->fresh();

        DriverWalletHistory::create([
            'user_id'=>$driver->id,
            'amount'=>$driver_commision,
            'transaction_id'=>$InvoiceId,
            'request_id'=> $request_detail->id,
            'merchant'=> 'Myfatoorah',
            'remarks'=>WalletRemarks::TRIP_COMMISSION_FOR_DRIVER.". Customer paid by Myfatoorah",
            'is_credit'=>true
        ]);

        $this->database->getReference('requests/'.$request_detail->id)->update(['is_paid'=>1,'updated_at'=> Database::SERVER_TIMESTAMP]);

//        $title = trans('push_notifications.payment_completed_by_user_title',[],$driver->user->lang);
//        $body = trans('push_notifications.payment_completed_by_user_body',[],$driver->user->lang);

     //   dispatch(new SendPushNotification($driver->user,$title,$body));
        return $this->respondSuccess(null,'payment_completed_successfully');
    }

    public function MyfatoorahRidePaymentError(Request $request){
        $model = new Myfatoorahv2();
        $data =$model->paymentdetails($request->paymentId);
        $this->updata_transaction_status($data);
        return $this->respondFailed('payment_failed');
    }


    public function updata_transaction_status($data){
        $InvoiceId = $data['InvoiceId'];
        $myfatoorah_model = Myfatoorah::Where('InvoiceId',$InvoiceId)->first();
        $myfatoorah_model->InvoiceStatus = $data['InvoiceStatus'];
        $myfatoorah_model->InvoiceReference= $data['InvoiceReference'];
        $myfatoorah_model->CustomerReference= $data['CustomerReference'];
        $myfatoorah_model->payment_status= $data['InvoiceStatus'];
        $myfatoorah_model->myfatoorah_transactions_response = json_encode($data);
        $myfatoorah_model->save();
        return $myfatoorah_model;
    }
}