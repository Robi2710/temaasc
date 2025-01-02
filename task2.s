.data
    a: .space 4194304
    nrinstr: .space 4
    instr: .space 4
    nrfis: .space 4
    i: .space 4
    i1: .space 4
    j: .space 4
    k: .space 4
    l: .space 4
    desc: .space 4
    cnt: .space 4
    dim: .space 4
    start_row: .space 4
    start_col: .space 4
    end_col: .space 4
    row: .space 4
    currentdesc: .space 4
    found: .space 4
    canfit: .space 4
    formatread: .asciz "%ld"
    formatADD: .asciz "%ld: ((%ld, %ld), (%ld, %ld))\n"
    formatGET: .asciz "((%ld, %ld), (%ld, %ld))\n"
    formatGET_0: .asciz "((0, 0), (0, 0))\n"
    ADD_0: .asciz "%ld: ((0, 0), (0, 0))\n"
.text
;#void ADD()
ADD:
    pushl %ebp          
    movl %esp, %ebp
    pushl %ebx
    pushl %esi
    pushl %edi
    ;#fin>>nrfis
    pushl $nrfis
    pushl $formatread
    call scanf
    popl %edx
    popl %edx

    ;#for (k=0; k < nrfis; k++)
    movl $0,k
et_for_ADD:
    mov nrfis,%ebx
    mov k,%edx
    cmp %edx,%ebx
    je exit_ADD

    ;#cin>>desc>>dim
    pushl $desc
    pushl $formatread
    call scanf
    popl %eax
    popl %eax
    pushl $dim
    pushl $formatread
    call scanf
    popl %eax
    popl %eax

    cmp $9,dim
    jl et_for_ADD_continue

    movl dim, %eax
    add $7, %eax
    shr $3, %eax
    movl %eax, cnt

    movl $0, found
    movl $0, start_row
    movl $0, start_col
;#for (i=0; i < 1024 && !found ; i++)
    movl $0,i1
et_for2_ADD:
    movl $1024, %eax
    movl i1, %ecx
    cmp %ecx, %eax
    je afisare_ADD 

    cmp $0, found
    jne afisare_ADD
    ;#for (j=0; j<= 1024 - cnt; j++)
    movl $0,j
et_for3_ADD:
    movl $1024, %eax
    movl j, %ecx
    sub cnt, %eax
    cmp %eax, %ecx
    jg et_for2_ADD_continue

    movl $1, canfit
    ;#for (l=0; l<cnt; l++)
    movl $0,l
et_for4_ADD:
    movl cnt, %eax
    movl l, %ecx
    cmp %ecx, %eax
    je et_canfit 

    movl j,%eax
    addl l, %eax
    cmp $1024,%eax
    jge et_cantfit
    ;#if (a[i][j+l] != 0)
    movl i1, %eax
    movl $0, %edx 
    movl $1024, %ebx
    mull %ebx
    add j, %eax
    add l,%eax 
    lea a, %edi
    movl (%edi,%eax,4), %ebx
    cmp $0, %ebx
    jne et_cantfit
    inc l
    jmp et_for4_ADD
et_cantfit:
    movl $0, canfit
    jmp et_canfit 
et_canfit:
    cmp $1, canfit
    jne et_for3_ADD_continue

    movl i1, %eax
    movl j, %ecx
    movl %eax, start_row
    movl %ecx, start_col
    movl $1, found
    jmp afisare_ADD
et_for3_ADD_continue:
    inc j
    jmp et_for3_ADD
et_for2_ADD_continue:
    inc i1
    jmp et_for2_ADD
afisare_ADD:
    cmp $0, found 
    je afisare0_ADD
    ;#for (int l=0; l<cnt; l++)
    movl $0,l
et_for5_ADD:
    movl cnt, %eax
    movl l,%ecx
    cmp %ecx,%eax
    je afisare_ADD_2

    ;#a[start_row][start_col+l]=desc
    movl start_row, %eax
    movl $0,%edx 
    movl $1024,%ebx
    mull %ebx
    add start_col, %eax
    add l, %eax
    lea a, %edi
    movl desc, %edx
    movl %edx, (%edi,%eax,4)
    inc l
    jmp et_for5_ADD
