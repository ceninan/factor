! Copyright (C) 2010 Niklas Waern.
! See http://factorcode.org/license.txt for BSD license.
USING: alien alien.c-types alien.enums alien.libraries
alien.syntax classes.struct locals sequences x11.syntax
x11.xlib x11.xinput2.constants ;
EXCLUDE: math => float ;
IN: x11.xinput2.ffi

<< "xinput2" "libXi.so" cdecl add-library >>

LIBRARY: xinput2


! *********
! * XI2.h *
! *********
<PRIVATE
: mask-index   ( event -- n ) enum>number -3 shift ;
: bitmask      ( event -- n ) enum>number 7 bitand 2^ ;
PRIVATE>

:: XISetMask ( mask event -- )
    event mask-index :> index
    event bitmask index mask nth bitor
    index mask set-nth ; inline

:: XIClearMask ( mask event -- )
    event mask-index :> index
    event bitmask bitnot index mask nth bitand
    index mask set-nth ; inline

:: XIMaskIsSet ( mask event -- n )
    event mask-index :> index
    event bitmask index mask nth bitand ;

: XIMaskLen ( event -- n ) enum>number 7 + -3 shift ;


! *************
! * XInput2.h *
! *************
STRUCT: XIAddMasterInfo
    { type      xi2-hierarchy-change-type }
    { name      c-string                  }
    { send_core bool                      }
    { enable    bool                      } ;

STRUCT: XIRemoveMasterInfo
    { type            xi2-hierarchy-change-type     }
    { deviceid        xi2-device-id                 }
    { return_mode     xi2-remove-master-return-mode }
    { return_pointer  xi2-device-id                 }
    { return_keyboard xi2-device-id                 } ;

STRUCT: XIAttachSlaveInfo
    { type       xi2-hierarchy-change-type }
    { deviceid   xi2-device-id             }
    { new_master xi2-device-id             } ;

STRUCT: XIDetachSlaveInfo
    { type     xi2-hierarchy-change-type }
    { deviceid xi2-device-id             } ;

UNION-STRUCT: XIAnyHierarchyChangeInfo
    { type   xi2-hierarchy-change-type }
    { add    XIAddMasterInfo           }
    { remove XIRemoveMasterInfo        }
    { attach XIAttachSlaveInfo         }
    { detach XIDetachSlaveInfo         } ;

STRUCT: XIModifierState
    { base int }
    { latched int }
    { locked int }
    { effective int } ;

TYPEDEF: XIModifierState XIGroupState

STRUCT: XIButtonState
    { mask_len int    }
    { mask     uchar* } ;

STRUCT: XIValuatorState
    { mask_len int     }
    { mask     uchar*  }
    { values   double* } ;

STRUCT: XIEventMask
    { deviceid xi2-device-id }
    { mask_len int           }
    { mask     uchar*        } ;

STRUCT: XIAnyClassInfo
    { type     xi2-device-class }
    { sourceid xi2-device-id    } ;

STRUCT: XIButtonClassInfo
    { type        xi2-device-class }
    { sourceid    xi2-device-id    }
    { num_buttons int              }
    { labels      Atom*            }
    { state       XIButtonState    } ;

STRUCT: XIKeyClassInfo
    { type         xi2-device-class }
    { sourceid     xi2-device-id    }
    { num_keycodes int              }
    { keycodes     int*             } ;

! number - the axis number
! mode - absolute or relative
STRUCT: XIValuatorClassInfo
    { type       xi2-device-class  }
    { sourceid   xi2-device-id     }
    { number     int               }
    { label      Atom              }
    { min        double            }
    { max        double            }
    { value      double            }
    { resolution int               }
    { mode       xi2-valuator-mode } ;

STRUCT: XIDeviceInfo
    { deviceid    xi2-device-id    }
    { name        c-string         }
    { use         xi2-device-type  }
    { attachment  xi2-device-id    }
    { enabled     bool             }
    { num_classes int              }
    { classes     XIAnyClassInfo** } ;

STRUCT: XIGrabModifiers
    { modifiers int }
    { status int } ;

! Generic XI2 event. All XI2 events have the same header.
! type - x11.constants:GenericEvent
STRUCT: XIEvent
    { type       x-event-type   }
    { serial     ulong          }
    { send_event bool           }
    { display    Display*       }
    { extension  int            }
    { evtype     xi2-event-type }
    { time       Time           } ;

! flags - probably hierarchy flags in x11.xinput2.constants
STRUCT: XIHierarchyInfo
    { deviceid   xi2-device-id   }
    { attachment xi2-device-id   }
    { use        xi2-device-type }
    { enabled    bool            }
    { flags      int             } ;

! Notifies the client that the device hierarcy has been changed
! The client is expected to re-query the server for the device
! hierarchy.
! flags - probably hierarchy flags in x11.xinput2.constants
STRUCT: XIHierarchyEvent
    { type       x-event-type     }
    { serial     ulong            }
    { send_event bool             }
    { display    Display          }
    { extension  int              }
    { evtype     xi2-event-type   }
    { time       Time             }
    { flags      int              }
    { num_info   int              }
    { info       XIHierarchyInfo* } ;

