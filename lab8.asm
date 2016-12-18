.model small
.stack 100h
.data
cout dw -1
temp dw 0
rows dw 4
cols dw 5
TWO db 2 
FOUR db 4
c db ?
CR_LF	db 0dh,0ah, '$'
mesg db 0dh,0ah,'Rezultat: $', 0dh,0ah
mas db 20 dup(?)
.code
;макрос вывода на экран текстового сообщения
;str - стока для вывода
write macro  str
    push    ax
    push    dx
 
    lea     dx,str  ;адрес строки для вывода
    mov     ah,09h  ;09h функция
    int     21h
 
    pop     dx
    pop     ax
endm
;макрос вывода числа на экран
;вход: AX - число для вывода на экран
putdigit macro
    local lput1
    local lput2
    local exx
 
    push    ax
    push    cx
    push    -1  ;сохраним признак конца числа
    mov     cx,10   ;делить будем на 10
lput1:  xor     dx,dx   ;чистим регистр dx
    mov     ah,0                   
    div     cl  ;Делим 
    mov     dl,ah   
    push    dx  ;Сохраним цифру
    cmp al,0    ;Остался 0? 
    jne lput1   ;нет -> продолжим
    mov ah,2h
lput2:  pop dx  ;Восстановим цифру
    cmp dx,-1   ;Дошли до конца -> выход 
    je  exx
    add dl,'0'  ;Преобразуем число в цифру
    int 21h ;Выведем цифру на экран
    jmp lput2   ;И продолжим
exx:
    mov dl,' ' 
    int 21h
    pop cx
    pop     ax
endm


start:
mov ax, @data
mov ds, ax
lea bx, mas
mov cx, rows
mov al, 0

in1:
  push cx
  mov cx, cols
  mov si, 0
  inc cout
in2:
   add al, 10
   mov [bx][si], al 
   mov al, [bx][si]
   inc si
   loop in2
   add bx, cols
   pop cx
   loop in1  
   
	   ;вывод массива на экран
    lea     bx,mas
    mov     cx,rows
 
    
out1:   ;цикл по строкам
    push    cx
    mov     cx,cols
    mov     si,0
    write CR_LF
out2:   ;цикл по колонкам
    xor     ax,ax
    mov al,[bx][si] ;Выводимое число в регисте AL
    putdigit    ;макрос вывода
    inc     si
    loop    out2
 
    add     bx,cols
    pop     cx
    loop    out1
	
   lea bx, mas
   mov cx, rows
   mov al, 0

   mov c, 0
op1:
  push cx
  mov cx, cols
  mov si, 0
  add cout, 1
op2:  
   xor ax, ax
   mov al, c
   div FOUR
   cmp ah, 0
   je oper
   add si, 1
   add c, 1
   loop op2
   add bx, cols
   pop cx
   loop op1  
   jmp @@Exit
   oper:
   mov al, [bx][si]
   div TWO
   add ax, 4
   mov [bx][si], al 
   add si, 1
   add c, 1
   loop op2
   add bx, cols
   pop cx
   loop op1
   @@Exit:
   write CR_LF 
   write mesg
      ;вывод массива на экран
    lea     bx,mas
    mov     cx,rows
   
output1:   ;цикл по строкам
    push    cx
    mov     cx,cols
    mov     si,0 
	write CR_LF 
output2:   ;цикл по колонкам
    xor     ax,ax
    mov al,[bx][si] ;Выводимое число в регисте AL
    putdigit    ;макрос вывода
    inc     si
    loop    output2
 
    add     bx,cols
    pop     cx
    loop    output1
   mov ah,4ch
   int 21h
end start   