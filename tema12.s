.data
    v: .space 4096
    temp: .space 4096
    n: .space 4
    instr: .space 4
    nrfis: .space 4
    desc: .space 4
    dim: .space 4
    cnt: .space 4
    canfit: .space 4
    index: .space 4
    startindex: .long -1
    i: .space 4
    j: .space 4
    k: .space 4
    i1: .space 4
    i2: .space 4
    i3: .space 4
    i4: .space 4
    i5: .space 4
    i6: .space 4
    i7: .space 4
    i8: .space 4
    start: .space 4
    start2: .space 4
    start3: .space 4
    end: .space 4
    end2: .space 4
    found: .space 4
    desccurent: .space 4
    desccurent2: .space 4
    aux: .space 4
    interval0: .asciz ": (0, 0)\n"
    interval0_get: .asciz "(0, 0)\n"
    interval0_add: .asciz "%ld: (0, 0)\n"
    interval: .asciz "%ld: (%ld, %ld)\n"
    interval_get: .asciz "(%ld, %ld)"
    newline: .asciz "\n"
    formatread: .asciz "%ld"
    formatprint: .asciz "%ld"
    stringprint: .asciz "%s"
.text
;#ADD(v,desc,dim)
ADD:
    pushl %ebp
    mov %esp,%ebp
    movl 16(%ebp), %eax
    add $7, %eax
    shr $3, %eax
    movl %eax, cnt
    cmp $1024, %eax
    jg afisare0_add
    movl $0, k
    movl $-1, startindex

loop_add_proced:
    movl $1023, %eax
    movl k, %ecx
    cmp %ecx, %eax
    je et_startindex

    movl $1, canfit
    movl $0, i8
    lea v, %edi
loop_add_proced_2:
    movl cnt, %edx
    movl i8, %ebx
    cmp %ebx, %edx
    je et_canfit

    movl i8, %edx
    addl %ecx, %edx
    cmp $1023, %edx
    ja et_canfit_0
    movl (%edi, %edx, 4), %eax
    cmp $0, %eax
    jne et_canfit_0

    inc i8
    jmp loop_add_proced_2
et_canfit_0:
    mov $0, canfit
    inc k
    jmp loop_add_proced
et_canfit:
    mov %ecx, startindex
    movl %ecx, %edx
    add cnt, %edx
    dec %edx
    cmp $1024, %edx
    ja afisare0_add

et_startindex:
    cmp $-1, startindex
    jne final_loop_add

    pushl desc
    pushl $interval0_add
    call printf
    popl %eax
    popl %eax

    pushl $0
    call fflush
    popl %eax

    popl %ebp
    ret
final_loop_add:
    mov $0, %ecx
    mov cnt, %eax
et_loop:
    cmp %ecx, %eax
    je afisare

    movl startindex, %ebx
    addl %ecx, %ebx
    movl 12(%ebp), %edx
    movl %edx, (%edi, %ebx, 4)
    inc %ecx
    jmp et_loop
afisare:
    movl startindex, %eax
    addl cnt, %eax
    sub $1, %eax
    cmp $-1, startindex
    jle afisare0_add
    pushl %eax
    pushl startindex
    pushl desc
    pushl $interval
    call printf
    popl %eax
    popl %eax
    popl %eax
    popl %eax

    pushl $0
    call fflush
    popl %eax

    popl %ebp
    ret
afisare0_add:
    pushl desc
    pushl $interval0_add
    call printf
    popl %eax
    popl %eax

    pushl $0
    call fflush
    popl %eax

    popl %ebp
    ret

GET:
    pushl %ebp
    mov %esp,%ebp
    
    movl $-1,start 
    movl $-1,end
    movl $0,i2
    ;#for (i=0; i<1024; i++)
et_for1_get:
    movl i2,%ecx
    movl $1024,%eax
    cmp %ecx,%eax
    je indici

    ;#if (v[i]==desc)
    movl i2,%edx
    lea v,%edi
    movl (%edi,%edx,4),%eax
    cmp %eax,12(%ebp)
    je exista
    inc i2
    jmp et_for1_get
exista:
    ;#if (start==-1)
    movl start,%eax
    mov %ecx,end
    cmp $-1,%eax
    je et_start
    inc i2
    jmp et_for1_get
