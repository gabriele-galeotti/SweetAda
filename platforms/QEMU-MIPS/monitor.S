
#define __ASSEMBLER__ 1

#include <mips.h>

////////////////////////////////////////////////////////////////////////////////

// .../hw/mips/mipssim.c:
// Register 64 KB of ISA IO space at 0x1fd00000.
// A single 16450 sits at offset 0x3f8. It is attached to
// MIPS CPU INT2, which is interrupt 4.
#define UART_BASE 0xBFD003F8

#define UART_DATA 0x0
#define UART_DLL  0x0
#define UART_DLM  0x1
#define UART_IER  0x1
#define UART_IIR  0x2
#define UART_FCR  0x2
#define UART_LCR  0x3
#define UART_MCR  0x4
#define UART_LSR  0x5
#define UART_MSR  0x6
#define UART_SCR  0x7

#define UART_LCR_W    0x07 // set UART to 8N2 & DLAB = 0
#define UART_LCR_DLAB 0x87 // set UART to 8N2 & DLAB = 1
#define UART_DLL_96   0x78 // sel UART Divisor latch LSB to 120 Dec
#define UART_DLM_96   0x00 // sel UART Divisor latch MSB to 0
#define UART_MCR_ON   0x0F // turn on LEDS, DTR and DSR
#define UART_MCR_OFF  0x03 // turn off LEDS, turn on DTR and DSR

#define UART_FCR_FIFO_EN 0x01 // FIFO enable

#define UART_LSR_DR 0x01 // UART received data present
#define UART_LSR_TE 0x40 // UART transmitter empty

#define UART_MCR_ON_1 0x04
#define UART_MCR_ON_2 0x08

UART_CLK     = 18432000/16
UART_BPS     = 115200
UART_DIVISOR = UART_CLK/UART_BPS

////////////////////////////////////////////////////////////////////////////////

flash_base              = 0xBFC00000
flash_sector_size       = 0x10000<<2
flash_sector_count      = 8
flash_cmd1_addr         = flash_base+(0x5555<<2)
flash_cmd1_data         = 0xAAAAAAAA
flash_cmd2_addr         = flash_base+(0x2AAA<<2)
flash_cmd2_data         = 0x55555555
flash_cmd3_addr         = flash_base+(0x5555<<2)
flash_cmd3_reset        = 0xF0F0F0F0
flash_cmd3_autosel      = 0x90909090
flash_cmd3_program      = 0xA0A0A0A0
flash_cmd3_erase_en     = 0x80808080
flash_cmd3_erase_chip   = 0x10101010
flash_cmd3_erase_sector = 0x30303030
flash_prot_mask         = 0x01010101

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .global monitor
monitor:

                //
                // Initialize UART baud rate, set to N,8,2.
                //
                la      $t0,UART_BASE
                li      $t1,UART_MCR_ON_1               // turn on LED
                sb      $t1,UART_MCR($t0)
                li      $t1,UART_LCR_DLAB               // DLAB on
                sb      $t1,UART_LCR($t0)               // write it out
                li      $t1,UART_DIVISOR                // divisor
                sb      $t1,UART_DLL($t0)               // write low order byte
                srl     $t1,$t1,8
                sb      $t1,UART_DLM($t0)               // write high order byte
                li      $t1,UART_LCR_W                  // DLAB off
                sb      $t1,UART_LCR($t0)               // write it out
                la      $a0,banner                      // write banner
                jal     outstr
                nop

                #
                # Command interpreter.
                #
main:           li      $a0,'>'
                jal     outch
                nop
                jal     getline
                nop
                jal     skip_ws
                nop
                la      $t0,inbufptr                    # get input buffer pointer in t1
                lw      $t1,0($t0)
                nop
                lbu     $t2,0($t1)                      # get char in t2
                nop
                addi    $t1,$t1,1                       # advance input buffer pointer
                sw      $t1,0($t0)
                beq     $t2,13,main                     # null command is OK
                nop
                beq     $t2,'?',help_cmd
                nop
                beq     $t2,'h',help_cmd
                nop
                beq     $t2,'d',dump_cmd
                nop
                beq     $t2,'s',set_cmd
                nop
                beq     $t2,'f',fill_cmd                # fill and flash commands
                nop
                beq     $t2,'l',load_cmd
                nop
                beq     $t2,'g',go_cmd
                nop
badcmd:         li      $a0,'?'
                jal     outch
                nop
                li      $a0,13
                jal     outch
                nop
                li      $a0,10
                jal     outch
                nop
                j       main
                nop

                ################
                # help command #
                ################
help_cmd:       la      $a0,help_msg
                jal     outstr
                nop
                j       main
                nop

                ##############################################
                # load command                               #
                #                                            #
                # download S-records                         #
                #                                            #
                # register usage:                            #
                # s0: S-record type (ascii char, '3' or '7') #
                # s1: S-record length                        #
                # s2: S-record address                       #
                # s3: S-record running checksum              #
                ##############################################
