! Copyright (C) 2010 Niklas Waern.
! See http://factorcode.org/license.txt for BSD license.
USING: alien assocs bit-arrays byte-arrays
help.markup help.syntax kernel libc math sequences strings
x11.xlib x11.xinput2.constants x11.xinput2.ffi ;
IN: x11.xinput2
EXCLUDE: alien.c-types => float ;

HELP: (device)
{ $values
    { "display" Display } { "device-id" xi2-device-id }
    { "device" XIDeviceInfo }
}
{ $description "" } ;

HELP: (device-properties)
{ $values
    { "display" Display } { "device-id" xi2-device-id }
    { "atoms" "an " { $link Atom } " array" }
}
{ $description "" } ;

HELP: (devices)
{ $values
    { "display" Display } { "device-id" xi2-device-id }
    { "device-array" "a " { $link XIDeviceInfo } " array" }
}
{ $description "" } ;

HELP: (raw-event>motion-data)
{ $values
    { "raw*" alien } { "accelerated*" alien } { "mask" bit-array }
    { "seq" sequence }
}
{ $description "" } ;

HELP: (xi-opcode)
{ $values
    { "display" Display }
    { "opcode" uint }
}
{ $description "" } ;

HELP: (xi2-available?)
{ $values
    { "display" Display }
    { "?" boolean }
}
{ $description "" } ;

HELP: <direct-Atom-array>
{ $values
    { "alien" alien } { "len" integer }
    { "specialized-array" "a specialized array" }
}
{ $description "" } ;

HELP: <motion-data>
{ $values
    { "axis" integer } { "raw" float } { "accelerated" float }
    { "motion-data" motion-data }
}
{ $description "" } ;

HELP: <xi2-event-mask>
{ $values
    { "seq" sequence }
    { "XIEventMask" XIEventMask }
}
{ $description "Construct a " { $link XIEventMask } "struct from a sequence of " { $link xi2-event-type } "." }
{ $notes "You should " { $link free } " the mask slot when you are done with the struct." } ;

HELP: alien>device-class
{ $values
    { "alien" alien }
    { "device-class" "a " { $links XIButtonClassInfo XIKeyClassInfo } " or " { $link XIValuatorClassInfo } }
}
{ $description "Returns the device class of the given alien." } ;

HELP: atom-names
{ $values
    { "atoms" sequence }
    { "seq" sequence }
}
{ $description "Maps a sequence of " { $link Atom } " to names, keeping 0 Atoms as " { $link f } " in the output." } ;

HELP: button-labels
{ $values
    { "button_class" XIButtonClassInfo }
    { "atom-array/f" "a " { $link sequence } " or " { $link f } }
}
{ $description "Returns the labels of the buttons of the given button class, or " { $link f } " if unavailable." } ;

HELP: button-mask
{ $values
    { "button_class" XIButtonClassInfo }
    { "byte-array" byte-array }
}
{ $description "Returns a mask where each bit corresponds to the pressed status of a button in the button class." } ;

HELP: button-names
{ $values
    { "button_class" XIButtonClassInfo }
    { "seq/f" "a " { $link sequence } " or " { $link f } }
}
{ $description "Returns a the button names or " { $link f } " if unavailable." } ;

HELP: device
{ $values
    { "device-id" xi2-device-id }
    { "device" XIDeviceInfo }
}
{ $description "Returns the device info of the given device id." }
{ $notes "You should free the result with " { $link XIFreeDeviceInfo } "." } ;

HELP: device-classes
{ $values
    { "device" XIDeviceInfo }
    { "seq" sequence }
}
{ $description "Returns the device classes (capabilities) of " { $snippet "device" } "." } ;

HELP: device-properties
{ $values
    { "device-id" xi2-device-id }
    { "atoms" "an " { $link Atom } " " { $link sequence } }
}
{ $description "Returns a list of property " { $link Atom } "s" }
{ $notes "You should free the resulting array with " { $link XFree } "." } ;

HELP: device-property-names
{ $values
    { "device-id" xi2-device-id }
    { "seq" sequence }
}
{ $description "Outputs a " { $link sequence } " with the names of device properties, with " { $link f } " where names are missing." } ;

HELP: devices
{ $values
    
    { "devices" "a " { $link XIDeviceInfo } " array" }
}
{ $description "Returns all detected devices." }
{ $notes "You should free the resulting array with " { $link XIFreeDeviceInfo } "." } ;

HELP: init-xi2
{ $description "Initialize the XInput2 wrapper. You should always call this unless you only use words where you provide your own X connection." } ;

HELP: motion-data
{ $var-description "" } ;

HELP: opcode
{ $var-description "" } ;

HELP: raw-event>motion-data
{ $values
    { "raw-event" XIRawEvent }
    { "seq" sequence }
}
{ $description "Returns a list of " { $link motion-data } "." } ;

HELP: valuator-name
{ $values
    { "valuator_class" XIValuatorClassInfo }
    { "string" string }
}
{ $description "Returns the name of a valuator class (axis)." } ;

HELP: xi-event?
{ $values
    { "event" XEvent }
    { "?" boolean }
}
{ $description "Checks if the event is a XI event." } ;

HELP: xi-opcode
{ $values
    
    { "opcode" uint }
}
{ $description "Returns the extension code of XInput." } ;

HELP: xi2-available?
{ $values
    
    { "?" boolean }
}
{ $description "Checks if XInput2 is available. Requires the X server to support the XInput extension - to see if it does, use " { $link XQueryExtension } "." }
{ $notes "This not only checks for XInput2 but also notifies the server that we support it." } ;

HELP: xi2-event-mask
{ $values
    { "seq" sequence }
    { "byte-array" byte-array }
}
{ $description "Takes a " { $link xi2-event-type } " sequence and returns a " { $link byte-array } " of size " { $link xi2-max-event-mask-size } " with the proper bits set." } ;

HELP: xi2-max-event-mask-size
{ $values
    
    { "n" integer }
}
{ $description "Returns the number of bytes needed to contain all event flags." } ;


{
    { valuator-name button-names button-labels }
    { devices device device-classes (device) (devices) }
    { xi-opcode (xi-opcode) opcode }
    { xi2-available? (xi2-available?) }
    { xi2-max-event-mask-size xi2-event-mask <xi2-event-mask> }
} [ related-words ] each


ARTICLE: "x11.xinput2" "x11.xinput2"
{ $vocab-link "x11.xinput2" }
;

ABOUT: "x11.xinput2"
