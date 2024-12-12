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
    start: .space 4
    start2: .space 4
    start3: .space 4
    end: .space 4
    end2: .space 4
    found: .space 4
    desccurent: .space 4
    desccurent2: .space 4
    interval0: .asciz ": (0,0)\n"
    interval0_get: .asciz "(0,0)\n"
    interval: .asciz "%ld: (%ld, %ld)\n"
    interval_get: .asciz "(%ld, %ld)\n"
    newline: .asciz "\n"
    formatread: .asciz "%ld"
    formatprint: .asciz "%ld"
    stringprint: .asciz "%s"
.text
;#ADD(v,desc,dim)
ADD:
    pushl %ebp
    mov %esp,%ebp
    ;#cnt=dim/8 + (dim%8!=0)
    movl 16(%ebp), %eax
    movl $0,%ecx
    mov $0, %edx
    add $7,%eax
    shr $3,%eax
    movl %eax,cnt

    movl $0,k
;#for (i=0; i<1024; i++)
loop_add_proced:
    movl $1024,%eax
    movl k,%ecx
    cmp %ecx,%eax
    je et_startindex

    movl $1,canfit
    ;#for (j=0; j<cnt; j++)
    mov $0, %ebx
    lea v,%edi
loop_add_proced_2:
    movl cnt,%edx
    cmp %ebx,%edx
    je et_canfit
    ;#if (v[i+j] !=0 )
    mov %ebx,%edx
    addl %ecx,%edx
    movl (%edi,%edx,4),%eax
    cmp $0,%eax
    jne et_canfit_0
    inc %ebx
    jmp loop_add_proced_2
;#canfit=false break
et_canfit_0:
    mov $0,canfit
    inc k
    jmp loop_add_proced
et_canfit:
    ;#if (canfit==true)
    mov %ecx,canfit
    inc %ecx
    mov canfit, %eax
    inc k
    cmp $0,%eax
    je loop_add_proced
    ;#startindex=i break
    sub $1,%ecx
    mov %ecx,startindex
et_startindex:
    ;#if startindex != -1
    cmp $-1,%ecx
    jne final_loop_add
    
    ;#cout<<desc<<": (0,0)\n"
    pushl desc
    pushl $interval0
    call printf
    popl %eax
    popl %eax

    pushl $0
    call fflush
    popl %eax

    popl %ebp
    ret
final_loop_add:
    ;#for (i=0; i<cnt; i++)
    mov $0,%ecx
    mov cnt,%eax
    et_loop:
    cmp %ecx,%eax
    je afisare

    ;#v[startindex+i]=desc
    movl startindex, %ebx
    addl %ecx,%ebx
    movl 12(%ebp),%edx
    movl %edx,(%edi,%ebx,4)
    inc %ecx
    jmp et_loop
afisare:
    ;#cout<<desc<<": (startindex,startindex+cnt-1)\n"
    movl startindex,%eax
    addl cnt,%eax
    sub $2,%eax
    sub $1,startindex
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
GET:
    pushl %ebp
    mov %esp,%ebp
    
    movl $-1,start 
    movl $-1,end
    movl $1,i2
    ;#for (i=1; i<256; i++)
et_for1_get:
    movl i2,%ecx
    movl $256,%eax
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
    sub $1,end
    sub $1,start
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
    ;#for (i=1; i<256; i++)
et_for1_delete:
    movl i3,%ecx
    movl $256,%eax
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
    cmp $1,%eax
    jne et_return
et_for2_delete:
    ;#for(i=0; i<256)
    movl i4,%ecx
    movl $256,%eax
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
    ;#while (i<256 && v[i]==desccurent)
et_while:
    cmp $256,%ecx
    je afisare_delete

    movl i4,%edx
    lea v,%edi
    movl (%edi,%edx,4),%eax
    cmp desccurent,%eax
    jne afisare_delete
    inc i4
    jmp et_while
et_continue:
    inc i4
    jmp et_for2_delete
