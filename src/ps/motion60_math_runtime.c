// Bare-metal, single-core math library errno storage; no OS or libc runtime.
static int math_errno;
int *__errno(void){return &math_errno;}
