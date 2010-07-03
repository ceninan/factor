! Copyright (C) 2010 Niklas Waern.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.c-types alien.syntax classes.struct kernel locals
unix.linux.ioctl unix.time unix.types ;
EXCLUDE: math => float ;
IN: unix.linux.input

CONSTANT: EV_VERSION HEX: 010000

! Event types
CONSTANT: EV_SYN       HEX: 00
CONSTANT: EV_KEY       HEX: 01
CONSTANT: EV_REL       HEX: 02
CONSTANT: EV_ABS       HEX: 03
CONSTANT: EV_MSC       HEX: 04
CONSTANT: EV_SW        HEX: 05
CONSTANT: EV_LED       HEX: 11
CONSTANT: EV_SND       HEX: 12
CONSTANT: EV_REP       HEX: 14
CONSTANT: EV_FF        HEX: 15
CONSTANT: EV_PWR       HEX: 16
CONSTANT: EV_FF_STATUS HEX: 17
CONSTANT: EV_MAX       HEX: 1f
: EV_CNT ( -- n )      EV_MAX 1 + ; inline


! Synchronization events
CONSTANT: SYN_REPORT    0
CONSTANT: SYN_CONFIG    1
CONSTANT: SYN_MT_REPORT 2


! Keys and buttons
CONSTANT: KEY_RESERVED 0
CONSTANT: KEY_ESC 1
CONSTANT: KEY_1 2
CONSTANT: KEY_2 3
CONSTANT: KEY_3 4
CONSTANT: KEY_4 5
CONSTANT: KEY_5 6
CONSTANT: KEY_6 7
CONSTANT: KEY_7 8
CONSTANT: KEY_8 9
CONSTANT: KEY_9 10
CONSTANT: KEY_0 11
CONSTANT: KEY_MINUS 12
CONSTANT: KEY_EQUAL 13
CONSTANT: KEY_BACKSPACE 14
CONSTANT: KEY_TAB 15
CONSTANT: KEY_Q 16
CONSTANT: KEY_W 17
CONSTANT: KEY_E 18
CONSTANT: KEY_R 19
CONSTANT: KEY_T 20
CONSTANT: KEY_Y 21
CONSTANT: KEY_U 22
CONSTANT: KEY_I 23
CONSTANT: KEY_O 24
CONSTANT: KEY_P 25
CONSTANT: KEY_LEFTBRACE 26
CONSTANT: KEY_RIGHTBRACE 27
CONSTANT: KEY_ENTER 28
CONSTANT: KEY_LEFTCTRL 29
CONSTANT: KEY_A 30
CONSTANT: KEY_S 31
CONSTANT: KEY_D 32
CONSTANT: KEY_F 33
CONSTANT: KEY_G 34
CONSTANT: KEY_H 35
CONSTANT: KEY_J 36
CONSTANT: KEY_K 37
CONSTANT: KEY_L 38
CONSTANT: KEY_SEMICOLON 39
CONSTANT: KEY_APOSTROPHE 40
CONSTANT: KEY_GRAVE 41
CONSTANT: KEY_LEFTSHIFT 42
CONSTANT: KEY_BACKSLASH 43
CONSTANT: KEY_Z 44
CONSTANT: KEY_X 45
CONSTANT: KEY_C 46
CONSTANT: KEY_V 47
CONSTANT: KEY_B 48
CONSTANT: KEY_N 49
CONSTANT: KEY_M 50
CONSTANT: KEY_COMMA 51
CONSTANT: KEY_DOT 52
CONSTANT: KEY_SLASH 53
CONSTANT: KEY_RIGHTSHIFT 54
CONSTANT: KEY_KPASTERISK 55
CONSTANT: KEY_LEFTALT 56
CONSTANT: KEY_SPACE 57
CONSTANT: KEY_CAPSLOCK 58
CONSTANT: KEY_F1 59
CONSTANT: KEY_F2 60
CONSTANT: KEY_F3 61
CONSTANT: KEY_F4 62
CONSTANT: KEY_F5 63
CONSTANT: KEY_F6 64
CONSTANT: KEY_F7 65
CONSTANT: KEY_F8 66
CONSTANT: KEY_F9 67
CONSTANT: KEY_F10 68
CONSTANT: KEY_NUMLOCK 69
CONSTANT: KEY_SCROLLLOCK 70
CONSTANT: KEY_KP7 71
CONSTANT: KEY_KP8 72
CONSTANT: KEY_KP9 73
CONSTANT: KEY_KPMINUS 74
CONSTANT: KEY_KP4 75
CONSTANT: KEY_KP5 76
CONSTANT: KEY_KP6 77
CONSTANT: KEY_KPPLUS 78
CONSTANT: KEY_KP1 79
CONSTANT: KEY_KP2 80
CONSTANT: KEY_KP3 81
CONSTANT: KEY_KP0 82
CONSTANT: KEY_KPDOT 83