load_cmd:       la      $a0,load_msg
                jal     outstr
                nop
find_s:         li      $s3,0                           # init checksum
                jal     inch                            # listen for S
                nop
                beq     $v0,3,load_int                  # interrupt?
                nop
                bne     $v0,'S',find_s
                nop
                jal     inch                            # get record type
                nop
                beq     $v0,3,load_int                  # interrupt?
                nop
                beq     $v0,'3',load_s3
                nop
                beq     $v0,'7',load_s7
                nop
                j       load_bad_srec
                nop
load_s3:        # get length into s1 - must be at least 5
                la      $a0,load_bad_digit              # get length - must be 5
                la      $a1,load_int
                jal     inbyte
                nop
                blt     $v0,5,load_bad_len
                nop
                addi    $s1,$v0,-5
                # get four bytes of address into s2
                jal     inbyte
                nop
                move    $s2,$v0
                jal     inbyte
                nop
                sll     $s2,$s2,8
                or      $s2,$s2,$v0
                jal     inbyte
                nop
                sll     $s2,$s2,8
                or      $s2,$s2,$v0
                jal     inbyte
                nop
                sll     $s2,$s2,8
                or      $s2,$s2,$v0
load_byte:      # get and store data bytes
                jal     inbyte
                nop
                sb      $v0,0($s2)
                addi    $s2,$s2,1                       # increment address
                addi    $s1,$s1,-1                      # decrement byte count
                bnez    $s1,load_byte
                nop
                # get checksum
                jal     inbyte
                nop
                # test checksum
                andi    $s3,$s3,255
                bne     $s3,255,load_bad_cksm
                nop
                # loop for more
                j       find_s
                nop
load_s7:        la      $a0,load_bad_digit              # get length - must be 5
                la      $a1,load_int
                jal     inbyte
                nop
                bne     $v0,5,load_bad_len
                nop
                # get four bytes of address
                jal     inbyte
                nop
                move    $s2,$v0
                jal     inbyte
                nop
                sll     $s2,$s2,8
                or      $s2,$s2,$v0
                jal     inbyte
                nop
                sll     $s2,$s2,8
                or      $s2,$s2,$v0
                jal     inbyte
                nop
                sll     $s2,$s2,8
                or      $s2,$s2,$v0
                la      $v0,go_addr                     # save for go command
                sw      $s2,0($v0)
                # get checksum
                jal     inbyte
                nop
                # test checksum
                andi    $s3,$s3,255
                bne     $s3,255,load_bad_cksm
                nop
                # return to main
                j       main
                nop
load_bad_digit: la      $a0,load_bad_digit_msg
                jal     outstr
                nop
                j       main
                nop
load_bad_len:   la      $a0,load_bad_len_msg
                jal     outstr
                nop
                j       main
                nop
load_bad_srec:  la      $a0,load_bad_srec_msg
                jal     outstr
                nop
                j       main
                nop
load_bad_cksm:  la      $a0,load_bad_cksm_msg
                jal     outstr
                nop
                j       main
                nop
load_int:       la      $a0,load_int_msg
                jal     outstr
                nop
                j       main
                nop

                ###############################################################
                # inbyte                                                      #
                #                                                             #
                # input a hexadecimal byte (without echo) and return it in v0 #
                #                                                             #
                # input -  a0 = address to jump to if bad hex digit found     #
                #          a1 = address to jump to if user interrupt (CTRL-C) #
                #          s3 = previous running checksum                     #
                # output - v0 = data byte                                     #
                #          s3 = updated running checksum                      #
                # uses   - t0 - used by inch                                  #
                #          t1 - used by inch                                  #
                #          t2 - value of first digit * 16                     #
                #          t3 = saved return address                          #
                ###############################################################
inbyte:         move    $t3,$ra
                jal     inch
                nop
                beq     $v0,3,inb_int
                nop
                blt     $v0,'0',inb_bd
                nop
                bgt     $v0,'9',inb_nn1
                nop
                addi    $t2,$v0,-'0'
                j       inb_d2
                nop
inb_nn1:        blt     $v0,'A',inb_bd
                nop
                bgt     $v0,'F',inb_bd
                nop
                addi    $t2,$v0,10-'A'
inb_d2:         sll     $t2,$t2,4
                jal     inch
                nop
                beq     $v0,3,inb_int
                nop
                blt     $v0,'0',inb_bd
                nop
                bgt     $v0,'9',inb_nn2
                nop
                addi    $v0,$v0,-'0'
                j       inb_9
                nop
inb_nn2:        blt     $v0,'A',inb_bd
                nop
                bgt     $v0,'F',inb_bd
                nop
                addi    $v0,$v0,10-'A'
inb_9:          add     $v0,$v0,$t2
                add     $s3,$s3,$v0
                j       $t3
                nop
inb_bd:         j       $a0
                nop
