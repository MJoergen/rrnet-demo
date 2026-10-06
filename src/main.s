; RR-Net demo for the C64: a simple "ping" utility.
;
; The program initializes the RR-Net, asks the local DHCP server for an IP
; address and prints the result. It then repeatedly asks for an IP address,
; sends an ICMP echo request ("ping") to it and prints how long the reply took.
; Pressing RETURN on an empty line returns to BASIC.

.include "common.inc"
.include "commonprint.inc"
.include "net.inc"

.import exit_to_basic

.import get_filtered_input      ; Read a line from the keyboard
.import filter_ip               ; Only allow digits and '.'

.import parse_dotted_quad       ; Convert "a.b.c.d" to 4 bytes
.import dotted_quad_value

.import icmp_echo_ip            ; Address to ping
.import icmp_ping               ; Send echo request and wait for the reply


; The C64 linker config expects these segments to exist.
.segment "INIT"
.segment "ONCE"


; The BASIC stub ("SYS 2061") jumps to the start of this segment.
.segment "STARTUP"

  lda #14                       ; Switch to lower case character set
  jsr print_a

  ldax #title_msg
  jsr print_ascii_as_native
  jsr print_cr

  init_ip_via_dhcp              ; Initialize RR-Net and get IP via DHCP
  bcc :+                        ; Carry set means an error was printed
  jmp @exit
:

  jsr print_ip_config

@ask:
  jsr print_cr
  ldax #prompt_msg
  jsr print_ascii_as_native

  ldy #15                       ; At most "255.255.255.255"
  ldax #filter_ip
  jsr get_filtered_input        ; AX points to the string entered
  bcc :+                        ; Carry set means empty line
  jmp @exit
:
  phax                          ; Save AX across print_cr
  jsr print_cr
  plax

  jsr parse_dotted_quad         ; Result goes to dotted_quad_value
  bcc :+
  ldax #invalid_msg
  jsr print_ascii_as_native
  jmp @ask

: ldx #3                        ; Copy the address to icmp_echo_ip
: lda dotted_quad_value,x
  sta icmp_echo_ip,x
  dex
  bpl :-

  jsr icmp_ping                 ; Returns the round trip time in AX
  bcs @no_reply
  stax ping_time

  ldax #reply_msg
  jsr print_ascii_as_native
  ldax #icmp_echo_ip
  jsr print_dotted_quad
  ldax #after_msg
  jsr print_ascii_as_native
  ldax ping_time
  jsr print_integer
  ldax #ms_msg
  jsr print_ascii_as_native
  jmp @ask

@no_reply:
  ldax #no_reply_msg
  jsr print_ascii_as_native
  ldax #icmp_echo_ip
  jsr print_dotted_quad
  jsr print_cr
  jsr print_errorcode           ; Explain why, e.g. timeout
  jmp @ask

@exit:
  jmp exit_to_basic


.rodata

title_msg:    .byte "RR-Net ping demo", 13, 0
prompt_msg:   .byte "IP address (RETURN to quit): ", 0
invalid_msg:  .byte "Invalid IP address", 13, 0
reply_msg:    .byte "Reply from ", 0
after_msg:    .byte " after ", 0
ms_msg:       .byte " ms", 13, 0
no_reply_msg: .byte "No reply from ", 0


.bss

ping_time: .res 2
