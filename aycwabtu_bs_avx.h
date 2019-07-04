
#ifndef AYCW_SSE_H_
#define AYCW_SSE_H_

#include <xmmintrin.h>
#include <emmintrin.h>
#include <immintrin.h>

typedef __m256i dvbcsa_bs_word_t;

#define BS_BATCH_SIZE 256
#define BS_BATCH_BYTES 32
#define BS_BATCH_SHIFT  8

#define BS_VAL(n, m, o, p)	_mm256_set_epi64x(n, m, o, p)
#define BS_VAL64(n)	BS_VAL(0x##n##ULL, 0x##n##ULL, 0x##n##ULL, 0x##n##ULL)
#define BS_VAL32(n)	BS_VAL64(n##n)
#define BS_VAL16(n)	BS_VAL32(n##n)
#define BS_VAL8(n)	BS_VAL16(n##n)
#define BS_VAL_LSDW(n)	BS_VAL(0,0,0,n)      // load 32 bit value to least significant dword

#define BS_AND(a, b)	_mm256_and_si256((a), (b))
#define BS_OR(a, b)	_mm256_or_si256 ((a), (b))
#define BS_XOR(a, b)	_mm256_xor_si256((a), (b))
#define BS_XOREQ(a, b)	{ dvbcsa_bs_word_t *_t = &(a); *_t = _mm256_xor_si256(*_t, (b)); }
#define BS_NOT(a)	_mm256_andnot_si256((a), BS_VAL8(ff))

// there is no intrinsic in sse for bitwise logical shift. See http://stackoverflow.com/questions/17610696/shift-a-m128i-of-n-bits
// _mm_slli_epi64 does not work!
// So a function is needed - unfortunately
dvbcsa_bs_word_t BS_SHL(dvbcsa_bs_word_t v, int n);
dvbcsa_bs_word_t BS_SHR(dvbcsa_bs_word_t v, int n);

#define BS_SHL8(a, n)	_mm256_slli_si256(a, n)
#define BS_SHR8(a, n)	_mm256_srli_si256(a, n)

#define BS_EXTRACT8(a, n) ((uint8_t*)&(a))[n]

static inline  BS_EXTLS32( __m256i a)
{
 __v8si b = (__v8si)a;
 return b[0];
}



#define BS_EMPTY()


#ifdef __SSE4_2__

#define CHECK_ZERO(a) _mm_testz_si128((a),(a))

#else

#define CHECK_ZERO(a) (_mm_movemask_epi8(_mm_cmpeq_epi32((a),_mm_setzero_si128())) == 0xFFFF)

#endif

#endif

