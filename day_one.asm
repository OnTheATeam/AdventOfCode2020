; -----------------------------------------------------------------------------
; A 64-bit Mac OSX application that solves the first puzzle of the 2020 Advent of Code
;
; nasm -f macho64 day_one.asm && gcc -arch x86_64 -o day_one day_one.o && ./day_one
; -----------------------------------------------------------------------------

  global _main
  extern _printf
  default rel

  section .text
_main:
  push    rbx

  mov     ecx, 0        ; ecx will be our first iterator for the outer loop
  xor     rax, rax
  xor     rbx, rbx
  xor     r15, r15
  inc     rbx 

  mov     r12, arr      ; r12 will hold our first number

loop:
  mov      r13d, ecx   ; r13d will be our second iterator for the inner loop
  add      r13d, 4
  mov      r14, r12    ; r14 will hold our second number
  add      r14, 4

  cmp     ecx, [arr_len]  ; If this isn't the final number in the array, perform inner loop
  jnz inner_loop

  jmp finish_loop

finish_loop:

   add     ecx, 4
   add     r12, 4

   cmp     ecx, [arr_len]
   jnz     loop
   
   jmp done_failed

inner_loop:
   cmp r13d, [arr_len]
   jge finish_loop

   mov r15, 0
   mov r15, [r14]
   add r15, [r12]

   cmp r15d, [sum]  ; If we've found our pair, jump to mult function
   je found

   add r14, 4
   add r13d, 4
   jmp inner_loop

found:
  ; Multiply our two numbers in r12 and r14
  mov eax, [r12]
  mov ebx, [r14] 
  imul ebx

  push    rax
  push    rcx

  lea     rdi, [format]
  mov     esi, eax
  xor     rax, rax

  call    _printf         ; Print the answer

  pop     rcx
  pop     rax

  mov     rax, 0x2000001 ; exit
  mov     rdi, 0
  syscall

; Jump here if we didn't find any numbers summing to 2020
done_failed: 
  mov     rax, 0x2000001 ; exit
  mov     rdi, 0
  syscall

format:
default rel
  db    "%d", 10, 0

arr:
default rel
  dd   1686,1983,1801,1890,1910,1722,1571,1952,1602,1551,1144,1208,1335,1914,1656,1515,1600,1520,1683,1679,1800,1889,1717,1592,1617,1756,1646,1596,1874,1595,1660,1748,1946,1734,1852,2006,1685,1668,1607,1677,403,1312,1828,1627,1925,1657,1536,1522,1557,1636,1586,1654,1541,1363,1844,1951,1765,1872,696,1764,1718,1540,1493,1947,1786,1548,1981,1861,1589,1707,1915,1755,1906,1911,1628,1980,1986,1780,1645,741,1727,524,1690,1732,1956,1523,1534,1498,1510,372,1777,1585,1614,1712,1650,702,1773,1713,1797,1691,1758,1973,1560,1615,1933,1281,1899,1845,1752,1542,1694,1950,1879,1684,1809,1988,1978,1843,1730,1377,1507,1506,1566,935,1851,1995,1796,1900,896,171,1728,1635,1810,2003,1580,1789,1709,2007,1639,1726,1537,1976,1538,1544,1626,1876,1840,1953,1710,1661,1563,1836,1358,1550,1112,1832,1555,1394,1912,1884,1524,1689,1775,1724,1366,1966,1549,1931,1975,1500,1667,1674,1771,1631,1662,1902,1970,1864,2004,2010,504,1714,1917,1907,1704,1501,1812,1349,1577,1638,1886,1157,1761,1676,1731,2001,1261,1154,1769,1529

arr_len:
default rel
  dd 800

sum:
default rel
  dd 2020