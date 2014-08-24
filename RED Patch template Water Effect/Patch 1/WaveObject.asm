;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 水波效果公用子程序
; by 罗云彬，http://asm.yeah.net，luoyunbin@sina.com
; V 1.0.041019 --- 初始版本
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 在源代码中只需要 include WaveObject.asm
; 然后按以下步骤调用即可：
;********************************************************************
; 1、创建水波对象：
;    要对一个窗口进行绘画，首先要创建一个水波对象（本函数申请一些缓冲区）
;    invoke _WaveInit,lpWaveObject,hWnd,hBmp,dwTime,dwType
;       lpWaveObject --> 指向一个空的 WAVE_OBJECT 结构
;       hWnd --> 要绘画水波效果的窗口，渲染后的图片将画到窗口的客户区中
;       hBmp --> 背景图片，绘画的范围大小同背景图片大小
;       dwTime --> 刷新的时间间隔（毫秒），建议值：10～30
;	dwType --> =0 表示圆形水波，=1表示椭圆型水波（用于透视效果）
;       返回值：eax = 0（成功，对象被初始化），eax = 1（失败）
;********************************************************************
; 2、如果 _WaveInit 函数返回成功，则对象被初始化，将对象传给下列各种函数
;    可以实现各种效果，下面函数中的 lpWaveObject 参数指向在 _WaveInit 函数
;    中初始化的 WAVE_OBJECT 结构
;
;    ◎ 在指定位置“扔石头”，激起水波
;       invoke _WaveDropStone,lpWaveObject,dwPosX,dwPosY,dwStoneSize,dwStoneWeight
;          dwPosX,dwPosY --> 扔下石头的位置
;          dwStoneSize --> 石头的大小，即初始点的大小，建议值：0～5
;          dwStoneWeight --> 石头的重量，决定了波最后扩散的范围大小，建议值：10～1000
;
;    ◎ 自动显示特效
;       invoke _WaveEffect,lpWaveObject,dwEffectType,dwParam1,dwParam2,dwParam3
;          dwParam1,dwParam2,dwParam3 --> 效果参数，对不同的特效类型参数含义不同
;          dwEffectType --> 特效类型
;             0 --> 关闭特效
;             1 --> 下雨，Param1＝密集速度（0最密，越大越稀疏），建议值：0～30
;                         Param2＝最大雨点直径，建议值：0～5
;                         Param3＝最大雨点重量，建议值：50～250
;             2 --> 汽艇，Param1＝速度（0最慢，越大越快），建议值：0～8
;                         Param2＝船大小，建议值：0～4
;                         Param3＝水波扩散的范围，建议值：100～500
;             3 --> 风浪，Param1＝密度（越大越密），建议值：50～300
;                         Param2＝大小，建议值：2～5
;                         Param3＝能量，建议值：5～10
;
;    ◎ 窗口客户区强制更新（用于在窗口的WM_PAINT消息中强制更新客户端）
;       .if     uMsg == WM_PAINT
;               invoke  BeginPaint,hWnd,addr @stPs
;               mov     @hDc,eax
;               invoke  _WaveUpdateFrame,lpWaveObject,eax,TRUE
;               invoke  EndPaint,hWnd,addr @stPs
;               xor     eax,eax
;               ret
;********************************************************************
; 3、释放水波对象：
;    使用完毕后，必须将水波对象释放（本函数将释放申请的缓冲区内存等资源）
;       invoke  _WaveFree,lpWaveObject
;       lpWaveObject --> 指向 WAVE_OBJECT 结构
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 实现上的细节说明：
;
; 1、 水波的特征：
;   ◎ 扩散：每一点的波会扩散到其四周的位置中
;   ◎ 衰减：每次扩散会损失少量能量（否则水波会永不停止的震荡下去）
;
; 2、 为了保存两个时刻中的能量分步图，对象中定义2个缓冲区Wave1和Wave2
;  （保存在lpWave1和lpWave2指向的缓冲区内），Wave1为当前数据，Wave2为
;   上一帧的数据，每次渲染时将根据上面的2个特征，由Wave1的数据计算出新
;   能量分别图后，保存到Wave2中，然后调换Wave1和Wave2，这时Wave1仍是最
;   新的数据。
;      计算的方法为，某个点的能量＝点四周的上次能量的平均值 * 衰减系数
;   取四周的平均值表现了扩展特征，乘以衰减系数表现了衰减特征。
;      这部分代码在 _WaveSpread 子程序中实现。
;
; 3、 对象在 lpDIBitsSource 中保存了原始位图的数据，每次渲染时，由原始
;   位图的数据根据Wave1中保存的能量分步数据产生新的位图。从视觉上看，
;   某个点的能量越大（水波越大），则光线折射出越远处的场景。
;      算法为：对于点（x,y），在Wave1中找出该点，计算出相邻点的波能差
;  （Dx和Dy两个数据），则新位图像素（x,y）＝原始位图像素（x+Dx,y+Dy），
;   该算法表现了能量大小影响了像素折射的偏移大小。
;      这部分代码在 _WaveRender 子程序中实现。
;
; 4、 扔石头的算法很好理解，即将Wave1中的某个点的能量值置为非0值，数值
;   越大，表示扔下的石头的能量越大。石头比较大，则将该点四周的点全部
;   置为非0值。
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;
;
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
ifndef		WAVEOBJ_INC
WAVEOBJ_INC	equ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
F_WO_ACTIVE		equ	0001h
F_WO_NEED_UPDATE	equ	0002h
F_WO_EFFECT		equ	0004h
F_WO_ELLIPSE		equ	0008h

