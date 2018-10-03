 .386
        .model  flat, stdcall
        option  casemap : none

btnID_Start      equ                     1000
btnID_End        equ                     1001
btnID_Next       equ                     1002
btnID_Back       equ                     1003
btnID_Help       equ                     1004
red              equ                     0ffh
;-----------rgb
RGB macro red,green,blue
    xor    eax,eax
    mov    ah,blue
    shl    eax,8
    mov    ah,green
    mov    al,red
endm
;--------------
include         D:\masm32\include\windows.inc
include         D:\masm32\include\user32.inc
include         D:\masm32\include\gdi32.inc
include         D:\masm32\include\kernel32.inc
includelib      D:\masm32\lib\user32.lib
includelib      D:\masm32\lib\gdi32.lib
includelib      D:\masm32\lib\kernel32.lib
includelib      D:\masm32\lib\Winmm.lib
include         D:\masm32\include\Winmm.inc

WndProc         proto   : HWND, : UINT, : WPARAM, : LPARAM
pointadd        proto   : HDC, : HWND
pointsub        proto   : HDC, : HWND
subheart        proto   : HDC, : HWND
help            proto   : PTR DWORD, : HDC
correct         proto   : PTR DWORD, : HDC
getBMP          proto   : HINSTANCE, : DWORD, : HWND
BmpButton       proto   : DWORD,  : DWORD, : DWORD, : DWORD, : DWORD
drawcount       proto   : HDC,: HWND,:PAINTSTRUCT
;***********************************************************
        .DATA
; ******************** For windows ********************
hMenu           HMENU       ?
hInstance       HINSTANCE   ?
hwnd            HWND        ?
ClassName       db          'ViewBMPWinClass',0
AppName         db          '蠟筆小新~來找碴！',0
MenuName        db          'VBMPMenu',0
IconName        db          'BMPIcon',0
wc              WNDCLASSEX  <?>
msg             MSG         <?>
; ******************** ********************

; ******************** For button ********************
hStart       HWND                ?
btn_Start1              db                  'bs_1', 0
hBtn_Start1             dd                        ?   ;022 位元圖物件代碼
lpfnbmpProc   dd 0

hEnd       HWND                ?
btn_End1              db                  'be_1', 0
hBtn_End1             dd                        ?   ;022 位元圖物件代碼

hEnd3       HWND                ?
btn_End3              db                  'be_3', 0
hBtn_End3             dd                        ?   ;022 位元圖物件代碼

hEnd5       HWND                ?
btn_End5              db                  'be_5', 0
hBtn_End5             dd                        ?   ;022 位元圖物件代碼

hNext       HWND                ?
btn_Next1              db                  'bn_1', 0
hBtn_Next1             dd                        ?   ;022 位元圖物件代碼

hHelp       HWND                ?
btn_Help1              db                  'bh_1', 0
btn_Help2              db                  'bh_2', 0
btn_Help3              db                  'bh_3', 0
btn_Help4              db                  'bh_4', 0
hBtn_Help1             dd                        ?   ;022 位元圖物件代碼

hBack       HWND                ?
btn_Back1              db                  'bb_1', 0
hBtn_Back1             dd                        ?   ;022 位元圖物件代碼
; ******************** ********************

; ******************** For picture ********************
hBitmap         dd          ?   ;022 位元圖物件代碼
picx            dd          0   ;025 BMP 圖檔座標起始
picy            dd          0   ;026 BMP 圖檔座標起始
ncx             dd          ?   ;025 BMP 圖檔的寬度
ncy             dd          ?   ;026 BMP 圖檔的高度
pic15           db          'pic2',0     ;next的圖
pic16           db          'pic3',0     ;gameover的圖
pic14           db          'pic1',0     ;start的圖
pic1            db          'pic10',0
pic2            db          'pic11',0
pic3            db          'pic12',0
pic4            db          'pic13',0
pic5            db          'pic14',0
pic6            db          'pic15',0
pic7            db          'pic16',0
pic8            db          'pic17',0
pic9            db          'pic18',0
pic10           db          'pic19',0
pic11           db          'pic20',0
pic12           db          'pic21',0
pic13           db          'pic22',0
pAddr                DWORD               offset pic14
; ******************** ********************

music            db          'musicgood',0

;-------------help&next-----------------

times           db          3
next            db          1
nextAddr        DWORD  offset pic15
;---------------backhome------------------

backhome        db          0
backhomeAddr       DWORD        offset pic14
;-----------------------------------------
lw_rt_x         dd          ?   ;33 lw_rt_x 與 lw_rt_y 是小正方形的右下角座標
lw_rt_y         dd          ?
MouseClick      db          0
brush           db          0

theend           db          'pic4',0
endAddr            DWORD        offset theend
winornot        db          0
click           db          0
hitpoint        POINT       <?>
NEXTORNOT       db          0
color           dd          red

