<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class HelperServiceProvider extends ServiceProvider
{
    public function register()
    {
        // Register the Qs class in the container
        $this->app->bind('Qs', function ($app) {
            return new \App\Helpers\Qs();
        });
    }

    public function boot()
    {
        //
    }
}