WAVE_OBJECT		struct
 hWnd			dd	?
 dwFlag			dd	?	; 见 F_WO_xxx 组合
;********************************************************************
 hDcRender		dd	?
 hBmpRender		dd	?
 lpDIBitsSource		dd	?	; 原始像素数据
 lpDIBitsRender		dd	?	; 用于显示到屏幕的像素数据
 lpWave1		dd	?	; 水波能量数据缓冲1
 lpWave2		dd	?	; 水波能量数据缓冲2
;********************************************************************
 dwBmpWidth		dd	?
 dwBmpHeight		dd	?
 dwDIByteWidth		dd	?	; = (dwBmpWidth * 3 + 3) and ~3
 dwWaveByteWidth	dd	?	; = dwBmpWidth * 4
 dwRandom		dd	?
;********************************************************************
; 特效参数
;********************************************************************
 dwEffectType		dd	?
 dwEffectParam1		dd	?
 dwEffectParam2		dd	?
 dwEffectParam3		dd	?
;********************************************************************
; 用于行船特效
;********************************************************************
 dwEff2X		dd	?
 dwEff2Y		dd	?
 dwEff2XAdd		dd	?
 dwEff2YAdd		dd	?
 dwEff2Flip		dd	?
;********************************************************************
 stBmpInfo		BITMAPINFO <>
WAVE_OBJECT		ends
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


		.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 随机数产生子程序
; 输入：要产生的随机数的最大值，输出：随机数
; 根据：
; 1. 数学公式 Rnd=(Rnd*I+J) mod K 循环回带生成 K 次以内不重复的
;    伪随机数，但K,I,J必须为素数
; 2. 2^(2n-1)-1 必定为素数（即2的奇数次方减1）
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveRandom16	proc	_lpWaveObject

		mov	ebx,_lpWaveObject
		assume	ebx:ptr WAVE_OBJECT
		push	edx
		push	ecx
		mov	eax,[ebx].dwRandom
		mov	ecx,32768-1	;2^15-1
		mul	ecx
		add	eax,2048-1	;2^11-1
		adc	edx,0
		mov	ecx,2147483647	;2^31-1
		div	ecx
		mov	eax,[ebx].dwRandom
		mov	[ebx].dwRandom,edx
		and	eax,0000ffffh
		pop	ecx
		pop	edx
		ret