test12          DWORD       605,319,644,350,806,289,851,322,503,225,560,400,683,418,739,480,753,214,799,249
                DWORD       794,364,860,429,535,337,573,372,750,337,768,381,652,364,697,430,611,260,656,286
                DWORD       500,216,615,245,757,325,809,365,695,415,731,437,744,356,756,370,779,420,840,458
                DWORD       661,252,677,261,599,342,631,368,740,294,815,340,600,241,632,265,545,316,640,336
                DWORD       709,369,759,378,841,255,876,275,703,384,736,399,579,386,607,404,621,317,633,331
                DWORD       526,419,592,448,650,408,670,423,723,315,787,340,630,379,669,388,750,300,811,316
                DWORD       818,401,850,424,502,281,592,293,782,308,822,363,519,353,559,375,516,388,554,436
                DWORD       766,265,788,281,521,436,537,454,775,356,799,396,621,336,641,360,602,434,646,451
                DWORD       784,340,806,358,561,327,577,343,710,234,743,252,633,298,651,312,607,359,646,377
                DWORD       625,330,666,349,554,447,590,462,723,422,749,436,754,359,771,378,710,331,725,343
                DWORD       726,316,760,354,535,244,561,268,738,437,761,455,599,262,622,285,652,356,708,428
                DWORD       563,257,732,308,520,312,562,344,703,326,745,345,627,434,650,451,813,360,823,374
                DWORD       638,254,670,266,703,341,740,361,794,347,837,402,723,440,750,460,666,274,691,300

t               DWORD       offset test12
firstpoint      db          0
secondpoint     db          0
thirdpoint      db          0
fourpoint       db          0
fivepoint       db          0
;---幾條命跟是否要扣命---------------------------------------
heart           db          '9',0
breakheart      db          0
heartlock       db          0
noheart         db          0
;---------
getpoint        db          0
counttext       db          '  ',0
countpoint      db          '100',0
stLocTime       SYSTEMTIME  <?>
initialtime     db          0
nowtime         dd          ?
timestartcount  db          0
over60          db          0
timer           db          1
nfirstdraw      db          1
timelock        db          0
lockonce        db          1
firstshow       db          0
hNewFont        HFONT       ?
szFontFace      BYTE        'elephant',0
;--------------
;***********************************************************
        .CODE
start:
        invoke  GetModuleHandle,NULL
        mov     hInstance,eax

        mov     wc.cbSize,sizeof WNDCLASSEX
        mov     wc.style,CS_HREDRAW or CS_VREDRAW
        mov     wc.lpfnWndProc,offset WndProc
        mov     eax,hInstance
        mov     wc.hInstance,eax

        invoke  PlaySound,600,hInstance, SND_RESOURCE or SND_ASYNC or SND_LOOP

        invoke  LoadIcon,hInstance,offset IconName
        mov     wc.hIcon,eax
        mov     wc.hIconSm,eax

        invoke  LoadCursor,NULL,IDC_ARROW
        mov     wc.hCursor,eax
        mov     wc.hbrBackground,COLOR_WINDOW+1

        invoke  LoadMenu,hInstance,offset MenuName
        mov     hMenu,eax
        mov     wc.lpszClassName,offset ClassName

        invoke  RegisterClassEx,offset wc

        ; ***********  設定視窗大小風格  *********************
        invoke  CreateWindowEx, NULL, offset ClassName,
                        offset  AppName, WS_OVERLAPPEDWINDOW,
                        300, 50, 959, 667, NULL, hMenu, hInstance, NULL
        mov     hwnd,eax

        invoke  ShowWindow,hwnd,SW_SHOWDEFAULT                     ; 最大化
        invoke  UpdateWindow,hwnd

        .while  TRUE
                invoke  GetMessage,offset msg,NULL,0,0
        .break  .if     !eax
                invoke  TranslateMessage,offset msg
                invoke  DispatchMessage,offset msg
        .endw
                mov     eax,msg.wParam
                invoke  ExitProcess,eax
;-----------------------------------------------------------
WndProc proc    hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
        local   bitmap:BITMAP           ; 存放位元圖屬性
        local   ps:PAINTSTRUCT
        local   hdc,hdcMem:HDC

         local  bmpAddr:PTR DWORD
;--------------------
        local   rect:RECT
;--------------------
         mov     esi, pAddr
         mov     bmpAddr, esi


