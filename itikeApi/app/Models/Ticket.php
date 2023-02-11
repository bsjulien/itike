<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\User;
use App\Models\Destination;

class Ticket extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'destination_id',
        'date',
        'time',
    ];

    public function user(){
        return $this->belongsTo(User::class);
    }

    public function destination(){
        return $this->hasOne(Destination::class);
    }
}
