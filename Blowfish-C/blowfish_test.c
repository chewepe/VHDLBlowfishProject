/*
blowfish_test.c:  Test file for blowfish.c

Copyright (C) 1997 by Paul Kocher

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.
This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.
You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

#include <stdio.h>
#include "blowfish.h"

void main(void) {
	//Input data line to then split into left and right

  uint32_t L = 0xA5A5A5A5, R = 0x01234567; //0x00000000
  BLOWFISH_CTX ctx;
  uint32_t keyarray[8] = { 0xDEADBEEF, 0x01234567, 0x89ABCDEF, 0xDEADBEEF };
  uint32_t keynum = 0xFFFFFFFF;//0xFFFFFFFF
  printf("The Key before_function should be %08lX\n", keyarray[3] );

  //Blowfish_Init (&ctx, (uint8_t *)"TESTKEY", 7);
  Blowfish_Init (&ctx, keyarray, 4);

  Blowfish_Encrypt(&ctx, &L, &R);
  printf("Encryption output: %08lX %08lX\n", (long unsigned int)L, (long unsigned int)R);
  if (L == 0xD7811DBDL && R == 0xDBB00D38L)
	  printf("Test encryption OK.\n");
  else
	  printf("Test encryption failed.\n");

  Blowfish_Decrypt(&ctx, &L, &R);
  printf(" Decryption output: %08lX %08lX\n", (long unsigned int)L, (long unsigned int)R);
  if (L == 0xA5A5A5A5 && R == 0x01234567)
  	  printf("Test decryption OK.\n");
  else
	  printf("Test decryption failed.\n");
}