.if uMsg==WM_CREATE
            invoke getBMP, hInstance, bmpAddr,hWnd

            invoke  LoadBitmap, hInstance, offset btn_Start1      ; 效果1
            mov     hBtn_Start1, eax

            invoke BmpButton,hWnd,hBtn_Start1, 600,400,btnID_Start     ; new button
            mov     hStart, eax
            invoke SendMessage, hStart, BM_SETIMAGE, 0, hBtn_Start1
            ; ********** **********

            ; ********** End Button **********
            invoke  LoadBitmap, hInstance, offset btn_End1      ; 效果1
            mov     hBtn_End1, eax

            invoke BmpButton,hWnd,hBtn_End1, 600,500,btnID_End     ; new button
            mov hEnd, eax
            invoke SendMessage, hEnd, BM_SETIMAGE, 0, hBtn_End1
            ; ********** **********
            ; ********** Next Button **********
            invoke  LoadBitmap, hInstance, offset btn_Next1      ; 效果1
            mov     hBtn_Next1, eax

            invoke BmpButton,hWnd,hBtn_Next1, 650,157,btnID_Next     ; new button
            mov hNext, eax
            invoke SendMessage, hNext, BM_SETIMAGE, 0, hBtn_Next1

            invoke  ShowWindow, hNext, SW_HIDE
            ; ********** **********
            ; ********** End3 Button **********
            invoke  LoadBitmap, hInstance, offset btn_End3      ; 效果1
            mov     hBtn_End3, eax

            invoke BmpButton,hWnd,hBtn_End3, 652,352,btnID_End     ; new button
            mov hEnd3, eax
            invoke SendMessage, hEnd3, BM_SETIMAGE, 0, hBtn_End3

            invoke  ShowWindow, hEnd3, SW_HIDE
            ; ********** **********
.elseif uMsg == WM_LBUTTONUP
        mov eax,lParam
        mov edx,20
        and eax,0FFFFh
        mov hitpoint.x,eax
        add eax,edx
        mov lw_rt_x,eax

        mov eax,lParam
        shr eax,16
        mov hitpoint.y,eax
        add eax,edx
        mov lw_rt_y,eax

        mov MouseClick,TRUE
        mov NEXTORNOT,FALSE

        invoke    InvalidateRect,hWnd,NULL,FALSE


.elseif uMsg==WM_PAINT
        invoke  BeginPaint,hWnd,addr ps ; 取得視窗的設備內容
        mov     hdc,eax

        invoke  CreateCompatibleDC,eax  ; 建立相同的設備內容作為來源
        mov     hdcMem,eax
        invoke  SelectObject,hdcMem,hBitmap     ; 選定來源設備內容的位元圖

        invoke  BitBlt, hdc, picx, picy, ncx, ncy, hdcMem, 0, 0, SRCCOPY         ; 傳送位元圖到視窗的設備內容
                   ;119 釋放來源設備內容   拿掉這個可以有圈圈
        ;---------------pointadd & sub & heart
        .IF firstshow
            invoke pointsub, hdc,hWnd
            invoke pointadd, hdc,hWnd
            invoke  GetClientRect,hWnd, ADDR rect
            mov rect.left,640
            mov rect.top,495
            draw:
            RGB 240,240,240
            invoke SetBkColor,hdc,eax
            invoke  DeleteObject,hNewFont
            invoke  CreateFont,30,0,0,0,500,0,0,0,0,0,0,0,0,OFFSET szFontFace
            mov hNewFont,eax
            invoke  SelectObject,hdc,eax
            invoke  DeleteObject,eax
            invoke  DrawText, hdc,ADDR heart,-1, ADDR rect, \
                DT_SINGLELINE or DT_CENTER or DT_VCENTER
            mov firstshow,FALSE
        .ENDIF
        .IF (timelock || heartlock) && lockonce && !noheart && next && backhome;死掉
                invoke  ShowWindow, hHelp, SW_HIDE; 隱藏按鈕

                ; ********** End5 Button **********
                invoke  LoadBitmap, hInstance, offset btn_End5      ; 效果1
                mov     hBtn_End5, eax

                invoke BmpButton,hWnd,hBtn_End5, 108,420,btnID_End     ; new button
                mov hEnd5, eax
                invoke SendMessage, hEnd5, BM_SETIMAGE, 0, hBtn_End5
                ; ********** Back Button **********
                invoke  LoadBitmap, hInstance, offset btn_Back1      ; 效果1
                mov     hBtn_Back1, eax

                invoke BmpButton,hWnd,hBtn_Back1, 108,238,btnID_Back     ; new button
                mov hBack, eax
                invoke SendMessage, hBack, BM_SETIMAGE, 0, hBtn_Back1
                 ; ********** **********

                invoke getBMP, hInstance,ADDR pic16,hWnd
                mov noheart,TRUE
                mov timestartcount,FALSE
                mov lockonce,FALSE
        .ENDIF

        .IF MouseClick && !noheart && next && backhome

            invoke  BeginPaint,hWnd,addr ps
            invoke  GetStockObject,HOLLOW_BRUSH               ;透明圈圈
            invoke  SelectObject,hdc,eax                         ;選擇
            invoke  CreatePen,PS_SOLID,5,color        ;圈圈粗細
            invoke  SelectObject,hdc,eax                 ;選擇

            invoke  correct,t,hdc