CONSTANT: KEY_ZENKAKUHANKAKU 85
CONSTANT: KEY_102ND 86
CONSTANT: KEY_F11 87
CONSTANT: KEY_F12 88
CONSTANT: KEY_RO 89
CONSTANT: KEY_KATAKANA 90
CONSTANT: KEY_HIRAGANA 91
CONSTANT: KEY_HENKAN 92
CONSTANT: KEY_KATAKANAHIRAGANA 93
CONSTANT: KEY_MUHENKAN 94
CONSTANT: KEY_KPJPCOMMA 95
CONSTANT: KEY_KPENTER 96
CONSTANT: KEY_RIGHTCTRL 97
CONSTANT: KEY_KPSLASH 98
CONSTANT: KEY_SYSRQ 99
CONSTANT: KEY_RIGHTALT 100
CONSTANT: KEY_LINEFEED 101
CONSTANT: KEY_HOME 102
CONSTANT: KEY_UP 103
CONSTANT: KEY_PAGEUP 104
CONSTANT: KEY_LEFT 105
CONSTANT: KEY_RIGHT 106
CONSTANT: KEY_END 107
CONSTANT: KEY_DOWN 108
CONSTANT: KEY_PAGEDOWN 109
CONSTANT: KEY_INSERT 110
CONSTANT: KEY_DELETE 111
CONSTANT: KEY_MACRO 112
CONSTANT: KEY_MUTE 113
CONSTANT: KEY_VOLUMEDOWN 114
CONSTANT: KEY_VOLUMEUP 115
CONSTANT: KEY_POWER 116
CONSTANT: KEY_KPEQUAL 117
CONSTANT: KEY_KPPLUSMINUS 118
CONSTANT: KEY_PAUSE 119
CONSTANT: KEY_SCALE 120

CONSTANT: KEY_KPCOMMA 121
CONSTANT: KEY_HANGEUL 122
CONSTANT: KEY_HANGUEL 122
CONSTANT: KEY_HANJA 123
CONSTANT: KEY_YEN 124
CONSTANT: KEY_LEFTMETA 125
CONSTANT: KEY_RIGHTMETA 126
CONSTANT: KEY_COMPOSE 127

CONSTANT: KEY_STOP 128
CONSTANT: KEY_AGAIN 129
CONSTANT: KEY_PROPS 130
CONSTANT: KEY_UNDO 131
CONSTANT: KEY_FRONT 132
CONSTANT: KEY_COPY 133
CONSTANT: KEY_OPEN 134
CONSTANT: KEY_PASTE 135
CONSTANT: KEY_FIND 136
CONSTANT: KEY_CUT 137
CONSTANT: KEY_HELP 138
CONSTANT: KEY_MENU 139
CONSTANT: KEY_CALC 140
CONSTANT: KEY_SETUP 141
CONSTANT: KEY_SLEEP 142
CONSTANT: KEY_WAKEUP 143
CONSTANT: KEY_FILE 144
CONSTANT: KEY_SENDFILE 145
CONSTANT: KEY_DELETEFILE 146
CONSTANT: KEY_XFER 147
CONSTANT: KEY_PROG1 148
CONSTANT: KEY_PROG2 149
CONSTANT: KEY_WWW 150
CONSTANT: KEY_MSDOS 151
CONSTANT: KEY_COFFEE 152
CONSTANT: KEY_SCREENLOCK 152
CONSTANT: KEY_DIRECTION 153
CONSTANT: KEY_CYCLEWINDOWS 154
CONSTANT: KEY_MAIL 155
CONSTANT: KEY_BOOKMARKS 156
CONSTANT: KEY_COMPUTER 157
CONSTANT: KEY_BACK 158
CONSTANT: KEY_FORWARD 159
CONSTANT: KEY_CLOSECD 160
CONSTANT: KEY_EJECTCD 161
CONSTANT: KEY_EJECTCLOSECD 162
CONSTANT: KEY_NEXTSONG 163
CONSTANT: KEY_PLAYPAUSE 164
CONSTANT: KEY_PREVIOUSSONG 165
CONSTANT: KEY_STOPCD 166
CONSTANT: KEY_RECORD 167
CONSTANT: KEY_REWIND 168
CONSTANT: KEY_PHONE 169
CONSTANT: KEY_ISO 170
CONSTANT: KEY_CONFIG 171
CONSTANT: KEY_HOMEPAGE 172
CONSTANT: KEY_REFRESH 173
CONSTANT: KEY_EXIT 174
CONSTANT: KEY_MOVE 175
CONSTANT: KEY_EDIT 176
CONSTANT: KEY_SCROLLUP 177
CONSTANT: KEY_SCROLLDOWN 178
CONSTANT: KEY_KPLEFTPAREN 179
CONSTANT: KEY_KPRIGHTPAREN 180
CONSTANT: KEY_NEW 181
CONSTANT: KEY_REDO 182

CONSTANT: KEY_F13 183
CONSTANT: KEY_F14 184
CONSTANT: KEY_F15 185
CONSTANT: KEY_F16 186
CONSTANT: KEY_F17 187
CONSTANT: KEY_F18 188
CONSTANT: KEY_F19 189
CONSTANT: KEY_F20 190
CONSTANT: KEY_F21 191
CONSTANT: KEY_F22 192
CONSTANT: KEY_F23 193
CONSTANT: KEY_F24 194

