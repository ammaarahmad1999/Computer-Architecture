
00000000 00100000 ldc 0x1000
00000001 0000000B a2sp 
00000002 FFFFFF0A adj -1
00000003 00000A00 ldc 10
00000004 00000003 stl 0
00000005 00004100 ldc array
00000006 0000010D call sort
00000007 00000012 halt 























00000008 FFFFFF0A sort: adj -1
00000009 00000003 stl 0

0000000A 00000203 stl 2

0000000B FFFFFD0A adj -3
0000000C 00000000 ldc 0
0000000D 00000003 stl 0

0000000E 00000100 ldc 1
0000000F 00000103 stl 1

00000010 00000000 ldc 0
00000011 00000203 stl 2

00000012 00000402 loop_out: ldl 4

00000013 00000202 ldl 2

00000014 00000007 sub 

00000015 00000100 ldc 1
00000016 00000007 sub 

00000017 0000260F brz done
00000018 00000100 ldc 1
00000019 00000103 stl 1

0000001A 00000402 loop_in: ldl 4

0000001B 00000202 ldl 2

0000001C 00000007 sub 

0000001D 00000102 ldl 1

0000001E 00000007 sub 

0000001F 0000160F brz addx
00000020 00000502 ldl 5

00000021 00000004 ldnl 0

00000022 00000000 ldc 0

00000023 00000104 ldnl 1

00000024 00000007 sub 

00000025 00000110 brlz swap
00000026 00000A11 br addy
00000027 00000502 swap: ldl 5

00000028 00000004 ldnl 0

00000029 00000003 stl 0

0000002A 00000502 ldl 5
0000002B 00000104 ldnl 1

0000002C 00000502 ldl 5
0000002D 00000005 stnl 0

0000002E 00000002 ldl 0

0000002F 00000502 ldl 5
00000030 00000105 stnl 1


00000031 00000100 addy: ldc 1
00000032 00000102 ldl 1

00000033 00000006 add 

00000034 00000103 stl 1

00000035 FFFFE411 br loop_in
00000036 00000100 addx: ldc 1
00000037 00000202 ldl 2

00000038 00000006 add 

00000039 00000203 stl 2
0000003A 00000100 ldc 1
0000003B 00000502 ldl 5
0000003C 00000006 add 

0000003D FFFFD411 br loop_out
0000003E 00000302 done: ldl 3

0000003F 0000050A adj 5

00000040 0000000E return 

00000041 DEADBEEF array: data -559038737
00000042 5EEDBED5 data 1592639189
00000043 C0EDBABE data -1058161986
00000044 5EAF00D5 data 1588527317
00000045 AB5C155A data -1420028582
00000046 CA5CADED data -899895827
00000047 FEEDFACE data -17958194
00000048 C0C0F00D data -1061097459
00000049 DECEA5ED data -556882451
0000004A 50FABED5 data 1358610133