;---------------pointadd & sub
            .IF getpoint && timestartcount
                    invoke pointadd, hdc,hWnd
                    mov getpoint,FALSE
            .ELSEIF !getpoint && timestartcount
                    invoke pointsub, hdc,hWnd
            .ENDIF
;---------------breakheart
            .IF breakheart
                invoke subheart, hdc,hWnd
            .ENDIF
;---------------------------------
            .IF click>4
                    mov next,FALSE
                    invoke Sleep,1000 ;等待
                    add winornot,1
                    .IF winornot == 13

                        invoke getBMP, hInstance,endAddr,hWnd
                        invoke  ShowWindow, hHelp, SW_HIDE; 隱藏按鈕
                        invoke  ShowWindow, hNext, SW_HIDE
                        invoke  ShowWindow, hEnd3, SW_HIDE
                        mov NEXTORNOT,TRUE
                        mov click ,0
                        mov firstpoint,FALSE
                        mov secondpoint,FALSE
                        mov thirdpoint,FALSE
                        mov fourpoint,FALSE
                        mov fivepoint,FALSE
                        mov timestartcount,FALSE;停止時間
                        mov initialtime,TRUE;
                    .ELSEIF
                        add t,80
                        invoke getBMP, hInstance, nextAddr,hWnd

                        invoke  ShowWindow, hHelp, SW_HIDE; 隱藏按鈕
                        invoke  ShowWindow, hNext, SW_SHOW
                        invoke  ShowWindow, hEnd3, SW_SHOW

                        mov NEXTORNOT,TRUE
                        mov click ,0
                        mov firstpoint,FALSE
                        mov secondpoint,FALSE
                        mov thirdpoint,FALSE
                        mov fourpoint,FALSE
                        mov fivepoint,FALSE
                        mov timestartcount,FALSE;停止時間
                        mov initialtime,TRUE;
                    .ENDIF
            .ENDIF

        invoke  InvalidateRect,hWnd,NULL,NEXTORNOT
        .ENDIF
        ;--------time
        .IF timer && timestartcount;timer讓他重複跑，timerstartcount讓他顯示
                push ecx
                mov ecx,10000000
            L:
                nop
                loop L
                pop ecx
                invoke  drawcount,hdc,hWnd,ps
                mov timer,FALSE
        .ENDIF
        mov timer,TRUE
        ;----------

        invoke  EndPaint,hWnd,addr ps   ;120 釋放視窗設備內容

