<?php
use Illuminate\Support\Facades\Http;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');



Route::post('/create-room', function () {
    $response = Http::withHeaders([
        'Authorization' => 'Bearer ' . env('DAILY_API_KEY'),
        'Content-Type' => 'application/json',
    ])->withOptions(['verify' => false]) // ⚠️ Bỏ qua SSL
        ->post('https://api.daily.co/v1/rooms', [
            'properties' => [
                'exp' => time() + 86400 // Hết hạn sau 24 giờ
            ]
        ]);

    // Đảm bảo trả về đúng định dạng JSON với key "url"
    return response()->json([
        'url' => $response->json()['url'] ?? null
    ]);
});