_WaveRandom16	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveRandom	proc	uses ebx ecx edx _lpWaveObject,_dwMax

		invoke	_WaveRandom16,_lpWaveObject
		mov	edx,eax
		invoke	_WaveRandom16,_lpWaveObject
		shl	eax,16
		or	ax,dx
		mov	ecx,_dwMax
		or	ecx,ecx
		jz	@F
		xor	edx,edx
		div	ecx
		mov	eax,edx
		@@:
		ret

_WaveRandom	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 波能扩散
; 算法：
; Wave2(x,y) = (Wave1(x+1,y)+Wave1(x-1,y)+Wave1(x,y+1)+Wave1(x,y-1))/2-Wave2(x,y)
; Wave2(x,y) = Wave2(x,y) - Wave2(x,y) >> 5
; xchg Wave1,Wave2
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveSpread	proc	_lpWaveObject

		pushad
		mov	ebx,_lpWaveObject
		assume	ebx:ptr WAVE_OBJECT
;********************************************************************
		test	[ebx].dwFlag,F_WO_ACTIVE
		jz	_Ret

		mov	esi,[ebx].lpWave1
		mov	edi,[ebx].lpWave2
		mov	ecx,[ebx].dwBmpWidth

		mov	eax,[ebx].dwBmpHeight
		dec	eax
		mul	ecx
;********************************************************************
; ebx = width
; ecx = i，eax = max
;********************************************************************
		.while	ecx < eax
			push	eax
			.if	[ebx].dwFlag & F_WO_ELLIPSE
				mov	edx,[esi+ecx*4-1*4]
				add	edx,[esi+ecx*4+1*4]
				add	edx,[esi+ecx*4-2*4]
				add	edx,[esi+ecx*4+2*4]
				lea	edx,[edx+edx*2]
				add	edx,[esi+ecx*4-3*4]
				add	edx,[esi+ecx*4-3*4]
				add	edx,[esi+ecx*4+3*4]
				add	edx,[esi+ecx*4+3*4]

				lea	eax,[esi+ecx*4]
				sub	eax,[ebx].dwWaveByteWidth
				mov	eax,[eax]
				shl	eax,3
				add	edx,eax

				lea	eax,[esi+ecx*4]
				add	eax,[ebx].dwWaveByteWidth
				mov	eax,[eax]
				shl	eax,3
				add	edx,eax

				sar	edx,4
				sub	edx,[edi+ecx*4]

				mov	eax,edx
				sar	eax,5
				sub	edx,eax

				mov	[edi+ecx*4],edx
			.else
				mov	edx,[esi+ecx*4-1*4]
				add	edx,[esi+ecx*4+1*4]

				lea	eax,[esi+ecx*4]
				sub	eax,[ebx].dwWaveByteWidth
				add	edx,[eax]

				lea	eax,[esi+ecx*4]
				add	eax,[ebx].dwWaveByteWidth
				add	edx,[eax]

				sar	edx,1
				sub	edx,[edi+ecx*4]

				mov	eax,edx
				sar	eax,5
				sub	edx,eax

				mov	[edi+ecx*4],edx
			.endif
			pop	eax
			inc	ecx
		.endw

		mov	[ebx].lpWave1,edi
		mov	[ebx].lpWave2,esi
_Ret:
;********************************************************************
		assume	ebx:nothing
		popad
		ret