;以下是使用者點選選單
.elseif uMsg==WM_COMMAND
    mov edx,wParam
    .IF     dx == btnID_Start       ; 按下開始遊戲
                    invoke  PlaySound,500,hInstance, SND_RESOURCE or SND_ASYNC
                    mov noheart,FALSE
                    mov backhome,TRUE
                    mov next,TRUE
                    mov heart,'9'
                    mov heartlock,FALSE
                    ;------
                    mov timestartcount,TRUE;按開始之後顯示計時///?????????????
                    mov timelock,FALSE
                    mov [countpoint],'1'
                    mov [countpoint+1],'0'
                    mov lockonce,TRUE
                    mov initialtime,FALSE
                    mov over60,FALSE
                    mov firstshow,TRUE
                    ;--------
                    invoke  ShowWindow, hStart, SW_HIDE; 隱藏按鈕
                    invoke  ShowWindow, hEnd, SW_HIDE; 隱藏按鈕

                    ; ********** Help button **********
                    invoke  LoadBitmap, hInstance, offset btn_Help1      ; 效果1
                    mov     hBtn_Help1, eax

                    invoke BmpButton,hWnd,hBtn_Help1, 800,100,btnID_Help     ; new button
                    mov hHelp, eax
                    invoke SendMessage, hHelp, BM_SETIMAGE, 0, hBtn_Help1

                    add bmpAddr, sizeof pic14
                    mov esi, bmpAddr
                    mov pAddr, esi

                    invoke getBMP, hInstance, bmpAddr,hWnd
                    invoke  UpdateWindow,hwnd;讓help不會不見
    .ELSEIF    dx == btnID_End
                    invoke  PlaySound,500,hInstance, SND_RESOURCE or SND_ASYNC
                    jmp     exit

    .ELSEIF  dx == btnID_Back
                    mov backhome,FALSE
                    invoke  PlaySound,600,hInstance, SND_RESOURCE or SND_ASYNC or SND_LOOP
                    invoke  ShowWindow, hStart, SW_SHOW; 顯示按鈕
                    invoke  ShowWindow, hEnd, SW_SHOW; 顯示按鈕
                    invoke  ShowWindow, hEnd5, SW_HIDE; 隱藏按鈕
                    invoke  ShowWindow, hBack, SW_HIDE; 隱藏按鈕

                    mov     pAddr, offset   pic14
                    mov     esi, pAddr
                    mov     bmpAddr, esi
                    invoke getBMP, hInstance, bmpAddr,hWnd
                   mov       esi,offset test12;  將T改為原本的第一張圖
                   mov       t,esi;
                   mov       times,3
                   mov       firstpoint,FALSE
                   mov       secondpoint,FALSE
                   mov       thirdpoint,FALSE
                   mov       fourpoint,FALSE
                   mov       fivepoint,FALSE
                   mov       click,0
                   mov       winornot,0


    .ELSEIF  dx==btnID_Next
                    invoke  PlaySound,500,hInstance, SND_RESOURCE or SND_ASYNC
                    mov next,TRUE
                    invoke  ShowWindow, hNext, SW_HIDE; 隱藏按鈕
                    invoke  ShowWindow, hEnd3, SW_HIDE; 隱藏按鈕
                    invoke  ShowWindow, hHelp, SW_SHOW; 隱藏按鈕

                    add bmpAddr, sizeof pic1
                    mov esi, bmpAddr
                    mov pAddr, esi
                    ;------------------
                    mov initialtime,FALSE
                    mov firstshow,TRUE
                    mov timestartcount,TRUE
                    mov over60,FALSE
                    invoke getBMP, hInstance, bmpAddr,hWnd
                    invoke  UpdateWindow,hwnd;讓help不會不見
    .ELSEIF  dx == btnID_Help
          .IF times > 0
            sub times,1
            .IF times == 2
                    invoke  PlaySound,500,hInstance, SND_RESOURCE or SND_ASYNC
                    invoke LoadBitmap,hInstance, offset btn_Help2       ; help = 2
                    mov hBtn_Help1, eax

                    invoke SendMessage, hHelp, BM_SETIMAGE, 0, hBtn_Help1
                    invoke CallWindowProc,lpfnbmpProc,hWnd,uMsg,wParam,lParam
            .ELSEIF times == 1
                    invoke  PlaySound,500,hInstance, SND_RESOURCE or SND_ASYNC
                    invoke LoadBitmap,hInstance, offset btn_Help3         ; help=1
                    mov hBtn_Help1, eax

                    invoke SendMessage, hHelp, BM_SETIMAGE, 0, hBtn_Help1
                    invoke CallWindowProc,lpfnbmpProc,hWnd,uMsg,wParam,lParam
            .ELSEIF times == 0
                invoke  PlaySound,500,hInstance, SND_RESOURCE or SND_ASYNC
                invoke LoadBitmap,hInstance, offset btn_Help4         ; help = 0
                mov hBtn_Help1, eax

                invoke SendMessage, hHelp, BM_SETIMAGE, 0, hBtn_Help1
                invoke CallWindowProc,lpfnbmpProc,hWnd,uMsg,wParam,lParam

                invoke SendMessage, hNext, BM_SETIMAGE, 0, hBtn_Next1
            .ENDIF

                mov NEXTORNOT,FALSE
                invoke    InvalidateRect,hWnd,NULL,FALSE
                invoke  BeginPaint,hWnd,addr ps ; 取得視窗的設備內容
                mov     hdc,eax
                invoke  CreateCompatibleDC,eax  ; 建立相同的設備內容作為來源
                mov     hdcMem,eax
                invoke  SelectObject,hdcMem,hBitmap     ; 選定來源設備內容的位元圖

                invoke  BeginPaint,hWnd,addr ps
                invoke GetStockObject,HOLLOW_BRUSH               ;透明圈圈
                invoke SelectObject,hdc,eax                         ;選擇
                invoke  CreatePen,PS_SOLID,5,color        ;圈圈粗細
                invoke  SelectObject,hdc,eax
                invoke help,t,hdc
                invoke  InvalidateRect,hWnd,NULL,NEXTORNOT
                invoke  EndPaint,hWnd,addr ps
                invoke  UpdateWindow,hwnd;讓help不會不見
        .ENDIF

            .IF click>4
                    mov next,FALSE
                    add winornot,1
                .IF winornot == 13
                    invoke getBMP, hInstance,endAddr,hWnd
                    invoke  ShowWindow, hHelp, SW_HIDE; 隱藏按鈕
                    invoke  ShowWindow, hNext, SW_HIDE
                    invoke  ShowWindow, hEnd3, SW_HIDE
                    mov NEXTORNOT,TRUE
                    mov click ,0
                    mov firstpoint,FALSE
                    mov secondpoint,FALSE
                    mov thirdpoint,FALSE
                    mov fourpoint,FALSE
                    mov fivepoint,FALSE
                    mov timestartcount,FALSE;停止時間
                    mov initialtime,TRUE;
                .ELSEIF
                    add t,80
                    invoke getBMP, hInstance, nextAddr,hWnd
                    invoke Sleep,2000 ;等待!

                    invoke  ShowWindow, hHelp, SW_HIDE
                    invoke  ShowWindow, hNext, SW_SHOW
                    invoke  ShowWindow, hEnd3, SW_SHOW

                    mov NEXTORNOT,TRUE
                    mov click ,0
                    mov firstpoint,FALSE
                    mov secondpoint,FALSE
                    mov thirdpoint,FALSE
                    mov fourpoint,FALSE
                    mov fivepoint,FALSE
                    mov timestartcount,FALSE;
                    mov initialtime,TRUE;
                .ENDIF
            .ENDIF
        .ENDIF