et_start:
    mov %ecx,start
    inc i2
    jmp et_for1_get
indici:
    ;#if (start!=-1)
    movl start,%eax
    cmp $-1,%eax
    je afisare0
    ;#cout<<"("<<start<<","<<end<<")\n"
afisare_get:
    pushl end
    pushl start
    pushl $interval_get
    call printf
    popl %eax
    popl %eax
    popl %eax

    pushl $0
    call fflush
    popl %eax

    ;#cout<<endl
    push $newline
    call printf
    popl %eax

    pushl $0
    call fflush
    popl %eax
    
    popl %ebp
    ret
afisare0:
    ;#cout<<"(0,0)\n"
    pushl $interval0_get
    call printf
    popl %eax

    pushl $0
    call fflush
    popl %eax

    popl %ebp
    ret
DELETE:
    pushl %ebp
    mov %esp,%ebp
    
    movl $0,found
    movl $0,i3
    ;#for (i=0; i<1024; i++)
et_for1_delete:
    movl i3,%ecx
    movl $1024,%eax
    cmp %ecx,%eax
    je indici_delete

    ;#if (v[i]==desc)
    movl i3,%edx
    lea v,%edi
    movl (%edi,%edx,4),%eax
    cmp %eax,12(%ebp)
    je exista_delete
    inc i3
    jmp et_for1_delete
exista_delete:
    ;#v[i]=0 found=true
    movl i3,%edx
    lea v,%edi
    movl $0,(%edi,%edx,4)
    movl $1,found
    inc i3
    jmp et_for1_delete
indici_delete:
    ;#if (found==true)
    movl found,%eax
    movl $0,i4
    
et_for2_delete:
    ;#for(i=0; i<1024)
    movl i4,%ecx
    movl $1024,%eax
    cmp %ecx,%eax
    je et_return
    ;#if (v[i]!=0)
    movl i4,%edx
    lea v,%edi
    movl (%edi,%edx,4),%eax
    cmp $0,%eax
    je et_continue
    ;#start2=i
    movl %ecx,start2
    ;#desccurent=v[i]
    movl %eax,desccurent
    ;#while (i<1024 && v[i]==desccurent)
et_while:
    movl i4,%ecx
    cmp $1024,%ecx
    je afisare_delete
    
    movl i4,%edx
    lea v,%edi
    movl (%edi,%edx,4),%eax
    cmp desccurent,%eax
    jne afisare_delete
    inc i4
    movl i4,%ecx
    jmp et_while
et_continue:
    inc i4
    jmp et_for2_delete
afisare_delete:
    ;#cout<<desccurent<<": (start2,i-1)\n"
    movl i4,%eax
    cmp $1023,%eax
    sub $1,%eax
afisare_delete_2:
    movl start2,%edx
    pushl %eax
    pushl %edx
    pushl desccurent
    pushl $interval
    call printf
    popl %eax
    popl %eax
    popl %eax
    popl %eax

    pushl $0
    call fflush
    popl %eax

    jmp et_for2_delete
et_return:
    popl %ebp
    ret
DEFRAGMENTATION:
    pushl %ebp
    mov %esp,%ebp
   
    movl $0, index      ;# Initialize index to 0
    movl $0, i5         ;# Initialize i5 to 0
    movl $0, i6         ;# Initialize i6 to 0
    movl $0, i7         ;# Initialize i7 to 0
    movl $-1, start3    ;# Initialize start3 to -1
    movl $-1, end2      ;# Initialize end2 to -1
    movl $0, desccurent2;# Initialize desccurent2 to 0

    ;# Loop through the array and copy non-zero elements to the front
et_loop1_defrag:
    movl i5,%ecx
    movl $1024,%eax
    cmp %ecx,%eax
    je et_loop2_defrag

    ;# If v[i5] != 0
    movl i5,%edx
    lea v,%edi
    movl (%edi,%edx,4),%eax
    cmp $0,%eax
    je et_continue1_defrag

    ;# aux = v[i5], v[i5] = 0, v[i6] = aux, i6++
    movl %eax,aux
    movl $0,(%edi,%edx,4)
    lea v,%edi
    movl i6,%ebx
    movl aux, %ecx
    movl %ecx,(%edi,%ebx,4)
    inc i6
    inc i5 
    jmp et_loop1_defrag

