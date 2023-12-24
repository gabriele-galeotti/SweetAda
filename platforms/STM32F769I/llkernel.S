
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .syntax unified

                .sect   .text,"ax"

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

Interrupt0:     .long   0                       //  16
Interrupt1:     .long   0                       //  17
Interrupt2:     .long   0                       //  18
Interrupt3:     .long   0                       //  19
Interrupt4:     .long   0                       //  20
Interrupt5:     .long   0                       //  21
Interrupt6:     .long   0                       //  22
Interrupt7:     .long   0                       //  23
Interrupt8:     .long   0                       //  24
Interrupt9:     .long   0                       //  25
Interrupt10:    .long   0                       //  26
Interrupt11:    .long   0                       //  27
Interrupt12:    .long   0                       //  28
Interrupt13:    .long   0                       //  29
Interrupt14:    .long   0                       //  30
Interrupt15:    .long   0                       //  31
Interrupt16:    .long   0                       //  32
Interrupt17:    .long   0                       //  33
Interrupt18:    .long   0                       //  34
Interrupt19:    .long   0                       //  35
Interrupt20:    .long   0                       //  36
Interrupt21:    .long   0                       //  37
Interrupt22:    .long   0                       //  38
Interrupt23:    .long   0                       //  39
Interrupt24:    .long   0                       //  40
Interrupt25:    .long   0                       //  41
Interrupt26:    .long   0                       //  42
Interrupt27:    .long   0                       //  43
Interrupt28:    .long   0                       //  44
Interrupt29:    .long   0                       //  45
Interrupt30:    .long   0                       //  46
Interrupt31:    .long   0                       //  47
Interrupt32:    .long   0                       //  48
Interrupt33:    .long   0                       //  49
Interrupt34:    .long   0                       //  50
Interrupt35:    .long   0                       //  51
Interrupt36:    .long   0                       //  52
Interrupt37:    .long   0                       //  53
Interrupt38:    .long   0                       //  54
Interrupt39:    .long   0                       //  55
Interrupt40:    .long   0                       //  56
Interrupt41:    .long   0                       //  57
Interrupt42:    .long   0                       //  58
Interrupt43:    .long   0                       //  59
Interrupt44:    .long   0                       //  60
Interrupt45:    .long   0                       //  61
Interrupt46:    .long   0                       //  62
Interrupt47:    .long   0                       //  63
Interrupt48:    .long   0                       //  64
Interrupt49:    .long   0                       //  65
Interrupt50:    .long   0                       //  66
Interrupt51:    .long   0                       //  67
Interrupt52:    .long   0                       //  68
Interrupt53:    .long   0                       //  69
Interrupt54:    .long   0                       //  70
Interrupt55:    .long   0                       //  71
Interrupt56:    .long   0                       //  72
Interrupt57:    .long   0                       //  73
Interrupt58:    .long   0                       //  74
Interrupt59:    .long   0                       //  75
Interrupt60:    .long   0                       //  76
Interrupt61:    .long   0                       //  77
Interrupt62:    .long   0                       //  78
Interrupt63:    .long   0                       //  79
Interrupt64:    .long   0                       //  80
Interrupt65:    .long   0                       //  81
Interrupt66:    .long   0                       //  82
Interrupt67:    .long   0                       //  83
Interrupt68:    .long   0                       //  84
Interrupt69:    .long   0                       //  85
Interrupt70:    .long   0                       //  86
Interrupt71:    .long   0                       //  87
Interrupt72:    .long   0                       //  88
Interrupt73:    .long   0                       //  89
Interrupt74:    .long   0                       //  90
Interrupt75:    .long   0                       //  91
Interrupt76:    .long   0                       //  92
Interrupt77:    .long   0                       //  93
Interrupt78:    .long   0                       //  94
Interrupt79:    .long   0                       //  95
Interrupt80:    .long   0                       //  96
Interrupt81:    .long   0                       //  97
Interrupt82:    .long   0                       //  98
Interrupt83:    .long   0                       //  99
Interrupt84:    .long   0                       // 100
Interrupt85:    .long   0                       // 101
Interrupt86:    .long   0                       // 102
Interrupt87:    .long   0                       // 103
Interrupt88:    .long   0                       // 104
Interrupt89:    .long   0                       // 105
Interrupt90:    .long   0                       // 106
Interrupt91:    .long   0                       // 107
Interrupt92:    .long   0                       // 108
Interrupt93:    .long   0                       // 109
Interrupt94:    .long   0                       // 110
Interrupt95:    .long   0                       // 111

// unused interrupts

