! Copyright (C) 2010 Niklas Waern.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors alien alien.c-types alien.data alien.enums
assocs bit-arrays classes.struct combinators
combinators.short-circuit io.binary kernel locals math.bitwise
namespaces pack sequences specialized-arrays x11 x11.constants
x11.xinput2.constants x11.xinput2.ffi x11.xlib ;
EXCLUDE: math => float ;
IN: x11.xinput2

SPECIALIZED-ARRAYS: XIDeviceInfo Atom double uchar void*  ;
ALIAS: <direct-Atom-array> <direct-ulong-array>

SYMBOL: opcode


: (xi2-available?) ( display -- ? )
    2 0 [ <int> ] bi@
    XIQueryVersion
    {
        { BadRequest [ f ] }
        { Success    [ t ] }
        [ "Internal Xlib error." throw ]
    } case ;

: xi2-available? ( -- ? ) dpy get (xi2-available?) ; inline


: (xi-opcode) ( display -- opcode )
    "XInputExtension" 0 0 0 [ <int> ] tri@
    [
        XQueryExtension c-bool> [
            "XInput extension not available." throw
        ] unless
    ] 3keep 2drop *uint ;

: xi-opcode ( -- opcode ) dpy get (xi-opcode) ; inline



: xi2-max-event-mask-size ( -- n )
    XI_LASTEVENT enum>number 7 + 8 /i ; inline

: xi2-event-mask ( seq -- byte-array )
    0 [ enum>number set-bit ] reduce
    xi2-max-event-mask-size >n-byte-array ;

: <xi2-event-mask> ( seq -- XIEventMask )
    xi2-event-mask malloc-byte-array
    XIEventMask <struct>
        swap >>mask
        xi2-max-event-mask-size >>mask_len
        XIAllMasterDevices >>deviceid ;


: xi-event? ( event -- ? )
    XGenericEventCookie>> {
        [ type>> GenericEvent = ]
        [ extension>> opcode get-global = ]
    } 1|| ;



: atom-names ( atoms -- seq )
    [
        dup 0 = [ drop f ] [ dpy get swap XGetAtomName ] if
    ] { } map-as ;

: button-labels ( button_class -- atom-array/f )
    [ labels>> ] [ num_buttons>> ] bi
    over *ulong 0 = [ 2drop f ] [ <direct-Atom-array> ] if ;

: button-names ( button_class -- seq/f )
    button-labels [ atom-names ] [ f ] if* ;

: button-mask ( button_class -- byte-array )
    state>> [ mask>> ] [ mask_len>> ] bi memory>byte-array ;

: valuator-name ( valuator_class -- string )
    label>> dpy get swap XGetAtomName ;


TUPLE: motion-data axis raw accelerated ;
C: <motion-data> motion-data

<PRIVATE
: get-set-bits ( bit-array -- seq )
    t swap indices ;
PRIVATE>

:: (raw-event>motion-data) ( raw* accelerated* mask -- seq )
    mask get-set-bits
    raw* accelerated*
    [ mask bit-count <direct-double-array> ] bi@
    [ <motion-data> ] 3map ;

: raw-event>motion-data ( raw-event -- seq )
    [ raw_values>> ]
    [ valuators>>  ] bi
        [ values>>   ]
        [ mask>>     ]
        [ mask_len>> ] tri
    memory>byte-array le> integer>bit-array
    (raw-event>motion-data) ;


: alien>device-class ( alien -- device-class )
    dup XIAnyClassInfo memory>struct type>>
    {
        { XIKeyClass      [ XIKeyClassInfo      ] }
        { XIButtonClass   [ XIButtonClassInfo   ] }
        { XIValuatorClass [ XIValuatorClassInfo ] }
        [ "Unknow XInput2 class type." throw ]
    } case
    memory>struct ;

: device-classes ( device -- seq )
    [ classes>> ] [ num_classes>> ] bi
    <direct-void*-array> [ alien>device-class ] { } map-as ;


: (devices) ( display device-id -- device-array )
    0 <int> [ XIQueryDevice >c-ptr ] keep
    *uint <direct-XIDeviceInfo-array> ;

: devices ( -- devices )
    dpy get XIAllDevices (devices) ; inline

: (device) ( display device-id -- device )
    (devices) first ; inline

: device ( device-id -- device )
    [ dpy get ] dip (device) ; inline


: (device-properties) ( display device-id -- atoms )
    0 <int> [ XIListProperties ] keep
    *uint <direct-Atom-array> ;

: device-properties ( device-id -- atoms )
    [ dpy get ] dip (device-properties) ; inline

: device-property-names ( device-id -- seq )
    device-properties dup atom-names swap XFree ;


: init-xi2 ( -- )
    dpy get [ f init-x ] unless
    xi-opcode opcode set-global
    xi2-available? [ "XInput2 not available." throw ] unless ;
