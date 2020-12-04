BITS 64
DEFAULT rel ; RIP-relative addressing by default


global _main
;
; Basic OS X calls to glibc
;
; compile with:
; nasm -g -f macho64 malloc64.asm
; gcc -o a.out malloc64.o
;

; glibc stuff
extern _puts, _printf, _malloc, _free

; static data
section .data

hello_world_str db "Hello world!", 10, 0
int_str db "Address %llx", 10, 0

; code
section .text


_main:
        ; save registers and align stack
        push rbp
        push r12
        push rbx

        mov  rdi, 3200  ; Malloc for 200 16-bit numbers - will use this like a hash map
        call _malloc

        ; check if the malloc failed
        test rax, rax
        jz   fail_exit
        mov  rbx, rax


        mov [rbx], dword 0;
        mov r12, dword 200

        mov r15, rbx   ; keep address to front of array in r15
_init_hash_loop:

        add rbx, 2
        mov [rbx], dword 12

        dec  r12
        jnz  _init_hash_loop

        mov r12, dword 200 ; Reset next iterator for counting loop
        mov r14, arr

_count_nums_loop:  ; Populate our hash in r15 with counts of each item in the input array
        mov r13, r15
        add r13, r14
        add r13, r14
        ;mov [r13], dword 1  ; assume no dups in the input array

        add r14, 4
        dec r12
        jnz _count_nums_loop

        mov r12, dword 200 ; Reset next iterator for counting loop
        mov r14, r15

_debug_loop:

        push    rax
        push    rcx

        lea     rdi, [format]
        mov     rsi, [r14]
        xor     rax, rax

        call    _printf

        pop     rcx
        pop     rax

        add r14, 2
        dec r12
        jnz _debug_loop

        jmp complete

complete:
        ; free the malloc'd memory
        mov  rdi, r15
        call _free

        xor rax, rax
        pop rbx
        pop r12
        pop rbp
        ret

fail_exit:
        mov rax, 1
        pop rbx
        pop r12
        pop rbp
        ret

format:
default rel
  db "%d", 10,
  
arr:
default rel
  dd 1686,1983,1801,1890,1910,1722,1571,1952,1602,1551,1144,1208,1335,1914,1656,1515,1600,1520,1683,1679,1800,1889,1717,1592,1617,1756,1646,1596,1874,1595,1660,1748,1946,1734,1852,2006,1685,1668,1607,1677,403,1312,1828,1627,1925,1657,1536,1522,1557,1636,1586,1654,1541,1363,1844,1951,1765,1872,696,1764,1718,1540,1493,1947,1786,1548,1981,1861,1589,1707,1915,1755,1906,1911,1628,1980,1986,1780,1645,741,1727,524,1690,1732,1956,1523,1534,1498,1510,372,1777,1585,1614,1712,1650,702,1773,1713,1797,1691,1758,1973,1560,1615,1933,1281,1899,1845,1752,1542,1694,1950,1879,1684,1809,1988,1978,1843,1730,1377,1507,1506,1566,935,1851,1995,1796,1900,896,171,1728,1635,1810,2003,1580,1789,1709,2007,1639,1726,1537,1976,1538,1544,1626,1876,1840,1953,1710,1661,1563,1836,1358,1550,1112,1832,1555,1394,1912,1884,1524,1689,1775,1724,1366,1966,1549,1931,1975,1500,1667,1674,1771,1631,1662,1902,1970,1864,2004,2010,504,1714,1917,1907,1704,1501,1812,1349,1577,1638,1886,1157,1761,1676,1731,2001,1261,1154,1769,1529