.elseif uMsg==WM_CLOSE
        exit:   invoke  DestroyWindow,hWnd

.elseif uMsg==WM_DESTROY
        invoke  PostQuitMessage,NULL

.else
def:    invoke  DefWindowProc,hWnd,uMsg,wParam,lParam
        ret
.endif
        xor     eax,eax
        ret
WndProc endp
;-----------------------------------------------------------

;HELP PROCEDUREs-----------------------------------------------------------
help proc uses edi esi edx,
        p:PTR DWORD,
        hnd:HDC
            mov edi, p
               .IF !firstpoint
                    invoke  Ellipse,hnd,[edi],[edi+4],[edi+8],[edi+12]   ;要調整圈圈大小可以用上面的+5
                    mov firstpoint,TRUE
                    inc click
                    invoke  PlaySound,200,hInstance, SND_RESOURCE or SND_ASYNC
                .ELSEIF !secondpoint
                    invoke  Ellipse,hnd,[edi+16],[edi+20],[edi+24],[edi+28]    ;要調整圈圈大小可以用上面的+5
                    mov secondpoint,TRUE
                    inc click
                    invoke  PlaySound,200,hInstance, SND_RESOURCE or SND_ASYNC

                .ELSEIF !thirdpoint
                    invoke  Ellipse,hnd,[edi+32] ,[edi+36],[edi+40],[edi+44]     ;要調整圈圈大小可以用上面的+5
                    mov thirdpoint,TRUE
                    inc click
                    invoke  PlaySound,200,hInstance, SND_RESOURCE or SND_ASYNC

                .ELSEIF !fourpoint
                    invoke  Ellipse,hnd,[edi+48],[edi+52],[edi+56] ,[edi+60]   ;要調整圈圈大小可以用上面的+5
                    mov fourpoint,TRUE
                    inc click
                    invoke  PlaySound,200,hInstance, SND_RESOURCE or SND_ASYNC

                .ELSEIF !fivepoint
                    invoke  Ellipse,hnd,[edi+64],[edi+68],[edi+72],[edi+76]    ;要調整圈圈大小可以用上面的+5
                    mov fivepoint,TRUE
                    inc click
                    invoke  PlaySound,200,hInstance, SND_RESOURCE or SND_ASYNC
                .ENDIF
        ret
help endp
;-----------------------------------------------------------

;----------drawcount----------------------------------------
drawcount proc uses eax ecx edx,
        hdc:HDC,
        hWnd:HWND,
        ps:PAINTSTRUCT
        local rect:RECT
        invoke  GetClientRect,hWnd, ADDR rect
        mov rect.left,205
        mov rect.right,245
        mov rect.top,545
        mov rect.bottom,575
startfrom:
        .IF !initialtime
            invoke  GetLocalTime,OFFSET stLocTime;數字，不是string
            movzx   ebx,stLocTime.wSecond    ;ebx為初始時間
            mov nowtime,ebx
            mov initialtime,TRUE
            invoke  DeleteObject,hNewFont
            invoke  CreateFont,30,0,0,0,500,0,0,0,0,0,0,0,0,0
            mov hNewFont,eax
            invoke  SelectObject,hdc,eax
            invoke  DeleteObject,eax
            invoke  DrawText, hdc,ADDR counttext,-1, ADDR rect, \
                    DT_SINGLELINE or DT_CENTER or DT_VCENTER
            jmp startfrom
        .ELSEIF
            invoke  GetLocalTime,OFFSET stLocTime;數字，不是string
            movzx   eax,stLocTime.wSecond    ;現在時間
            mov     ebx,nowtime
        .ENDIF
        jmp changetime
changetime:
            cmp eax,ebx         ;小於0跳到minus
            jb minus
            sub eax,ebx
            .IF eax==0 && !timelock && over60
                mov [counttext+1],38
                mov timelock,TRUE
            .ENDIF
            jmp nochange

minus:
            mov ecx,ebx
            sub ecx,eax
            mov eax,60
            sub eax,ecx
            mov over60,TRUE