_WaveSpread	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; esi -> edi, ecx = line width
; return = (4*Pixel(x,y)+3*Pixel(x-1,y)+3*Pixel(x+1,y)+3*Pixel(x,y+1)+3*Pixel(x,y-1))/16
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveGetPixel:
		movzx	eax,byte ptr [esi]
		shl	eax,2
		movzx	edx,byte ptr [esi+3]
		lea	edx,[edx+2*edx]
		add	eax,edx
		movzx	edx,byte ptr [esi-3]
		lea	edx,[edx+2*edx]
		add	eax,edx
		movzx	edx,byte ptr [esi+ecx]
		lea	edx,[edx+2*edx]
		add	eax,edx
		mov	edx,esi
		sub	edx,ecx
		movzx	edx,byte ptr [edx]
		lea	edx,[edx+2*edx]
		add	eax,edx
		shr	eax,4
		mov	[edi],al
		inc	esi
		inc	edi
		ret
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 渲染子程序，将新的帧数据渲染到 lpDIBitsRender 中
; 算法：
; posx = Wave1(x-1,y)-Wave1(x+1,y)+x
; posy = Wave1(x,y-1)-Wave1(x,y+1)+y
; SourceBmp(x,y) = DestBmp(posx,posy)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveRender	proc	_lpWaveObject
		local	@dwPosX,@dwPosY,@dwPtrSource,@dwFlag

		pushad
		xor	eax,eax
		mov	@dwFlag,eax
		mov	ebx,_lpWaveObject
		assume	ebx:ptr WAVE_OBJECT

		test	[ebx].dwFlag,F_WO_ACTIVE
		jz	_Ret

		or	[ebx].dwFlag,F_WO_NEED_UPDATE
		mov	esi,[ebx].lpWave1
		mov	edi,[ebx].dwWaveByteWidth	; edi = 像素指针

		xor	ecx,ecx
		inc	ecx		; ecx=i  --  i=1; i<height; i++
_Loop1:
		xor	edx,edx		; edx=j  --  j=0; j<width; j++
_Loop2:
		push	edx
;********************************************************************
; PosY=i+像素上1能量-像素下1能量
; PosX=j+像素左1能量-像素右1能量
;********************************************************************
		mov	eax,edi
		sub	eax,[ebx].dwWaveByteWidth
		mov	eax,[esi+eax]
		mov	@dwPosY,eax

		mov	eax,[ebx].dwWaveByteWidth
		lea	eax,[edi+eax]
		mov	eax,[esi+eax]
		sub	@dwPosY,eax
		add	@dwPosY,ecx

		mov	eax,[esi+edi-4]
		sub	eax,[esi+edi+4]
		add	eax,edx			;@dwPosX = eax
		mov	@dwPosX,eax

		cmp	eax,0
		jl	_Continue
		cmp	eax,[ebx].dwBmpWidth
		jge	_Continue
		mov	eax,@dwPosY
		cmp	eax,0
		jl	_Continue
		cmp	eax,[ebx].dwBmpHeight
		jge	_Continue
;********************************************************************
; ptrSource = dwPosY * dwDIByteWidth + dwPosX * 3
; ptrDest = i * dwDIByteWidth + j * 3
;********************************************************************
		mov	eax,@dwPosX
		lea	eax,[eax+eax*2]
		mov	@dwPosX,eax
		push	edx
		mov	eax,@dwPosY
		mul	[ebx].dwDIByteWidth
		add	eax,@dwPosX
		mov	@dwPtrSource,eax

		mov	eax,ecx
		mul	[ebx].dwDIByteWidth
		pop	edx
		lea	edx,[edx+edx*2]
		add	eax,edx			;@dwPtrDest = eax
;********************************************************************
; 渲染像素 [ptrDest] = 原始像素 [ptrSource]
;********************************************************************
		pushad
		mov	ecx,@dwPtrSource
		mov	esi,[ebx].lpDIBitsSource
		mov	edi,[ebx].lpDIBitsRender
		lea	esi,[esi+ecx]
		lea	edi,[edi+eax]
		.if	ecx !=	eax
			or	@dwFlag,1	;如果存在源像素和目标像素不同，则表示还在活动状态
			mov	ecx,[ebx].dwDIByteWidth
			call	_WaveGetPixel
			call	_WaveGetPixel
			call	_WaveGetPixel
		.else
			cld
			movsw
			movsb
		.endif
		popad
;********************************************************************
; 继续循环
;********************************************************************
_Continue:
		pop	edx
		inc	edx
		add	edi,4		; 像素++
		cmp	edx,[ebx].dwBmpWidth
		jb	_Loop2

		inc	ecx
		mov	eax,[ebx].dwBmpHeight
		dec	eax
		cmp	ecx,eax
		jb	_Loop1
