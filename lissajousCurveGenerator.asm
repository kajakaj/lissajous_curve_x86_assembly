    section     .data
    start_time   dq -3.1416
    end_time     dq 3.1416
    time_step    dq 0.001
    sin          dq 0

    section   .text	
    global  lissajous

;function arguments in registers:
;rdi - pixels
;rsi - width
;rdx - height
;xmm0 - a
;xmm1 - b
;xmm2 - delta

;local variables in registers;
;xmm3 - time
;xmm4 - x - rax
;xmm5 - y - rbx
;xmm6 - temp - rcx
;xmm7 - length/2
;xmm8 - width/2

lissajous:
    ;double(width/2)
    mov rcx, rsi
    sar rcx, 1          ;width/2
    cvtsi2sd xmm8, rcx

    ;double(height/2)
    mov rcx, rdx
    sar rcx, 1          ;height/2
    cvtsi2sd xmm7, rcx

    movsd xmm3, [start_time]

loop:
    ;x = sin(a * t + delta) * width/2 + width/2
    movsd xmm6, xmm0    ;a * t 
    mulsd xmm6, xmm3    
    addsd xmm6, xmm2    ;a * t + delta
    movsd [sin], xmm6
    fld qword [sin]
    fsin                ;sin(a * t + delta)
    fstp qword [sin]
    movsd xmm6, [sin]
    mulsd xmm6, xmm8    ;sin(a * t + delta) * width/2
    addsd xmm6, xmm8    ;sin(a * t + delta) * width/2 + width/2
    movsd xmm4, xmm6

    ;int(x)
    cvttsd2si rax, xmm4
    
    ;y = sin(b * t) * length/2 + length/2
    movsd xmm6, xmm1   
    mulsd xmm6, xmm3    ;b * t 
    movsd [sin], xmm6
    fld qword [sin]
    fsin                ;sin(b * t)
    fstp qword [sin]
    movsd xmm6, [sin]
    mulsd xmm6, xmm7    ;sin(b * t) * length/2
    addsd xmm6, xmm7    ;sin(b * t) * length/2 + length/2
    movsd xmm5, xmm6

    ;int(y)
    cvttsd2si rbx, xmm5
    
    ;save pixel to an address: piksele + (y*width + x)*4
    imul rbx, rsi           ;y*width
    add rbx, rax            ;y*width + x
    sal rbx, 2              ;(y*width + x)*4

    mov	rcx, 0xffffff00     ;blue color
    mov [rdi + rbx], rcx    ;save a pixel

    ;time += time_step
    addsd xmm3, [time_step]

    ;check condition t>end_time
    ucomisd xmm3, [end_time]
   
    ;if condition not satisfied, jump to loop
    jbe loop

end:
    ret
