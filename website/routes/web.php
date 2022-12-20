<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/


/*
 * These routes use the root namespace 'App\Http\Controllers\Web'.
 */
Route::namespace('Web')->group(function () {

    // All the folder based web routes
    include_route_files('web');
    Route::get('/', 'FrontPageController@index')->name('index');
    Route::get('/driverpage', 'FrontPageController@driverp')->name('driverpage');
    Route::get('/howdriving', 'FrontPageController@howdrive')->name('howdriving');
    Route::get('/driverrequirements', 'FrontPageController@driverrequirement')->name('driverrequirements');
    Route::get('/safety', 'FrontPageController@safetypage')->name('safety');
    Route::get('/serviceareas', 'FrontPageController@serviceareaspage')->name('serviceareas');
    Route::get('/compliance', 'FrontPageController@complaincepage')->name('complaince');
    Route::get('/privacy', 'FrontPageController@privacypage')->name('privacy');
    Route::get('/terms', 'FrontPageController@termspage')->name('terms');
    Route::get('/dmv', 'FrontPageController@dmvpage')->name('dmv');
    Route::get('/contactus', 'FrontPageController@contactuspage')->name('contactus');
    Route::post('/contactussendmail','FrontPageController@contactussendmailadd')->name('contactussendmail');


    Route::get('/myfatoorah-wallet-payment-success', 'MyFatoorahController@MyfatoorahWalletPaymentSuccess');
    Route::get('/myfatoorah-wallet-payment-error', 'MyFatoorahController@MyfatoorahWalletPaymentError');

    Route::get('/myfatoorah-driver-wallet-payment-success', 'MyFatoorahController@MyfatoorahDriverWalletPaymentSuccess');
    Route::get('/myfatoorah-driver-wallet-payment-error', 'MyFatoorahController@MyfatoorahDriverWalletPaymentError');

    Route::get('/myfatoorah-ride-payment-success', 'MyFatoorahController@MyfatoorahRidePaymentSuccess');
    Route::get('/myfatoorah-ride-payment-error', 'MyFatoorahController@MyfatoorahRidePaymentError');



    // Website home route
    //Route::get('/', 'HomeController@index')->name('home');
    Route::get('/foo', function () {
        Artisan::call('storage:link');
    });

});