CONSTANT: KEY_PLAYCD 200
CONSTANT: KEY_PAUSECD 201
CONSTANT: KEY_PROG3 202
CONSTANT: KEY_PROG4 203
CONSTANT: KEY_DASHBOARD 204
CONSTANT: KEY_SUSPEND 205
CONSTANT: KEY_CLOSE 206
CONSTANT: KEY_PLAY 207
CONSTANT: KEY_FASTFORWARD 208
CONSTANT: KEY_BASSBOOST 209
CONSTANT: KEY_PRINT 210
CONSTANT: KEY_HP 211
CONSTANT: KEY_CAMERA 212
CONSTANT: KEY_SOUND 213
CONSTANT: KEY_QUESTION 214
CONSTANT: KEY_EMAIL 215
CONSTANT: KEY_CHAT 216
CONSTANT: KEY_SEARCH 217
CONSTANT: KEY_CONNECT 218
CONSTANT: KEY_FINANCE 219
CONSTANT: KEY_SPORT 220
CONSTANT: KEY_SHOP 221
CONSTANT: KEY_ALTERASE 222
CONSTANT: KEY_CANCEL 223
CONSTANT: KEY_BRIGHTNESSDOWN 224
CONSTANT: KEY_BRIGHTNESSUP 225
CONSTANT: KEY_MEDIA 226

CONSTANT: KEY_SWITCHVIDEOMODE 227

CONSTANT: KEY_KBDILLUMTOGGLE 228
CONSTANT: KEY_KBDILLUMDOWN 229
CONSTANT: KEY_KBDILLUMUP 230

CONSTANT: KEY_SEND 231
CONSTANT: KEY_REPLY 232
CONSTANT: KEY_FORWARDMAIL 233
CONSTANT: KEY_SAVE 234
CONSTANT: KEY_DOCUMENTS 235

CONSTANT: KEY_BATTERY 236

CONSTANT: KEY_BLUETOOTH 237
CONSTANT: KEY_WLAN 238
CONSTANT: KEY_UWB 239

CONSTANT: KEY_UNKNOWN 240

CONSTANT: KEY_VIDEO_NEXT 241
CONSTANT: KEY_VIDEO_PREV 242
CONSTANT: KEY_BRIGHTNESS_CYCLE 243
CONSTANT: KEY_BRIGHTNESS_ZERO 244
CONSTANT: KEY_DISPLAY_OFF 245

CONSTANT: KEY_WIMAX 246


CONSTANT: BTN_MISC HEX: 100
CONSTANT: BTN_0 HEX: 100
CONSTANT: BTN_1 HEX: 101
CONSTANT: BTN_2 HEX: 102
CONSTANT: BTN_3 HEX: 103
CONSTANT: BTN_4 HEX: 104
CONSTANT: BTN_5 HEX: 105
CONSTANT: BTN_6 HEX: 106
CONSTANT: BTN_7 HEX: 107
CONSTANT: BTN_8 HEX: 108
CONSTANT: BTN_9 HEX: 109

CONSTANT: BTN_MOUSE HEX: 110
CONSTANT: BTN_LEFT HEX: 110
CONSTANT: BTN_RIGHT HEX: 111
CONSTANT: BTN_MIDDLE HEX: 112
CONSTANT: BTN_SIDE HEX: 113
CONSTANT: BTN_EXTRA HEX: 114
CONSTANT: BTN_FORWARD HEX: 115
CONSTANT: BTN_BACK HEX: 116
CONSTANT: BTN_TASK HEX: 117

CONSTANT: BTN_JOYSTICK HEX: 120
CONSTANT: BTN_TRIGGER HEX: 120
CONSTANT: BTN_THUMB HEX: 121
CONSTANT: BTN_THUMB2 HEX: 122
CONSTANT: BTN_TOP HEX: 123
CONSTANT: BTN_TOP2 HEX: 124
CONSTANT: BTN_PINKIE HEX: 125
CONSTANT: BTN_BASE HEX: 126
CONSTANT: BTN_BASE2 HEX: 127
CONSTANT: BTN_BASE3 HEX: 128
CONSTANT: BTN_BASE4 HEX: 129
CONSTANT: BTN_BASE5 HEX: 12a
CONSTANT: BTN_BASE6 HEX: 12b
CONSTANT: BTN_DEAD HEX: 12f

CONSTANT: BTN_GAMEPAD HEX: 130
CONSTANT: BTN_A HEX: 130
CONSTANT: BTN_B HEX: 131
CONSTANT: BTN_C HEX: 132
CONSTANT: BTN_X HEX: 133
CONSTANT: BTN_Y HEX: 134
CONSTANT: BTN_Z HEX: 135
CONSTANT: BTN_TL HEX: 136
CONSTANT: BTN_TR HEX: 137
CONSTANT: BTN_TL2 HEX: 138
CONSTANT: BTN_TR2 HEX: 139
CONSTANT: BTN_SELECT HEX: 13a
CONSTANT: BTN_START HEX: 13b
CONSTANT: BTN_MODE HEX: 13c
CONSTANT: BTN_THUMBL HEX: 13d
CONSTANT: BTN_THUMBR HEX: 13e

CONSTANT: BTN_DIGI HEX: 140
CONSTANT: BTN_TOOL_PEN HEX: 140
CONSTANT: BTN_TOOL_RUBBER HEX: 141
CONSTANT: BTN_TOOL_BRUSH HEX: 142
CONSTANT: BTN_TOOL_PENCIL HEX: 143
CONSTANT: BTN_TOOL_AIRBRUSH HEX: 144
CONSTANT: BTN_TOOL_FINGER HEX: 145
CONSTANT: BTN_TOOL_MOUSE HEX: 146
CONSTANT: BTN_TOOL_LENS HEX: 147
CONSTANT: BTN_TOUCH HEX: 14a
CONSTANT: BTN_STYLUS HEX: 14b
CONSTANT: BTN_STYLUS2 HEX: 14c
CONSTANT: BTN_TOOL_DOUBLETAP HEX: 14d
CONSTANT: BTN_TOOL_TRIPLETAP HEX: 14e
CONSTANT: BTN_TOOL_QUADTAP HEX: 14f

