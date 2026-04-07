				AREA	myData, DATA, READWRITE
GPIO_B_BASE		EQU		0x48000400
GPIO_C_BASE		EQU		0x48000800
RCC_BASE		EQU		0x40021000
	
GPIO_MODER		equ		0x00
GPIO_IDR		equ		0x10
GPIO_ODR		equ		0x14
	
RCC_AHB2ENR		equ		0x4C
	
				AREA	myCode, CODE, READONLY
					
				EXPORT	main
				ENTRY

enable_clock	proc
	
				ldr		r2, =RCC_BASE
				ldr		r1, [r2, #RCC_AHB2ENR]
				orr		r1, r1, #1
				str		r1, [r2, #RCC_AHB2ENR]
				bx		lr

				endp



main			proc

				bl		enable_clock
				
				

stop			b		stop
				endp
				ALIGN
				END