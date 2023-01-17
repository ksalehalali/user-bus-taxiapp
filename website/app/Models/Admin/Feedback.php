<?php

namespace App\Models\Admin;

use App\Base\Uuid\UuidModel;
use App\Models\Traits\HasActive;
use Illuminate\Database\Eloquent\Model;
use App\Models\Traits\HasActiveCompanyKey;

class Feedback extends Model
{
    use UuidModel,HasActive;

    protected $fillable = [
        'user_id','rating_id','request_id'
    ];
}