! Notifies the client that the classes have been changed.
! This happens when the slave device that sends through the
! master changes.
STRUCT: XIDeviceChangedEvent
    { type        x-event-type              }
    { serial      ulong                     }
    { send_event  bool                      }
    { display     Display*                  }
    { extension   int                       }
    { evtype      xi2-event-type            }
    { time        Time                      }
    { deviceid    xi2-device-id             }
    { sourceid    xi2-device-id             }
    { reason      xi2-device-change-reason  }
    { num_classes int                       }
    { classes     XIAnyClassInfo**          } ;

! detail - button events: the button number after mapping
!          key events: keycode (supports 32bit)
!          motion events: 0
! flags - various flags; currently only XIKeyRepeat
STRUCT: XIDeviceEvent
    { type       x-event-type    }
    { serial     ulong           }
    { send_event bool            }
    { display    Display*        }
    { extension  int             }
    { evtype     xi2-event-type  }
    { time       Time            }
    { deviceid   xi2-device-id   }
    { sourceid   xi2-device-id   }
    { detail     int             }
    { root       Window          }
    { event      Window          }
    { child      Window          }
    { root_x     double          }
    { root_y     double          }
    { event_x    double          }
    { event_y    double          }
    { flags      int             }
    { buttons    XIButtonState   }
    { valuators  XIValuatorState }
    { mods       XIModifierState }
    { group      XIGroupState    } ;

! detail, flags - probably the same as XIDeviceEvent
STRUCT: XIRawEvent
    { type       x-event-type    }
    { serial     ulong           }
    { send_event bool            }
    { display    Display*        }
    { extension  int             }
    { evtype     xi2-event-type  }
    { time       Time            }
    { deviceid   xi2-device-id   }
    { sourceid   xi2-device-id   }
    { detail     int             }
    { flags      int             }
    { valuators  XIValuatorState }
    { raw_values double*         } ;

STRUCT: XIEnterEvent
    { type        x-event-type      }
    { serial      ulong             }
    { send_event  bool              }
    { display     Display*          }
    { extension   int               }
    { evtype      xi2-event-type    }
    { time        Time              }
    { deviceid    xi2-device-id     }
    { sourceid    xi2-device-id     }
    { detail      xi2-notify-detail }
    { root        Window            }
    { event       Window            }
    { child       Window            }
    { root_x      double            }
    { root_y      double            }
    { event_x     double            }
    { event_y     double            }
    { mode        xi2-notify-mode   }
    { focus       bool              }
    { same_screen bool              }
    { buttons     XIButtonState     }
    { mods        XIModifierState   }
    { group       XIGroupState      } ;

TYPEDEF: XIEnterEvent XILeaveEvent
TYPEDEF: XIEnterEvent XIFocusInEvent
TYPEDEF: XIEnterEvent XIFocusOutEvent

STRUCT: XIPropertyEvent
    { type       x-event-type       }
    { serial     ulong              }
    { send_event bool               }
    { display    Display*           }
    { extension  int                }
    { evtype     xi2-event-type     }
    { time       Time               }
    { deviceid   xi2-device-id      }
    { property   Atom               }
    { what       xi2-property-event } ;



X-FUNCTION: bool XIQueryPointer (
    Display*         display,
    xi2-device-id    deviceid,
    Window           win,
    Window*          root,
    Window*          child,
    double*          root_x,
    double*          root_y,
    double*          win_x,
    double*          win_y,
    XIButtonState*   buttons,
    XIModifierState* modifiers,
    XIGroupState*    group ) ;

X-FUNCTION: bool XIWarpPointer (
    Display*      display,
    xi2-device-id deviceid,
    Window        src_win,
    Window        dst_win,
    double        src_x,
    double        src_y,
    uint          src_width,
    uint          src_height,
    double        dst_x,
    double        dst_y ) ;

X-FUNCTION: Status XIDefineCursor (
    Display*      display,
    xi2-device-id deviceid,
    Window        win,
    Cursor        cursor ) ;

X-FUNCTION: Status XIUndefineCursor (
    Display*      display,
    xi2-device-id deviceid,
    Window        win ) ;

X-FUNCTION: Status XIChangeHierarchy (
    Display*                  display,
    XIAnyHierarchyChangeInfo* changes,
    int                       num_changes ) ;

X-FUNCTION: Status XISetClientPointer (
    Display*      dpy,
    Window        win,
    xi2-device-id deviceid ) ;

X-FUNCTION: bool XIGetClientPointer (
    Display*       dpy,
    Window         win,
    xi2-device-id* deviceid ) ;

X-FUNCTION: int XISelectEvents (
    Display*     dpy,
    Window       win,
    XIEventMask* masks,
    int          num_masks ) ;

X-FUNCTION: XIEventMask* XIGetSelectedEvents (
    Display* dpy,
    Window   win,
    int*     num_masks_return ) ;

X-FUNCTION: Status XIQueryVersion (
    Display* display,
    int*     major_version_inout,
    int*     minor_version_inout ) ;