;********************************************************************
; 将渲染的像素数据拷贝到 hDc 中
;********************************************************************
		invoke	SetDIBits,[ebx].hDcRender,[ebx].hBmpRender,0,[ebx].dwBmpHeight,\
			[ebx].lpDIBitsRender,addr [ebx].stBmpInfo,DIB_RGB_COLORS
		.if	! @dwFlag
			and	[ebx].dwFlag,not F_WO_ACTIVE
		.endif
_Ret:
;********************************************************************
		assume	ebx:nothing
		popad
		ret

_WaveRender	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveUpdateFrame	proc	_lpWaveObject,_hDc,_bIfForce

		pushad
		mov	ebx,_lpWaveObject
		assume	ebx:ptr WAVE_OBJECT

		cmp	_bIfForce,0
		jnz	@F
		.if	[ebx].dwFlag & F_WO_NEED_UPDATE
			@@:
			invoke	BitBlt,_hDc,0,0,[ebx].dwBmpWidth,[ebx].dwBmpHeight,\
				[ebx].hDcRender,0,0,SRCCOPY
			and	[ebx].dwFlag,not F_WO_NEED_UPDATE
		.endif

		assume	ebx:nothing
		popad
		ret

_WaveUpdateFrame	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 扔一块石头
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveDropStone	proc	_lpWaveObject,_dwX,_dwY,_dwSize,_dwWeight
		local	@dwMaxX,@dwMaxY

		pushad
		mov	ebx,_lpWaveObject
		assume	ebx:ptr WAVE_OBJECT
;********************************************************************
; 计算范围
;********************************************************************
		mov	edx,_dwSize
		shr	edx,1

		mov	eax,_dwX
		mov	esi,_dwY

		mov	ecx,eax
		mov	edi,esi
		add	eax,edx		; x + size
		sub	ecx,edx		; x - size

		push	edx
		.if	[ebx].dwFlag & F_WO_ELLIPSE
			shr	edx,1
		.endif
		add	esi,edx		; y + size
		sub	edi,edx		; y - size
		pop	edx

		shl	edx,1
		.if	! edx
			inc	edx
		.endif
		mov	_dwSize,edx
;********************************************************************
; 判断范围的合法性
;********************************************************************
		inc	eax
		cmp	eax,[ebx].dwBmpWidth
		jge	_Ret
		cmp	ecx,1
		jl	_Ret
		inc	esi
		cmp	esi,[ebx].dwBmpHeight
		jge	_Ret
		cmp	edi,1
		jl	_Ret

		dec	eax
		dec	esi
;********************************************************************
; 将范围内的点的能量置为 _dwWeight
;********************************************************************
		mov	@dwMaxX,eax
		mov	@dwMaxY,esi
		.while	ecx <=	@dwMaxX
			push	edi
			.while	edi <=	@dwMaxY
				mov	eax,ecx
				sub	eax,_dwX
				imul	eax
				push	eax
				mov	eax,edi
				sub	eax,_dwY
				imul	eax
				pop	edx
				add	eax,edx
				push	eax
				mov	eax,_dwSize
				imul	eax
				pop	edx
				.if	edx <=	eax
					mov	eax,edi
					mul	[ebx].dwBmpWidth
					add	eax,ecx
					shl	eax,2
					add	eax,[ebx].lpWave1
					push	_dwWeight
					pop	[eax]
				.endif
				inc	edi
			.endw
			pop	edi
			inc	ecx
		.endw
		or	[ebx].dwFlag,F_WO_ACTIVE
;********************************************************************
_Ret:
		assume	ebx:nothing
		popad
		ret

_WaveDropStone	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 计算扩散数据、渲染位图、更新窗口、处理特效的定时器过程
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveTimerProc	proc	_hWnd,_uMsg,_idEvent,_dwTime

		pushad
		mov	ebx,_idEvent
		assume	ebx:ptr WAVE_OBJECT

		invoke	_WaveSpread,ebx
		invoke	_WaveRender,ebx
		.if	[ebx].dwFlag & F_WO_NEED_UPDATE
			invoke	GetDC,[ebx].hWnd
			invoke	_WaveUpdateFrame,ebx,eax,FALSE
			invoke	ReleaseDC,[ebx].hWnd,eax
		.endif
