bits 32

global swap, sum

;extern "C" void swap(int *p1, int *p2) __attribute__((fastcall));
swap:
	xchg ecx, [eax]
	xchg ecx, [edx]
	xchg [eax], ecx
	ret

;extern "C" int sum(int *p1, int *p2);
sum:
	mov eax, [esp+4]	;get pointer
	mov eax, [eax]		;dereference
	mov ecx, [esp+8]
	add eax, [ecx]
	ret