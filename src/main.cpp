#include <iostream>
#include <cassert>

extern "C" void swap(int *p1, int *p2) __attribute__((fastcall));
extern "C" int sum(int *p1, int *p2); // __attribute__((fastcall));

void DoCheck(uint32_t dwSomeValue);
void do_print(uint32_t dwSomeValue);
#define DebugBreak asm("int3")

int main()
{
#ifdef DEBUG
	std::cout << "Debug version\n";
#else
	std::cout << "Release version\n";
#endif

	int a = 10, b = 20;
	std::cout << "a=" << a << ", b=" << b << std::endl;
	swap(&a, &b);
	std::cout << "After swap(&a, &b): a=" << a << ", b=" << b << std::endl;

	// asm("int3\nint3");

	int c = sum(&a, &b);
	std::cout << "After sum(&a, &b):  c=" << c << std::endl;

	std::cout << "Program finished\n";

	// DoCheck(4);
	// do_print(32);

	return 0;
}


void DoCheck(uint32_t dwSomeValue)
{
   uint32_t dwRes;

   // Assumes dwSomeValue is not zero.
   asm ("bsfl %1,%0"
     : "=r" (dwRes)
     : "r" (dwSomeValue)
     : "cc");

   assert(dwRes > 3);
}

void do_print(uint32_t dwSomeValue)
{
   uint32_t dwRes;

   for (uint32_t x=0; x < 5; x++)
   {
      // Assumes dwSomeValue is not zero.
      asm ("bsfl %1,%0"
        : "=r" (dwRes)
        : "r" (dwSomeValue)
        : "cc");

      printf("%u: %u %u\n", x, dwSomeValue, dwRes);
   }
}