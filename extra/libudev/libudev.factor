! Copyright (C) 2010 Niklas Waern.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors combinators destructors kernel locals
libudev.ffi sequences ;
IN: libudev

: udev-list-entries ( first_entry -- seq )
    [ ] collector [ udev_list_entry_foreach ] dip ;


: <udev> ( -- alien ) udev_new ; inline
: <enumerate> ( udev -- alien ) udev_enumerate_new ; inline


: (scan-devices) ( enumerate -- syspaths )
    [
        udev_enumerate_scan_devices 0 = [
            "udev_enumerate_scan_devices failed." throw
        ] unless
    ] keep
    udev_enumerate_get_list_entry udev-list-entries
    [ udev_list_entry_get_name ] map ;

:: scan-devices ( enumerate udev -- devices )
    enumerate (scan-devices)
    [| syspath |
            udev syspath udev_device_new_from_syspath
    ] map ;