CONSTANT: BTN_WHEEL HEX: 150
CONSTANT: BTN_GEAR_DOWN HEX: 150
CONSTANT: BTN_GEAR_UP HEX: 151

CONSTANT: KEY_OK HEX: 160
CONSTANT: KEY_SELECT HEX: 161
CONSTANT: KEY_GOTO HEX: 162
CONSTANT: KEY_CLEAR HEX: 163
CONSTANT: KEY_POWER2 HEX: 164
CONSTANT: KEY_OPTION HEX: 165
CONSTANT: KEY_INFO HEX: 166
CONSTANT: KEY_TIME HEX: 167
CONSTANT: KEY_VENDOR HEX: 168
CONSTANT: KEY_ARCHIVE HEX: 169
CONSTANT: KEY_PROGRAM HEX: 16a
CONSTANT: KEY_CHANNEL HEX: 16b
CONSTANT: KEY_FAVORITES HEX: 16c
CONSTANT: KEY_EPG HEX: 16d
CONSTANT: KEY_PVR HEX: 16e
CONSTANT: KEY_MHP HEX: 16f
CONSTANT: KEY_LANGUAGE HEX: 170
CONSTANT: KEY_TITLE HEX: 171
CONSTANT: KEY_SUBTITLE HEX: 172
CONSTANT: KEY_ANGLE HEX: 173
CONSTANT: KEY_ZOOM HEX: 174
CONSTANT: KEY_MODE HEX: 175
CONSTANT: KEY_KEYBOARD HEX: 176
CONSTANT: KEY_SCREEN HEX: 177
CONSTANT: KEY_PC HEX: 178
CONSTANT: KEY_TV HEX: 179
CONSTANT: KEY_TV2 HEX: 17a
CONSTANT: KEY_VCR HEX: 17b
CONSTANT: KEY_VCR2 HEX: 17c
CONSTANT: KEY_SAT HEX: 17d
CONSTANT: KEY_SAT2 HEX: 17e
CONSTANT: KEY_CD HEX: 17f
CONSTANT: KEY_TAPE HEX: 180
CONSTANT: KEY_RADIO HEX: 181
CONSTANT: KEY_TUNER HEX: 182
CONSTANT: KEY_PLAYER HEX: 183
CONSTANT: KEY_TEXT HEX: 184
CONSTANT: KEY_DVD HEX: 185
CONSTANT: KEY_AUX HEX: 186
CONSTANT: KEY_MP3 HEX: 187
CONSTANT: KEY_AUDIO HEX: 188
CONSTANT: KEY_VIDEO HEX: 189
CONSTANT: KEY_DIRECTORY HEX: 18a
CONSTANT: KEY_LIST HEX: 18b
CONSTANT: KEY_MEMO HEX: 18c
CONSTANT: KEY_CALENDAR HEX: 18d
CONSTANT: KEY_RED HEX: 18e
CONSTANT: KEY_GREEN HEX: 18f
CONSTANT: KEY_YELLOW HEX: 190
CONSTANT: KEY_BLUE HEX: 191
CONSTANT: KEY_CHANNELUP HEX: 192
CONSTANT: KEY_CHANNELDOWN HEX: 193
CONSTANT: KEY_FIRST HEX: 194
CONSTANT: KEY_LAST HEX: 195
CONSTANT: KEY_AB HEX: 196
CONSTANT: KEY_NEXT HEX: 197
CONSTANT: KEY_RESTART HEX: 198
CONSTANT: KEY_SLOW HEX: 199
CONSTANT: KEY_SHUFFLE HEX: 19a
CONSTANT: KEY_BREAK HEX: 19b
CONSTANT: KEY_PREVIOUS HEX: 19c
CONSTANT: KEY_DIGITS HEX: 19d
CONSTANT: KEY_TEEN HEX: 19e
CONSTANT: KEY_TWEN HEX: 19f
CONSTANT: KEY_VIDEOPHONE HEX: 1a0
CONSTANT: KEY_GAMES HEX: 1a1
CONSTANT: KEY_ZOOMIN HEX: 1a2
CONSTANT: KEY_ZOOMOUT HEX: 1a3
CONSTANT: KEY_ZOOMRESET HEX: 1a4
CONSTANT: KEY_WORDPROCESSOR HEX: 1a5
CONSTANT: KEY_EDITOR HEX: 1a6
CONSTANT: KEY_SPREADSHEET HEX: 1a7
CONSTANT: KEY_GRAPHICSEDITOR HEX: 1a8
CONSTANT: KEY_PRESENTATION HEX: 1a9
CONSTANT: KEY_DATABASE HEX: 1aa
CONSTANT: KEY_NEWS HEX: 1ab
CONSTANT: KEY_VOICEMAIL HEX: 1ac
CONSTANT: KEY_ADDRESSBOOK HEX: 1ad
CONSTANT: KEY_MESSENGER HEX: 1ae
CONSTANT: KEY_DISPLAYTOGGLE HEX: 1af
CONSTANT: KEY_SPELLCHECK HEX: 1b0
CONSTANT: KEY_LOGOFF HEX: 1b1

