; RR-Net demo for the C64.
;
; This first version only brings up the network: it initializes the RR-Net,
; asks the local DHCP server for an IP address and prints the result.

.include "common.inc"
.include "commonprint.inc"
.include "net.inc"

.import exit_to_basic


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
  bcs @done                     ; Carry set means an error was printed

  jsr print_ip_config

@done:
  jmp exit_to_basic


.rodata

title_msg: .byte "RR-Net demo", 13, 0
