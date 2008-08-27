! Copyright (C) 2007 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: ui.gadgets colors kernel ui.render namespaces
       models models.mapping sequences ui.gadgets.buttons
       ui.gadgets.packs ui.gadgets.labels tools.deploy.config
       namespaces ui.gadgets.editors ui.gadgets.borders ui.gestures
       ui.commands assocs ui.gadgets.tracks ui ui.tools.listener
       tools.deploy vocabs ui.tools.workspace system accessors ;

IN: ui.tools.deploy

TUPLE: deploy-gadget < pack vocab settings ;

: bundle-name ( parent -- parent )
    deploy-name get <field>
    "Executable name:" label-on-left add-gadget ;

: deploy-ui ( parent -- parent )
    deploy-ui? get
    "Include user interface framework" <checkbox> add-gadget ;

: exit-when-windows-closed ( parent -- parent )
    "stop-after-last-window?" get
    "Exit when last UI window closed" <checkbox> add-gadget ;

: io-settings ( parent -- parent )
    "Input/output support:" <label> add-gadget
    deploy-io get deploy-io-options <radio-buttons> add-gadget ;

: reflection-settings ( parent -- parent )
    "Reflection support:" <label> add-gadget
    deploy-reflection get deploy-reflection-options <radio-buttons> add-gadget ;

: advanced-settings ( parent -- parent )
    "Advanced:" <label> add-gadget
    deploy-compiler? get "Use optimizing compiler" <checkbox> add-gadget
    deploy-math? get "Rational and complex number support" <checkbox> add-gadget
    deploy-threads? get "Threading support" <checkbox> add-gadget
    deploy-random? get "Random number generator support" <checkbox> add-gadget
    deploy-word-props? get "Retain all word properties" <checkbox> add-gadget
    deploy-word-defs? get "Retain all word definitions" <checkbox> add-gadget
    deploy-c-types? get "Retain all C types" <checkbox> add-gadget ;

: deploy-settings-theme ( gadget -- gadget )
  { 10 10 } >>gap
  1         >>fill ;

: <deploy-settings> ( vocab -- control )
    default-config [ <model> ] assoc-map
        [
            <pile>
            bundle-name
            deploy-ui
            os macosx? [ exit-when-windows-closed ] when
            io-settings
            reflection-settings
            advanced-settings

            deploy-settings-theme
            namespace <mapping> over set-gadget-model
        ]
    bind ;

: find-deploy-gadget ( gadget -- deploy-gadget )
    [ deploy-gadget? ] find-parent ;

: find-deploy-vocab ( gadget -- vocab )
    find-deploy-gadget deploy-gadget-vocab ;

: find-deploy-config ( gadget -- config )
    find-deploy-vocab deploy-config ;

: find-deploy-settings ( gadget -- settings )
    find-deploy-gadget deploy-gadget-settings ;

: com-revert ( gadget -- )
    dup find-deploy-config
    swap find-deploy-settings set-control-value ;

: com-save ( gadget -- )
    dup find-deploy-settings control-value
    swap find-deploy-vocab set-deploy-config ;

: com-deploy ( gadget -- )
    dup com-save
    dup find-deploy-vocab [ deploy ] curry call-listener
    close-window ;

: com-help ( -- )
    "ui.tools.deploy" help-window ;

\ com-help H{
    { +nullary+ t }
} define-command

: com-close ( gadget -- )
    close-window ;

deploy-gadget "toolbar" f {
    { f com-close }
    { f com-help }
    { f com-revert }
    { f com-save }
    { T{ key-down f f "RET" } com-deploy }
} define-command-map

: <deploy-gadget> ( vocab -- gadget )
    deploy-gadget new-gadget
      over                           >>vocab
      { 0 1 }                        >>orientation
      swap <deploy-settings>         >>settings    
      dup settings>>                 add-gadget
      dup <toolbar> { 10 10 } >>gap  add-gadget
    deploy-settings-theme
    dup com-revert ;
    
: deploy-tool ( vocab -- )
    vocab-name dup <deploy-gadget> 10 <border>
    "Deploying \"" rot "\"" 3append open-window ;