et_continue1_defrag:
    inc i5
    jmp et_loop1_defrag

    ;# Loop to print intervals of descriptors
et_loop2_defrag:
    movl i7,%ecx
    movl $1024,%eax
    cmp %ecx,%eax
    je et_return_defrag

    ;# If v[i7] != 0
    movl i7,%edx
    lea v,%edi
    movl (%edi,%edx,4),%eax
    cmp $0,%eax
    je et_continue2_defrag

    ;# start3 = i7, desccurent2 = v[i7]
    movl i7,%edx
    movl %edx,start3
    movl %eax,desccurent2

    ;# While i7 < 1024 && v[i7] == descurent2
et_while_defrag:
    movl i7,%ecx
    cmp $1024,%ecx
    je defrag_afisare
    
    movl i7,%edx
    lea v,%edi
    movl (%edi,%edx,4),%eax
    cmp desccurent2,%eax
    jne defrag_afisare
    inc i7
    jmp et_while_defrag 

et_continue2_defrag:
    inc i7
    jmp et_loop2_defrag

defrag_afisare:
    ;# Print desccurent2: (start3, i7-1)
    movl i7,%eax
    sub $1,%eax
    movl start3,%edx
    pushl %eax
    pushl %edx
    pushl desccurent2
    pushl $interval
    call printf
    popl %eax
    popl %eax
    popl %eax
    popl %eax

    pushl $0
    call fflush
    popl %eax

    jmp et_loop2_defrag

et_return_defrag:
    popl %ebp
    ret

.global main
main:
    ;#cin>>n
    pushl $n
    pushl $formatread
    call scanf
    popl %ebx
    popl %ebx

    ;#for (i=0; i<n; i++) 
    xor %ecx,%ecx
    mov $0,i1
et_for:
    movl n,%eax
    mov i1,%ecx
    cmp %ecx, %eax
    je exit

    ;#cin>>instr
    pushl $instr
    pushl $formatread
    call scanf
    popl %edx
    popl %edx

    inc %ecx
    ;#if (instr==1)
    mov $1,%edx
    mov instr,%ebx
    cmp %ebx,%edx
    je et_read_nrfis
    mov instr, %ebx
    mov $2, %edx
    cmp %ebx,%edx
    je et_read_get
    mov instr, %ebx
    mov $3, %edx
    cmp %ebx,%edx
    je et_read_delete
    mov instr, %ebx
    mov $4, %edx
    cmp %ebx,%edx
    je et_read_defrag
;#fin>>nrfis
et_read_nrfis:
    pushl $nrfis
    pushl $formatread
    call scanf
    popl %edx
    popl %edx
    movl $0,%edx
    movl $0,i
;#for (j=0; j<nrfis; j++)
et_loop_nrfis:
    mov nrfis,%ebx
    movl i,%edx
    cmp %edx,%ebx
    je continua_add

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
    jl continua_add
    ;#ADD(v,desc,dim)
    pushl dim
    pushl desc
    pushl v
    call ADD
    popl %eax
    popl %eax
    popl %eax

    inc i
    jmp et_loop_nrfis
continua_add:
    inc i1
    jmp et_for
et_read_get:
    ;#cin>>desc
    pushl $desc
    pushl $formatread
    call scanf
    popl %edx
    popl %edx

    ;#GET(v,desc)
    pushl desc
    pushl v
    call GET
    popl %edx
    popl %edx

    inc i1
    jmp et_for
et_read_delete:
    pushl $desc
    pushl $formatread
    call scanf
    popl %edx
    popl %edx

    pushl desc
    pushl v
    call DELETE
    popl %edx
    popl %edx

    inc i1
    jmp et_for
et_read_defrag:
    ;#DEFRAGMENTATION(v)
    pushl v
    call DEFRAGMENTATION
    popl %edx

    inc i1
    jmp et_for
exit:
    pushl $0
    call fflush
    popl %eax

    mov $1, %eax
    xor %ebx,%ebx
    int $0x80
