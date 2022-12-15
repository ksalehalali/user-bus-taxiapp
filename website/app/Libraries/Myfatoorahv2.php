<?php

namespace App\Libraries;

use App\Models\Myfatoorah;
use App\Models\Setting;

class Myfatoorahv2
{
    public $token;
    public $return_url;
    public $error_ret_url;
    public $basURL;
    public $merchantCode;
    public $contact_phone;
    public $allowed_payment_methods;

    public function __construct()
    {
        $this->allowed_payment_methods = [1,2];
        $myfatoorah_mode = Setting::Where('group_name', "myfatoorah_setttings")->Where('name', 'myfatoorah_mode')->first()->value;
        $myfatoorah_status = Setting::Where('group_name', "myfatoorah_setttings")->Where('name', 'enable-myfatoorah')->first()->value;
        $token = Setting::Where('group_name', "myfatoorah_setttings")->Where('name', 'my_fatoorah_api_key')->first()->value;
        if ($myfatoorah_status) {
            if ($myfatoorah_mode == "sandbox") {
                $this->merchantCode = '';
                $this->token = "Tfwjij9tbcHVD95LUQfsOtbfcEEkw1hkDGvUbWPs9CscSxZOttanv3olA6U6f84tBCXX93GpEqkaP_wfxEyNawiqZRb3Bmflyt5Iq5wUoMfWgyHwrAe1jcpvJP6xRq3FOeH5y9yXuiDaAILALa0hrgJH5Jom4wukj6msz20F96Dg7qBFoxO6tB62SRCnvBHe3R-cKTlyLxFBd23iU9czobEAnbgNXRy0PmqWNohXWaqjtLZKiYY-Z2ncleraDSG5uHJsC5hJBmeIoVaV4fh5Ks5zVEnumLmUKKQQt8EssDxXOPk4r3r1x8Q7tvpswBaDyvafevRSltSCa9w7eg6zxBcb8sAGWgfH4PDvw7gfusqowCRnjf7OD45iOegk2iYSrSeDGDZMpgtIAzYVpQDXb_xTmg95eTKOrfS9Ovk69O7YU-wuH4cfdbuDPTQEIxlariyyq_T8caf1Qpd_XKuOaasKTcAPEVUPiAzMtkrts1QnIdTy1DYZqJpRKJ8xtAr5GG60IwQh2U_-u7EryEGYxU_CUkZkmTauw2WhZka4M0TiB3abGUJGnhDDOZQW2p0cltVROqZmUz5qGG_LVGleHU3-DgA46TtK8lph_F9PdKre5xqXe6c5IYVTk4e7yXd6irMNx4D4g1LxuD8HL4sYQkegF2xHbbN8sFy4VSLErkb9770-0af9LT29kzkva5fERMV90w";
                $this->basURL = "https://apitest.myfatoorah.com";
            } else {
//            $this->merchantCode = $payment_Setting->my_fatoorah_supplier_code;
                $this->merchantCode = '';
                $this->token = $token;
                $this->basURL = "https://api.myfatoorah.com";
            }
        }
    }

    public function Init($price)
    {

        $token = $this->token;
        $basURL = $this->basURL;

        $curl = curl_init();
        curl_setopt_array($curl, array(
            CURLOPT_URL => "$basURL/v2/InitiatePayment",
            CURLOPT_CUSTOMREQUEST => "POST",
            CURLOPT_POSTFIELDS => "{\"InvoiceAmount\": $price,\"CurrencyIso\": \"KWD\"}",
            CURLOPT_HTTPHEADER => array("Authorization: Bearer $token", "Content-Type: application/json"),
        ));
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);

        $response = curl_exec($curl);
        $err = curl_error($curl);
        curl_close($curl);

        $payment_methods = [];

