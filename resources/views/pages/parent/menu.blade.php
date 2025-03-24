{{--My Children--}}
<li class="nav-item">
    <a href="{{ route('my_children') }}" class="nav-link {{ in_array(Route::currentRouteName(), ['my_children']) ? 'active' : '' }}">
        <i class="icon-users4"></i>
        <span>My Children</span>
    </a>
</li>

{{--Children Attendance--}}
<li class="nav-item">
    <a href="{{ route('attendance.children') }}" class="nav-link {{ in_array(Route::currentRouteName(), ['attendance.children', 'attendance.child.show']) ? 'active' : '' }}">
        <i class="icon-calendar"></i>
        <span>Attendance</span>
    </a>
</li>

{{--Children Timetables--}}
@php
    $children = App\Models\StudentRecord::where('my_parent_id', Auth::user()->id)
        ->with(['user:id,name', 'my_class:id,name', 'section:id,name'])
        ->get();
@endphp
<li class="nav-item nav-item-submenu {{ in_array(Route::currentRouteName(), ['timetables.children', 'timetables.child.show']) ? 'nav-item-expanded nav-item-open' : '' }}">
    <a href="#" class="nav-link">
        <i class="icon-calendar3"></i>
        <span>Timetables</span>
    </a>

    <ul class="nav nav-group-sub" data-submenu-title="Timetables" style="{{ in_array(Route::currentRouteName(), ['timetables.children', 'timetables.child.show']) ? 'display: block;' : '' }}">
        @foreach($children as $child)
            <li class="nav-item">
                <a href="{{ route('timetables.child.show', $child->id) }}" 
                   class="nav-link {{ Request::is('timetables/child/'.$child->id) ? 'active' : '' }}">
                    {{ $child->user->name }} 
                    <small class="d-block text-muted">
                        {{ $child->my_class->name }} - {{ $child->section->name }}
                    </small>
                </a>
            </li>
        @endforeach
    </ul>
</li>

{{--Children Payments--}}
@php
    $children = App\Models\StudentRecord::where('my_parent_id', Auth::user()->id)
        ->with(['user:id,name', 'my_class:id,name', 'section:id,name'])
        ->get();
@endphp
<li class="nav-item nav-item-submenu {{ in_array(Route::currentRouteName(), ['payments.children', 'payments.child.show']) ? 'nav-item-expanded nav-item-open' : '' }}">
    <a href="#" class="nav-link">
        <i class="icon-cash3"></i>
        <span>Payments</span>
    </a>

    <ul class="nav nav-group-sub" data-submenu-title="Payments" style="{{ in_array(Route::currentRouteName(), ['payments.children', 'payments.child.show']) ? 'display: block;' : '' }}">
        @foreach($children as $child)
            <li class="nav-item">
                <a href="{{ route('payments.child.show', $child->id) }}" 
                   class="nav-link {{ Request::is('payments/child/'.$child->id) ? 'active' : '' }}">
                    {{ $child->user->name }} 
                    <small class="d-block text-muted">
                        {{ $child->my_class->name }} - {{ $child->section->name }}
                    </small>
                </a>
            </li>
        @endforeach
    </ul>
</li>