;********************************************************************
; 特效处理
;********************************************************************
		test	[ebx].dwFlag,F_WO_EFFECT
		jz	_Ret
		mov	eax,[ebx].dwEffectType
;********************************************************************
; Type = 1 雨点，Param1＝速度（0最快，越大越慢），Param2＝雨点大小，Param3＝能量
;********************************************************************
		.if	eax ==	1
			mov	eax,[ebx].dwEffectParam1
			or	eax,eax
			jz	@F
			invoke	_WaveRandom,ebx,eax
			.if	! eax
				@@:
				mov	eax,[ebx].dwBmpWidth
				dec	eax
				dec	eax
				invoke	_WaveRandom,ebx,eax
				inc	eax
				mov	ecx,eax

				mov	eax,[ebx].dwBmpHeight
				dec	eax
				dec	eax
				invoke	_WaveRandom,ebx,eax
				inc	eax
				mov	edx,eax

				invoke	_WaveRandom,ebx,[ebx].dwEffectParam2
				inc	eax
				mov	esi,eax
				invoke	_WaveRandom,ebx,[ebx].dwEffectParam3
				add	eax,50
				invoke	_WaveDropStone,ebx,ecx,edx,esi,eax
			.endif
;********************************************************************
; Type = 2 行船，Param1＝速度（0最快，越大越快），Param2＝大小，Param3＝能量
;********************************************************************
		.elseif	eax ==	2
			inc	[ebx].dwEff2Flip
			test	[ebx].dwEff2Flip,1
			jnz	_Ret

			mov	ecx,[ebx].dwEff2X
			mov	edx,[ebx].dwEff2Y
			add	ecx,[ebx].dwEff2XAdd
			add	edx,[ebx].dwEff2YAdd

			cmp	ecx,1
			jge	@F
			sub	ecx,1
			neg	ecx
			neg	[ebx].dwEff2XAdd
			@@:
			cmp	edx,1
			jge	@F
			sub	edx,1
			neg	edx
			neg	[ebx].dwEff2YAdd
			@@:
			mov	eax,[ebx].dwBmpWidth
			dec	eax
			cmp	ecx,eax
			jl	@F
			sub	ecx,eax
			xchg	eax,ecx
			sub	ecx,eax
			neg	[ebx].dwEff2XAdd
			@@:
			mov	eax,[ebx].dwBmpHeight
			dec	eax
			cmp	edx,eax
			jl	@F
			sub	edx,eax
			xchg	eax,edx
			sub	edx,eax
			neg	[ebx].dwEff2YAdd
			@@:
			mov	[ebx].dwEff2X,ecx
			mov	[ebx].dwEff2Y,edx
			invoke	_WaveDropStone,ebx,ecx,edx,[ebx].dwEffectParam2,[ebx].dwEffectParam3
;********************************************************************
; Type = 3 波浪，Param1＝密度，Param2＝大小，Param3＝能量
;********************************************************************
		.elseif	eax ==	3
			xor	edi,edi
			.while	edi <=	[ebx].dwEffectParam1
				mov	eax,[ebx].dwBmpWidth
				dec	eax
				dec	eax
				invoke	_WaveRandom,ebx,eax
				inc	eax
				mov	ecx,eax

				mov	eax,[ebx].dwBmpHeight
				dec	eax
				dec	eax
				invoke	_WaveRandom,ebx,eax
				inc	eax
				mov	edx,eax

				invoke	_WaveRandom,ebx,[ebx].dwEffectParam2
				inc	eax
				mov	esi,eax
				invoke	_WaveRandom,ebx,[ebx].dwEffectParam3
				invoke	_WaveDropStone,ebx,ecx,edx,esi,eax
				inc	edi
			.endw
		.endif
_Ret:
		assume	ebx:nothing
		popad
		ret

_WaveTimerProc	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 释放对象
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveFree	proc	_lpWaveObject

		pushad
		mov	ebx,_lpWaveObject
		assume	ebx:ptr WAVE_OBJECT