afisare_delete:
    ;#cout<<desccurent<<": (start2,i-1)\n"
    movl i4,%eax
    sub $2,%eax
    sub $1,start2
    pushl %eax
    pushl start2
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

    movl $0, index
    movl $0, i5
    movl $0, i6
    movl $0, i7
    movl $-1, start3
    movl $-1, end2
    movl $0, desccurent2
    ;#for (i=0; i<256; i++)
et_for1_defrag:
    movl i5,%ecx
    movl $256,%eax
    cmp %ecx,%eax
    je et_for2_defrag

    ;#if (v[i] != 0)
    movl i5,%edx
    lea v,%edi
    movl (%edi,%edx,4),%eax
    cmp $0,%eax
    jne actualizare_temp
    inc i5
    jmp et_for1_defrag
actualizare_temp:
    ;#temp[index++]=v[i]
    movl i5,%edx
    lea v,%edi
    movl (%edi,%edx,4),%eax
    lea temp,%esi 
    movl index,%ebx
    movl %eax,(%esi,%ebx,4)
    inc index
    inc i5
    jmp et_for1_defrag
et_for2_defrag:
    ;#for (i=0; i<256; i++)
    movl $256,%eax
    cmp i6,%eax
    je et_for3_defrag

    ;#v[i]=temp[i]
    lea v,%edi
    lea temp,%esi
    movl i6,%edx
    movl (%esi,%edx,4),%eax
    movl %eax,(%edi,%edx,4)
    inc i6
    jmp et_for2_defrag
et_for3_defrag:
    ;#for (i=0; i<256; i++)
    movl $256,%eax
    movl i7,%ecx
    cmp %ecx,%eax
    je afisare_finala

    ;#if (v[i] != desccurent2 && v[i] != 0)
    movl i7,%edx
    lea v,%edi
    movl (%edi,%edx,4),%eax
    cmp desccurent2,%eax
    je verifica_dif0
    cmp $0,%eax
    je verifica_dif0

    ;#if (start3==-1)
    movl start3,%eax
    cmp $-1,%eax
    jne afisare_defrag

    ;#desccurent2=v[i]
actualizare_desc:
    lea v,%edi
    movl (%edi,%edx,4),%eax
    movl %eax,desccurent2
    ;#start3=i
    movl %ecx,start3
verifica_dif0:
    ;#if v[i] != 0 end2=i
    cmp $0,%eax
    je for_continue_defrag
    movl %ecx,end2
    inc i7
    jmp et_for3_defrag
for_continue_defrag:
    inc i7
    jmp et_for3_defrag
afisare_defrag:
    ;#cout<<desccurent2<<": (start3,end2)\n"
    pushl end2
    pushl start3
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
    
    movl $-1,start3
    movl $0,desccurent2
    jmp et_for3_defrag
afisare_finala:
    ;#if start3 != -1
    movl start3,%eax
    cmp $-1,%eax
    je defrag_ret

    ;#cout<<desccurent2<<": (start3,end2)\n"
    pushl end2
    pushl start3
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

defrag_ret:
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
    je et_newline
    ;#cin>>dim>>desc
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
et_newline:
    ;#cout<<endl
    push $newline
    call printf
    popl %eax

    pushl $0
    call fflush
    popl %eax

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

    ;#cout<<endl
    push $newline
    call printf
    popl %edx

    pushl $0
    call fflush
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
    
    push $newline
    call printf
    popl %edx

    pushl $0
    call fflush
    popl %edx

    inc i1
    jmp et_for
et_read_defrag:
    ;#DEFRAGMENTATION(v)
    pushl v
    call DEFRAGMENTATION
    popl %edx

    ;#cout<<endl
    push $newline
    call printf
    popl %edx

    pushl $0
    call fflush
    popl %edx

    inc i1
    jmp et_for
exit:
    mov $1, %eax
    xor %ebx,%ebx
    int $0x80