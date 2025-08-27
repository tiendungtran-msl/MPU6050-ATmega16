#ifndef _LCD_LIB_H_
#define _LCD_LIB_H_

#include "main.h"

void LCD_Cmd(unsigned char cmd);

void LCD_Init();

void LCD_Char(unsigned char data); // in ki tu

void LCD_String(char *str);  // in chuoi

void LCD_String_xy(char row, char pos, char *str); // set vi tri

void LCD_Clear();

void LCD_Roll_Right(unsigned char times_roll);

#endif