;********************************************************************
		.if	[ebx].hDcRender
			invoke	DeleteDC,[ebx].hDcRender
		.endif
		.if	[ebx].hBmpRender
			invoke	DeleteObject,[ebx].hBmpRender
		.endif
		.if	[ebx].lpDIBitsSource
			invoke	GlobalFree,[ebx].lpDIBitsSource
		.endif
		.if	[ebx].lpDIBitsRender
			invoke	GlobalFree,[ebx].lpDIBitsRender
		.endif
		.if	[ebx].lpWave1
			invoke	GlobalFree,[ebx].lpWave1
		.endif
		.if	[ebx].lpWave2
			invoke	GlobalFree,[ebx].lpWave2
		.endif
		invoke	KillTimer,[ebx].hWnd,ebx
		invoke	RtlZeroMemory,ebx,sizeof WAVE_OBJECT
;********************************************************************
		assume	ebx:nothing
		popad
		ret

_WaveFree	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 初始化对象
; 参数：_lpWaveObject ＝ 指向 WAVE_OBJECT的指针
; 返回：eax = 0 成功、= 1 失败
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveInit	proc	_lpWaveObject,_hWnd,_hBmp,_dwSpeed,_dwType
		local	@stBmp:BITMAP,@dwReturn

		pushad
		xor	eax,eax
		mov	@dwReturn,eax
		mov	ebx,_lpWaveObject
		assume	ebx:ptr WAVE_OBJECT
		invoke	RtlZeroMemory,ebx,sizeof WAVE_OBJECT

		.if	_dwType
			or	[ebx].dwFlag,F_WO_ELLIPSE
		.endif
;********************************************************************
; 获取位图尺寸
;********************************************************************
		push	_hWnd
		pop	[ebx].hWnd
		invoke	GetTickCount
		mov	[ebx].dwRandom,eax

		invoke	GetObject,_hBmp,sizeof BITMAP,addr @stBmp
		.if	! eax
			@@:
			inc	@dwReturn
			jmp	_Ret
		.endif
		mov	eax,@stBmp.bmHeight
		mov	[ebx].dwBmpHeight,eax
		cmp	eax,3
		jle	@B
		mov	eax,@stBmp.bmWidth
		mov	[ebx].dwBmpWidth,eax
		cmp	eax,3
		jle	@B

		push	eax
		shl	eax,2
		mov	[ebx].dwWaveByteWidth,eax
		pop	eax
		lea	eax,[eax+eax*2]
		add	eax,3
		and	eax,not 0011b
		mov	[ebx].dwDIByteWidth,eax
;********************************************************************
; 创建用于渲染的位图
;********************************************************************
		invoke	GetDC,_hWnd
		mov	esi,eax
		invoke	CreateCompatibleDC,esi
		mov	[ebx].hDcRender,eax
		invoke	CreateCompatibleBitmap,esi,[ebx].dwBmpWidth,[ebx].dwBmpHeight
		mov	[ebx].hBmpRender,eax
		invoke	SelectObject,[ebx].hDcRender,eax
;********************************************************************
; 分配波能缓冲区
;********************************************************************
		mov	eax,[ebx].dwWaveByteWidth
		mul	[ebx].dwBmpHeight
		mov	edi,eax
		invoke	GlobalAlloc,GPTR,edi
		mov	[ebx].lpWave1,eax
		invoke	GlobalAlloc,GPTR,edi
		mov	[ebx].lpWave2,eax
;********************************************************************
; 分配像素缓冲区
;********************************************************************
		mov	eax,[ebx].dwDIByteWidth
		mul	[ebx].dwBmpHeight
		mov	edi,eax
		invoke	GlobalAlloc,GPTR,edi
		mov	[ebx].lpDIBitsSource,eax
		invoke	GlobalAlloc,GPTR,edi
		mov	[ebx].lpDIBitsRender,eax