CONSTANT: KEY_DOLLAR HEX: 1b2
CONSTANT: KEY_EURO HEX: 1b3

CONSTANT: KEY_FRAMEBACK HEX: 1b4
CONSTANT: KEY_FRAMEFORWARD HEX: 1b5
CONSTANT: KEY_CONTEXT_MENU HEX: 1b6
CONSTANT: KEY_MEDIA_REPEAT HEX: 1b7

CONSTANT: KEY_DEL_EOL HEX: 1c0
CONSTANT: KEY_DEL_EOS HEX: 1c1
CONSTANT: KEY_INS_LINE HEX: 1c2
CONSTANT: KEY_DEL_LINE HEX: 1c3

CONSTANT: KEY_FN HEX: 1d0
CONSTANT: KEY_FN_ESC HEX: 1d1
CONSTANT: KEY_FN_F1 HEX: 1d2
CONSTANT: KEY_FN_F2 HEX: 1d3
CONSTANT: KEY_FN_F3 HEX: 1d4
CONSTANT: KEY_FN_F4 HEX: 1d5
CONSTANT: KEY_FN_F5 HEX: 1d6
CONSTANT: KEY_FN_F6 HEX: 1d7
CONSTANT: KEY_FN_F7 HEX: 1d8
CONSTANT: KEY_FN_F8 HEX: 1d9
CONSTANT: KEY_FN_F9 HEX: 1da
CONSTANT: KEY_FN_F10 HEX: 1db
CONSTANT: KEY_FN_F11 HEX: 1dc
CONSTANT: KEY_FN_F12 HEX: 1dd
CONSTANT: KEY_FN_1 HEX: 1de
CONSTANT: KEY_FN_2 HEX: 1df
CONSTANT: KEY_FN_D HEX: 1e0
CONSTANT: KEY_FN_E HEX: 1e1
CONSTANT: KEY_FN_F HEX: 1e2
CONSTANT: KEY_FN_S HEX: 1e3
CONSTANT: KEY_FN_B HEX: 1e4

CONSTANT: KEY_BRL_DOT1 HEX: 1f1
CONSTANT: KEY_BRL_DOT2 HEX: 1f2
CONSTANT: KEY_BRL_DOT3 HEX: 1f3
CONSTANT: KEY_BRL_DOT4 HEX: 1f4
CONSTANT: KEY_BRL_DOT5 HEX: 1f5
CONSTANT: KEY_BRL_DOT6 HEX: 1f6
CONSTANT: KEY_BRL_DOT7 HEX: 1f7
CONSTANT: KEY_BRL_DOT8 HEX: 1f8
CONSTANT: KEY_BRL_DOT9 HEX: 1f9
CONSTANT: KEY_BRL_DOT10 HEX: 1fa

CONSTANT: KEY_NUMERIC_0 HEX: 200
CONSTANT: KEY_NUMERIC_1 HEX: 201
CONSTANT: KEY_NUMERIC_2 HEX: 202
CONSTANT: KEY_NUMERIC_3 HEX: 203
CONSTANT: KEY_NUMERIC_4 HEX: 204
CONSTANT: KEY_NUMERIC_5 HEX: 205
CONSTANT: KEY_NUMERIC_6 HEX: 206
CONSTANT: KEY_NUMERIC_7 HEX: 207
CONSTANT: KEY_NUMERIC_8 HEX: 208
CONSTANT: KEY_NUMERIC_9 HEX: 209
CONSTANT: KEY_NUMERIC_STAR HEX: 20a
CONSTANT: KEY_NUMERIC_POUND HEX: 20b