inb_int:        j       $a1
                nop

                ##############
                # go command #
                ##############
go_cmd:         jal     skip_ws
                nop
                la      $t0,inbufptr                    # get input buffer pointer in t1
                lw      $t1,0($t0)
                nop
                lbu     $t2,0($t1)                      # get char
                nop
                beq     $t2,13,go_now                   # if it is a CR, don''t get 2nd address
                nop
                jal     parse_hex                       # get address from command line
                nop
                la      $t3,go_addr                     # save address
                sw      $v0,0($t3)
go_now:         la      $t3,go_addr                     # get address
                lw      $v0,0($t3)
                nop
                jal     $v0                             # call it
                nop
                j       main                            # it might return
                nop

                ##########################
                # dump a block of memory #
                ##########################
dump_cmd:       lbu     $t2,0($t1)                      # get char in t2
                nop
                addi    $t1,$t1,1                       # advance input buffer pointer
                sw      $t1,0($t0)
                li      $a2,1                           # bytes
                beq     $t2,' ',d_cmd_1
                nop
                beq     $t2,'b',d_cmd_1
                nop
                li      $a2,2                           # half-words
                beq     $t2,'h',d_cmd_1
                nop
                li      $a2,4                           # words
                beq     $t2,'w',d_cmd_1
                nop
                j       badcmd
                nop
d_cmd_1:        jal     skip_ws
                nop
                jal     parse_hex                       # get first address
                nop
                move    $a0,$v0
                jal     skip_ws
                nop
                li      $a1,64                          # default to dumping 64 bytes
                add     $a1,$a1,$a0
                la      $t0,inbufptr                    # get input buffer pointer in t1
                lw      $t1,0($t0)
                nop
                lbu     $t2,0($t1)                      # get char
                nop
                beq     $t2,13,dumpit                   # if it is a CR, don''t get 2nd address
                nop
                jal     parse_hex                       # get 2nd address
                nop
                move    $a1,$v0
dumpit:         jal     dump
                nop
                j       main
                nop

                ###########################
                # fill and flash commands #
                ###########################
fill_cmd:       lbu     $t2,0($t1)                      # get char in t2
                nop
                addi    $t1,$t1,1                       # advance input buffer pointer
                sw      $t1,0($t0)
                beq     $t2,'b',fb_cmd
                nop
                beq     $t2,'h',fh_cmd
                nop
                beq     $t2,'w',fw_cmd
                nop
                beq     $t2,'i',flash_id_cmd
                nop
                beq     $t2,'e',flash_erase_cmd
                nop
                beq     $t2,'p',flash_program_cmd
                nop
                j       badcmd
                nop
fb_cmd:         jal     skip_ws                         # get address 1 in s0
                nop
                jal     parse_hex
                nop
                move    $s0,$v0
                jal     skip_ws                         # get address 2 in s1
                nop
                jal     parse_hex
                nop
                move    $s1,$v0
                jal     skip_ws                         # get data in s1
                nop
                jal     parse_hex
                nop
                move    $s2,$v0
fb_loop:        sb      $s2,0($s0)
                addi    $s0,$s0,1
                blt     $s0,$s1,fb_loop
                nop
                j       main
                nop
fh_cmd:         jal     skip_ws                         # get address 1 in s0
                nop
                jal     parse_hex
                nop
                move    $s0,$v0
                jal     skip_ws                         # get address 2 in s1
                nop
                jal     parse_hex
                nop
                move    $s1,$v0
                jal     skip_ws                         # get data in s1
                nop
                jal     parse_hex
                nop
                move    $s2,$v0
fh_loop:        sh      $s2,0($s0)
                addi    $s0,$s0,2
                blt     $s0,$s1,fh_loop
                nop
                j       main
                nop
fw_cmd:         jal     skip_ws                         # get address 1 in s0
                nop
                jal     parse_hex
                nop
                move    $s0,$v0
                jal     skip_ws                         # get address 2 in s1
                nop
                jal     parse_hex
                nop
                move    $s1,$v0
                jal     skip_ws                         # get data in s1
                nop
                jal     parse_hex
                nop
                move    $s2,$v0
fw_loop:        sw      $s2,0($s0)
                addi    $s0,$s0,4
                blt     $s0,$s1,fw_loop
                nop
                j       main
                nop
set_cmd:        lbu     $t2,0($t1)                      # get char in t2
                nop
                addi    $t1,$t1,1                       # advance input buffer pointer
                sw      $t1,0($t0)
                beq     $t2,'b',sb_cmd
                nop
                beq     $t2,'h',sh_cmd
                nop
                beq     $t2,'w',sw_cmd
                nop
                j       badcmd
                nop
sb_cmd:         jal     skip_ws                         # get address in s0
                nop
                jal     parse_hex
                nop
                move    $s0,$v0