afisare_ADD_2:
    ;#fout<<desc:((start_row, start_col),(start_row, start_col+cnt-1))
    movl start_col, %eax
    add cnt, %eax
    dec %eax
    pushl %eax
    pushl start_row
    pushl start_col
    pushl start_row
    pushl desc
    pushl $formatADD
    call printf
    popl %eax
    popl %eax
    popl %eax
    popl %eax
    popl %eax

    pushl $0
    call fflush
    popl %eax 

    inc k
    jmp et_for_ADD
afisare0_ADD:
    ;#fout<<"0:((0,0),(0,0))\n"
    pushl desc
    pushl $ADD_0
    call printf
    popl %eax
    popl %eax

    pushl $0
    call fflush
    popl %eax

    inc k
    jmp et_for_ADD
et_for_ADD_continue:
    inc k
    jmp et_for_ADD
exit_ADD:
    popl %edi           
    popl %esi
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret
GET:
    pushl %ebp          
    movl %esp, %ebp
    pushl %ebx
    pushl %esi
    pushl %edi

    pushl $desc
    pushl $formatread
    call scanf
    popl %eax
    popl %eax

    movl $-1, start_col 
    movl $-1, end_col
    ;#for (int i=0; i<1024; i++)
    movl $0,i1
et_for_GET:
    movl $1024, %eax
    movl i1, %ecx
    cmp %ecx, %eax
    je afisare_GET 

    ;# for (int j=0; j<1024; j++)  
    movl $0,j
et_for2_GET:
    movl $1024, %eax
    movl j, %ecx
    cmp %ecx, %eax
    je et_for_GET_continue

    ;#if (a[i][j]==desc)
    movl i1, %eax
    movl $0, %edx
    movl $1024, %ebx
    mull %ebx
    add j, %eax
    lea a, %edi
    movl (%edi,%eax,4), %ebx
    cmp desc, %ebx
    jne et_for2_GET_continue
    ;#end_col=j
    movl j, %eax
    movl %eax, end_col
    ;#row=i
    movl i1, %eax
    movl %eax, row
    

    ;#if (start_col==-1)
    movl start_col, %eax
    cmp $-1, %eax
    jne et_for2_GET_continue
    ;#start_col=j
    movl j, %eax
    movl %eax, start_col
et_for2_GET_continue:
    inc j
    jmp et_for2_GET
et_for_GET_continue:
    inc i1
    jmp et_for_GET
afisare_GET:
    ;#if start_col!=-1
    movl start_col, %eax
    cmp $-1, %eax
    je afisare0_GET

    ;#cout<<"((row, start_column), (row,end_col))\n"
    pushl end_col
    pushl row
    pushl start_col
    pushl row
    pushl $formatGET
    call printf
    popl %eax
    popl %eax
    popl %eax
    popl %eax
    popl %eax

    pushl $0
    call fflush
    popl %eax

    jmp exit_get
afisare0_GET:
    ;#cout<<"((0,0), (0,0))\n"
    pushl formatGET_0
    call printf
    popl %eax

    pushl $0
    call fflush
    popl %eax
exit_get:
    popl %edi           
    popl %esi
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret
DELETE:
    pushl %ebp          
    movl %esp, %ebp
    pushl %ebx
    pushl %esi
    pushl %edi

    pushl $desc
    pushl $formatread
    call scanf
    popl %eax
    popl %eax

    ;#for (int i=0; i<1024; i++)
    movl $0,i1
et_for_DELETE:
    movl $1024, %eax
    movl i1, %ecx
    cmp %ecx, %eax
    je afisare_DELETE

    ;#for (int j=0; j<1024; j++)
    movl $0,j
