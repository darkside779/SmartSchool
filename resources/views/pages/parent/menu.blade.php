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