sb0:            jal     skip_ws                         # get data in s1
                nop
                la      $t0,inbufptr                    # get input buffer pointer in t1
                lw      $t1,0($t0)
                nop
                lbu     $t2,0($t1)                      # get char in t2
                nop
                beq     $t2,13,main                     # if CR, done
                nop
                jal     parse_hex
                nop
                move    $s1,$v0
                sb      $s1,0($s0)                      # store the byte
                addi    $s0,$s0,1                       # advance
                j       sb0
                nop
sh_cmd:         jal     skip_ws                         # get address in s0
                nop
                jal     parse_hex
                nop
                move    $s0,$v0
sh0:            jal     skip_ws                         # get data in s1
                nop
                la      $t0,inbufptr                    # get input buffer pointer in t1
                lw      $t1,0($t0)
                nop
                lbu     $t2,0($t1)                      # get char in t2
                nop
                beq     $t2,13,main                     # if CR, done
                nop
                jal     parse_hex
                nop
                move    $s1,$v0
                sh      $s1,0($s0)                      # store the half-word
                addi    $s0,$s0,2                       # advance
                j       sh0
                nop
sw_cmd:         lbu     $t2,0($t1)                      # get char in t2
                nop
                addi    $t1,$t1,1                       # advance input buffer pointer
                sw      $t1,0($t0)
                beq     $t2,'l',swl_cmd
                nop
                beq     $t2,'r',swr_cmd
                nop
                jal     skip_ws                         # get address in s0
                nop
                jal     parse_hex
                nop
                move    $s0,$v0
sw0:            jal     skip_ws                         # get data in s1
                nop
                la      $t0,inbufptr                    # get input buffer pointer in t1
                lw      $t1,0($t0)
                nop
                lbu     $t2,0($t1)                      # get char in t2
                nop
                beq     $t2,13,main                     # if CR, done
                nop
                jal     parse_hex
                nop
                move    $s1,$v0
                sw      $s1,0($s0)                      # store the word
                addi    $s0,$s0,4                       # advance
                j       sw0
                nop
swl_cmd:        jal     skip_ws                         # get address in s0
                nop
                jal     parse_hex
                nop
                move    $s0,$v0
                jal     skip_ws                         # get data in s1
                nop
                jal     parse_hex
                nop
                move    $s1,$v0
                swl     $s1,0($s0)                      # store the word
                j       main
                nop
swr_cmd:        jal     skip_ws                         # get address in s0
                nop
                jal     parse_hex
                nop
                move    $s0,$v0
                jal     skip_ws                         # get data in s1
                nop
                jal     parse_hex
                nop
                move    $s1,$v0
                swr     $s1,0($s0)                      # store the word
                j       main
                nop
flash_id_cmd:   jal     copy_flash_code_to_ram
                nop
                la      $a0,flash_read_id
                la      $a1,flash_code_begin
                subu    $a0,$a0,$a1
                la      $a1,play_area
                addu    $a0,$a0,$a1
                jal     $a0
                nop
                la      $a0,manuf_msg
                jal     outstr
                nop
                move    $a0,$v0
                jal     outhexw
                nop
                la      $a0,dev_msg
                jal     outstr
                nop
                move    $a0,$v1
                jal     outhexw
                nop
                la      $a0,flash_read_prot
                la      $a1,flash_code_begin
                subu    $a0,$a0,$a1
                la      $a1,play_area
                addu    $a0,$a0,$a1
                jal     $a0
                nop
                la      $a0,sect_prot_msg
                jal     outstr
                nop
                move    $a0,$v0
                jal     outhexw
                nop
                la      $a0,crlf_msg
                jal     outstr
                nop
                j       main
                nop
flash_erase_cmd:jal     copy_flash_code_to_ram
                nop
                la      $a0,flash_erase_sector
                la      $a1,flash_code_begin
                subu    $a0,$a0,$a1
                la      $a1,play_area
                addu    $a0,$a0,$a1
                jal     $a0
                nop
                j       main
                nop
flash_program_cmd:
                jal     copy_flash_code_to_ram
                nop
                jal     skip_ws                         # get address in a0
                nop
                jal     parse_hex
                nop
                move    $a0,$v0
                jal     skip_ws                         # get data in a1
                nop
                jal     parse_hex
                nop
                move    $a1,$v0
                la      $t0,flash_program_word
                la      $t1,flash_code_begin
                subu    $t0,$t0,$t1
                la      $t1,play_area
                addu    $t0,$t0,$t1
                jal     $t0
                nop
                j       main
                nop
copy_flash_code_to_ram:
                la      $t0,flash_code_begin
                la      $t1,flash_code_end
                la      $t2,play_area
cfl:            lw      $t3,0($t0)
                addi    $t0,$t0,4
                sw      $t3,0($t2)
                addi    $t2,$t2,4
                bne     $t0,$t1,cfl
                nop
                j       $ra
                nop
flash_code_begin:
                ####################
                # returns          #
                # v0: manufacturer #
                # v1: device       #
                ####################