CONSTANT: BTN_TRIGGER_HAPPY HEX: 2c0
CONSTANT: BTN_TRIGGER_HAPPY1 HEX: 2c0
CONSTANT: BTN_TRIGGER_HAPPY2 HEX: 2c1
CONSTANT: BTN_TRIGGER_HAPPY3 HEX: 2c2
CONSTANT: BTN_TRIGGER_HAPPY4 HEX: 2c3
CONSTANT: BTN_TRIGGER_HAPPY5 HEX: 2c4
CONSTANT: BTN_TRIGGER_HAPPY6 HEX: 2c5
CONSTANT: BTN_TRIGGER_HAPPY7 HEX: 2c6
CONSTANT: BTN_TRIGGER_HAPPY8 HEX: 2c7
CONSTANT: BTN_TRIGGER_HAPPY9 HEX: 2c8
CONSTANT: BTN_TRIGGER_HAPPY10 HEX: 2c9
CONSTANT: BTN_TRIGGER_HAPPY11 HEX: 2ca
CONSTANT: BTN_TRIGGER_HAPPY12 HEX: 2cb
CONSTANT: BTN_TRIGGER_HAPPY13 HEX: 2cc
CONSTANT: BTN_TRIGGER_HAPPY14 HEX: 2cd
CONSTANT: BTN_TRIGGER_HAPPY15 HEX: 2ce
CONSTANT: BTN_TRIGGER_HAPPY16 HEX: 2cf
CONSTANT: BTN_TRIGGER_HAPPY17 HEX: 2d0
CONSTANT: BTN_TRIGGER_HAPPY18 HEX: 2d1
CONSTANT: BTN_TRIGGER_HAPPY19 HEX: 2d2
CONSTANT: BTN_TRIGGER_HAPPY20 HEX: 2d3
CONSTANT: BTN_TRIGGER_HAPPY21 HEX: 2d4
CONSTANT: BTN_TRIGGER_HAPPY22 HEX: 2d5
CONSTANT: BTN_TRIGGER_HAPPY23 HEX: 2d6
CONSTANT: BTN_TRIGGER_HAPPY24 HEX: 2d7
CONSTANT: BTN_TRIGGER_HAPPY25 HEX: 2d8
CONSTANT: BTN_TRIGGER_HAPPY26 HEX: 2d9
CONSTANT: BTN_TRIGGER_HAPPY27 HEX: 2da
CONSTANT: BTN_TRIGGER_HAPPY28 HEX: 2db
CONSTANT: BTN_TRIGGER_HAPPY29 HEX: 2dc
CONSTANT: BTN_TRIGGER_HAPPY30 HEX: 2dd
CONSTANT: BTN_TRIGGER_HAPPY31 HEX: 2de
CONSTANT: BTN_TRIGGER_HAPPY32 HEX: 2df
CONSTANT: BTN_TRIGGER_HAPPY33 HEX: 2e0
CONSTANT: BTN_TRIGGER_HAPPY34 HEX: 2e1
CONSTANT: BTN_TRIGGER_HAPPY35 HEX: 2e2
CONSTANT: BTN_TRIGGER_HAPPY36 HEX: 2e3
CONSTANT: BTN_TRIGGER_HAPPY37 HEX: 2e4
CONSTANT: BTN_TRIGGER_HAPPY38 HEX: 2e5
CONSTANT: BTN_TRIGGER_HAPPY39 HEX: 2e6
CONSTANT: BTN_TRIGGER_HAPPY40 HEX: 2e7

CONSTANT: KEY_MIN_INTERESTING 113
CONSTANT: KEY_MAX HEX: 2ff
: KEY_CNT ( -- n ) KEY_MAX 1 + ; inline

! Relative axes
CONSTANT: REL_X HEX: 00
CONSTANT: REL_Y HEX: 01
CONSTANT: REL_Z HEX: 02
CONSTANT: REL_RX HEX: 03
CONSTANT: REL_RY HEX: 04
CONSTANT: REL_RZ HEX: 05
CONSTANT: REL_HWHEEL HEX: 06
CONSTANT: REL_DIAL HEX: 07
CONSTANT: REL_WHEEL HEX: 08
CONSTANT: REL_MISC HEX: 09
CONSTANT: REL_MAX HEX: 0f
: REL_CNT ( -- n ) REL_MAX 1 + ; inline

! Absolute axes
CONSTANT: ABS_X HEX: 00
CONSTANT: ABS_Y HEX: 01
CONSTANT: ABS_Z HEX: 02
CONSTANT: ABS_RX HEX: 03
CONSTANT: ABS_RY HEX: 04
CONSTANT: ABS_RZ HEX: 05
CONSTANT: ABS_THROTTLE HEX: 06
CONSTANT: ABS_RUDDER HEX: 07
CONSTANT: ABS_WHEEL HEX: 08
CONSTANT: ABS_GAS HEX: 09
CONSTANT: ABS_BRAKE HEX: 0a
CONSTANT: ABS_HATHEX:  HEX: 10
CONSTANT: ABS_HAT0Y HEX: 11
CONSTANT: ABS_HAT1X HEX: 12
CONSTANT: ABS_HAT1Y HEX: 13
CONSTANT: ABS_HAT2X HEX: 14
CONSTANT: ABS_HAT2Y HEX: 15
CONSTANT: ABS_HAT3X HEX: 16
CONSTANT: ABS_HAT3Y HEX: 17
CONSTANT: ABS_PRESSURE HEX: 18
CONSTANT: ABS_DISTANCE HEX: 19
CONSTANT: ABS_TILT_X HEX: 1a
CONSTANT: ABS_TILT_Y HEX: 1b
CONSTANT: ABS_TOOL_WIDTH HEX: 1c
CONSTANT: ABS_VOLUME HEX: 20
CONSTANT: ABS_MISC HEX: 28

CONSTANT: ABS_MT_TOUCH_MAJOR HEX: 30
CONSTANT: ABS_MT_TOUCH_MINOR HEX: 31
CONSTANT: ABS_MT_WIDTH_MAJOR HEX: 32
CONSTANT: ABS_MT_WIDTH_MINOR HEX: 33
CONSTANT: ABS_MT_ORIENTATION HEX: 34
CONSTANT: ABS_MT_POSITION_X HEX: 35
CONSTANT: ABS_MT_POSITION_Y HEX: 36
CONSTANT: ABS_MT_TOOL_TYPE HEX: 37
CONSTANT: ABS_MT_BLOB_ID HEX: 38
CONSTANT: ABS_MT_TRACKING_ID HEX: 39
CONSTANT: ABS_MT_PRESSURE HEX: 3a

CONSTANT: ABS_MAX HEX: 3f
: ABS_CNT ( -- n ) ABS_MAX 1 + ; inline

