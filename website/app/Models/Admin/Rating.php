<?php

namespace App\Models\Admin;

use App\Base\Uuid\UuidModel;
use App\Models\Traits\HasActive;
use Illuminate\Database\Eloquent\Model;
use App\Models\Traits\HasActiveCompanyKey;

class Rating extends Model
{
    use UuidModel,HasActive;

    protected $fillable = [
        'title','star'
    ];
}
