<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Ticket;

class Destination extends Model
{
    use HasFactory;

    protected $fillable = [
        'start_point',
        'end_point',
        'start_time',
        'end_time',
        'price'
    ];

    // public function tickets(){
    //     return $this->hasMany(Ticket::class);
    // }
}
