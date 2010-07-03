! Copyright (C) 2010 Niklas Waern.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.enums alien.syntax math ;
IN: x11.xinput2.constants

! From XI2.h

CONSTANT: XInput_2_0               7

CONSTANT: XI_2_Major               2
CONSTANT: XI_2_Minor               0

ENUM: xi2-property-event
    XIPropertyDeleted
    XIPropertyCreated
    XIPropertyModified ;

! Enter/Leave and Focus In/Out modes
ENUM: xi2-notify-mode
    XINotifyNormal
    XINotifyGrab
    XINotifyUngrab
    XINotifyWhileGrabbed
    XINotifyPassiveGrab
    XINotifyPassiveUngrab ;

! Enter/Leave and Focus In/Out detail
ENUM: xi2-notify-detail
    XINotifyAncestor
    XINotifyVirtual
    XINotifyInferior
    XINotifyNonlinear
    XINotifyNonlinearVirtual
    XINotifyPointer
    XINotifyPointerRoot
    XINotifyDetailNone ;

ENUM: xi2-passive-grab-type
    XIGrabtypeButton
    XIGrabtypeKeycode
    XIGrabtypeEnter
    XIGrabtypeFocusIn ;

! Passive grab modifiers
: XIAnyModifier ( -- n ) 31 2^ ; inline
CONSTANT: XIAnyButton    0
CONSTANT: XIAnyKeycode   0

! XIAllowEvents event modes
ENUM: xi2-allow-events-mode
    XIAsyncDevice
    XISyncDevice
    XIReplayDevice
    XIAsyncPairedDevice
    XIAsyncPair
    XISyncPair ;

! DeviceChangedEvent change reasons
ENUM: xi2-device-change-reason
  { XISlaveSwitch 1 }
    XIDeviceChange ;

! Hierarchy flags
: XIMasterAdded    ( -- n ) 0 2^ ; inline
: XIMasterRemoved  ( -- n ) 1 2^ ; inline
: XISlaveAdded     ( -- n ) 2 2^ ; inline
: XISlaveRemoved   ( -- n ) 3 2^ ; inline
: XISlaveAttached  ( -- n ) 4 2^ ; inline
: XISlaveDetached  ( -- n ) 5 2^ ; inline
: XIDeviceEnabled  ( -- n ) 6 2^ ; inline
: XIDeviceDisabled ( -- n ) 7 2^ ; inline

ENUM: xi2-hierarchy-change-type
  { XIAddMaster 1 }
    XIRemoveMaster
    XIAttachSlave
    XIDetachSlave ;

! XIRemoveMasterInfo return modes
ENUM: xi2-remove-master-return-mode
  { XIAttachToMaster 1 }
    XIFloating ;

ENUM: xi2-valuator-mode
    XIModeRelative
    XIModeAbsolute ;

ENUM: xi2-device-type
  { XIMasterPointer 1 }
    XIMasterKeyboard
    XISlavePointer
    XISlaveKeyboard
    XIFloatingSlave ;

ENUM: xi2-device-class
    XIKeyClass
    XIButtonClass
    XIValuatorClass ;

! Device event flags (common)
! Device event flags (key events only)
: XIKeyRepeat ( -- n ) 16 2^ ; inline
! Device event flags (pointer events only)

! Fake device ids
ENUM: xi2-device-id
    XIAllDevices
    XIAllMasterDevices ;

ENUM: xi2-event-type
  { XI_DeviceChanged 1 }
    XI_KeyPress
    XI_KeyRelease
    XI_ButtonPress
    XI_ButtonRelease
    XI_Motion
    XI_Enter
    XI_Leave
    XI_FocusIn
    XI_FocusOut
    XI_HierarchyChanged
    XI_PropertyEvent
    XI_RawKeyPress
    XI_RawKeyRelease
    XI_RawButtonPress
    XI_RawButtonRelease
    XI_RawMotion ;

: XI_LASTEVENT ( -- n ) XI_RawMotion ; inline

! Event masks
: XI_DeviceChangedMask    ( -- n ) XI_DeviceChanged    enum>number 2^ ; inline
: XI_KeyPressMask         ( -- n ) XI_KeyPress         enum>number 2^ ; inline
: XI_KeyReleaseMask       ( -- n ) XI_KeyRelease       enum>number 2^ ; inline
: XI_ButtonPressMask      ( -- n ) XI_ButtonPress      enum>number 2^ ; inline
: XI_ButtonReleaseMask    ( -- n ) XI_ButtonRelease    enum>number 2^ ; inline
: XI_MotionMask           ( -- n ) XI_Motion           enum>number 2^ ; inline
: XI_EnterMask            ( -- n ) XI_Enter            enum>number 2^ ; inline
: XI_LeaveMask            ( -- n ) XI_Leave            enum>number 2^ ; inline
: XI_FocusInMask          ( -- n ) XI_FocusIn          enum>number 2^ ; inline
: XI_FocusOutMask         ( -- n ) XI_FocusOut         enum>number 2^ ; inline
: XI_HierarchyChangedMask ( -- n ) XI_HierarchyChanged enum>number 2^ ; inline
: XI_PropertyEventMask    ( -- n ) XI_PropertyEvent    enum>number 2^ ; inline
: XI_RawKeyPressMask      ( -- n ) XI_RawKeyPress      enum>number 2^ ; inline
: XI_RawKeyReleaseMask    ( -- n ) XI_RawKeyRelease    enum>number 2^ ; inline
: XI_RawButtonPressMask   ( -- n ) XI_RawButtonPress   enum>number 2^ ; inline
: XI_RawButtonReleaseMask ( -- n ) XI_RawButtonRelease enum>number 2^ ; inline
: XI_RawMotionMask        ( -- n ) XI_RawMotion        enum>number 2^ ; inline



! From x11.constants and x11.xlib; repeating here to be able
! to use them as enums in xinput2 code without having to switch
! all of x11 over.
ENUM: x-grabmode
    XGrabModeSync
    XGrabModeAsync ;

ENUM: x-propmode
    XPropModeReplace
    XPropModePrepend
    XPropModeAppend ;

ENUM: x-event-type
  { X_KeyPress 2 }
    X_KeyRelease
    X_ButtonPress
    X_ButtonRelease
    X_MotionNotify
    X_EnterNotify
    X_LeaveNotify
    X_FocusIn
    X_FocusOut
    X_KeymapNotify
    X_Expose
    X_GraphicsExpose
    X_NoExpose
    X_VisibilityNotify
    X_CreateNotify
    X_DestroyNotify
    X_UnmapNotify
    X_MapNotify
    X_MapRequest
    X_ReparentNotify
    X_ConfigureNotify
    X_ConfigureRequest
    X_GravityNotify
    X_ResizeNotify
    X_CirculateNotify
    X_CirculateRequest
    X_PropertyNotify
    X_SelectionClear
    X_SelectionRequest
    X_SelectionNotify
    X_ColormapNotify
    X_ClientMessage
    X_MappingNotify
    X_GenericEvent
    X_LASTEvent ;

