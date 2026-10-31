#ifndef MODE_BUTTON_H
#define MODE_BUTTON_H
#include <stdint.h>
// Timer units are the existing 400 MHz global timer. A held key never repeats.
// Require a stable release after boot, a capture restart, or a polling gap.
typedef struct {
 uint64_t sampled_at,changed_at;
 unsigned raw,stable,armed;
} mode_button;
static inline void mode_button_reset(mode_button *b,uint64_t now,unsigned high){
 b->sampled_at=b->changed_at=now;b->raw=high;b->stable=high;b->armed=0;
}
static inline unsigned mode_button_due(const mode_button *b,uint64_t now){
 return now-b->sampled_at>=400000u; // At most one GPIO read per millisecond.
}
static inline unsigned mode_button_sample(mode_button *b,uint64_t now,unsigned high){
 if(!mode_button_due(b,now))return 0;
 if(now-b->sampled_at>8000000u){mode_button_reset(b,now,high);return 0;}
 b->sampled_at=now;
 if(high!=b->raw){b->raw=high;b->changed_at=now;}
 if(now-b->changed_at<10000000u)return 0; // 25 ms stable in both directions.
 b->stable=high;
 if(high){b->armed=1;return 0;}
 if(!b->armed)return 0;
 b->armed=0;return 1;
}
#endif
