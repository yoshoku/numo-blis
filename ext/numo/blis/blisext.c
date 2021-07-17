#include <ruby.h>

VALUE mNumo;
VALUE mBLIS;

void Init_blisext()
{
  mNumo = rb_define_module("Numo");
  mBLIS = rb_define_module_under(mNumo, "BLIS");
  rb_define_const(mBLIS, "BLIS_VERSION", rb_str_new_cstr("0.8.1"));
}