et_for2_DELETE:
    movl $1024, %eax
    movl j, %ecx
    cmp %ecx, %eax
    je et_for_DELETE_continue

    ;#if (a[i][j]==desc)
    movl i1, %eax
    movl $0, %edx
    movl $1024, %ebx
    mull %ebx
    add j, %eax
    lea a, %edi
    movl (%edi,%eax,4), %ebx
    cmp desc, %ebx
    jne et_for2_DELETE_continue
    ;#a[i][j]=0
    movl i1, %eax
    movl $0, %edx
    movl $1024, %ebx
    mull %ebx
    add j, %eax
    lea a, %edi
    movl $0, %ebx
    movl %ebx, (%edi,%eax,4)
et_for2_DELETE_continue:
    inc j
    jmp et_for2_DELETE
et_for_DELETE_continue:
    inc i1
    jmp et_for_DELETE
afisare_DELETE:
    ;#for (i=0; i<1024; i++)
    movl $0,i1
et_for3_DELETE:
    movl $1024, %eax
    movl i1, %ecx
    cmp %ecx, %eax
    je exit_DELETE

    ;#for (int j=0; j<1024;)
    movl $0,j
et_for4_DELETE:
    movl $1024, %eax
    movl j, %ecx
    cmp %ecx, %eax
    je et_for3_DELETE_continue

    ;#if (a[i][j]!=0)
    movl i1, %eax
    movl $0, %edx
    movl $1024, %ebx
    mull %ebx
    add j, %eax
    lea a, %edi
    movl (%edi,%eax,4), %ebx
    cmp $0, %ebx
    je et_for4_DELETE_continue
    ;#row = i start_col=j currentdesc=a[i][j]
    movl i1, %eax
    movl %eax, row
    movl j, %eax
    movl %eax, start_col
    movl %ebx, currentdesc
    ;#while (j < 1024 && a[i][j]==currentdesc)
et_while_delete:
    movl $1024, %eax
    movl j, %ecx
    cmp %ecx, %eax
    je afisare_DELETE_2

    movl i1, %eax
    movl $0, %edx
    movl $1024, %ebx
    mull %ebx
    add j, %eax
    lea a, %edi
    movl (%edi,%eax,4), %ebx
    cmp currentdesc, %ebx
    jne afisare_DELETE_2
    inc j
    jmp et_while_delete
et_for3_DELETE_continue:
    inc i1
    jmp et_for3_DELETE
et_for4_DELETE_continue:
    inc j
    jmp et_for4_DELETE  
afisare_DELETE_2:
    ;#cout<<"currentdesc: ((row, start_col), (row, j-1))\n"
    movl j, %eax
    dec %eax
    pushl %eax
    pushl row
    pushl start_col
    pushl row
    pushl currentdesc
    pushl $formatADD
    call printf
    popl %eax
    popl %eax
    popl %eax
    popl %eax
    popl %eax
    popl %eax 

    pushl $0
    call fflush
    popl %eax

    jmp et_for4_DELETE 
exit_DELETE:  
    popl %edi           
    popl %esi
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret
.global main
main:
    ;#cin>>nrinstr
    pushl $nrinstr
    pushl $formatread
    call scanf
    popl %ebx
    popl %ebx

    ;#for (i=0; i<nrinstr; i++)
    xor %ecx,%ecx
    mov $0,i
et_for_main:
    movl nrinstr, %eax
    mov i, %ecx
    cmp %ecx, %eax
    je exit_main

    ;#cin>>instr
    pushl $instr
    pushl $formatread
    call scanf
    popl %edx
    popl %edx

    ;#if (instr==1) 
    mov $1,%edx
    mov instr,%ebx
    cmp %ebx,%edx
    je apelare_add
    ;#if (instr==2)
    mov instr, %ebx
    mov $2, %edx
    cmp %ebx,%edx
    je apelare_GET
    mov $3, %edx 
    cmp %ebx, %edx 
    je apelare_DELETE
    inc i 
    jmp et_for_main
apelare_add:
    ;#ADD()
    call ADD
    inc i
    jmp et_for_main
apelare_GET:
    ;#GET()
    call GET
    inc i
    jmp et_for_main
apelare_DELETE:
    ;#DELETE()
    call DELETE
    inc i
    jmp et_for_main
exit_main:
    pushl $0
    call fflush
    popl %eax

    mov $1,%eax
    xor %ebx,%ebx
    int $0x80
