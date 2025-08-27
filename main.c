/*******************************************************
Project : DO GOC NGHIENG BANG MPU6050, HIEN THI LEN LCD 16x02
Version : 1.0
Date    : 04/04/2024
Author  : Tran Tien Dung
Team    : Dung_Dong_Duc
*******************************************************/

#include "main.h"

unsigned long previous_time, current_time, eslapsed_time;

float AccX,AccY,AccZ,Gyro_x,Gyro_y,Gyro_z, Temp;

void MPU6050_Init()
{
    delay_ms(150);                                          /* Power up time >100ms */
    I2C_Start_Wait(0xD0);                                   /* Start with device write address */
    I2C_Write(SMPLRT_DIV);                                  /* Access to sample rate register */
    I2C_Write(0x07);                                        /* 1KHz sample rate */
    I2C_Stop();
    delay_ms(100);

    I2C_Start_Wait(0xD0);
    I2C_Write(PWR_MGMT_1);                                  /* Write to power management register */
    I2C_Write(0x01);                                        /* PLL with X axis gyroscope reference frequency */
    I2C_Stop();
    delay_ms(100);

    I2C_Start_Wait(0xD0);
    I2C_Write(CONFIG);                                      /* Write to Configuration register */
    I2C_Write(0x00);                                        /* Fs = 8KHz */
    I2C_Stop();
    delay_ms(100);

    I2C_Start_Wait(0xD0);
    I2C_Write(GYRO_CONFIG);                                 /* Write to Gyro configuration register */
    I2C_Write(0x18);                                        /* Full scale range +/- 2000 degree/C */
    I2C_Stop();
    delay_ms(100);

    I2C_Start_Wait(0xD0);
    I2C_Write(INT_ENABLE);                                  /* Write to interrupt enable register */
    I2C_Write(0x01);
    I2C_Stop();
    delay_ms(100);
}

void MPU_Start_Loc()
{
    I2C_Start_Wait(0xD0);                                   /* I2C start with device write address */
    I2C_Write(ACCEL_XOUT_H);                                /* Write start location address from where to read */
    I2C_Repeated_Start(0xD1);                               /* I2C start with device read address */
}

void Read_RawValue()
{
	MPU_Start_Loc();			                            /* Read Gyro values */
	AccX = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack());
	AccY = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack());
	AccZ = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack());
    Temp = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack());
	Gyro_x = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack());
	Gyro_y = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Ack());
	Gyro_z = (((int)I2C_Read_Ack()<<8) | (int)I2C_Read_Nack());
	I2C_Stop();
}

float Roll_Acc (float AccX, float AccY, float AccZ)
{
    float Roll_Acc;
    Roll_Acc = atan(AccY/sqrt(pow(AccX,2)+pow(AccZ,2)))*180/PI;
    return Roll_Acc;
}

float Pitch_Acc (float AccX, float AccY, float AccZ)
{
    float Pitch_Acc;
    Pitch_Acc = atan(-1*AccX/sqrt(pow(AccY,2)+pow(AccZ,2)))*180/PI;
    return Pitch_Acc;
}

float Angle_Gyr (float Gyro, float Acc)
{
    float Angle_Gyr = Acc, v;
    previous_time = current_time;
    current_time = millis();
    eslapsed_time = (float)((current_time - previous_time));
    v = (Gyro)/16.4;
    Angle_Gyr += v*eslapsed_time/1000;                      /*Fs_SEL = 1*/
    return Angle_Gyr;
}

void main()
{
    char buffer_X[5],buffer_Y[5]; //float_[10];
    float R_Acc, P_Acc, R_Gyr, P_Gyr, Roll, Pitch;
    previous_time = 0;
    current_time = 0;
    eslapsed_time = 0;
    I2C_Init();                                            /* Initialize I2C */
    MPU6050_Init();                                        /* Initialize MPU6050 */
    LCD_Init();
    LCD_String_xy(0,0,"Goc_Roll :");
    LCD_String_xy(1,0,"Goc_Pitch:");
    millis_setup();
    #asm("sei")

    while(1)
    {
        Read_RawValue();

        R_Acc = Roll_Acc(AccX, AccY, AccZ);
        P_Acc = Pitch_Acc(AccX, AccY, AccZ);

        R_Gyr = Angle_Gyr(Gyro_y, Roll);
        P_Gyr = Angle_Gyr(Gyro_x, Pitch);

        Roll = 0.3*R_Gyr + 0.7*R_Acc;
        Pitch = 0.3*P_Gyr + 0.7*P_Acc;

        sprintf(buffer_X,"%3d",(int)Pitch);
        sprintf(buffer_Y,"%3d",(int)Roll);

        LCD_String_xy(0,10,buffer_X);
        LCD_String_xy(1,10,buffer_Y);
	}
}
