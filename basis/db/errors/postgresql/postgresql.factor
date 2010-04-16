! Copyright (C) 2010 Niklas Waern.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors combinators db.errors kernel regexp sequences ;
IN: db.errors.postgresql

: table-name ( message -- table )
    R/ \".+\"/ first-match
    [ CHAR: " = ] trim ;

: parse-postgresql-sql-error ( location summary message error-code -- error' )
    {
        { "42P01"  [ nip table-name <sql-table-missing> ] }
        { "42P07"  [ nip table-name <sql-table-exists>  ] }
        { "42883"  [ drop <sql-function-missing> ] }
        { "42723"  [ drop <sql-function-exists>  ] }
        { "42601"  [ drop <sql-syntax-error>     ] }
        [ 2drop <sql-unknown-error> ]
    } case swap >>location ;