X-FUNCTION: XIDeviceInfo* XIQueryDevice (
    Display*      dpy,
    xi2-device-id deviceid,
    int*          ndevices_return ) ;

X-FUNCTION: Status XISetFocus (
    Display*      dpy,
    xi2-device-id deviceid,
    Window        focus,
    Time          time ) ;

X-FUNCTION: Status XIGetFocus (
    Display*      dpy,
    xi2-device-id deviceid,
    Window*       focus_return ) ;

! grab_mode, paired_device_mode: x11.constants.GrabMode(A)sync
X-FUNCTION: Status XIGrabDevice (
    Display*      dpy,
    xi2-device-id deviceid,
    Window        grab_window,
    Time          time,
    Cursor        cursor,
    x-grabmode    grab_mode,
    x-grabmode    paired_device_mode,
    bool          owner_events,
    XIEventMask*  mask ) ;

X-FUNCTION: Status XIUngrabDevice (
    Display*      dpy,
    xi2-device-id deviceid,
    Time          time ) ;

X-FUNCTION: Status XIAllowEvents (
    Display*              display,
    xi2-device-id         deviceid,
    xi2-allow-events-mode event_mode,
    Time                  time ) ;

! grab_mode, paired_device_mode: x11.constants.GrabMode(A)sync
X-FUNCTION: int XIGrabButton (
    Display*         display,
    xi2-device-id    deviceid,
    int              button,
    Window           grab_window,
    Cursor           cursor,
    x-grabmode       grab_mode,
    x-grabmode       paired_device_mode,
    bool             owner_events,
    XIEventMask*     mask,
    int              num_modifiers,
    XIGrabModifiers* modifiers_inout ) ;

! grab_mode, paired_device_mode: x11.constants.GrabMode(A)sync
X-FUNCTION: int XIGrabKeycode (
    Display*         display,
    xi2-device-id    deviceid,
    int              keycode,
    Window           grab_window,
    x-grabmode       grab_mode,
    x-grabmode       paired_device_mode,
    bool             owner_events,
    XIEventMask*     mask,
    int              num_modifiers,
    XIGrabModifiers* modifiers_inout ) ;

! grab_mode, paired_device_mode: x11.constants.GrabMode(A)sync
X-FUNCTION: int XIGrabEnter (
    Display*         display,
    xi2-device-id    deviceid,
    Window           grab_window,
    Cursor           cursor,
    x-grabmode       grab_mode,
    x-grabmode       paired_device_mode,
    bool             owner_events,
    XIEventMask*     mask,
    int              num_modifiers,
    XIGrabModifiers* modifiers_inout ) ;

! grab_mode, paired_device_mode: x11.constants.GrabMode(A)sync
X-FUNCTION: int XIGrabFocusIn (
    Display*         display,
    xi2-device-id    deviceid,
    Window           grab_window,
    x-grabmode       grab_mode,
    x-grabmode       paired_device_mode,
    bool             owner_events,
    XIEventMask*     mask,
    int              num_modifiers,
    XIGrabModifiers* modifiers_inout ) ;

X-FUNCTION: Status XIUngrabButton (
    Display*         display,
    xi2-device-id    deviceid,
    int              button,
    Window           grab_window,
    int              num_modifiers,
    XIGrabModifiers* modifiers ) ;

X-FUNCTION: Status XIUngrabKeycode (
    Display*         display,
    xi2-device-id    deviceid,
    int              keycode,
    Window           grab_window,
    int              num_modifiers,
    XIGrabModifiers* modifiers ) ;

X-FUNCTION: Status XIUngrabEnter (
    Display*         display,
    xi2-device-id    deviceid,
    Window           grab_window,
    int              num_modifiers,
    XIGrabModifiers* modifiers ) ;

X-FUNCTION: Status XIUngrabFocusIn (
    Display*         display,
    xi2-device-id    deviceid,
    Window           grab_window,
    int              num_modifiers,
    XIGrabModifiers* modifiers ) ;

X-FUNCTION: Atom* XIListProperties (
    Display*      display,
    xi2-device-id deviceid,
    int*          num_props_return ) ;

! format - Specifies whether the data should be viewed as a
!          list of 8-bit, 16-bit, or 32-bit quantities.
X-FUNCTION: void XIChangeProperty (
    Display*      display,
    xi2-device-id deviceid,
    Atom          property,
    Atom          type,
    int           format,
    x-propmode    mode,
    uchar*        data,
    int           num_items ) ;

X-FUNCTION: void XIDeleteProperty (
    Display*      display,
    xi2-device-id deviceid,
    Atom          property ) ;

X-FUNCTION: Status XIGetProperty (
    Display*      display,
    xi2-device-id deviceid,
    Atom          property,
    long          offset,
    long          length,
    bool          delete_property,
    Atom          type,
    Atom*         type_return,
    int*          format_return,
    ulong*        num_items_return,
    ulong*        bytes_after_return,
    uchar**       data ) ;

X-FUNCTION: void XIFreeDeviceInfo ( XIDeviceInfo* info ) ;

