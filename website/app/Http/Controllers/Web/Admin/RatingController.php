<?php

namespace App\Http\Controllers\Web\Admin;

use App\Base\Filters\Master\CommonMasterFilter;
use App\Base\Libraries\QueryFilter\QueryFilterContract;
use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\Rating\CreateRatingRequest;
use App\Models\Admin\Rating;
use Illuminate\Http\Request;

class RatingController extends Controller
{
    protected $reason;

    /**
     * FaqController constructor.
     *
     * @param \App\Models\Admin\Rating $reason
     */
    public function __construct(Rating $reason)
    {
        $this->reason = $reason;
    }

    public function index()
    {
        $page = trans('pages_names.view_rating');

        $main_menu = 'rating';
        $sub_menu = '';

        return view('admin.rating.index', compact('page', 'main_menu', 'sub_menu'));
    }

    public function fetch(QueryFilterContract $queryFilter)
    {

        $query = $this->reason->query();
        $results = $queryFilter->builder($query)->customFilter(new CommonMasterFilter)->paginate();

        return view('admin.rating._rating', compact('results'));
    }

    public function create()
    {
        $page = trans('pages_names.add_rating_reason');
        $main_menu = 'rating-reason';
        $sub_menu = '';

        return view('admin.rating.create', compact('page', 'main_menu', 'sub_menu'));
    }

    public function store(CreateRatingRequest $request)
    {
        $created_params = $request->only(['title', 'star','user_type']);
        // $created_params['company_key'] = auth()->user()->company_key;
        $this->reason->create($created_params);
        $message = trans('succes_messages.rating_reason_added_succesfully');
        return redirect('rating')->with('success', $message);
    }

    public function getById(Rating $reason)
    {
        $page = trans('pages_names.edit_rating_reason');
        $main_menu = 'rating-reason';
        $sub_menu = '';
        $item = $reason;

        return view('admin.rating.update', compact('item', 'page', 'main_menu', 'sub_menu'));
    }

    public function update(CreateRatingRequest $request, Rating $reason)
    {
        $updated_params = $request->all();
        $reason->update($updated_params);

        $message = trans('succes_messages.rating_reason_updated_succesfully');

        return redirect('rating')->with('success', $message);
    }

    public function delete(Rating $reason)
    {
        $reason->delete();

        $message = trans('succes_messages.rating_reason_deleted_succesfully');

        return redirect('rating')->with('success', $message);
    }
}
