@extends('layouts.master')
@section('page_title', 'Payment Details')
@section('content')

<div class="card">
    <div class="card-header header-elements-inline">
        <h6 class="card-title">
            Payment Details for {{ $student->user->name }}
            <br>
            <small class="text-muted">Class: {{ $student->my_class->name }} - Section: {{ $student->section->name }}</small>
        </h6>
        <div class="header-elements">
            <a href="{{ route('payments.children') }}" class="btn btn-secondary">Go Back</a>
        </div>
    </div>

    <div class="card-body">
        {{-- Current Year Payment Statistics --}}
        <div class="mb-3">
            <h4 class="text-muted">Current Year ({{ $current_year }}) Summary</h4>
        </div>
        <div class="row mb-4">
            <div class="col-sm-6 col-xl-3">
                <div class="card card-body bg-blue-400 has-bg-image">
                    <div class="media">
                        <div class="media-body">
                            <h3 class="mb-0">{{ number_format($total_fees, 2) }}</h3>
                            <span class="text-uppercase font-size-xs">Total Fees</span>
                        </div>
                        <div class="ml-3 align-self-center">
                            <i class="icon-cash4 icon-3x opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-xl-3">
                <div class="card card-body bg-success-400 has-bg-image">
                    <div class="media">
                        <div class="media-body">
                            <h3 class="mb-0">{{ number_format($total_paid, 2) }}</h3>
                            <span class="text-uppercase font-size-xs">Amount Paid</span>
                        </div>
                        <div class="ml-3 align-self-center">
                            <i class="icon-coins icon-3x opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-xl-3">
                <div class="card card-body {{ $total_balance > 0 ? 'bg-danger-400' : 'bg-success-400' }} has-bg-image">
                    <div class="media">
                        <div class="media-body">
                            <h3 class="mb-0">{{ number_format($total_balance, 2) }}</h3>
                            <span class="text-uppercase font-size-xs">Balance</span>
                        </div>
                        <div class="ml-3 align-self-center">
                            <i class="icon-wallet icon-3x opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-xl-3">
                <div class="card card-body {{ $payment_status == 'Paid' ? 'bg-success-400' : 'bg-danger-400' }} has-bg-image">
                    <div class="media">
                        <div class="media-body">
                            <h3 class="mb-0">{{ $payment_status }}</h3>
                            <span class="text-uppercase font-size-xs">Status</span>
                        </div>
                        <div class="ml-3 align-self-center">
                            <i class="icon-stack-check icon-3x opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        {{-- Payment Records By Year --}}
        @foreach($payments_by_year as $year => $payments)
            <div class="card mb-3">
                <div class="card-header header-elements-inline">
                    <h5 class="card-title">Payments for Year {{ $year }}</h5>
                    @php
                        $year_total = $payments->sum(function($pr) { return $pr->payment ? $pr->payment->amount : 0; });
                        $year_paid = $payments->sum('amt_paid');
                        $year_balance = $year_total - $year_paid;
                    @endphp
                    <div class="header-elements">
                        <span class="badge {{ $year_balance > 0 ? 'badge-danger' : 'badge-success' }}">
                            Balance: {{ number_format($year_balance, 2) }}
                        </span>
                    </div>
                </div>

                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-striped">
                            <thead>
                                <tr>
                                    <th>S/N</th>
                                    <th>Title</th>
                                    <th>Amount</th>
                                    <th>Amount Paid</th>
                                    <th>Balance</th>
                                    <th>Payment Date</th>
                                    <th>Status</th>
                                    <th>Receipt</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($payments as $key => $pr)
                                    <tr>
                                        <td>{{ $key + 1 }}</td>
                                        <td>{{ $pr->payment->title }}</td>
                                        <td>{{ number_format($pr->payment->amount, 2) }}</td>
                                        <td>{{ number_format($pr->amt_paid, 2) }}</td>
                                        <td>{{ number_format($pr->balance, 2) }}</td>
                                        <td>{{ $pr->created_at->format('d/m/Y') }}</td>
                                        <td>
                                            <span class="badge {{ $pr->paid ? 'badge-success' : 'badge-danger' }}">
                                                {{ $pr->paid ? 'Paid' : 'Outstanding' }}
                                            </span>
                                        </td>
                                        <td>
                                            @if($pr->receipt->count() > 0)
                                                <a href="{{ route('payments.pdf_receipts', $pr->id) }}" target="_blank" class="btn btn-sm btn-info">
                                                    <i class="icon-printer"></i> Print
                                                </a>
                                            @else
                                                <span class="text-muted">No Receipt</span>
                                            @endif
                                        </td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        @endforeach
    </div>
</div>

@endsection

@section('page_scripts')
<script src="{{ asset('global_assets/js/plugins/tables/datatables/datatables.min.js') }}"></script>
<script>
    $('.table').DataTable({
        ordering: false
    });
</script>
@endsection
