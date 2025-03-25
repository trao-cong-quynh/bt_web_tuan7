<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/test-daily', function () {
    $apiKey = env('DAILY_API_KEY');
    $response = Http::withHeaders([
        'Authorization' => 'Bearer ' . $apiKey,
        'Content-Type' => 'application/json',
    ])->withOptions(['verify' => false]) // ⚠️ Bỏ qua SSL
        ->get('https://api.daily.co/v1/rooms');

    return response()->json($response->json());
});