nochange:
            xor edx,edx
            mov bx,ax
            mov ax,60
            sub ax,bx
            mov cx,10
            div cx
            add al,48
            mov [counttext],al
            add dl,48       ;個位數
            mov [counttext+1],dl
            ;invoke SetTextColor,hdc,Blue;如果要換字體顏色
            RGB 240,240,240
            invoke SetBkColor,hdc,eax
            invoke  DeleteObject,hNewFont
            invoke  CreateFont,30,0,0,0,500,0,0,0,0,0,0,0,0,OFFSET szFontFace
            mov hNewFont,eax
            invoke  SelectObject,hdc,eax
            invoke  DeleteObject,eax
            invoke  DrawText, hdc,ADDR counttext,-1, ADDR rect, \
                    DT_SINGLELINE or DT_CENTER or DT_VCENTER
            invoke  InvalidateRect,hWnd,ADDR rect,0
            ret
drawcount endp
;-----------pointadd---------------------------------------
pointadd proc uses eax esi ebx,
        hdc:HDC,
        hWnd:HWND
        local rect:RECT
        invoke  GetClientRect,hWnd, ADDR rect
        mov rect.left,170
        mov rect.top,495
        mov esi,offset countpoint
        mov al,48
        mov bl,57
        inc esi         ;十位數
        cmp [esi],bl
        je  carry
        jmp without
carry:
        mov [esi],al    ;十位數=0
        dec esi         ;百位數+1
        mov ah,[esi]
        inc ah
        mov [esi],ah
        jmp draw
without:
        mov ah,[esi]    ;十位數+1
        inc ah
        mov [esi],ah
        dec esi
draw:
        RGB 240,240,240
        invoke SetBkColor,hdc,eax
        ;invoke SetTextColor,hdc,Red
        invoke  DeleteObject,hNewFont
        invoke  CreateFont,30,0,0,0,500,0,0,0,0,0,0,0,0,OFFSET szFontFace
        mov hNewFont,eax
        invoke  SelectObject,hdc,eax
        invoke  DeleteObject,eax

        invoke  DrawText, hdc,ADDR countpoint,-1, ADDR rect, \
        DT_SINGLELINE or DT_CENTER or DT_VCENTER
        ret
pointadd endp
;-----------pointsub-------------------------------------
pointsub proc uses eax esi ebx,
        hdc:HDC,
        hWnd:HWND
        local rect:RECT
        invoke  GetClientRect,hWnd, ADDR rect
        mov rect.left,170
        mov rect.top,495
        mov esi,offset countpoint
        mov al,48
        mov bl,57
        inc esi         ;十位數
        cmp [esi],al
        je  carry
        jmp without
carry:
        mov [esi],bl    ;十位數=0
        dec esi         ;百位數-1
        mov ah,[esi]
        dec ah
        mov [esi],ah
        jmp draw
without:
        mov ah,[esi]    ;十位數-1
        dec ah
        mov [esi],ah
        dec esi
draw:
        RGB 240,240,240
        invoke SetBkColor,hdc,eax
        ;invoke SetTextColor,hdc,Red
        invoke  DeleteObject,hNewFont
        invoke  CreateFont,30,0,0,0,500,0,0,0,0,0,0,0,0,OFFSET szFontFace
        mov hNewFont,eax
        invoke  SelectObject,hdc,eax
        invoke  DeleteObject,eax

        invoke  DrawText, hdc,ADDR countpoint,-1, ADDR rect, \
            DT_SINGLELINE or DT_CENTER or DT_VCENTER
        ret
pointsub endp
;-----------------------------------------------------------
subheart proc uses eax esi,
        hdc:HDC,
        hWnd:HWND
        local rect:RECT
        invoke  GetClientRect,hWnd, ADDR rect
            mov rect.left,640
            mov rect.top,495

        .IF !heartlock
            mov esi,offset heart
            mov ah,[esi]
            dec ah
            mov [esi],ah
            .IF ah<='0'
                mov heartlock,TRUE
                mov MouseClick,FALSE
            .ENDIF
        draw:
            RGB 240,240,240
            invoke SetBkColor,hdc,eax
            invoke  DeleteObject,hNewFont
            invoke  CreateFont,30,0,0,0,500,0,0,0,0,0,0,0,0,OFFSET szFontFace
            mov hNewFont,eax
            invoke  SelectObject,hdc,eax
            invoke  DeleteObject,eax
            invoke  DrawText, hdc,ADDR heart,-1, ADDR rect, \
                DT_SINGLELINE or DT_CENTER or DT_VCENTER
        .ENDIF
        ret