;********************************************************************
; 获取原始像素数据
;********************************************************************
		mov	[ebx].stBmpInfo.bmiHeader.biSize,sizeof BITMAPINFOHEADER
		push	[ebx].dwBmpWidth
		pop	[ebx].stBmpInfo.bmiHeader.biWidth
		mov	eax,[ebx].dwBmpHeight
		neg	eax
		mov	[ebx].stBmpInfo.bmiHeader.biHeight,eax
		inc	[ebx].stBmpInfo.bmiHeader.biPlanes
		mov	[ebx].stBmpInfo.bmiHeader.biBitCount,24
		mov	[ebx].stBmpInfo.bmiHeader.biCompression,BI_RGB
		mov	[ebx].stBmpInfo.bmiHeader.biSizeImage,0

		invoke	CreateCompatibleDC,esi
		push	eax
		invoke	SelectObject,eax,_hBmp
		invoke	ReleaseDC,_hWnd,esi
		pop	eax
		mov	esi,eax

		invoke	GetDIBits,esi,_hBmp,0,[ebx].dwBmpHeight,[ebx].lpDIBitsSource,\
			addr [ebx].stBmpInfo,DIB_RGB_COLORS
		invoke	GetDIBits,esi,_hBmp,0,[ebx].dwBmpHeight,[ebx].lpDIBitsRender,\
			addr [ebx].stBmpInfo,DIB_RGB_COLORS
		invoke	DeleteDC,esi

		.if	![ebx].lpWave1 || ![ebx].lpWave2 || ![ebx].lpDIBitsSource ||\
			![ebx].lpDIBitsRender || ![ebx].hDcRender
			invoke	_WaveFree,ebx
			inc	@dwReturn
		.endif

		invoke	SetTimer,_hWnd,ebx,_dwSpeed,addr _WaveTimerProc

		or	[ebx].dwFlag,F_WO_ACTIVE or F_WO_NEED_UPDATE
		invoke	_WaveRender,ebx
		invoke	GetDC,[ebx].hWnd
		invoke	_WaveUpdateFrame,ebx,eax,TRUE
		invoke	ReleaseDC,[ebx].hWnd,eax
;********************************************************************
_Ret:
		assume	ebx:nothing
		popad
		mov	eax,@dwReturn
		ret

_WaveInit	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 一些特效
; 输入：_dwType = 0	关闭特效
;	_dwType <> 0	开启特效，参数具体见上面
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveEffect	proc	uses ebx eax _lpWaveObject,\
			_dwType,_dwParam1,_dwParam2,_dwParam3
		local	@dwMaxX,@dwMaxY

		mov	ebx,_lpWaveObject
		assume	ebx:ptr WAVE_OBJECT
;********************************************************************
		mov	eax,_dwType
		.if	eax ==	0
;********************************************************************
; 关闭特效
;********************************************************************
			and	[ebx].dwFlag,not F_WO_EFFECT
			mov	[ebx].dwEffectType,eax
		.elseif	eax ==	2
;********************************************************************
; 行船特效
;********************************************************************
			mov	eax,_dwParam1
			mov	[ebx].dwEff2XAdd,eax
			mov	[ebx].dwEff2YAdd,eax

			mov	eax,[ebx].dwBmpWidth
			dec	eax
			dec	eax
			invoke	_WaveRandom,ebx,eax
			inc	eax
			mov	[ebx].dwEff2X,eax

			mov	eax,[ebx].dwBmpHeight
			dec	eax
			dec	eax
			invoke	_WaveRandom,ebx,eax
			inc	eax
			mov	[ebx].dwEff2Y,eax

			jmp	@F
		.else
;********************************************************************
; 默认
;********************************************************************
			@@:
			push	_dwType
			pop	[ebx].dwEffectType
			push	_dwParam1
			pop	[ebx].dwEffectParam1
			push	_dwParam2
			pop	[ebx].dwEffectParam2
			push	_dwParam3
			pop	[ebx].dwEffectParam3
			or	[ebx].dwFlag,F_WO_EFFECT
		.endif
;********************************************************************
		assume	ebx:nothing
		ret

_WaveEffect	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;
;
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
endif
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