Interrupt96:    .long   0                       // 112
Interrupt97:    .long   0                       // 113
Interrupt98:    .long   0                       // 114
Interrupt99:    .long   0                       // 115
Interrupt100:   .long   0                       // 116
Interrupt101:   .long   0                       // 117
Interrupt102:   .long   0                       // 118
Interrupt103:   .long   0                       // 119
Interrupt104:   .long   0                       // 120
Interrupt105:   .long   0                       // 121
Interrupt106:   .long   0                       // 122
Interrupt107:   .long   0                       // 123
Interrupt108:   .long   0                       // 124
Interrupt109:   .long   0                       // 125
Interrupt110:   .long   0                       // 126
Interrupt111:   .long   0                       // 127
Interrupt112:   .long   0                       // 128
Interrupt113:   .long   0                       // 129
Interrupt114:   .long   0                       // 130
Interrupt115:   .long   0                       // 131
Interrupt116:   .long   0                       // 132
Interrupt117:   .long   0                       // 133
Interrupt118:   .long   0                       // 134
Interrupt119:   .long   0                       // 135
Interrupt120:   .long   0                       // 136
Interrupt121:   .long   0                       // 137
Interrupt122:   .long   0                       // 138
Interrupt123:   .long   0                       // 139
Interrupt124:   .long   0                       // 140
Interrupt125:   .long   0                       // 141
Interrupt126:   .long   0                       // 142
Interrupt127:   .long   0                       // 143
Interrupt128:   .long   0                       // 144
Interrupt129:   .long   0                       // 145
Interrupt130:   .long   0                       // 146
Interrupt131:   .long   0                       // 147
Interrupt132:   .long   0                       // 148
Interrupt133:   .long   0                       // 149
Interrupt134:   .long   0                       // 150
Interrupt135:   .long   0                       // 151
Interrupt136:   .long   0                       // 152
Interrupt137:   .long   0                       // 153
Interrupt138:   .long   0                       // 154
Interrupt139:   .long   0                       // 155
Interrupt140:   .long   0                       // 156
Interrupt141:   .long   0                       // 157
Interrupt142:   .long   0                       // 158
Interrupt143:   .long   0                       // 159
Interrupt144:   .long   0                       // 160
Interrupt145:   .long   0                       // 161
Interrupt146:   .long   0                       // 162
Interrupt147:   .long   0                       // 163
Interrupt148:   .long   0                       // 164
Interrupt149:   .long   0                       // 165
Interrupt150:   .long   0                       // 166
Interrupt151:   .long   0                       // 167
Interrupt152:   .long   0                       // 168
Interrupt153:   .long   0                       // 169
Interrupt154:   .long   0                       // 170
Interrupt155:   .long   0                       // 171
Interrupt156:   .long   0                       // 172
Interrupt157:   .long   0                       // 173
Interrupt158:   .long   0                       // 174
Interrupt159:   .long   0                       // 175
Interrupt160:   .long   0                       // 176
Interrupt161:   .long   0                       // 177
Interrupt162:   .long   0                       // 178
Interrupt163:   .long   0                       // 179
Interrupt164:   .long   0                       // 180
Interrupt165:   .long   0                       // 181
Interrupt166:   .long   0                       // 182
Interrupt167:   .long   0                       // 183
Interrupt168:   .long   0                       // 184
Interrupt169:   .long   0                       // 185
Interrupt170:   .long   0                       // 186
Interrupt171:   .long   0                       // 187
Interrupt172:   .long   0                       // 188
Interrupt173:   .long   0                       // 189
Interrupt174:   .long   0                       // 190
Interrupt175:   .long   0                       // 191
Interrupt176:   .long   0                       // 192
Interrupt177:   .long   0                       // 193
Interrupt178:   .long   0                       // 194
Interrupt179:   .long   0                       // 195
Interrupt180:   .long   0                       // 196
Interrupt181:   .long   0                       // 197
Interrupt182:   .long   0                       // 198
Interrupt183:   .long   0                       // 199
Interrupt184:   .long   0                       // 200
Interrupt185:   .long   0                       // 201
Interrupt186:   .long   0                       // 202
Interrupt187:   .long   0                       // 203
Interrupt188:   .long   0                       // 204
Interrupt189:   .long   0                       // 205
Interrupt190:   .long   0                       // 206
Interrupt191:   .long   0                       // 207
Interrupt192:   .long   0                       // 208
Interrupt193:   .long   0                       // 209
Interrupt194:   .long   0                       // 210
Interrupt195:   .long   0                       // 211
Interrupt196:   .long   0                       // 212
Interrupt197:   .long   0                       // 213
Interrupt198:   .long   0                       // 214
Interrupt199:   .long   0                       // 215
Interrupt200:   .long   0                       // 216
Interrupt201:   .long   0                       // 217
Interrupt202:   .long   0                       // 218
Interrupt203:   .long   0                       // 219
Interrupt204:   .long   0                       // 220
Interrupt205:   .long   0                       // 221
Interrupt206:   .long   0                       // 222
Interrupt207:   .long   0                       // 223
Interrupt208:   .long   0                       // 224
Interrupt209:   .long   0                       // 225
Interrupt210:   .long   0                       // 226
Interrupt211:   .long   0                       // 227
Interrupt212:   .long   0                       // 228
Interrupt213:   .long   0                       // 229
Interrupt214:   .long   0                       // 230
Interrupt215:   .long   0                       // 231
Interrupt216:   .long   0                       // 232
Interrupt217:   .long   0                       // 233
Interrupt218:   .long   0                       // 234
Interrupt219:   .long   0                       // 235
Interrupt220:   .long   0                       // 236
Interrupt221:   .long   0                       // 237
Interrupt222:   .long   0                       // 238
Interrupt223:   .long   0                       // 239
Interrupt224:   .long   0                       // 240
Interrupt225:   .long   0                       // 241
Interrupt226:   .long   0                       // 242
Interrupt227:   .long   0                       // 243
Interrupt228:   .long   0                       // 244
Interrupt229:   .long   0                       // 245
Interrupt230:   .long   0                       // 246
Interrupt231:   .long   0                       // 247
Interrupt232:   .long   0                       // 248
Interrupt233:   .long   0                       // 249
Interrupt234:   .long   0                       // 250
Interrupt235:   .long   0                       // 251
Interrupt236:   .long   0                       // 252
Interrupt237:   .long   0                       // 253
Interrupt238:   .long   0                       // 254
Interrupt239:   .long   0                       // 255

                .thumb_func
systick_handler:
                push    {lr}
                .extern irq_process
                bl      irq_process
                pop     {lr}
                bx      lr