flash_read_id:  la      $t0,flash_cmd1_addr             # unlock
                li      $t1,flash_cmd1_data
                sw      $t1,0($t0)
                la      $t0,flash_cmd2_addr
                li      $t1,flash_cmd2_data
                sw      $t1,0($t0)
                la      $t0,flash_cmd3_addr             # auto-id
                li      $t1,flash_cmd3_autosel
                sw      $t1,0($t0)
                la      $t0,flash_base                  # read manuf. and device
                lw      $v0,0($t0)
                lw      $v1,4($t0)
                la      $t0,flash_cmd1_addr             # unlock
                li      $t1,flash_cmd1_data
                sw      $t1,0($t0)
                la      $t0,flash_cmd2_addr
                li      $t1,flash_cmd2_data
                sw      $t1,0($t0)
                la      $t0,flash_cmd3_addr             # reset
                li      $t1,flash_cmd3_reset
                sw      $t1,0($t0)
                j       $ra
                nop
                ##############################
                # returns                    #
                # v0: sector protection mask #
                ##############################
flash_read_prot:la      $t0,flash_cmd1_addr             # unlock
                li      $t1,flash_cmd1_data
                sw      $t1,0($t0)
                la      $t0,flash_cmd2_addr
                li      $t1,flash_cmd2_data
                sw      $t1,0($t0)
                la      $t0,flash_cmd3_addr             # auto-id
                li      $t1,flash_cmd3_autosel
                sw      $t1,0($t0)
                li      $v0,0                           # read sector protection
                li      $t2,flash_prot_mask
                li      $t3,flash_sector_size
                li      $t4,flash_sector_count
fidl:           lw      $t5,8($t0)                      # get protection bits for one sector
                nop
                and     $t5,$t5,$t2                     # keep only low bits
                sll     $v0,$v0,1                       # v0 = (v0 << 1) | t5
                or      $v0,$v0,$t5
                add     $t0,$t0,$t3                     # advance pointer to next sector
                addi    $t4,$t4,-1                      # decrement sector counter
                bnez    $t4,fidl
                nop
                la      $t0,flash_cmd1_addr             # unlock
                li      $t1,flash_cmd1_data
                sw      $t1,0($t0)
                la      $t0,flash_cmd2_addr
                li      $t1,flash_cmd2_data
                sw      $t1,0($t0)
                la      $t0,flash_cmd3_addr             # reset
                li      $t1,flash_cmd3_reset
                sw      $t1,0($t0)
                j       $ra
                nop
flash_erase_sector:
                la      $t0,flash_cmd1_addr             # unlock
                li      $t1,flash_cmd1_data
                sw      $t1,0($t0)
                la      $t0,flash_cmd2_addr
                li      $t1,flash_cmd2_data
                sw      $t1,0($t0)
                la      $t0,flash_cmd3_addr             # erase enable
                li      $t1,flash_cmd3_erase_en
                sw      $t1,0($t0)
                la      $t0,flash_cmd1_addr             # unlock
                li      $t1,flash_cmd1_data
                sw      $t1,0($t0)
                la      $t0,flash_cmd2_addr
                li      $t1,flash_cmd2_data
                sw      $t1,0($t0)
                la      $t0,flash_base+flash_sector_size        # sector
                li      $t1,flash_cmd3_erase_sector
                sw      $t1,0($t0)
                li      $t2,0xFFFFFFFF
fe_poll:        lw      $t1,0($t0)
                nop
                bne     $t1,$t2,fe_poll
                nop
                j       $ra
                nop
                ###############
                # entry       #
                # a0: address #
                # a1: data    #
                ###############
flash_program_word:
                la      $t0,flash_cmd1_addr             # unlock
                li      $t1,flash_cmd1_data
                sw      $t1,0($t0)
                la      $t0,flash_cmd2_addr
                li      $t1,flash_cmd2_data
                sw      $t1,0($t0)
                la      $t0,flash_cmd3_addr             # program
                li      $t1,flash_cmd3_program
                sw      $t1,0($t0)
                nop
                nop
                sw      $a1,0($a0)                      # write data
                nop
                nop
fw_poll:        lw      $t0,0($a0)
                nop
                bne     $t0,$a1,fw_poll
                nop
                j       $ra
                nop
flash_code_end:

                #############################
                # dump memory from a0 to a1 #
                # a2: size (1, 2, 4)        #
                #############################
dump:           move    $s0,$a0                         # $$$ need to save s0..s3 on stack
                move    $s1,$a1
                move    $s2,$ra
dump0:          move    $a0,$s0                         # output address
                jal     outhexw
                nop
                li      $a0,':'
                jal     outch
                nop
                li      $s3,16                          # init line byte counter
dump1:          li      $a0,' '                         # output data
                jal     outch
                nop
                beq     $a2,1,dump_byte
                nop
                beq     $a2,2,dump_half
                nop
                beq     $a2,4,dump_word
                nop
                li      $a2,1                           # should never happen, but try to fix it up
