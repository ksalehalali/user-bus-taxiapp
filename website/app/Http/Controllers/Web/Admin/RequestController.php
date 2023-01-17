<?php

namespace App\Http\Controllers\Web\Admin;

use App\Base\Filters\Admin\RequestFilter;
use App\Base\Filters\Master\CommonMasterFilter;
use App\Base\Libraries\QueryFilter\QueryFilterContract;
use App\Http\Controllers\Controller;
use App\Models\Request\Request as RequestRequest;
use Carbon\Carbon;
use Illuminate\Http\Request;
use App\Models\Admin\Feedback;
use Illuminate\Support\Facades\DB;

class RequestController extends Controller
{
    public function index()
    {
//        dd($created_request);
        $page = trans('pages_names.request');
        $main_menu = 'trip-request';
        $sub_menu = 'request';

        return view('admin.request.index', compact('page', 'main_menu', 'sub_menu'));
    }

    public function getAllRequest(QueryFilterContract $queryFilter)
    {
//        dd(Carbon::now());
        $query = RequestRequest::companyKey()->whereIsCompleted(true);

        $results = $queryFilter->builder($query)->customFilter(new RequestFilter)->defaultSort('-created_at')->paginate();

        return view('admin.request._request', compact('results'));
    }

    public function retrieveSingleRequest(RequestRequest $request){
        $item = $request;

        return view('admin.request._singlerequest', compact('item'));
    }

    public function getSingleRequest(RequestRequest $request)
    {
        $page = trans('pages_names.request');
        $main_menu = 'trip-request';
        $sub_menu = 'request';

        $item = $request;
        $request_id = $item->id;

        $userFeedBackData = DB::table('feedback')
        ->join('ratings', 'ratings.id', '=', 'feedback.rating_id')
        ->join('users', 'users.id', '=', 'feedback.user_id')
        ->where(['feedback.request_id'=>$request_id,'ratings.user_type'=>'user'])
        ->get();
        
        $driverFeedBackData = DB::table('feedback')
        ->join('ratings', 'ratings.id', '=', 'feedback.rating_id')
        ->join('drivers', 'drivers.id', '=', 'feedback.user_id')
        ->where(['feedback.request_id'=>$request_id,'ratings.user_type'=>'driver'])
        ->get();

        return view('admin.request.requestview', compact('page', 'main_menu', 'sub_menu', 'item','userFeedBackData','driverFeedBackData'));
    }

    public function fetchSingleRequest(RequestRequest $request){
        return $request;
    }

     public function requestDetailedView(RequestRequest $request){
        $item = $request;
        $page = trans('pages_names.request');
         $main_menu = 'trip-request';
        $sub_menu = 'request';

        return view('admin.request.trip-request',compact('item','page', 'main_menu', 'sub_menu'));
    }

     public function indexScheduled()
    {
        $page = trans('pages_names.request');
        $main_menu = 'trip-request';
        $sub_menu = 'scheduled-rides';

        return view('admin.scheduled-rides.index', compact('page', 'main_menu', 'sub_menu'));
    }

     public function getAllScheduledRequest(QueryFilterContract $queryFilter)
    {
        $query = RequestRequest::companyKey()->whereIsCompleted(false)->whereIsCancelled(false)->whereIsLater(true);
        $results = $queryFilter->builder($query)->customFilter(new RequestFilter)->defaultSort('-created_at')->paginate();

        return view('admin.scheduled-rides._scheduled', compact('results'));
    }

    /**
     * View Invoice
     *
     * */
    public function viewCustomerInvoice(RequestRequest $request_detail){

        $data = $request_detail;

        return view('email.invoice',compact('data'));

    }
    /**
     * View Invoice
     *
     * */
    public function viewDriverInvoice(RequestRequest $request_detail){

        $data = $request_detail;

        return view('email.driver_invoice',compact('data'));

    }
    public function getCancelledRequest(RequestRequest $request)
    {
        $page = trans('pages_names.request');
        $main_menu = 'cancelled-request';
        $sub_menu = 'request';

        $item = $request;
        // dd($item->cancelReason);

        return view('admin.request.Cancelledview', compact('page', 'main_menu', 'sub_menu', 'item'));
    }

}
