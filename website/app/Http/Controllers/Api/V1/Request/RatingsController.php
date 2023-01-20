<?php

namespace App\Http\Controllers\Api\V1\Request;

use App\Models\Request\RequestRating;
use App\Base\Constants\Auth\Role as RoleSlug;
use App\Http\Controllers\Api\V1\BaseController;
use App\Http\Requests\Request\TripRatingRequest;
use App\Models\Admin\Feedback;
use App\Http\Requests\Request\FeedbackRequest;
use Exception;
/**
 * @group Ratings
 *
 * APIs for User & Driver-trip ratig api
 */
class RatingsController extends BaseController
{
    /**
    * Rate The Request B/W User & Driver
    * @bodyParam request_id uuid required id of request
    * @bodyParam rating float required rating of the request
    * @bodyParam comment string optional comment of the request
    * @response {
    "success": true,
    "message": "rated_successfully"
    }
    */
    public function rateRequest(TripRatingRequest $request)
    {
        $postData = $request->all('options');
        $options = @json_decode($postData['options'],true);
        $json_OK= json_last_error() == JSON_ERROR_NONE;

        if(empty($json_OK)){
            throw new Exception('Feedback json is not correct.');
        }

        if(empty($options[0]['rating_id']) && empty($options[0]['star'])){
            throw new Exception('Feedback json data not found.');
        }
        
        $user_rating = false;
        $driver_rating = false;
        $user_type = '';
        if (access()->hasRole(RoleSlug::USER)) {
            $user_id = auth()->user()->id;
            $request_detail = auth()->user()->requestDetail()->where('id', $request->request_id)->first();
            if (!$request_detail) {
                throw new Exception('You are not allowed to review this request.');
            }
            if ($request_detail->user_rated) {
                throw new Exception('You have already reviewed this request.');
            }
            $driver_id = $request_detail->driver_id;
            $user_rating = true;
            $exist_user_rating = auth()->user()->rating;
            $user_type = 'user';
        } else {
            $driver_id = auth()->user()->driver->id;
            $request_detail = auth()->user()->driver->requestDetail()->where('id', $request->request_id)->first();
            if (!$request_detail) {
                throw new Exception('You are not allowed to review this request.');
            }
            if ($request_detail->driver_rated) {
                throw new Exception('You have already reviewed this request.');
            }
            $user_id = $request_detail->user_id;
            $driver_rating = true;
            $exist_user_rating = auth()->user()->rating;
            $user_type = 'driver';
        }
        
    // Store rating to the request rating table
        foreach($options as $option){
            $request_rating_params = [
                'user_id'=>$user_id,
                'driver_id'=>$driver_id,
                'request_id'=>$request->request_id,
                'rating'=>$option['star'],
                'comment'=>$request->comment,
                'rating_id'=>$option['rating_id'],
                'user_rating'=>$user_rating,
                'driver_rating'=>$driver_rating
            ];
            RequestRating::create($request_rating_params);
        }
    // Update Rating with existing rating

        $user = auth()->user();
        $rating_total = ($user->rating_total+$request->rating);
        $no_of_ratings =($user->no_of_ratings+1);
        $calculated_rating = round($rating_total/$no_of_ratings, 2);

        $rating = $user->update(['rating'=>$calculated_rating,'rating_total'=>$rating_total,'no_of_ratings'=>$no_of_ratings]);
        // Update user rated & driver rated
        if ($user_rating) {
            $request_detail->update(['user_rated'=>$user_rating]);
        } else {
            $request_detail->update(['driver_rated'=>$driver_rating]);
        }

        return $this->respondSuccess(null, 'rated_successfully');
    }

    public function getFeedback(FeedbackRequest $request){
        // $postData = $_GET;
        $request_id = $request->request_id;
        if(empty($request_id)){
            throw new Exception('No request id found.');
        }

        $response_data = [];

        if (access()->hasRole('user'))
        {
            // user feedback will have driver rating data on his screen
            $feedback = RequestRating::where(['request_ratings.request_id'=>$request_id,'request_ratings.driver_rating'=>1])->with('user','triprating')->get();
            if (!empty($feedback)) {
                foreach ($feedback as $key => $value) {
                    $rated_star = $value->rating;
                    $comment = $value->comment;
                    $rating_title = $value->triprating->title;
                    $response_data['comment'] = $comment;
                    $response_data['user'][$key]['rated_star'] = $rated_star;
                    $response_data['user'][$key]['rating_title'] = $rating_title;
                }
            }
        }elseif (access()->hasRole('driver'))
        {
            // driver feedback will have user rating data on his screen
            $feedback = RequestRating::where(['request_ratings.request_id'=>$request_id,'request_ratings.user_rating'=>1])->with('driver','triprating')->get(); 
            if (!empty($feedback)) {
                foreach ($feedback as $key => $value) {
                    $rated_star = $value->rating;
                    $comment = $value->comment;
                    $rating_title = $value->triprating->title;
                    $response_data['comment'] = $comment;
                    $response_data['driver'][$key]['rated_star'] = $rated_star;
                    $response_data['driver'][$key]['rating_title'] = $rating_title;
                }
            }

        }
        return $this->respondOk($response_data);
    }
}
