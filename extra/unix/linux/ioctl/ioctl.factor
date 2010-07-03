! Copyright (C) 2010 Niklas Waern.
! See http://factorcode.org/license.txt for BSD license.
USING: locals math ;
IN: unix.linux.ioctl

CONSTANT: _IOC_NRBITS   8
CONSTANT: _IOC_TYPEBITS 8

! Arch may override
CONSTANT: _IOC_SIZEBITS 14
CONSTANT: _IOC_DIRBITS 2

! Arch may override
CONSTANT: _IOC_NONE  0
CONSTANT: _IOC_WRITE 1
CONSTANT: _IOC_READ  2


: _IOC_NRMASK   ( -- n ) _IOC_NRBITS   2^ 1 - ; inline
: _IOC_TYPEMASK ( -- n ) _IOC_TYPEBITS 2^ 1 - ; inline
: _IOC_SIZEMASK ( -- n ) _IOC_SIZEBITS 2^ 1 - ; inline
: _IOC_DIRMASK  ( -- n ) _IOC_DIRBITS  2^ 1 - ; inline

CONSTANT: _IOC_NRSHIFT 0
: _IOC_TYPESHIFT ( -- n ) _IOC_NRSHIFT   _IOC_NRBITS   + ; inline
: _IOC_SIZESHIFT ( -- n ) _IOC_TYPESHIFT _IOC_TYPEBITS + ; inline
: _IOC_DIRSHIFT  ( -- n ) _IOC_SIZESHIFT _IOC_SIZEBITS + ; inline

:: _IOC ( dir type nr size -- n )
    dir  _IOC_DIRSHIFT  shift
    type _IOC_TYPESHIFT shift bitor
    nr   _IOC_NRSHIFT   shift bitor
    size _IOC_SIZESHIFT shift bitor ; inline

! Caller is responsible for calculating proper length, unlike C
! : _IOC_TYPECHECK ( t -- n ) heap-size ; inline
: _IOC_TYPECHECK ( t -- n ) ; inline

! Used to create numbers
:: _IO ( type nr -- n ) _IOC_NONE type nr 0 _IOC ; inline
:: _IOR ( type nr size -- n )
    _IOC_READ type nr size _IOC_TYPECHECK _IOC ; inline
:: _IOW ( type nr size -- n )
    _IOC_WRITE type nr size _IOC_TYPECHECK _IOC ; inline
:: _IOWR ( type nr size -- n )
    _IOC_READ _IOC_WRITE bitor type nr size _IOC_TYPECHECK _IOC ; inline
:: _IOR_BAD ( type nr size -- n )
    _IOC_READ type nr size _IOC ; inline
:: _IOW_BAD ( type nr size -- n )
    _IOC_WRITE type nr size _IOC ; inline
:: _IOWR_BAD ( type nr size -- n )
    _IOC_READ _IOC_WRITE bitor type nr size _IOC ; inline

! Used to decode ioctl numbers...
: _IOC_DIR ( nr -- n )
    _IOC_DIRSHIFT neg shift _IOC_DIRMASK bitand ; inline
: _IOC_TYPE ( nr -- n )
    _IOC_TYPESHIFT neg shift _IOC_TYPEMASK bitand ; inline
: _IOC_NR ( nr -- n )
    _IOC_NRSHIFT neg shift _IOC_NRMASK bitand ; inline
: _IOC_SIZE ( nr -- n )
    _IOC_SIZESHIFT neg shift _IOC_NRMASK bitand ; inline

! ...and for the drivers/sound files...

: IOC_IN        ( -- n ) _IOC_WRITE _IOC_DIRSHIFT shift ; inline
: IOC_OUT       ( -- n ) _IOC_READ  _IOC_DIRSHIFT shift ; inline
: IOC_INOUT     ( -- n ) _IOC_WRITE _IOC_READ bitor _IOC_DIRSHIFT shift ; inline
: IOCSIZE_MASK  ( -- n ) _IOC_SIZEMASK _IOC_SIZESHIFT shift ; inline
: IOCSIZE_SHIFT ( -- n ) _IOC_SIZESHIFT ; inline
