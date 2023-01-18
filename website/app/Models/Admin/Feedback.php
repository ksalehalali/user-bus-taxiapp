<?php

namespace App\Models\Admin;

use App\Base\Uuid\UuidModel;
use App\Models\Traits\HasActive;
use Illuminate\Database\Eloquent\Model;
use App\Models\Traits\HasActiveCompanyKey;
use App\Models\Admin\Rating;
use App\Models\User;
use App\Models\Admin\Driver;

class Feedback extends Model
{
    use UuidModel,HasActive;

    protected $fillable = [
        'user_id','rating_id','request_id','star'
    ];


    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'id');
    } 

    public function rating()
    {
        return $this->belongsTo(Rating::class, 'rating_id', 'id');
    } 

    public function driver()
    {
        return $this->belongsTo(Driver::class, 'user_id', 'id');
    } 
}