dump_byte:      lbu     $a0,0($s0)
                jal     outhexb
                nop
                j       dump_8
                nop
dump_half:      lhu     $a0,0($s0)
                jal     outhexh
                nop
                j       dump_8
                nop
dump_word:      lw      $a0,0($s0)
                jal     outhexw
                nop
                j       dump_8
                nop
dump_8:         addu    $s0,$s0,$a2                     # increment address
                subu    $s3,$s3,$a2                     # decrement line byte counter
                bne     $s3,0,dump1                     # more bytes this line?
                nop
                li      $a0,13                          # output CRLF
                jal     outch
                nop
                li      $a0,10
                jal     outch
                nop
                jal     chk_intr                        # user interrupt?
                nop
                bnez    $v0,dump9
                nop
                blt     $s0,$s1,dump0                   # more bytes?
                nop
dump9:          j       $s2                             # return
                nop

                ###################
                # skip whitespace #
                # uses t0,t1,t2   #
                ###################
skip_ws:        la      $t0,inbufptr                    # get input buffer pointer in t1
                lw      $t1,0($t0)
                nop
skipw0:         lbu     $t2,0($t1)                      # get char
                nop
                beq     $t2,32,skipw1                   # space?
                nop
                beq     $t2,8,skipw1                    # tab?
                nop
                sw      $t1,0($t0)                      # save buffer pointer
                j       $ra
                nop
skipw1:         addi    $t1,$t1,1                       # advance input buffer pointer
                j       skipw0
                nop

                #########################################
                # parse hexadecimal input, return in v0 #
                #########################################
parse_hex:      li      $v0,0
                la      $t0,inbufptr                    # get input buffer pointer in t1
                lw      $t1,0($t0)
                nop
ph0:            lbu     $t2,0($t1)                      # get char in t2
                nop
                blt     $t2,'0',notnum
                nop
                bgt     $t2,'9',notnum
                nop
                addi    $t2,$t2,-'0'
                j       gotdigit
                nop
notnum:         blt     $t2,'a',notlc
                nop
                bgt     $t2,'f',notlc
                nop
                addi    $t2,$t2,10-'a'
gotdigit:       sll     $v0,$v0,4
                add     $v0,$v0,$t2
                addi    $t1,$t1,1                       # advance input buffer pointer
                j       ph0                             # get some more
                nop
notlc:          sw      $t1,0($t0)                      # store input buffer pointer
                j       $ra
                nop

                ###########################
                # output a string from a0 #
                ###########################
outstr:         move    $t7,$ra
                move    $t6,$a0
outs0:          lbu     $a0,0($t6)                      # get byte
                addi    $t6,$t6,1
                beqz    $a0,outs9
                nop
                jal     outch
                nop
                j       outs0
                nop
outs9:          j       $t7
                nop

                #############################
                # output a hex word from a0 #
                #############################
outhexw:        move    $t7,$ra
                move    $t6,$a0
                srl     $a0,$t6,28
                jal     outhexd
                nop
                srl     $a0,$t6,24
                jal     outhexd
                nop
                srl     $a0,$t6,20
                jal     outhexd
                nop
                srl     $a0,$t6,16
                jal     outhexd
                nop
                srl     $a0,$t6,12
                jal     outhexd
                nop
                srl     $a0,$t6,8
                jal     outhexd
                nop
                srl     $a0,$t6,4
                jal     outhexd
                nop
                move    $a0,$t6
                move    $ra,$t7
                j       outhexd
                nop

                ##################################
                # output a hex half-word from a0 #
                ##################################
outhexh:        move    $t7,$ra
                move    $t6,$a0
                srl     $a0,$t6,12
                jal     outhexd
                nop
                srl     $a0,$t6,8
                jal     outhexd
                nop
                srl     $a0,$t6,4
                jal     outhexd
                nop
                move    $a0,$t6
                move    $ra,$t7
                j       outhexd
                nop

                #############################
                # output a hex byte from a0 #
                #############################
outhexb:        move    $t7,$ra
                move    $t6,$a0
                srl     $a0,$t6,4
                jal     outhexd
                nop
                move    $a0,$t6
                move    $ra,$t7
                # fall into outhexd

                ##############################
                # output a hex digit from a0 #
                ##############################
outhexd:        andi    $a0,$a0,15
                blt     $a0,10,lt9
                nop
                addi    $a0,$a0,7
lt9:            addi    $a0,$a0,48
                # fall into outch

                ############################
                # output a character in a0 #
                ############################
outch:          la      $t0,UART_BASE
outch0:         lbu     $t4,UART_LSR($t0)               # get line status
                nop
                andi    $t4,$t4,UART_LSR_TE             # check for transmitter empty
                beqz    $t4,outch0                      # try again
                nop
                sb      $a0,UART_DATA($t0)              # write the character
                j       $ra
                nop

                #################################
                # get a line of input           #
                # use: s0 - save return address #
                #      s1 - buffer pointer      #
                #      s2 - temp                #
                #################################
