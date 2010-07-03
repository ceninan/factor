! Copyright (C) 2010 Erik Charlebois, William Schlieper, Niklas Waern.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors alien.c-types alien.data arrays kernel game.input
namespaces math classes bit-arrays system sequences vectors
x11 x11.xlib assocs generalizations unix.linux.udev
unix.linux.udev.ffi destructors math.parser combinators
combinators.short-circuit threads io.backend.unix.multiplexers
locals unix.ffi ;
IN: game.input.linux

SINGLETON: linux-game-input-backend

SYMBOLS: +udev+ +monitor+ +monitor-thread+
         +controllers+ ;

linux-game-input-backend game-input-backend set-global


<PRIVATE

TUPLE: controller-handle device fd ;

: <input-monitor> ( -- monitor )
    +udev+ get-global "udev" udev_monitor_new_from_netlink
    [
        [
            "input" f
            udev_monitor_filter_add_match_subsystem_devtype
            drop
        ]
        [ udev_monitor_enable_receiving drop ]
        bi
    ] keep ;


: controller-device? ( device -- ? )
    {
        [
            "ID_INPUT_JOYSTICK"
            udev_device_get_property_value "1" =
        ]
        [ udev_device_get_sysname "event" head? ]
    } 1&& ;

: controllers-only ( devices -- controllers )
    [ controller-device? ] partition
    [ udev_device_unref ] each ;


:: controller-open ( device -- controller )
    controller new
        controller-handle new
            device >>device
            device udev_device_get_devnode O_RDWR 0 open
            [ >>fd ] keep
            0 < [
                "Failed to open controller device." throw
            ] when
        >>handle ;

: controller-close ( controller -- )
    handle>> [ device>> udev_device_unref ] [ fd>> close drop ] bi ;

:: controller-add ( device -- )
    device "ID_PATH" udev_device_get_property_value
    +controllers+ get-global
    [
        [ controller-close ] when*
        device controller-open
    ] change-at ;

: controller-remove ( device -- )
    [
        "ID_PATH" udev_device_get_property_value
        +controllers+ get-global delete-at* [
            controller-close
        ] [ drop ] if
    ] keep udev_device_unref ;


: handle-udev-event ( event -- )
    dup controller-device? [
        dup udev_device_get_action
        {
            { "add"     [ controller-add ] }
            { "remove"  [ controller-remove ] }
            ! { "change"  [ ] }
            ! { "online"  [ ] }
            ! { "offline" [ ] }
            [ "what's this udev action?" throw ]
        } case
    ] [ udev_device_unref ] if ;

: spawn-udev-listener ( -- thread )
    [
        [
            self
            +monitor+ get-global udev_monitor_get_fd
            mx get-global
            add-input-callback
            "udev device changes" suspend drop

            +monitor+ get-global [ stop ] unless

            +monitor+ get-global
            udev_monitor_receive_device
            handle-udev-event
            t
        ] loop
    ] "game.input.udev-monitor" spawn ;


: find-controller-devices ( -- controllers )
    [
        +udev+ get-global udev_enumerate_new &udev_enumerate_unref
        [
            "ID_INPUT_JOYSTICK" "1"
            udev_enumerate_add_match_property drop
        ] keep
        +udev+ get-global scan-devices
        controllers-only
    ] with-destructors ;


: setup-controllers ( -- )
    H{ } clone +controllers+ set-global
    <input-monitor> +monitor+ set-global
    spawn-udev-listener +monitor-thread+ set-global
    find-controller-devices [ controller-add ] each ;

PRIVATE>


M: linux-game-input-backend (open-game-input)
    udev_new +udev+ set-global
    setup-controllers ;

M: linux-game-input-backend (close-game-input)
    +controllers+
    [ values [ controller-close ] each f ] change-global
    +monitor+ [ udev_monitor_unref f ] change-global
    +monitor-thread+ [ resume f ] change-global
    +udev+ [ udev_unref f ] change-global ;

M: linux-game-input-backend (reset-game-input)
    ;

M: linux-game-input-backend get-controllers
    +controllers+ get-global values ;

M: linux-game-input-backend product-string
    handle>> device>>
    [ "ID_VENDOR" udev_device_get_property_value ]
    [ "ID_MODEL" udev_device_get_property_value ]
    bi 2array harvest " " join ;
     
M: linux-game-input-backend product-id
    handle>> device>>
    [ "ID_VENDOR_ID" udev_device_get_property_value ]
    [ "ID_MODEL_ID" udev_device_get_property_value ]
    bi [ hex> ] bi@ 2array ;
     
M: linux-game-input-backend instance-id
    handle>> device>>
    "ID_PATH" udev_device_get_property_value ;
     
M: linux-game-input-backend read-controller
    drop controller-state new ;
     
M: linux-game-input-backend calibrate-controller
    drop ;
     
M: linux-game-input-backend vibrate-controller
    3drop ;

HOOK: x>hid-bit-order os ( -- x )

M: linux x>hid-bit-order
    {
        0 0 0 0 0 0 0 0 
        0 41 30 31 32 33 34 35 
        36 37 38 39 45 46 42 43 
        20 26 8 21 23 28 24 12 
        18 19 47 48 40 224 4 22 
        7 9 10 11 13 14 15 51 
        52 53 225 49 29 27 6 25 
        5 17 16 54 55 56 229 85 
        226 44 57 58 59 60 61 62 
        63 64 65 66 67 83 71 95 
        96 97 86 92 93 94 87 91 
        90 89 98 99 0 0 0 68 
        69 0 0 0 0 0 0 0 
        88 228 84 70 0 0 74 82 
        75 80 79 77 81 78 73 76 
        127 129 128 102 103 0 72 0 
        0 0 0 227 231 0 0 0 
        0 0 0 0 0 0 0 0 
        0 0 0 0 0 0 0 0 
        0 0 0 0 0 0 0 0 
        0 0 0 0 0 0 0 0 
        0 0 0 0 0 0 0 0 
        0 0 0 0 0 0 0 0 
        0 0 0 0 0 0 0 0 
        0 0 0 0 0 0 0 0 
        0 0 0 0 0 0 0 0 
        0 0 0 0 0 0 0 0 
        0 0 0 0 0 0 0 0 
        0 0 0 0 0 0 0 0 
        0 0 0 0 0 0 0 0 
        0 0 0 0 0 0 0 0 
        0 0 0 0 0 0 0 0 
    } ; inline
     
: x-bits>hid-bits ( bit-array -- bit-array )
    256 iota [ 2array ] { } 2map-as [ first ] filter values
    x>hid-bit-order [ nth ] curry map
    256 <bit-array> swap [ t swap pick set-nth ] each ;
        
M: linux-game-input-backend read-keyboard
    dpy get 256 <bit-array> [ XQueryKeymap drop ] keep
    x-bits>hid-bits keyboard-state boa ;

: query-pointer ( -- x y buttons )
    dpy get dup XDefaultRootWindow
    { int int int int int int int }
    [ XQueryPointer drop ] [ ] with-out-parameters
    [ 4 ndrop ] 3dip ;

SYMBOL: mouse-reset?
     
M: linux-game-input-backend read-mouse
    mouse-reset? get [ reset-mouse ] unless
    query-pointer
    mouse-state new
    swap 256 /i >>buttons
    swap 400 - >>dy
    swap 400 - >>dx
    0 >>scroll-dy 0 >>scroll-dx ;
     
M: linux-game-input-backend reset-mouse
    dpy get dup XDefaultRootWindow dup
    0 0 0 0 400 400 XWarpPointer drop t mouse-reset? set-global ;
