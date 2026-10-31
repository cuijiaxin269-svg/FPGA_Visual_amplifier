#include "motion60_clip_spatial.h"
#include <math.h>
static const float even[5]={.0625f,.25f,.375f,.25f,.0625f};
static const float odd[5]={-.125f,-.25f,0,.25f,.125f};
static unsigned reflect(int x,unsigned n){return x<0?(unsigned)-x:(x>=(int)n?2*n-2-(unsigned)x:(unsigned)x);}
static void sep(const float *in,float *tmp,float *out,unsigned w,unsigned h,const float *kx,const float *ky){
 for(unsigned y=0;y<h;y++)for(unsigned x=0;x<w;x++){
  float v=0;for(int k=0;k<5;k++)v+=in[y*w+reflect((int)x+k-2,w)]*kx[k];tmp[y*w+x]=v;
 }
 for(unsigned y=0;y<h;y++)for(unsigned x=0;x<w;x++){
  float v=0;for(int k=0;k<5;k++)v+=tmp[reflect((int)y+k-2,h)*w+x]*ky[k];out[y*w+x]=v;
 }
}
static float up(const float *in,unsigned w,unsigned h,unsigned x,unsigned y){
 int ix=((int)x-1)/2,iy=((int)y-1)/2;
 float fx=(x&1)?.25f:.75f,fy=(y&1)?.25f:.75f;
 if(!x){ix=0;fx=0;}if(!y){iy=0;fy=0;}
 unsigned x0=(unsigned)ix,y0=(unsigned)iy,x1=x0+1<w?x0+1:x0,y1=y0+1<h?y0+1:y0;
 float a=in[y0*w+x0]*(1-fx)+in[y0*w+x1]*fx;
 float b=in[y1*w+x0]*(1-fx)+in[y1*w+x1]*fx;
 return a*(1-fy)+b*fy;
}
int motion_clip_decompose(const uint16_t *raw,unsigned w,unsigned h,motion_clip_spatial*s){
 if(w<64||h<64||w>1280||h>800||(w&7)||(h&7))return -1;
 for(unsigned i=0;i<w*h;i++)s->a[i]=(float)raw[i];
 for(unsigned level=0;level<3;level++){
  sep(s->a,s->tmp,s->b,w,h,even,even);
  unsigned nw=w/2,nh=h/2;
  for(unsigned y=0;y<nh;y++)for(unsigned x=0;x<nw;x++){
   unsigned i=2*y*w+2*x;
   s->next[y*nw+x]=((s->b[i]+s->b[i+1])+(s->b[i+w]+s->b[i+w+1]))*.25f;
  }
  for(unsigned y=0;y<h;y++)for(unsigned x=0;x<w;x++)s->band[level][y*w+x]=s->b[y*w+x]-up(s->next,nw,nh,x,y);
  for(unsigned i=0;i<nw*nh;i++)s->a[i]=s->next[i];
  w=nw;h=nh;
 }
 for(unsigned i=0;i<w*h;i++)s->residual[i]=s->a[i];
 return 0;
}
static void gradient(motion_clip_spatial*s,unsigned w,unsigned h,unsigned level){
 sep(s->band[level],s->tmp,s->a,w,h,odd,even);
 sep(s->band[level],s->tmp,s->b,w,h,even,odd);
}
void motion_clip_phase(motion_clip_spatial*s,unsigned w,unsigned h,unsigned level,float *phase){
 w>>=level;h>>=level;gradient(s,w,h,level);
 for(unsigned i=0;i<w*h;i++)phase[i]=atan2f(s->band[level][i],sqrtf(s->a[i]*s->a[i]+s->b[i]*s->b[i])+1e-6f);
}
void motion_clip_reconstruct(motion_clip_spatial*s,unsigned w,unsigned h,const float *delta[3],float alpha,uint16_t*out){
 const float *current=s->residual;
 for(int level=2;level>=0;level--){
  unsigned lw=w>>level,lh=h>>level;gradient(s,lw,lh,(unsigned)level);
  for(unsigned y=0;y<lh;y++)for(unsigned x=0;x<lw;x++){
   unsigned i=y*lw+x;float angle=alpha*delta[level][i];
   float radius=sqrtf(s->a[i]*s->a[i]+s->b[i]*s->b[i])+1e-6f;
   s->band[level][i]=s->band[level][i]*cosf(angle)+radius*sinf(angle)+up(current,lw/2,lh/2,x,y);
  }
  current=s->band[level];
 }
 for(unsigned i=0;i<w*h;i++){float v=current[i];out[i]=(uint16_t)(v<0?0:(v>1023?1023:v+.5f));}
}