getline:        move    $s0,$ra                         # save return address
                la      $s1,inbuf                       # init input buffer pointer
                la      $s2,inbufptr
                sw      $s1,0($s2)
gl0:            jal     inch                            # get a character
                nop
                andi    $v0,$v0,127                     # mask off high bit
                beq     $v0,8,glbs                      # handle backspace
                nop
                beq     $v0,127,glbs                    # handle rubout like backspace
                nop
                sb      $v0,0($s1)                      # store it in the buffer
                addi    $s1,$s1,1
                move    $a0,$v0                         # echo it
                jal     outch
                nop
                bne     $v0,13,gl0                      # if not a CR, get some more
                nop
                li      $a0,10                          # output an LF
                jal     outch
                nop
glcr:           j       $s0                             # return
                nop
glbs:           la      $s2,inbuf                       # if at beginning of buffer, do
                beq     $s1,$s2,gl0                     # nothing
                nop
                li      $a0,8                           # echo BS
                jal     outch
                nop
                li      $a0,32                          # echo space
                jal     outch
                nop
                li      $a0,8                           # echo BS
                jal     outch
                nop
                addi    $s1,$s1,-1                      # back up
                j       gl0
                nop

                #####################################################################
                # check for interrupt from user, return non-zero in v0 if interrupt #
                #####################################################################
chk_intr:       la      $t0,UART_BASE
                lbu     $v0,UART_LSR($t0)               # get line status
                nop
                andi    $v0,$v0,UART_LSR_DR
                j       $ra
                nop

                #########################
                # get a character in v0 #
                # uses t0,t1            #
                #########################
inch:           la      $t0,UART_BASE
inch0:          lbu     $t1,UART_LSR($t0)               # get line status
                nop
                andi    $t1,$t1,UART_LSR_DR
                beqz    $t1,inch0
                nop
                lbu     $v0,UART_DATA($t0)              # get data
                nop
                j       $ra
                nop

banner:         .byte   13,10
                .ascii  "mmon: VR4300 mini-monitor, "
                .ascii  "Copyright 1996, 2003 Eric Smith <eric@brouhaha.com>"
                .byte   13,10
                .byte   0
#                .ascii "$Id$"
crlf_msg:       .byte   13,10,0

help_msg:       .ascii  "Commands:"
                .byte   13,10,13,10
                .ascii  "db <addr1> [<addr2>]       dump bytes from addr1 to addr2"
                .byte   13,10
                .ascii  "dh <addr1> [<addr2>]       dump half-words (16 bits)"
                .byte   13,10
                .ascii  "dw <addr1> [<addr2>]       dump words (32 bits)"
                .byte   13,10
                .ascii  "sb <addr> <data>...        store byte"
                .byte   13,10
                .ascii  "sh <addr> <data>...        store half-word (16 bits)"
                .byte   13,10
                .ascii  "sw <addr> <data>...        store word (32 bits)"
                .byte   13,10
                .ascii  "swl <addr> <data>          store word left"
                .byte   13,10
                .ascii  "swr <addr> <data>          store word right"
                .byte   13,10
                .ascii  "fb <addr1> <addr2> <data>  fill bytes of memory range"
                .byte   13,10
                .ascii  "fh <addr1> <addr2> <data>  fill half-words"
                .byte   13,10
                .ascii  "fw <addr1> <addr2> <data>  fill words"
                .byte   13,10
                .ascii  "l                          load S-records"
                .byte   13,10
                .ascii  "g [<addr>]                 go (start execution at address)"
                .byte   13,10
                .ascii  "h                          help (show this command list)"
                .byte   13,10,0
load_msg:       .ascii  "Start S-record download now, or control-C to abort."
                .byte   13,10,0
load_int_msg:   .ascii  "S-record download aborted by user."
                .byte   13,10,0
load_bad_srec_msg:
                .ascii  "S-record type unrecognized, download aborted."
                .byte   13,10,0
load_bad_len_msg:
                .ascii  "bad S-record length, download aborted."
                .byte   13,10,0
load_bad_digit_msg:
                .ascii  "bad hex digit in S-record, download aborted."
                .byte   13,10,0
load_bad_cksm_msg:
                .ascii  "bad checksum in S-record, download aborted."
                .byte   13,10,0
manuf_msg:      .ascii  "manufacturer: "
                .byte   0
dev_msg:        .byte   13,10
                .ascii  "      device: "
                .byte   0
sect_prot_msg:  .byte   13,10
                .ascii  " sector prot: "
                .byte   0
gen_exc_msg:    .byte   13,10
                .ascii  "General"
                .byte   0
tlb_miss_msg:   .byte   13,10
                .ascii  "TLB Miss"
                .byte   0
x_tlb_miss_msg: .byte   13,10
                .ascii  "XTLB Miss"
                .byte   0