! Switch events
CONSTANT: SW_LID HEX: 00
CONSTANT: SW_TABLET_MODE HEX: 01
CONSTANT: SW_HEADPHONE_INSERT HEX: 02
CONSTANT: SW_RFKILL_ALL HEX: 03

CONSTANT: SW_RADIO HEX: 03
CONSTANT: SW_MICROPHONE_INSERT HEX: 04
CONSTANT: SW_DOCK HEX: 05
CONSTANT: SW_LINEOUT_INSERT HEX: 06
CONSTANT: SW_JACK_PHYSICAL_INSERT HEX: 07
CONSTANT: SW_VIDEOOUT_INSERT HEX: 08
CONSTANT: SW_MAX HEX: 0f
: SW_CNT ( -- n ) SW_MAX 1 + ; inline

! Misc events
CONSTANT: MSC_SERIAL HEX: 00
CONSTANT: MSC_PULSELED HEX: 01
CONSTANT: MSC_GESTURE HEX: 02
CONSTANT: MSC_RAW HEX: 03
CONSTANT: MSC_SCAN HEX: 04
CONSTANT: MSC_MAX HEX: 07
: MSC_CNT ( -- n ) MSC_MAX 1 + ; inline

! LEDs
CONSTANT: LED_NUML HEX: 00
CONSTANT: LED_CAPSL HEX: 01
CONSTANT: LED_SCROLLL HEX: 02
CONSTANT: LED_COMPOSE HEX: 03
CONSTANT: LED_KANA HEX: 04
CONSTANT: LED_SLEEP HEX: 05
CONSTANT: LED_SUSPEND HEX: 06
CONSTANT: LED_MUTE HEX: 07
CONSTANT: LED_MISC HEX: 08
CONSTANT: LED_MAIL HEX: 09
CONSTANT: LED_CHARGING HEX: 0a
CONSTANT: LED_MAX HEX: 0f
: LED_CNT ( -- n ) LED_MAX 1 + ; inline

! Autorepeat values
CONSTANT: REP_DELAY HEX: 00
CONSTANT: REP_PERIOD HEX: 01
CONSTANT: REP_MAX HEX: 01

! Sounds
CONSTANT: SND_CLICK HEX: 00
CONSTANT: SND_BELL HEX: 01
CONSTANT: SND_TONE HEX: 02
CONSTANT: SND_MAX HEX: 07
: SND_CNT ( -- n ) SND_MAX 1 + ; inline

! IDs
CONSTANT: ID_BUS 0
CONSTANT: ID_VENDOR 1
CONSTANT: ID_PRODUCT 2
CONSTANT: ID_VERSION 3

CONSTANT: BUS_PCI HEX: 01
CONSTANT: BUS_ISAPNP HEX: 02
CONSTANT: BUS_USB HEX: 03
CONSTANT: BUS_HIL HEX: 04
CONSTANT: BUS_BLUETOOTH HEX: 05
CONSTANT: BUS_VIRTUAL HEX: 06

CONSTANT: BUS_ISA HEX: 10
CONSTANT: BUS_I8042 HEX: 11
CONSTANT: BUS_XTKBD HEX: 12
CONSTANT: BUS_RS232 HEX: 13
CONSTANT: BUS_GAMEPORT HEX: 14
CONSTANT: BUS_PARPORT HEX: 15
CONSTANT: BUS_AMIGA HEX: 16
CONSTANT: BUS_ADB HEX: 17
CONSTANT: BUS_I2C HEX: 18
CONSTANT: BUS_HOST HEX: 19
CONSTANT: BUS_GSC HEX: 1A
CONSTANT: BUS_ATARI HEX: 1B

! MT_TOOL types
CONSTANT: MT_TOOL_FINGER 0
CONSTANT: MT_TOOL_PEN 1

! Values describing the status of a force-feedback effect
CONSTANT: FF_STATUS_STOPPED HEX: 00
CONSTANT: FF_STATUS_PLAYING HEX: 01
CONSTANT: FF_STATUS_MAX HEX: 01


! Force feedback effect types
CONSTANT: FF_RUMBLE HEX: 50
CONSTANT: FF_PERIODIC HEX: 51
CONSTANT: FF_CONSTANT HEX: 52
CONSTANT: FF_SPRING HEX: 53
CONSTANT: FF_FRICTION HEX: 54
CONSTANT: FF_DAMPER HEX: 55
CONSTANT: FF_INERTIA HEX: 56
CONSTANT: FF_RAMP HEX: 57

: FF_EFFECT_MIN ( -- n ) FF_RUMBLE ; inline
: FF_EFFECT_MAX ( -- n ) FF_RAMP ; inline

! Force feedback periodic effect types
CONSTANT: FF_SQUARE HEX: 58
CONSTANT: FF_TRIANGLE HEX: 59
CONSTANT: FF_SINE HEX: 5a
CONSTANT: FF_SAW_UP HEX: 5b
CONSTANT: FF_SAW_DOWN HEX: 5c
CONSTANT: FF_CUSTOM HEX: 5d

: FF_WAVEFORM_MIN ( -- n ) FF_SQUARE ; inline
: FF_WAVEFORM_MAX ( -- n ) FF_CUSTOM ; inline

! Set ff device properties
CONSTANT: FF_GAIN HEX: 60
CONSTANT: FF_AUTOCENTER HEX: 61

