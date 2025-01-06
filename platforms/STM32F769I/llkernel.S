
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .syntax unified

                .sect   .vectors,"ax"

                .align  7

                .global vectors
vectors:

SP_Main:        .long   0
                .extern _start
Reset:          .long   _start                  //   1
NMI:            .long   0                       //   2
HardFault:      .long   0                       //   3
MemManage:      .long   0                       //   4
BusFault:       .long   0                       //   5
UsageFault:     .long   0                       //   6
ReservedExc7:   .long   0                       //   7
ReservedExc8:   .long   0                       //   8
ReservedExc9:   .long   0                       //   9
ReservedExcA:   .long   0                       //  10
SVCall:         .long   0                       //  11
DebugMonitor:   .long   0                       //  12
ReservedExcD:   .long   0                       //  13
PendSV:         .long   0                       //  14
SysTick:        .long   systick_handler         //  15

Interrupt0:     .long   0                       //  16 WWDG               Window Watchdog interrupt
Interrupt1:     .long   0                       //  17 PVD                PVD through EXTI line detection interrupt
Interrupt2:     .long   0                       //  18 TAMP_STAMP         Tamper and TimeStamp interrupts through the EXTI line
Interrupt3:     .long   0                       //  19 RTC_WKUP           RTC Wakeup interrupt through the EXTI line
Interrupt4:     .long   0                       //  20 FLASH              Flash global interrupt
Interrupt5:     .long   0                       //  21 RCC                RCC global interrupt
Interrupt6:     .long   0                       //  22 EXTI0              EXTI Line0 interrupt
Interrupt7:     .long   0                       //  23 EXTI1              EXTI Line1 interrupt
Interrupt8:     .long   0                       //  24 EXTI2              EXTI Line2 interrupt
Interrupt9:     .long   0                       //  25 EXTI3              EXTI Line3 interrupt
Interrupt10:    .long   0                       //  26 EXTI4              EXTI Line4 interrupt
Interrupt11:    .long   0                       //  27 DMA1_Stream0       DMA1 Stream0 global interrupt
Interrupt12:    .long   0                       //  28 DMA1_Stream1       DMA1 Stream1 global interrupt
Interrupt13:    .long   0                       //  29 DMA1_Stream2       DMA1 Stream2 global interrupt
Interrupt14:    .long   0                       //  30 DMA1_Stream3       DMA1 Stream3 global interrupt
Interrupt15:    .long   0                       //  31 DMA1_Stream4       DMA1 Stream4 global interrupt
Interrupt16:    .long   0                       //  32 DMA1_Stream5       DMA1 Stream5 global interrupt
Interrupt17:    .long   0                       //  33 DMA1_Stream6       DMA1 Stream6 global interrupt
Interrupt18:    .long   0                       //  34 ADC                ADC1, ADC2 and ADC3 global interrupts
Interrupt19:    .long   0                       //  35 CAN1_TX            CAN1 TX interrupts
Interrupt20:    .long   0                       //  36 CAN1_RX0           CAN1 RX0 interrupts
Interrupt21:    .long   0                       //  37 CAN1_RX1           CAN1 RX1 interrupt
Interrupt22:    .long   0                       //  38 CAN1_SCE           CAN1 SCE interrupt
Interrupt23:    .long   0                       //  39 EXTI9_5            EXTI Line[9:5] interrupts
Interrupt24:    .long   0                       //  40 TIM1_BRK_TIM9      TIM1 Break interrupt and TIM9 global interrupt
Interrupt25:    .long   0                       //  41 TIM1_UP_TIM10      TIM1 Update interrupt and TIM10 global interrupt
Interrupt26:    .long   0                       //  42 TIM1_TRG_COM_TIM11 TIM1 Trigger and Commutation interrupts and TIM11 global interrupt
Interrupt27:    .long   0                       //  43 TIM1_CC            TIM1 Capture Compare interrupt
Interrupt28:    .long   0                       //  44 TIM2               TIM2 global interrupt
Interrupt29:    .long   0                       //  45 TIM3               TIM3 global interrupt
Interrupt30:    .long   0                       //  46 TIM4               TIM4 global interrupt
Interrupt31:    .long   0                       //  47 I2C1_EV            I2C1 event interrupt
Interrupt32:    .long   0                       //  48 I2C1_ER            I2C1 error interrupt
Interrupt33:    .long   0                       //  49 I2C2_EV            I2C2 event interrupt
Interrupt34:    .long   0                       //  50 I2C2_ER            I2C2 error interrupt
Interrupt35:    .long   0                       //  51 SPI1               SPI1 global interrupt
Interrupt36:    .long   0                       //  52 SPI2               SPI2 global interrupt
Interrupt37:    .long   0                       //  53 USART1             USART1 global interrupt
Interrupt38:    .long   0                       //  54 USART2             USART2 global interrupt
Interrupt39:    .long   0                       //  55 USART3             USART3 global interrupt
Interrupt40:    .long   0                       //  56 EXTI15_10          EXTI Line[15:10] interrupts
Interrupt41:    .long   0                       //  57 RTC_Alarm          RTC Alarms (A and B) through EXTI line interrupt
Interrupt42:    .long   0                       //  58 OTG_FS_WKUP USB    On-The-Go FS Wakeup through EXTI line interrupt
Interrupt43:    .long   0                       //  59 TIM8_BRK_TIM12     TIM8 Break interrupt and TIM12 global interrupt
Interrupt44:    .long   0                       //  60 TIM8_UP_TIM13      TIM8 Update interrupt and TIM13 global interrupt
Interrupt45:    .long   0                       //  61 TIM8_TRG_COM_TIM14 TIM8 Trigger and Commutation interrupts and TIM14 global interrupt
Interrupt46:    .long   0                       //  62 TIM8_CC            TIM8 Capture Compare interrupt
Interrupt47:    .long   0                       //  63 DMA1_Stream7       DMA1 Stream7 global interrupt
Interrupt48:    .long   0                       //  64 FMC                FMC global interrupt
Interrupt49:    .long   0                       //  65 SDMMC1             SDMMC1 global interrupt
Interrupt50:    .long   0                       //  66 TIM5               TIM5 global interrupt
Interrupt51:    .long   0                       //  67 SPI3               SPI3 global interrupt
Interrupt52:    .long   0                       //  68 UART4              UART4 global interrupt
Interrupt53:    .long   0                       //  69 UART5              UART5 global interrupt
Interrupt54:    .long   0                       //  70 TIM6_DAC           TIM6 global interrupt, DAC1 and DAC2 underrun error interrupts
Interrupt55:    .long   0                       //  71 TIM7               TIM7 global interrupt
Interrupt56:    .long   0                       //  72 DMA2_Stream0       DMA2 Stream0 global interrupt
Interrupt57:    .long   0                       //  73 DMA2_Stream1       DMA2 Stream1 global interrupt
Interrupt58:    .long   0                       //  74 DMA2_Stream2       DMA2 Stream2 global interrupt
Interrupt59:    .long   0                       //  75 DMA2_Stream3       DMA2 Stream3 global interrupt
Interrupt60:    .long   0                       //  76 DMA2_Stream4       DMA2 Stream4 global interrupt
Interrupt61:    .long   0                       //  77 ETH                Ethernet global interrupt
Interrupt62:    .long   0                       //  78 ETH_WKUP           Ethernet Wakeup through EXTI line interrupt
Interrupt63:    .long   0                       //  79 CAN2_TX            CAN2 TX interrupts
Interrupt64:    .long   0                       //  80 CAN2_RX0           CAN2 RX0 interrupts
Interrupt65:    .long   0                       //  81 CAN2_RX1           CAN2 RX1 interrupt
Interrupt66:    .long   0                       //  82 CAN2_SCE           CAN2 SCE interrupt
Interrupt67:    .long   0                       //  83 OTG_FS             USB On The Go FS global interrupt
Interrupt68:    .long   0                       //  84 DMA2_Stream5       DMA2 Stream5 global interrupt
Interrupt69:    .long   0                       //  85 DMA2_Stream6       DMA2 Stream6 global interrupt
Interrupt70:    .long   0                       //  86 DMA2_Stream7       DMA2 Stream7 global interrupt
Interrupt71:    .long   0                       //  87 USART6             USART6 global interrupt
Interrupt72:    .long   0                       //  88 I2C3_EV            I2C3 event interrupt
Interrupt73:    .long   0                       //  89 I2C3_ER            I2C3 error interrupt
Interrupt74:    .long   0                       //  90 OTG_HS_EP1_OUT     USB On The Go HS End Point 1 Out global interrupt
Interrupt75:    .long   0                       //  91 OTG_HS_EP1_IN      USB On The Go HS End Point 1 In global interrupt
Interrupt76:    .long   0                       //  92 OTG_HS_WKUP        USB On The Go HS Wakeup through EXTI interrupt
Interrupt77:    .long   0                       //  93 OTG_HS             USB On The Go HS global interrupt
Interrupt78:    .long   0                       //  94 DCMI               DCMI global interrupt
Interrupt79:    .long   0                       //  95 CRYP               CRYP crypto global interrupt
Interrupt80:    .long   0                       //  96 HASH_RNG           Hash and Rng global interrupt
Interrupt81:    .long   0                       //  97 FPU                FPU global interrupt
Interrupt82:    .long   0                       //  98 UART7              UART7 global interrupt
Interrupt83:    .long   0                       //  99 UART8              UART8 global interrupt
Interrupt84:    .long   0                       // 100 SPI4               SPI4 global interrupt
Interrupt85:    .long   0                       // 101 SPI5               SPI5 global interrupt
Interrupt86:    .long   0                       // 102 SPI6               SPI6 global interrupt
Interrupt87:    .long   0                       // 103 SAI1               SAI1 global interrupt
Interrupt88:    .long   0                       // 104 LCD-TFT            LCD-TFT global interrupt
Interrupt89:    .long   0                       // 105 LCD-TFT            LCD-TFT global Error interrupt
Interrupt90:    .long   0                       // 106 DMA2D              DMA2D global interrupt
Interrupt91:    .long   0                       // 107 SAI2               SAI2 global interrupt
Interrupt92:    .long   0                       // 108 QuadSPI            QuadSPI global interrupt
Interrupt93:    .long   0                       // 109 LP Timer1          LP Timer1 global interrupt
Interrupt94:    .long   0                       // 110 HDMI-CEC           HDMI-CEC global interrupt
Interrupt95:    .long   0                       // 111 I2C4_EV            I2C4 event interrupt
Interrupt96:    .long   0                       // 112 I2C4_ER            I2C4 Error interrupt
Interrupt97:    .long   0                       // 113 SPDIFRX            SPDIFRX global interrupt
Interrupt98:    .long   0                       // 114 DSIHOST            DSI host global interrupt
Interrupt99:    .long   0                       // 115 DFSDM1_FLT0        DFSDM1 Filter 0 global interrupt
Interrupt100:   .long   0                       // 116 DFSDM1_FLT1        DFSDM1 Filter 1 global interrupt
Interrupt101:   .long   0                       // 117 DFSDM1_FLT2        DFSDM1 Filter 2 global interrupt
Interrupt102:   .long   0                       // 118 DFSDM1_FLT3        DFSDM1 Filter 3 global interrupt
Interrupt103:   .long   0                       // 119 SDMMC2             SDMMC2 global interrupt
Interrupt104:   .long   0                       // 120 CAN3_TX            CAN3 TX interrupt
Interrupt105:   .long   0                       // 121 CAN3_RX0           CAN3 RX0 interrupt
Interrupt106:   .long   0                       // 122 CAN3_RX1           CAN3 RX1 interrupt
Interrupt107:   .long   0                       // 123 CAN3_SCE           CAN3 SCE interrupt
Interrupt108:   .long   0                       // 124 JPEG               JPEG global interrupt
Interrupt109:   .long   0                       // 125 MDIOS              MDIO slave global interrupt

                .sect   .text,"ax"

                .thumb_func
                .type   systick_handler,%function
                .global systick_handler
systick_handler:
                push    {lr}
                .extern irq_process
                bl      irq_process
                pop     {lr}
                bx      lr

