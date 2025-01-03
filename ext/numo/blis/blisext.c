/**
 * Numo::BLIS downloads and builds BLIS during installation and
 * uses that as a background library for Numo::Linalg.
 */

#include <ruby.h>

VALUE mNumo;
VALUE mBLIS;

void Init_blisext()
{
  /**
  * Document-module: Numo
  * Numo is the top level namespace of NUmerical MOdules for Ruby.
  */
  mNumo = rb_define_module("Numo");

  /**
   * Document-module: Numo::BLIS
   * Numo::BLIS loads Numo::NArray and Linalg with BLIS used as a backend library.
   */
  mBLIS = rb_define_module_under(mNumo, "BLIS");

  /* The version of BLIS used as a background library. */
  rb_define_const(mBLIS, "BLIS_VERSION", rb_str_new_cstr("1.0"));

  /* The version of LAPACK used as a background library. */
  rb_define_const(mBLIS, "LAPACK_VERSION", rb_str_new_cstr("3.11.0"));
}
