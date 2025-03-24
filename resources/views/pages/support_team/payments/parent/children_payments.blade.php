@extends('layouts.master')
@section('page_title', 'My Children\'s Payments')
@section('content')

<div class="card">
    <div class="card-header header-elements-inline">
        <h6 class="card-title">My Children's Payments</h6>
    </div>

    <div class="card-body">
        @if($children->count() > 0)
            <div class="row">
                @foreach($children as $child)
                    @php
                        $payment_records = $child->payment_records;
                        $total_fees = $payment_records->sum(function($pr) {
                            return $pr->payment ? $pr->payment->amount : 0;
                        });
                        $total_paid = $payment_records->sum('amt_paid');
                        $balance = $total_fees - $total_paid;
                    @endphp
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="mr-3">
                                        <img class="rounded-circle" style="width: 60px; height: 60px;" src="{{ $child->user->photo }}" alt="">
                                    </div>
                                    <div class="flex-fill">
                                        <h5 class="mb-0">{{ $child->user->name }}</h5>
                                        <span class="text-muted">{{ $child->my_class->name }} - {{ $child->section->name }}</span>
                                    </div>
                                </div>
                                
                                <div class="mt-3">
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="text-muted">Total Fees:</span>
                                        <span class="font-weight-bold">{{ number_format($total_fees, 2) }}</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="text-muted">Amount Paid:</span>
                                        <span class="font-weight-bold text-success">{{ number_format($total_paid, 2) }}</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="text-muted">Balance:</span>
                                        <span class="font-weight-bold {{ $balance > 0 ? 'text-danger' : 'text-success' }}">
                                            {{ number_format($balance, 2) }}
                                        </span>
                                    </div>
                                    <div class="d-flex justify-content-between">
                                        <span class="text-muted">Status:</span>
                                        <span class="badge {{ $balance > 0 ? 'badge-danger' : 'badge-success' }}">
                                            {{ $balance > 0 ? 'Outstanding' : 'Paid' }}
                                        </span>
                                    </div>
                                </div>

                                <div class="mt-3 text-right">
                                    <a href="{{ route('payments.child.show', $child->id) }}" class="btn btn-info">
                                        <i class="icon-eye mr-2"></i>View Details
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                @endforeach
            </div>
        @else
            <div class="alert alert-info">
                No children found.
            </div>
        @endif
    </div>
</div>

@endsection
