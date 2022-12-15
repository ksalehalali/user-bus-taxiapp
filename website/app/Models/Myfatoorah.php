<?php

namespace App\Models;

use Carbon\Carbon;
use App\Models\Country;
use App\Models\Access\Role;
use App\Models\Admin\Staff;
use App\Models\Admin\Driver;
use App\Models\Admin\Owner;
use App\Models\Request\Request;
use App\Models\Master\Developer;
use App\Models\Master\PocClient;
use App\Models\Traits\HasActive;
use App\Models\Admin\AdminDetail;
use App\Models\Admin\UserDetails;
use App\Models\Payment\UserWallet;
use Illuminate\Database\Eloquent\Model;
use Laravel\Passport\HasApiTokens;
use App\Models\LinkedSocialAccount;
use App\Models\Payment\DriverWallet;
use App\Base\Services\OTP\CanSendOTP;
use App\Models\Traits\DeleteOldFiles;
use App\Models\Traits\UserAccessTrait;
use Illuminate\Support\Facades\Storage;
use Illuminate\Notifications\Notifiable;
use App\Models\Payment\UserWalletHistory;
use App\Models\Traits\HasActiveCompanyKey;
use App\Models\Traits\UserAccessScopeTrait;
use App\Base\Services\OTP\CanSendOTPContract;
use Nicolaslopezj\Searchable\SearchableTrait;
use Illuminate\Foundation\Auth\User as Authenticatable;
use App\Models\Request\FavouriteLocation;
use App\Models\Payment\UserBankInfo;
use App\Models\Payment\WalletWithdrawalRequest;

class Myfatoorah extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'myfatoorah_transactions';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'InvoiceId',
        'InvoiceStatus',
        'InvoiceReference',
        'CustomerReference',
        'CreatedDate',
        'ExpiryTime',
        'Comments',
        'customer_name',
        'customer_mobile',
        'customer_email',
        'UserDefinedField',
        'invoice_items',
        'invoice_value',
        'order_id',
        'user_id',
        'payment_method_id',
        'payment_status',
        'myfatoorah_transactions_response',
        'myfatoorah_initial_response',
        'payment_url',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [

    ];

    /**
     * The attributes that have files that should be auto deleted on updating or deleting.
     *
     * @var array
     */
    public $deletableFiles = [
    ];

    /**
     * The attributes that can be used for sorting with query string filtering.
     *
     * @var array
     */
    public $sortable = [
        'id',
        'invoice_items',
        'customer_name',
        'customer_mobile',
        'customer_email',
        'invoice_value',
        'order_id',
        'payment_method_id',
        'payment_status',
    ];
}
