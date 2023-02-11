<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Ticket;
use App\Models\Destination;

class TicketController extends Controller
{
    //get tickets according to the date selected
    public function index($date){

        // return response([
        //     'tickets' => Ticket::whereDate('date', $date)->where('user_id', auth()->user()->id)->with('destination', function($query){
        //         return $query->select('id', 'start_point', 'end_point', 'price');
        //     })->orderBy('created_at', 'desc')->get()
        // ], 200);

        return response([
            'tickets' => Ticket::join('destinations', 'destinations.id', '=', 'tickets.destination_id')->whereDate('date', $date)->where('user_id', auth()->user()->id)
            ->select("tickets.id", "user_id", "date", "time", "start_point", "end_point", "price")->orderBy('tickets.created_at', 'desc')->get()
        ], 200);
    }


    //create a ticket
    public function store(Request $request, $dest_id){

        $destination = Destination::find($dest_id);

        if(!$destination){
            return response([
                'message' => "Destination not found."
            ], 403);
        }

        $date = $request['date'];
        $time = $request['time'];

        if(Ticket::where('date', $date)->where('time', $time)->where('destination_id', $dest_id)->where('user_id', auth()->user()->id)->exists()){
            return response(
                [
                    'message' => 'Ticket exist'
                ], 403
            );
        }

        $ticket = Ticket::create([
            'date' => $date,
            'time' => $time,
            'destination_id' => $dest_id,
            'user_id' => auth()->user()->id
        ]);

        return response([
            'message' => "Ticket created",
            "ticket" => $ticket
        ]);
    }

    //check if the ticket already exist
    public function checkTicketExist(Request $request, $dest_id){

        $date = $request['date'];
        $time = $request['time'];

        if(Ticket::where('date', $date)->where('time', $time)->where('destination_id', $dest_id)->where('user_id', auth()->user()->id)->exists()){
            return response(
                [
                    'message' => 'Ticket exist'
                ], 403
            );
        }
    }

    //delete Ticket
    public function destroy($id){
        $ticket = Ticket::find($id);

        if(!$ticket){
            return response(
                [
                    'message' => 'Ticket not found'
                ], 403
            );
        }

        $ticket ->delete();

        return response([
            'message' => 'Ticket deleted'
        ], 200);
    }
}