CONSTANT: FF_MAX HEX: 7f
: FF_CNT ( -- n ) FF_MAX 1 + ; inline



STRUCT: input_event
  { time timeval }
  { type uint16_t }
  { code uint16_t }
  { value int32_t } ;

STRUCT: input_id
  { bustype uint16_t }
  { vendor uint16_t }
  { product uint16_t }
  { version uint16_t } ;

STRUCT: input_absinfo
  { value int32_t }
  { minimum int32_t }
  { maximum int32_t }
  { fuzz int32_t }
  { flat int32_t }
  { resolution int32_t } ;



STRUCT: ff_replay
  { length uint16_t }
  { delay uint16_t } ;

STRUCT: ff_trigger
  { button uint16_t }
  { interval uint16_t } ;

STRUCT: ff_envelope
  { attack_length uint16_t }
  { attack_level uint16_t }
  { fade_length uint16_t }
  { fade_level uint16_t } ;

STRUCT: ff_constant_effect
  { level int16_t }
  { envelope ff_envelope } ;

STRUCT: ff_ramp_effect
  { start_level int16_t }
  { end_level int16_t }
  { envelope ff_envelope } ;

STRUCT: ff_condition_effect
  { right_saturation uint16_t }
  { left_saturation uint16_t }
  { right_coeff int16_t }
  { left_coeff int16_t }
  { deadband uint16_t }
  { center int16_t } ;

STRUCT: ff_periodic_effect
  { waveform uint16_t }
  { period uint16_t }
  { magnitude int16_t }
  { offset int16_t }
  { phase uint16_t }
  { envelope ff_envelope }
  { custom_len uint32_t }
  { custom_data int16_t* } ;

STRUCT: ff_rumble_effect
  { strong_magnitude uint16_t }
  { weak_magnitude uint16_t } ;

UNION-STRUCT: ff_effect_union
  { constant ff_constant_effect }
  { ramp ff_ramp_effect }
  { periodic ff_periodic_effect }
  { condition ff_condition_effect[2] }
  { rumble ff_rumble_effect } ;

STRUCT: ff_effect
  { type uint16_t }
  { id int16_t initial: -1 }
  { direction uint16_t }
  { trigger ff_trigger }
  { replay ff_replay }
  { u ff_effect_union } ;



! ioctl macros

! Get driver version
: EVIOCGVERSION ( -- n )
    CHAR: E HEX: 01 int heap-size _IOR ; inline

! Get device id
: EVIOCGID ( -- n )
    CHAR: E HEX: 02 input_id heap-size _IOR ; inline

! Get repeat settings
: EVIOCGREP ( -- n )
    CHAR: E HEX: 03 int heap-size 2 * _IOR ; inline

! Set repeat settings
: EVIOCSREP ( -- n )
    CHAR: E HEX: 03 int heap-size 2 * _IOW ; inline

! Get keycode
: EVIOCGKEYCODE ( -- n )
    CHAR: E HEX: 04 int heap-size 2 * _IOR ; inline

! Set keycode
: EVIOCSKEYCODE ( -- n )
    CHAR: E HEX: 04 int heap-size 2 * _IOW ; inline


! Get device name
: EVIOCGNAME ( len -- n )
    [ _IOC_READ CHAR: E HEX: 06 ] dip _IOC ; inline

! Get physical location
: EVIOCGPHYS ( len -- n )
    [ _IOC_READ CHAR: E HEX: 07 ] dip _IOC ; inline

! Get unique identifier
: EVIOCGUNIQ ( len -- n )
    [ _IOC_READ CHAR: E HEX: 08 ] dip _IOC ; inline


! Get global keystate
: EVIOCGKEY ( len -- n )
    [ _IOC_READ CHAR: E HEX: 18 ] dip _IOC ; inline

! Get all LEDs
: EVIOCGLED ( len -- n )
    [ _IOC_READ CHAR: E HEX: 19 ] dip _IOC ; inline

! Get all sounds status
: EVIOCGSND ( len -- n )
    [ _IOC_READ CHAR: E HEX: 1a ] dip _IOC ; inline

! Get all switch states
: EVIOCGSW ( len -- n )
    [ _IOC_READ CHAR: E HEX: 1b ] dip _IOC ; inline


! Get event bits
:: EVIOCGBIT ( ev len -- n )
    _IOC_READ CHAR: E HEX: 20 ev + len _IOC ; inline

! Get abs value/limits
: EVIOCGABS ( abs -- n )
    [ CHAR: E HEX: 40 ] dip + input_absinfo heap-size _IOR ; inline

! Set abs value/limits
: EVIOCSABS ( abs -- n )
    [ CHAR: E HEX: c0 ] dip + input_absinfo heap-size _IOW ; inline


! Send a force effect to a force feedback device
: EVIOCSFF ( -- n )
    _IOC_WRITE CHAR: E HEX: 80 ff_effect heap-size _IOC ; inline

! Erase a force effect
: EVIOCRMFF ( -- n )
    CHAR: E HEX: 81 int heap-size _IOW ; inline

! Report number of effects playable at the same time
: EVIOCGEFFECTS ( -- n )
    CHAR: E HEX: 84 int heap-size _IOR ; inline


! Grab/Release device
: EVIOCGRAB ( -- n )
    CHAR: E HEX: 90 int heap-size _IOW ; inline
