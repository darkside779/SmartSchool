<link rel="icon" href="{{ asset('global_assets/images/favicon.png') }}">

{{--<!-- Global stylesheets -->--}}
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,300,100,500,700,900" rel="stylesheet" type="text/css">
    <link href="{{ asset('global_assets/css/icons/icomoon/styles.css') }}" rel="stylesheet" type="text/css">
    <link href=" {{ asset('assets/css/bootstrap.min.css') }}" rel="stylesheet" type="text/css">
    <link href=" {{ asset('assets/css/bootstrap_limitless.min.css') }}" rel="stylesheet" type="text/css">
    <link href=" {{ asset('assets/css/layout.min.css') }}" rel="stylesheet" type="text/css">
    <link href=" {{ asset('assets/css/components.min.css') }}" rel="stylesheet" type="text/css">
    <link href=" {{ asset('assets/css/colors.min.css') }}" rel="stylesheet" type="text/css">
    
    @if(app()->getLocale() == 'ar')
        <!-- RTL stylesheets -->
        <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@200;300;400;600;700&display=swap" rel="stylesheet">
        <link href="{{ asset('assets/css/bootstrap-rtl.min.css') }}" rel="stylesheet" type="text/css">
        <link href="{{ asset('assets/css/custom-rtl.css') }}" rel="stylesheet" type="text/css">
        <style>
            body, h1, h2, h3, h4, h5, h6, .h1, .h2, .h3, .h4, .h5, .h6 {
                font-family: 'Cairo', sans-serif !important;
            }
            .sidebar-user-material-menu > a {
                text-align: right;
            }
            .nav-group-sub {
                padding-right: 0;
            }
            .form-check {
                padding-right: 1.75rem;
                padding-left: 0;
            }
            .form-check-input {
                margin-right: -1.75rem;
                margin-left: 0;
            }
            .card-header {
                text-align: right;
            }
            .dropdown-menu {
                text-align: right;
            }
            .nav {
                padding-right: 0;
            }
            .navbar-nav {
                padding-right: 0;
            }
            .dl-horizontal dt {
                float: right;
                clear: right;
                text-align: left;
            }
            .dl-horizontal dd {
                margin-right: 180px;
                margin-left: 0;
            }
        </style>
    @endif
    <!-- /global stylesheets -->

   
{{--DatePickers--}}
<link rel="stylesheet" href="{{ asset('assets/css/bootstrap-datepicker.min.css') }}" type="text/css">

{{-- Custom App CSS--}}
<link href=" {{ asset('assets/css/qs.css') }}" rel="stylesheet" type="text/css">

{{--   Core JS files --}}
    <script src="{{ asset('global_assets/js/main/jquery.min.js') }} "></script>
    <script src="{{ asset('global_assets/js/main/bootstrap.bundle.min.js') }} "></script>
    <script src="{{ asset('global_assets/js/plugins/loaders/blockui.min.js') }} "></script>
