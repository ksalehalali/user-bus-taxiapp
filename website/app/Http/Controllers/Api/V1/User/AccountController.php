<?php

namespace App\Http\Controllers\Api\V1\User;

use App\Base\Constants\Auth\Role;
use App\Http\Controllers\ApiController;
use App\Models\User;
use App\Transformers\Driver\DriverProfileTransformer;
use App\Transformers\Owner\OwnerProfileTransformer;
use App\Transformers\User\UserTransformer;

class AccountController extends ApiController
{
    /**
     * Get the current logged in user.
     * @group User-Management
     * @return \Illuminate\Http\JsonResponse
     * @responseFile responses/auth/authenticated_driver.json
     * @responseFile responses/auth/authenticated_user.json
     */
    public function me()
    {

        $user = auth()->user();

        if (auth()->user()->hasRole(Role::DRIVER)) {

            $driver_details = $user->driver;

            $user = fractal($driver_details, new DriverProfileTransformer)->parseIncludes(['onTripRequest.userDetail', 'onTripRequest.requestBill', 'metaRequest.userDetail']);

        } else if (auth()->user()->hasRole(Role::USER)) {

            $user = fractal($user, new UserTransformer)->parseIncludes(['onTripRequest.driverDetail', 'onTripRequest.requestBill', 'metaRequest.driverDetail', 'favouriteLocations', 'laterMetaRequest.driverDetail']);
        } else {

            $owner_details = $user->owner;

            $user = fractal($owner_details, new OwnerProfileTransformer);
        }

        if (auth()->user()->hasRole(Role::DISPATCHER)) {

            $user = User::where('id', auth()->user()->id)->first();

        }

        return $this->respondOk($user);
    }

    public function myreferrers()
    {
        $referrers = User::select(['id','name','mobile','profile_picture'])->where('referred_by', auth()->user()->id)->get();
        if (!empty(empty($referrers))){
            $data['total_referrers'] = 0;
        } else {
            $data['total_referrers'] = count($referrers);
        }
        $data['referrers'] = $referrers;
        return $this->respondOk($data);
    }
}