        if ($err) {
            return false;
        } else {
            $response = json_decode($response, true);
            if (!empty($response['IsSuccess'])) {
                foreach ($response['Data']['PaymentMethods'] as $PaymentMethod){
                    if (in_array($PaymentMethod['PaymentMethodId'],$this->allowed_payment_methods)){
                        $payment_methods[] = $PaymentMethod;
                    }
                }
                return $payment_methods;
            } else {
                return false;
            }
        }
    }

    public function getPaymentLink($cust_details, $price, $order_id, $user_id,$PaymentMethodId = 1, $return_url = '', $error_ret_url = '',$currency_code = "KWD",$country_code="+965")
    {

        if (!in_array($PaymentMethodId,$this->allowed_payment_methods)){
            return ["status" => false, "error" => "Invalid payment method id"];
        }

        $token = $this->token;
        $basURL = $this->basURL;

        if (!empty($return_url)) {
            $this->return_url = $return_url;
        }

        if (!empty($error_ret_url)) {
            $this->error_ret_url = $error_ret_url;
        }

        if ($_SERVER['REMOTE_ADDR'] == "::1" || $_SERVER['REMOTE_ADDR'] == "localhost") {
            $this->return_url = "https://google.com/myfatoorah-payment-success";
            $this->error_ret_url = "https://google.com/myfatoorah-payment-error";
        }

        $expirydate_init = date("Y-m-d H:i:s", strtotime(date("Y-m-d H:i:s") . " +1 minute"));
        $expirydate = date("Y-m-d", strtotime($expirydate_init)) . "T" . date("H:i:s", strtotime($expirydate_init)) . ".00";

        $items = [];

        $post_string_array = [
            'PaymentMethodId' => $PaymentMethodId,
            'CustomerName' => (string)$cust_details['name'],
            'DisplayCurrencyIso' => $currency_code,
            'MobileCountryCode' => $country_code,
            'CustomerMobile' => $cust_details['phone'],
            'CustomerEmail' => $cust_details['email'],
            'InvoiceValue' => $price,
            'CallBackUrl' => $this->return_url,
            'ErrorUrl' => $this->error_ret_url,
            'Language' => "en",
            'CustomerReference' => $user_id,
            'CustomerCivilId' => (string)$cust_details['civil_id'],
            'UserDefinedField' => (string)$order_id,
            'ExpireDate' => $expirydate,
            'CustomerAddress' => [
                'Block' => '',
                'Street' => '',
                'HouseBuildingNo' => '',
                'Address' => '',
                'AddressInstructions' => ''
            ],
            'InvoiceItems' => [],
        ];

        $post_string = json_encode($post_string_array);

        $model_myfatorah = new Myfatoorah();
        $model_myfatorah->InvoiceId = '';
        $model_myfatorah->InvoiceStatus = 'Pending';
        $model_myfatorah->InvoiceReference= '';
        $model_myfatorah->CustomerReference= '';
        $model_myfatorah->CreatedDate= date("Y-m-d H:i:s");
        $model_myfatorah->ExpiryTime= '';
        $model_myfatorah->Comments= '';
        $model_myfatorah->customer_name= $cust_details['name'];
        $model_myfatorah->customer_mobile= $cust_details['phone'];
        $model_myfatorah->customer_email= $cust_details['email'];
        $model_myfatorah->user_id= $user_id;
        $model_myfatorah->UserDefinedField= $order_id;
        $model_myfatorah->invoice_items= json_encode($items);
        $model_myfatorah->invoice_value= $price;
        $model_myfatorah->order_id= $order_id;
        $model_myfatorah->payment_method_id= $PaymentMethodId;
        $model_myfatorah->payment_status= 'Pending';
        $model_myfatorah->myfatoorah_transactions_response = '';
        $model_myfatorah->myfatoorah_initial_response = '';
        $model_myfatorah->payment_url = '';
        $model_myfatorah->save();


        $curl = curl_init();
        curl_setopt_array($curl, array(
            CURLOPT_URL => "$basURL/v2/ExecutePayment",
            CURLOPT_CUSTOMREQUEST => "POST",
            CURLOPT_POSTFIELDS => $post_string,
            CURLOPT_HTTPHEADER => array("Authorization: Bearer $token", "Content-Type: application/json"),
        ));

        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        $response = curl_exec($curl);

        $model_myfatorah->myfatoorah_initial_response = $response;
        $model_myfatorah->save();

        $err = curl_error($curl);
        curl_close($curl);
        if ($err) {
            return ["status" => false, "error" => "Unable to reach payment gateway"];
        } else {
            $response = json_decode($response, true);
            if ($response['IsSuccess']) {

                $model_myfatorah->InvoiceId = $response['Data']['InvoiceId'];
                $model_myfatorah->save();

                return ["status" => true, "PaymentURL" => $response['Data']['PaymentURL']];
            } else {
                $message = "";
                if (!empty($response['ValidationErrors'])) {
                    foreach ($response['ValidationErrors'] as $ValidationErrors_key => $ValidationErrors) {
                        $message .= $ValidationErrors['Error'];
                        if (!empty($ValidationErrors_key)) {
                            $message .= "<br>";
                        }
                    }
                } else {
                    $message = $response["Message"];
                }
                return ["status" => false, "error" => $message];
            }
        }
    }

    public
    function paymentdetails($payment_id)
    {
        $token = $this->token;
        $basURL = $this->basURL;

        $url = "$basURL/v2/getPaymentStatus";
        $data = array(
            'KeyType' => 'paymentId',
            'Key' => "$payment_id" //the callback paymentID
        );
        $fields = json_encode($data);


        $curl = curl_init($url);

        curl_setopt_array($curl, array(
            CURLOPT_CUSTOMREQUEST => 'POST',
            CURLOPT_POSTFIELDS => $fields,
            CURLOPT_HTTPHEADER => array("Authorization: Bearer $token", 'Content-Type: application/json'),
            CURLOPT_RETURNTRANSFER => true,
        ));

        $response = curl_exec($curl);
        $err = curl_error($curl);


        curl_close($curl);

        if ($err) {
            return false;
        } else {
            $response = json_decode($response, true);
            if (!empty($response['IsSuccess'])) {
                return $response['Data'];
            } else {
                return false;
            }
        }
    }

    public function refund($order, $order_product)
    {

        $myfatoorah_transactions_id = "";
        $CI =& get_instance();
        $CI->db->where('OrderId', $order->id);
        $myfatoorah_transactions = $CI->db->get('myfatoorah_transactions')->row();
        $payment_status = '';
        if (!empty($myfatoorah_transactions)) {
            $payment_status = $myfatoorah_transactions->PaymentStatus;
            $myfatoorah_inital_responce = !empty($myfatoorah_transactions->myfatoorah_inital_responce) ? json_decode($myfatoorah_transactions->myfatoorah_inital_responce) : [];
            if (!empty($myfatoorah_inital_responce)) {
                $myfatoorah_transactions_id = $myfatoorah_inital_responce->Data->InvoiceId;
            }
        }

        $token = $this->token;
        $basURL = $this->basURL;
        $price = $order_product->product_unit_price * $order_product->product_quantity;
        $price = $price / 100;
        $post_string_array = [
            'KeyType' => 'invoiceid',
            'Key' => $myfatoorah_transactions_id,
            'RefundChargeOnCustomer' => false,
            'ServiceChargeOnCustomer' => false,
            'Amount' => $price,
            'Comment' => 'Refund amount to customer',
            'AmountDeductedFromSupplier' => '',
        ];
        $post_string = json_encode($post_string_array);

        $insert_myfatoorah_refunded_products = [
            "order_id" => $order->id,
            "order_product_id" => $order_product->id,
            "product_id" => $order_product->product_id,
            "response" => '',
            "user_id" => $CI->auth_user->id,
            "created_at" => date("Y-m-d H:i:s"),
        ];


        $CI->db->insert("myfatoorah_refunded_products", $insert_myfatoorah_refunded_products);
        $refuded_log_id = $CI->db->insert_id();

        $curl = curl_init();
        curl_setopt_array($curl, array(
            CURLOPT_URL => "$basURL/v2/MakeRefund",
            CURLOPT_CUSTOMREQUEST => "POST",
            CURLOPT_POSTFIELDS => $post_string,
            CURLOPT_HTTPHEADER => array("Authorization: Bearer $token", "Content-Type: application/json"),
        ));
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        $response = curl_exec($curl);

        $insert_myfatoorah_refunded_products = [
            "response" => $response,
        ];
        $CI->db->where('id', $refuded_log_id);
        $CI->db->update("myfatoorah_refunded_products", $insert_myfatoorah_refunded_products);

        $err = curl_error($curl);
        curl_close($curl);

        if ($err) {

            return false;
        } else {
            $response = json_decode($response, true);
            if (!empty($response['IsSuccess'])) {
                return $response['Data'];
            } else {
                return false;
            }
        }
    }


    public function paymentdetailsByIvoiceId($InvoiceId)
    {
        $token = $this->token;
        $basURL = $this->basURL;

        $url = "$basURL/v2/getPaymentStatus";
        $data = array(
            'KeyType' => 'InvoiceId',
            'Key' => "$InvoiceId" //the callback paymentID
        );
        $fields = json_encode($data);


        $curl = curl_init($url);

        curl_setopt_array($curl, array(
            CURLOPT_CUSTOMREQUEST => 'POST',
            CURLOPT_POSTFIELDS => $fields,
            CURLOPT_HTTPHEADER => array("Authorization: Bearer $token", 'Content-Type: application/json'),
            CURLOPT_RETURNTRANSFER => true,
        ));

        $response = curl_exec($curl);
        $err = curl_error($curl);


        curl_close($curl);

        if ($err) {
            return false;
        } else {
            $response = json_decode($response, true);
            if (!empty($response['IsSuccess'])) {
                return $response['Data'];
            } else {
                return false;
            }
        }
    }

    public function Getsupplier()
    {

        $token = $this->token;
        $basURL = $this->basURL;
        $SupplierCode = $this->merchantCode;
        $curl = curl_init();

        curl_setopt_array($curl, array(
            CURLOPT_URL => "$basURL/v2/GetSuppliers",
            CURLOPT_CUSTOMREQUEST => "GET",
            CURLOPT_POSTFIELDS => "",
            CURLOPT_HTTPHEADER => array("Authorization: Bearer $token", "Content-Type: application/json"),
        ));

        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        $response = curl_exec($curl);
        $err = curl_error($curl);
        curl_close($curl);
        if ($err) {
            return $err;
        } else {
            $response = json_decode($response, true);
            if ($response) {
                return $response;
            } else {
                return false;
            }

        }

    }


}