subheart endp
;-----------------------------------------------------------
correct proc uses edi esi edx,
        p:PTR DWORD,
        hnd:HDC
            mov edi, p
            mov edx,hitpoint.x
            mov esi,hitpoint.y
               .IF edx>[edi] && edx<[edi+8] && esi>[edi+4] && esi<[edi+12] &&!firstpoint
                    invoke  Ellipse,hnd,[edi],[edi+4],[edi+8],[edi+12]   ;要調整圈圈大小可以用上面的+5
                    mov MouseClick,FALSE
                    mov firstpoint,TRUE
                    inc click
                    mov getpoint,TRUE
                    mov breakheart,FALSE
                    invoke  PlaySound,200,hInstance, SND_RESOURCE or SND_ASYNC
                .ELSEIF edx>[edi+16] &&  edx<[edi+24]  && esi>[edi+20] && esi<[edi+28] &&!secondpoint
                    invoke  Ellipse,hnd,[edi+16],[edi+20],[edi+24],[edi+28]    ;要調整圈圈大小可以用上面的+5
                    mov MouseClick,FALSE
                    mov secondpoint,TRUE
                    inc click
                    mov getpoint,TRUE
                    mov breakheart,FALSE
                    invoke  PlaySound,200,hInstance, SND_RESOURCE or SND_ASYNC
                .ELSEIF edx>[edi+32] && edx<[edi+40] && esi>[edi+36] && esi<[edi+44] && !thirdpoint
                    invoke  Ellipse,hnd,[edi+32] ,[edi+36],[edi+40],[edi+44]     ;要調整圈圈大小可以用上面的+5
                    mov MouseClick,FALSE
                    mov thirdpoint,TRUE
                    inc click
                    mov getpoint,TRUE
                    mov breakheart,FALSE
                    invoke  PlaySound,200,hInstance, SND_RESOURCE or SND_ASYNC
                .ELSEIF edx>[edi+48] && edx<[edi+56]  && esi>[edi+52] && esi<[edi+60]  &&!fourpoint
                    invoke  Ellipse,hnd,[edi+48],[edi+52],[edi+56] ,[edi+60]   ;要調整圈圈大小可以用上面的+5
                    mov MouseClick,FALSE
                    mov fourpoint,TRUE
                    inc click
                    mov getpoint,TRUE
                    mov breakheart,FALSE
                    invoke  PlaySound,200,hInstance, SND_RESOURCE or SND_ASYNC
                .ELSEIF edx>[edi+64] && edx<[edi+72] && esi>[edi+68] && esi<[edi+76] &&!fivepoint
                    invoke  Ellipse,hnd,[edi+64],[edi+68],[edi+72],[edi+76]    ;要調整圈圈大小可以用上面的+5
                    mov MouseClick,FALSE
                    mov fivepoint,TRUE
                    inc click
                    mov getpoint,TRUE
                    mov breakheart,FALSE
                    invoke  PlaySound,200,hInstance, SND_RESOURCE or SND_ASYNC
                .ELSEIF
                    mov breakheart,TRUE
                    mov MouseClick,FALSE
                    invoke  PlaySound,400,hInstance, SND_RESOURCE or SND_ASYNC
                .ENDIF
        ret
correct endp
; ********** **********
; **********  add a picture  *******************
getBMP proc,
            h : HINSTANCE,
            b : DWORD,
            hParent : HWND

            local   bitmap : BITMAP

            invoke  LoadBitmap, h, b             ; 載入位元圖
            mov     hBitmap, eax
            invoke  GetObject,hBitmap,sizeof BITMAP,addr bitmap     ; 取得位元圖屬性
            mov     ecx, bitmap.bmWidth      ; 位元圖寬度存於 ncx
            mov     ncx, ecx
            mov     ecx, bitmap.bmHeight     ; 位元圖高度存於 ncy
            mov     ncy, ecx

            invoke  InvalidateRect, hParent, NULL, TRUE   ; 強迫重新繪製工作區

            ret
getBMP endp

; ********** **********

; ********** Button class&name **********
szText MACRO Name, Text:VARARG
            LOCAL lbl
            jmp lbl
            Name db Text,0

        lbl:
            ENDM

            m2m MACRO M1, M2
            push M2
            pop  M1
ENDM

            return MACRO arg
            mov eax, arg
            ret
ENDM
; ********** **********

; ********** new a button **********
BmpButton proc ,
            hParent : DWORD,
            hChild : DWORD,
            x : DWORD,
            y : DWORD,
            ID : DWORD

            local   bitmap : BITMAP
            local   wid : DWORD
            local   hei : DWORD

            szText bmpBtnCl, "BUTTON"
            szText blnk2, 0


            invoke  GetObject, hChild, sizeof BITMAP, ADDR  bitmap     ; 取得位元圖屬性
            mov     ecx, bitmap.bmWidth      ; 位元圖寬度存於 ncx
            mov     wid, ecx
            mov     ecx, bitmap.bmHeight     ; 位元圖高度存於 ncy
            mov     hei, ecx

            invoke CreateWindowEx,
                         0,ADDR bmpBtnCl,ADDR blnk2,
                         WS_CHILD or WS_VISIBLE or BS_BITMAP,
                         x,y,wid,hei,hParent,ID,hInstance,NULL

            ret
BmpButton endp

;  ********** **********


;***********************************************************
end     start