cache_err_msg:  .byte   13,10
                .ascii  "Cache Error"
                .byte   0
exc_msg0:       .ascii  " exception!"
                .byte   0
exc_cause_msg:  .byte   13,10
                .ascii  "Cause:    "
                .byte   0
exc_pc_msg:     .byte   13,10
                .ascii  "PC:       "
                .byte   0
exc_epc_msg:    .byte   13,10
                .ascii  "EPC:      "
                .byte   0
exc_stat_msg:   .byte   13,10
                .ascii  "Status:   "
                .byte   0
exc_badaddr_msg:.byte   13,10
                .ascii  "Bad Addr: "
                .byte   0
exc_ctx_msg:    .byte   13,10
                .ascii  "Context:  "
                .byte   0
exc_xctx_msg:   .byte   13,10
                .ascii  "XContext: "
                .byte   0
exc_msg9:       .byte   13,10,0

                .align  2                               # 4-byte alignment, 2 low bits of address must be zero

                .global tlb_miss
tlb_miss:       mfc0    $s0,CP0_XContext
                mfc0    $s1,CP0_EPC
                mfc0    $s2,CP0_Context
                mfc0    $s3,CP0_Cause
                mfc0    $s4,CP0_SR
                mfc0    $s5,CP0_BadAddr
                la      $a0,tlb_miss_msg
                jal     outstr
                nop
                j       handle_exc
                nop

                .global x_tlb_miss
x_tlb_miss:     mfc0    $s0,CP0_XContext
                mfc0    $s1,CP0_EPC
                mfc0    $s2,CP0_Context
                mfc0    $s3,CP0_Cause
                mfc0    $s4,CP0_SR
                mfc0    $s5,CP0_BadAddr
                la      $a0,x_tlb_miss_msg
                jal     outstr
                nop
                j       handle_exc
                nop

                .global cache_err
cache_err:      mfc0    $s0,CP0_XContext
                mfc0    $s1,CP0_EPC
                mfc0    $s2,CP0_Context
                mfc0    $s3,CP0_Cause
                mfc0    $s4,CP0_SR
                mfc0    $s5,CP0_BadAddr
                la      $a0,cache_err_msg
                jal     outstr
                nop
                j       handle_exc
                nop

                .global gen_exc
gen_exc:        mfc0    $s0,CP0_XContext
                mfc0    $s1,CP0_EPC
                mfc0    $s2,CP0_Context
                mfc0    $s3,CP0_Cause
                mfc0    $s4,CP0_SR
                mfc0    $s5,CP0_BadAddr
                la      $a0,gen_exc_msg
                jal     outstr
                nop
                j       handle_exc
                nop

handle_exc:     la      $a0,exc_msg0
                jal     outstr
                nop
                la      $a0,exc_cause_msg
                jal     outstr
                nop
                move    $a0,$s3
                jal     outhexw
                nop
                la      $a0,exc_epc_msg
                jal     outstr
                nop
                move    $a0,$s1
                jal     outhexw
                nop
                la      $a0,exc_stat_msg
                jal     outstr
                nop
                move    $a0,$s4
                jal     outhexw
                nop
                la      $a0,exc_badaddr_msg
                jal     outstr
                nop
                move    $a0,$s5
                jal     outhexw
                nop
#if 0
                la      $a0,exc_ctx_msg
                jal     outstr
                nop
                move    $a0,$s2
                jal     outhexw
                nop
                la      $a0,exc_xctx_msg
                jal     outstr
                nop
                move    $a0,$s0
                jal     outhexw
                nop
#endif
                la      $a0,exc_msg9
                jal     outstr
                nop
                j       main                            # go back to command interpreter
                nop

reg_cpu_isr:
unred_cpu_isr:
reg_ic_isr:
unred_ic_isr:
reg_esr:
unreg_esr:
flush_cache:
getchar:
syscon_read:
ret:
                li      $v0,0
                j       $ra

print:          move    $t7,$ra
                move    $t6,$a1
print0:         lbu     $a0,0($t6)                      # get byte
                addi    $t6,$t6,1
                beqz    $a0,print9
                nop
                jal     outch
                nop
                j       print0
                nop
print9:         j       $t7
                nop
print_count:    move    $t7,$ra
                move    $t6,$a1
                move    $t8,$a2                         # count
prc0:           lbu     $a0,0($t6)                      # get byte
                jal     outch
                nop
                addi    $t6,$t6,1
                addi    $t8,$t8,-1
                bnez    $t8,prc0
                nop
                j       $t7
                nop

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

// Note - On our target hardware, the same DRAM is aliased between A0000000 and
//        BFC00000. Data section starts at A0000010 to allow room for the four
//        instructions of the reset exception handler. Data section must end
//        before A0000200, so size of data section must be <= 496 bytes.

play_area:      .space  64
go_addr:        .space  4
inbufptr:       .space  4
inbuf:          .space  256

