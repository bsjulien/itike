<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DestinationController;
use App\Http\Controllers\TicketController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     return $request->user();
// });

// Public routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

//Protected routes
Route::group(['middleware' => ['auth:sanctum']], function(){

    //User
    Route::get('/user', [AuthController::class, 'user']);
    //Route::put('/user', [AuthController::class, 'update']);
    Route::post('/logout', [AuthController::class, 'logout']);

    //Destinations

    Route::get('/kigali', [DestinationController::class, 'index']); // getting Kigali information for homepage
    Route::get('/destination/{id}', [DestinationController::class, 'getDestinationById']); // getting destination information based on id(Homepage)
    Route::get('/startpoints', [DestinationController::class, 'getStartpoints']); // getting startPoints
    Route::get('/endpoints/{start_point}', [DestinationController::class, 'getEndPoints']); // getting endPoints
    Route::get('/destinfo/{start_point}/{end_point}', [DestinationController::class, 'getDestInfo']); // getting all destination info

    //Tickets
    Route::get('/tickets/{date}', [TicketController::class, 'index']); // all tickets
    Route::post('/tickets/check/{dest_id}', [TicketController::class, 'checkTicketExist']); // check if ticket exist
    Route::post('/tickets/{dest_id}', [TicketController::class, 'store']); // create tickets
    Route::delete('/tickets/{id}', [TicketController::class, 'destroy']); // delete ticket

});
