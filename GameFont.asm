	EXTERN DrawPixel:FAR
	PUBLIC DrawString
	PUBLIC DrawChar
	.MODEL LARGE;TINY   :data+code = 64KB    
	;SMALL  :data = 64KB and code = 64KB
	;MEDIUM :data = 64KB but no code restriction
	;COMPACT:code = 64KB but no data restriction
	;LARGE  :Single set of data can not exceed 64KB
	;HUGE   :No restriction
;------------------------------------------------------
	.STACK 64
;------------------------------------------------------                    
FontSegment SEGMENT
	
FONTTABLE LABEL BYTE
		
; Font: THIN8X8.pf

		db	00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H	; (.)
		db	7EH, 81H, 0A5H, 81H, 0BDH, 99H, 81H, 7EH	; (.)
		db	7EH, 0FFH, 0DBH, 0FFH, 0C3H, 0E7H, 0FFH, 7EH	; (.)
		db	6CH, 0FEH, 0FEH, 0FEH, 7CH, 38H, 10H, 00H	; (.)
		db	10H, 38H, 7CH, 0FEH, 7CH, 38H, 10H, 00H	; (.)
		db	38H, 7CH, 38H, 0FEH, 0FEH, 7CH, 38H, 7CH	; (.)
		db	10H, 10H, 38H, 7CH, 0FEH, 7CH, 38H, 7CH	; (.)
		db	00H, 00H, 18H, 3CH, 3CH, 18H, 00H, 00H	; (.)
		db	0FFH, 0FFH, 0E7H, 0C3H, 0C3H, 0E7H, 0FFH, 0FFH	; (.)
		db	00H, 3CH, 66H, 42H, 42H, 66H, 3CH, 00H	; (.)
		db	0FFH, 0C3H, 99H, 0BDH, 0BDH, 99H, 0C3H, 0FFH	; (.)
		db	0FH, 07H, 0FH, 7DH, 0CCH, 0CCH, 0CCH, 78H	; (.)
		db	3CH, 66H, 66H, 66H, 3CH, 18H, 7EH, 18H	; (.)
		db	3FH, 33H, 3FH, 30H, 30H, 70H, 0F0H, 0E0H	; (.)
		db	7FH, 63H, 7FH, 63H, 63H, 67H, 0E6H, 0C0H	; (.)
		db	99H, 5AH, 3CH, 0E7H, 0E7H, 3CH, 5AH, 99H	; (.)
		db	80H, 0E0H, 0F8H, 0FEH, 0F8H, 0E0H, 80H, 00H	; (.)
		db	02H, 0EH, 3EH, 0FEH, 3EH, 0EH, 02H, 00H	; (.)
		db	18H, 3CH, 7EH, 18H, 18H, 7EH, 3CH, 18H	; (.)
		db	66H, 66H, 66H, 66H, 66H, 00H, 66H, 00H	; (.)
		db	7FH, 0DBH, 0DBH, 7BH, 1BH, 1BH, 1BH, 00H	; (.)
		db	3EH, 63H, 38H, 6CH, 6CH, 38H, 0CCH, 78H	; (.)
		db	00H, 00H, 00H, 00H, 7EH, 7EH, 7EH, 00H	; (.)
		db	18H, 3CH, 7EH, 18H, 7EH, 3CH, 18H, 0FFH	; (.)
		db	18H, 3CH, 7EH, 18H, 18H, 18H, 18H, 00H	; (.)
		db	18H, 18H, 18H, 18H, 7EH, 3CH, 18H, 00H	; (.)
		db	00H, 18H, 0CH, 0FEH, 0CH, 18H, 00H, 00H	; (.)
		db	00H, 30H, 60H, 0FEH, 60H, 30H, 00H, 00H	; (.)
		db	00H, 00H, 0C0H, 0C0H, 0C0H, 0FEH, 00H, 00H	; (.)
		db	00H, 24H, 66H, 0FFH, 66H, 24H, 00H, 00H	; (.)
		db	00H, 18H, 3CH, 7EH, 0FFH, 0FFH, 00H, 00H	; (.)
		db	00H, 0FFH, 0FFH, 7EH, 3CH, 18H, 00H, 00H	; (.)
		db	00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H	; ( )
		db	40H, 40H, 40H, 40H, 40H, 00H, 40H, 00H	; (!)
		db	90H, 90H, 00H, 00H, 00H, 00H, 00H, 00H	; (")
		db	50H, 50H, 0F8H, 50H, 0F8H, 50H, 50H, 00H	; (#)
		db	20H, 78H, 0A0H, 70H, 28H, 0F0H, 20H, 00H	; ($)
		db	0C8H, 0C8H, 10H, 20H, 40H, 98H, 98H, 00H	; (%)
		db	70H, 88H, 50H, 20H, 54H, 88H, 74H, 00H	; (&)
		db	60H, 20H, 40H, 00H, 00H, 00H, 00H, 00H	; (')
		db	20H, 40H, 80H, 80H, 80H, 40H, 20H, 00H	; (()
		db	20H, 10H, 08H, 08H, 08H, 10H, 20H, 00H	; ())
		db	00H, 20H, 0A8H, 70H, 70H, 0A8H, 20H, 00H	; (*)
		db	00H, 00H, 20H, 20H, 0F8H, 20H, 20H, 00H	; (+)
		db	00H, 00H, 00H, 00H, 00H, 60H, 20H, 40H	; (,)
		db	00H, 00H, 00H, 00H, 0F8H, 00H, 00H, 00H	; (-)
		db	00H, 00H, 00H, 00H, 00H, 60H, 60H, 00H	; (.)
		db	02H, 04H, 08H, 10H, 20H, 40H, 80H, 00H	; (/)
		db	70H, 88H, 98H, 0A8H, 0C8H, 88H, 70H, 00H	; (0)
		db	40H, 0C0H, 40H, 40H, 40H, 40H, 0E0H, 00H	; (1)
		db	70H, 88H, 08H, 10H, 20H, 40H, 0F8H, 00H	; (2)
		db	70H, 88H, 08H, 10H, 08H, 88H, 70H, 00H	; (3)
		db	08H, 18H, 28H, 48H, 0FCH, 08H, 08H, 00H	; (4)
		db	0F8H, 80H, 80H, 0F0H, 08H, 88H, 70H, 00H	; (5)
		db	20H, 40H, 80H, 0F0H, 88H, 88H, 70H, 00H	; (6)
		db	0F8H, 08H, 10H, 20H, 40H, 40H, 40H, 00H	; (7)
		db	70H, 88H, 88H, 70H, 88H, 88H, 70H, 00H	; (8)
		db	70H, 88H, 88H, 78H, 08H, 08H, 70H, 00H	; (9)
		db	00H, 00H, 60H, 60H, 00H, 60H, 60H, 00H	; (:)
		db	00H, 00H, 60H, 60H, 00H, 60H, 60H, 20H	; (;)
		db	10H, 20H, 40H, 80H, 40H, 20H, 10H, 00H	; (<)
		db	00H, 00H, 0F8H, 00H, 0F8H, 00H, 00H, 00H	; (=)
		db	80H, 40H, 20H, 10H, 20H, 40H, 80H, 00H	; (>)
		db	78H, 84H, 04H, 08H, 10H, 00H, 10H, 00H	; (?)
		db	70H, 88H, 88H, 0A8H, 0B8H, 80H, 78H, 00H	; (@)
		db	20H, 50H, 88H, 88H, 0F8H, 88H, 88H, 00H	; (A)
		db	0F0H, 88H, 88H, 0F0H, 88H, 88H, 0F0H, 00H	; (B)
		db	70H, 88H, 80H, 80H, 80H, 88H, 70H, 00H	; (C)
		db	0F0H, 88H, 88H, 88H, 88H, 88H, 0F0H, 00H	; (D)
		db	0F8H, 80H, 80H, 0E0H, 80H, 80H, 0F8H, 00H	; (E)
		db	0F8H, 80H, 80H, 0E0H, 80H, 80H, 80H, 00H	; (F)
		db	70H, 88H, 80H, 80H, 98H, 88H, 78H, 00H	; (G)
		db	88H, 88H, 88H, 0F8H, 88H, 88H, 88H, 00H	; (H)
		db	0E0H, 40H, 40H, 40H, 40H, 40H, 0E0H, 00H	; (I)
		db	38H, 10H, 10H, 10H, 10H, 90H, 60H, 00H	; (J)
		db	88H, 90H, 0A0H, 0C0H, 0A0H, 90H, 88H, 00H	; (K)
		db	80H, 80H, 80H, 80H, 80H, 80H, 0F8H, 00H	; (L)
		db	82H, 0C6H, 0AAH, 92H, 82H, 82H, 82H, 00H	; (M)
		db	84H, 0C4H, 0A4H, 94H, 8CH, 84H, 84H, 00H	; (N)
		db	70H, 88H, 88H, 88H, 88H, 88H, 70H, 00H	; (O)
		db	0F0H, 88H, 88H, 0F0H, 80H, 80H, 80H, 00H	; (P)
		db	70H, 88H, 88H, 88H, 0A8H, 90H, 68H, 00H	; (Q)
		db	0F0H, 88H, 88H, 0F0H, 0A0H, 90H, 88H, 00H	; (R)
		db	70H, 88H, 80H, 70H, 08H, 88H, 70H, 00H	; (S)
		db	0F8H, 20H, 20H, 20H, 20H, 20H, 20H, 00H	; (T)
		db	88H, 88H, 88H, 88H, 88H, 88H, 70H, 00H	; (U)
		db	88H, 88H, 88H, 50H, 50H, 20H, 20H, 00H	; (V)
		db	82H, 82H, 82H, 82H, 92H, 92H, 6CH, 00H	; (W)
		db	88H, 88H, 50H, 20H, 50H, 88H, 88H, 00H	; (X)
		db	88H, 88H, 88H, 50H, 20H, 20H, 20H, 00H	; (Y)
		db	0F8H, 08H, 10H, 20H, 40H, 80H, 0F8H, 00H	; (Z)
		db	0E0H, 80H, 80H, 80H, 80H, 80H, 0E0H, 00H	; ([)
		db	80H, 40H, 20H, 10H, 08H, 04H, 02H, 00H	; (\)
		db	0E0H, 20H, 20H, 20H, 20H, 20H, 0E0H, 00H	; (])
		db	20H, 50H, 88H, 00H, 00H, 00H, 00H, 00H	; (^)
		db	00H, 00H, 00H, 00H, 00H, 00H, 0F8H, 00H	; (_)
		db	40H, 20H, 00H, 00H, 00H, 00H, 00H, 00H	; (`)
		db	00H, 00H, 70H, 08H, 78H, 88H, 74H, 00H	; (a)
		db	80H, 80H, 0B0H, 0C8H, 88H, 0C8H, 0B0H, 00H	; (b)
		db	00H, 00H, 70H, 88H, 80H, 88H, 70H, 00H	; (c)
		db	08H, 08H, 68H, 98H, 88H, 98H, 68H, 00H	; (d)
		db	00H, 00H, 70H, 88H, 0F8H, 80H, 70H, 00H	; (e)
		db	30H, 48H, 40H, 0E0H, 40H, 40H, 40H, 00H	; (f)
		db	00H, 00H, 34H, 48H, 48H, 38H, 08H, 30H	; (g)
		db	80H, 80H, 0B0H, 0C8H, 88H, 88H, 88H, 00H	; (h)
		db	20H, 00H, 60H, 20H, 20H, 20H, 70H, 00H	; (i)
		db	10H, 00H, 30H, 10H, 10H, 10H, 90H, 60H	; (j)
		db	80H, 80H, 88H, 90H, 0A0H, 0D0H, 88H, 00H	; (k)
		db	0C0H, 40H, 40H, 40H, 40H, 40H, 0E0H, 00H	; (l)
		db	00H, 00H, 0ECH, 92H, 92H, 92H, 92H, 00H	; (m)
		db	00H, 00H, 0B0H, 0C8H, 88H, 88H, 88H, 00H	; (n)
		db	00H, 00H, 70H, 88H, 88H, 88H, 70H, 00H	; (o)
		db	00H, 00H, 0B0H, 0C8H, 0C8H, 0B0H, 80H, 80H	; (p)
		db	00H, 00H, 68H, 98H, 98H, 68H, 08H, 08H	; (q)
		db	00H, 00H, 0B0H, 0C8H, 80H, 80H, 80H, 00H	; (r)
		db	00H, 00H, 78H, 80H, 70H, 08H, 0F0H, 00H	; (s)
		db	40H, 40H, 0E0H, 40H, 40H, 50H, 20H, 00H	; (t)
		db	00H, 00H, 88H, 88H, 88H, 98H, 68H, 00H	; (u)
		db	00H, 00H, 88H, 88H, 88H, 50H, 20H, 00H	; (v)
		db	00H, 00H, 82H, 82H, 92H, 92H, 6CH, 00H	; (w)
		db	00H, 00H, 88H, 50H, 20H, 50H, 88H, 00H	; (x)
		db	00H, 00H, 88H, 88H, 98H, 68H, 08H, 70H	; (y)
		db	00H, 00H, 0F8H, 10H, 20H, 40H, 0F8H, 00H	; (z)
		db	10H, 20H, 20H, 40H, 20H, 20H, 10H, 00H	; ({)
		db	40H, 40H, 40H, 00H, 40H, 40H, 40H, 00H	; (|)
		db	40H, 20H, 20H, 10H, 20H, 20H, 40H, 00H	; (})
		db	76H, 0DCH, 00H, 00H, 00H, 00H, 00H, 00H	; (~)
		db	00H, 10H, 38H, 6CH, 0C6H, 0C6H, 0FEH, 00H	; (.)
		db	3EH, 60H, 0C0H, 60H, 3EH, 08H, 04H, 18H	; (.)
		db	00H, 48H, 00H, 0CCH, 0CCH, 0CCH, 0CCH, 76H	; (.)
		db	18H, 20H, 00H, 78H, 0CCH, 0FCH, 0C0H, 78H	; (.)
		db	10H, 28H, 00H, 78H, 0CH, 7CH, 0CCH, 76H	; (.)
		db	00H, 48H, 00H, 78H, 0CH, 7CH, 0CCH, 76H	; (.)
		db	30H, 08H, 00H, 78H, 0CH, 7CH, 0CCH, 76H	; (.)
		db	48H, 30H, 00H, 78H, 0CH, 7CH, 0CCH, 76H	; (.)
		db	78H, 0CCH, 0C0H, 0CCH, 78H, 10H, 08H, 30H	; (.)
		db	30H, 48H, 84H, 78H, 0CCH, 0FCH, 0C0H, 78H	; (.)
		db	00H, 48H, 00H, 78H, 0CCH, 0FCH, 0C0H, 78H	; (.)
		db	30H, 08H, 00H, 78H, 0CCH, 0FCH, 0C0H, 78H	; (.)
		db	00H, 48H, 00H, 30H, 30H, 30H, 30H, 30H	; (.)
		db	30H, 48H, 00H, 30H, 30H, 30H, 30H, 30H	; (.)
		db	60H, 10H, 00H, 30H, 30H, 30H, 30H, 30H	; (.)
		db	48H, 00H, 30H, 78H, 0CCH, 0CCH, 0FCH, 0CCH	; (.)
		db	30H, 48H, 30H, 48H, 84H, 0FCH, 84H, 84H	; (.)
		db	18H, 20H, 00H, 0F8H, 80H, 0F0H, 80H, 0F8H	; (.)
		db	00H, 00H, 00H, 66H, 19H, 77H, 88H, 77H	; (.)
		db	00H, 00H, 00H, 0FH, 14H, 3EH, 44H, 87H	; (.)
		db	30H, 48H, 84H, 78H, 0CCH, 0CCH, 0CCH, 78H	; (.)
		db	00H, 48H, 00H, 78H, 0CCH, 0CCH, 0CCH, 78H	; (.)
		db	60H, 10H, 00H, 78H, 0CCH, 0CCH, 0CCH, 78H	; (.)
		db	30H, 48H, 84H, 00H, 0CCH, 0CCH, 0CCH, 76H	; (.)
		db	60H, 10H, 00H, 0CCH, 0CCH, 0CCH, 0CCH, 76H	; (.)
		db	48H, 00H, 0CCH, 0CCH, 0CCH, 7CH, 0CH, 0F8H	; (.)
		db	44H, 00H, 38H, 6CH, 0C6H, 0C6H, 6CH, 38H	; (.)
		db	24H, 00H, 66H, 66H, 66H, 66H, 66H, 3CH	; (.)
		db	00H, 08H, 1CH, 28H, 28H, 1CH, 08H, 00H	; (.)
		db	1CH, 22H, 20H, 70H, 20H, 22H, 5CH, 00H	; (.)
		db	44H, 28H, 10H, 10H, 38H, 10H, 38H, 10H	; (.)
		db	0F0H, 88H, 8AH, 0F7H, 82H, 82H, 83H, 00H	; (.)
		db	06H, 08H, 08H, 3CH, 10H, 10H, 60H, 00H	; (.)
		db	18H, 20H, 00H, 78H, 0CH, 7CH, 0CCH, 76H	; (.)
		db	18H, 20H, 00H, 30H, 30H, 30H, 30H, 30H	; (.)
		db	18H, 20H, 00H, 78H, 0CCH, 0CCH, 0CCH, 78H	; (.)
		db	18H, 20H, 00H, 0CCH, 0CCH, 0CCH, 0CCH, 76H	; (.)
		db	80H, 78H, 04H, 0F8H, 0CCH, 0CCH, 0CCH, 0CCH	; (.)
		db	80H, 7EH, 01H, 0C6H, 0E6H, 0D6H, 0CEH, 0C6H	; (.)
		db	00H, 78H, 0CH, 7CH, 0CCH, 76H, 00H, 0FEH	; (.)
		db	00H, 78H, 0CCH, 0CCH, 0CCH, 78H, 00H, 0FCH	; (.)
		db	00H, 00H, 18H, 18H, 30H, 60H, 66H, 3CH	; (.)
		db	0FFH, 80H, 80H, 80H, 00H, 00H, 00H, 00H	; (.)
		db	0FFH, 01H, 01H, 01H, 00H, 00H, 00H, 00H	; (.)
		db	40H, 0C4H, 48H, 50H, 26H, 49H, 82H, 07H	; (.)
		db	40H, 0C4H, 48H, 50H, 26H, 4AH, 9FH, 02H	; (.)
		db	00H, 30H, 00H, 30H, 30H, 30H, 30H, 30H	; (.)
		db	00H, 12H, 24H, 48H, 90H, 48H, 24H, 12H	; (.)
		db	00H, 48H, 24H, 12H, 09H, 12H, 24H, 48H	; (.)
		db	49H, 00H, 92H, 00H, 49H, 00H, 92H, 00H	; (.)
		db	6DH, 00H, 0B6H, 00H, 6DH, 00H, 0B6H, 00H	; (.)
		db	0AAH, 55H, 0AAH, 55H, 0AAH, 55H, 0AAH, 55H	; (.)
		db	10H, 10H, 10H, 10H, 10H, 10H, 10H, 10H	; (.)
		db	10H, 10H, 10H, 10H, 0F0H, 10H, 10H, 10H	; (.)
		db	10H, 10H, 10H, 0F0H, 10H, 0F0H, 10H, 10H	; (.)
		db	28H, 28H, 28H, 28H, 0E8H, 28H, 28H, 28H	; (.)
		db	00H, 00H, 00H, 00H, 0F8H, 28H, 28H, 28H	; (.)
		db	00H, 00H, 00H, 0F0H, 10H, 0F0H, 10H, 10H	; (.)
		db	28H, 28H, 28H, 0E8H, 08H, 0E8H, 28H, 28H	; (.)
		db	28H, 28H, 28H, 28H, 28H, 28H, 28H, 28H	; (.)
		db	00H, 00H, 00H, 0F8H, 08H, 0E8H, 28H, 28H	; (.)
		db	28H, 28H, 28H, 0E8H, 08H, 0F8H, 00H, 00H	; (.)
		db	28H, 28H, 28H, 28H, 0F8H, 00H, 00H, 00H	; (.)
		db	10H, 10H, 10H, 0F0H, 10H, 0F0H, 00H, 00H	; (.)
		db	00H, 00H, 00H, 00H, 0F0H, 10H, 10H, 10H	; (.)
		db	10H, 10H, 10H, 10H, 1FH, 00H, 00H, 00H	; (.)
		db	10H, 10H, 10H, 10H, 0FFH, 00H, 00H, 00H	; (.)
		db	00H, 00H, 00H, 00H, 0FFH, 10H, 10H, 10H	; (.)
		db	10H, 10H, 10H, 10H, 1FH, 10H, 10H, 10H	; (.)
		db	00H, 00H, 00H, 00H, 0FFH, 00H, 00H, 00H	; (.)
		db	10H, 10H, 10H, 10H, 0FFH, 10H, 10H, 10H	; (.)
		db	10H, 10H, 10H, 1FH, 10H, 1FH, 10H, 10H	; (.)
		db	28H, 28H, 28H, 28H, 3FH, 28H, 28H, 28H	; (.)
		db	28H, 28H, 28H, 2FH, 20H, 3FH, 00H, 00H	; (.)
		db	00H, 00H, 00H, 3FH, 20H, 2FH, 28H, 28H	; (.)
		db	28H, 28H, 28H, 0EFH, 00H, 0FFH, 00H, 00H	; (.)
		db	00H, 00H, 00H, 0FFH, 00H, 0EFH, 28H, 28H	; (.)
		db	28H, 28H, 28H, 2FH, 20H, 2FH, 28H, 28H	; (.)
		db	00H, 00H, 00H, 0FFH, 00H, 0FFH, 00H, 00H	; (.)
		db	28H, 28H, 28H, 0EFH, 00H, 0EFH, 28H, 28H	; (.)
		db	10H, 10H, 10H, 0FFH, 00H, 0FFH, 00H, 00H	; (.)
		db	28H, 28H, 28H, 28H, 0FFH, 00H, 00H, 00H	; (.)
		db	00H, 00H, 00H, 0FFH, 00H, 0FFH, 10H, 10H	; (.)
		db	00H, 00H, 00H, 00H, 0FFH, 28H, 28H, 28H	; (.)
		db	28H, 28H, 28H, 28H, 3FH, 00H, 00H, 00H	; (.)
		db	10H, 10H, 10H, 1FH, 10H, 1FH, 00H, 00H	; (.)
		db	00H, 00H, 00H, 1FH, 10H, 1FH, 10H, 10H	; (.)
		db	00H, 00H, 00H, 00H, 3FH, 28H, 28H, 28H	; (.)
		db	28H, 28H, 28H, 28H, 0FFH, 28H, 28H, 28H	; (.)
		db	10H, 10H, 10H, 0FFH, 10H, 0FFH, 10H, 10H	; (.)
		db	10H, 10H, 10H, 10H, 0F0H, 00H, 00H, 00H	; (.)
		db	00H, 00H, 00H, 00H, 1FH, 10H, 10H, 10H	; (.)
		db	0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH	; (.)
		db	00H, 00H, 00H, 00H, 0FFH, 0FFH, 0FFH, 00H	; (.)
		db	0E0H, 0E0H, 0E0H, 0E0H, 0E0H, 0E0H, 0E0H, 0E0H	; (.)
		db	07H, 07H, 07H, 07H, 07H, 07H, 07H, 07H	; (.)
		db	0FFH, 0FFH, 0FFH, 0FFH, 00H, 00H, 00H, 00H	; (.)
		db	00H, 00H, 00H, 02H, 34H, 4CH, 4CH, 32H	; (.)
		db	00H, 5CH, 22H, 22H, 3CH, 44H, 44H, 78H	; (.)
		db	7EH, 42H, 42H, 40H, 40H, 40H, 40H, 40H	; (.)
		db	00H, 00H, 02H, 7CH, 0A8H, 28H, 28H, 44H	; (.)
		db	00H, 7EH, 61H, 30H, 18H, 08H, 10H, 20H	; (.)
		db	00H, 00H, 08H, 7FH, 88H, 88H, 88H, 70H	; (.)
		db	00H, 00H, 00H, 22H, 44H, 44H, 7AH, 80H	; (.)
		db	00H, 00H, 00H, 7CH, 10H, 10H, 10H, 10H	; (.)
		db	00H, 1CH, 08H, 3EH, 41H, 41H, 41H, 3EH	; (.)
		db	00H, 00H, 38H, 44H, 44H, 7CH, 44H, 44H	; (.)
		db	3CH, 66H, 0C3H, 0C3H, 0C3H, 66H, 24H, 66H	; (.)
		db	0CH, 10H, 08H, 1CH, 22H, 22H, 22H, 1CH	; (.)
		db	00H, 00H, 00H, 00H, 6CH, 92H, 92H, 6CH	; (.)
		db	00H, 01H, 1AH, 26H, 2AH, 32H, 2CH, 40H	; (.)
		db	00H, 18H, 20H, 20H, 30H, 20H, 20H, 18H	; (.)
		db	00H, 3CH, 42H, 42H, 42H, 42H, 42H, 42H	; (.)
		db	00H, 00H, 7EH, 00H, 7EH, 00H, 7EH, 00H	; (.)
		db	00H, 08H, 08H, 3EH, 08H, 08H, 00H, 3EH	; (.)
		db	00H, 10H, 08H, 04H, 08H, 10H, 00H, 3EH	; (.)
		db	00H, 04H, 08H, 10H, 08H, 04H, 00H, 3EH	; (.)
		db	00H, 06H, 09H, 09H, 08H, 08H, 08H, 00H	; (.)
		db	00H, 00H, 08H, 08H, 08H, 48H, 48H, 30H	; (.)
		db	00H, 00H, 08H, 00H, 3EH, 00H, 08H, 00H	; (.)
		db	00H, 60H, 92H, 0CH, 60H, 92H, 0CH, 00H	; (.)
		db	60H, 90H, 60H, 00H, 00H, 00H, 00H, 00H	; (.)
		db	00H, 00H, 00H, 30H, 78H, 30H, 00H, 00H	; (.)
		db	00H, 00H, 00H, 00H, 20H, 00H, 00H, 00H	; (.)
		db	00H, 03H, 04H, 04H, 0C8H, 28H, 10H, 00H	; (.)
		db	00H, 00H, 00H, 7CH, 42H, 42H, 42H, 00H	; (.)
		db	18H, 24H, 08H, 10H, 3CH, 00H, 00H, 00H	; (.)
		db	00H, 00H, 00H, 3EH, 3EH, 3EH, 3EH, 00H	; (.)
		db	00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H	; (.)
FontSegment ENDS
	.DATA
	;Data Definitions Here
FONTWIDTH EQU 8
FONTHEIGHT EQU 8
;------------------------------------------------------
	.CODE

;Draws a NULL(0) terminated string at given position (string height = 8 pixels)
;input: BX: string address, cx: column, dx: row, ah= color(fg,bg)
;output: none
;modifies: none
DrawString PROC FAR
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH SI
drawloop:
		MOV AL, [BX]
		;check if zero(NULL)
		AND AL, AL
		JZ stop
		
		;backup bx
		MOV SI, BX
		
		MOV BL, AL
		MOV BH, AH
		CALL DrawChar
		
		ADD CX, FONTWIDTH
		;ADD DX, 20
		
		MOV BX, SI
		INC BX
		JMP drawloop
stop:
		POP SI
		POP CX
		POP BX
		POP AX
		RET
DrawString ENDP

;Draws a 8x8 char at specified pixel position
;input: bl: ascii, cx: column, dx: row, bh: color attribute
;output: none
;modifies: none

DrawChar PROC FAR
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
		PUSH SI
		PUSH DI
		PUSH DS
		
		MOV AX, FontSegment
		MOV DS, AX
		;multiply ascii by 8(font height)
		MOV AL, BL
		MOV BL, FONTHEIGHT
		
		MUL BL
		
		LEA BP, FONTTABLE
		ADD BP, AX
		
		; now we have ascii bitmap at BP
		
		;push column
		
		PUSH CX
		MOV SI, FONTHEIGHT
rowloop:
		MOV CX, FONTWIDTH
		
		MOV BL, DS:[BP]
columnloop:

		MOV DI, DX
		DEC CX
		MOV DH, 1
		SHL DH, CL
		INC CX
		
		TEST BL, DH
		MOV DX, DI
		JNZ print1
		MOV AL,BH ; bg
		
		;backup CX in DI
		MOV DI, CX
		MOV CX, 4
		SHR AL, CL
		MOV CX, DI
		
		JMP printreal
print1:
		MOV AL,BH ; fg
		AND AL, 0FH
printreal:
		MOV DI, CX
		
		POP CX
		
		;replace interrupt here
		CALL DrawPixel
		
		INC CX
		PUSH CX
		MOV CX, DI
		
		loop columnloop
		
		
		POP DI
		SUB DI, FONTWIDTH
		PUSH DI
		
		INC DX
		INC BP
		
		DEC SI
		JNZ rowloop
		POP CX
		
		POP DS
		POP DI
		POP SI
		POP DX
		POP CX
		POP BX
		POP AX
		RET
DrawChar ENDP
END