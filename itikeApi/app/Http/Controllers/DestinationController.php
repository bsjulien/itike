<?php

namespace App\Http\Controllers;

use App\Models\Destination;
use Illuminate\Http\Request;

class DestinationController extends Controller
{
    //getting the kigali information for displaying on home page
    public function index(){
        return response([
            "Destinations" => Destination::where('start_point', 'Kigali')->get()
        ], 200);

        // $output = Destination::where('start_point', 'Kigali')->get();
        // return response()->json($output);
    }

    // getting the full destination info by id
    public function getDestinationById($id){
        $destination = Destination::find($id);

        if(!$destination){
            return response([
                'message' => "Destination not found."
            ], 403);
        }

        return response([
            "destination" => Destination::where('id', $id)->get()
        ], 200);
    }

    //getting startpoint locations
    public function getStartPoints(){
        return response([
            'startpoints' => Destination::distinct()->select('start_point')->get()
        ], 200);
    }

    //getting endpoints locations based on startpoint
    public function getEndPoints($start_point){
        $checkstart = Destination::where('start_point', $start_point);

        if(!$checkstart){
            return response([
                'message' => "start point not found."
            ], 403);
        }

        return response([
            'endpoints' => Destination::where('start_point', $start_point)->select('end_point')->get()
        ], 200);
    }

    //getting time possible for a certain location
    public function getDestInfo($start_point, $end_point){

        return response([
            'destinationinfo' => Destination::where('start_point', $start_point)->where('end_point', $end_point)
->select('id', 'start_point', 'end_point', 'start_time', 'end_time', 'price')->get()
        ], 200);
    }
}
