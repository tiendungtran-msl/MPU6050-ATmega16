#include "I2C.h"

void I2C_Init()            /* I2C initialize function */
{
    TWBR = BITRATE(TWSR=0x00);    /* Get bit rate register value by formula */
}

unsigned char I2C_Start_Wait(char write_address)
{
    unsigned char status;
    TWCR = (1<<TWSTA)|(1<<TWEN)|(1<<TWINT);     // Start_Enable_Interrupt
    while (!(TWCR & (1<<TWINT)));               // Doi den khi I2C thuc hien xong nhiem vu hien tai
    status = TWCR & 0xF8;                       // Doc trang thai (5 bit cao)
    if (status != 0x08) return 0;               // Dieu kien bat dau khong thanh cong
    TWDR = write_address;                       // Ghi SLA+W vao thanh ghi du lieu
    TWCR = (1<<TWEN)|(1<<TWINT);                // Bat TWI, xoa co ngat
    while (!(TWCR & (1<<TWINT)));               // Doi den khi ket thuc qua trinh
    status = TWSR & 0xF8;                       // Doc trang thai
    if (status == 0x18) return 1;               // Da nhan duoc xac nhan tu slave
    if (status == 0x20) return 2;               // Khong nhan duoc xac nhan tu slave
    else return 3;                              // Truyen loi
}

unsigned char I2C_Repeated_Start(char read_address) /* I2C repeated start function */
{
    unsigned char status;		
    TWCR = (1<<TWSTA)|(1<<TWEN)|(1<<TWINT); /* Start_Enable_Interrupt */
    while (!(TWCR & (1<<TWINT)));	        /* Doi */
    status = TWSR & 0xF8;		            /* Doc trang thai */
    if(status!=0x10) return 0;		        /* Kiem tra lap co loi hay khong */
    TWDR = read_address;		            /* Write SLA+R in TWI data register */
    TWCR = (1<<TWEN)|(1<<TWINT);	        /* Enable TWI and clear interrupt flag */
    while (!(TWCR & (1<<TWINT)));	        /* Wait until TWI finish its current job */
    status = TWSR & 0xF8;		            /* Read TWI status register */
    if (status == 0x40) return 1;		    /* Co xac nhan tu slave */
    if (status == 0x48) return 2;	        /* Khong co xac nhan tra ve */
    else return 3;                          /* Truyen loi */
}

unsigned char I2C_Write(char data)	    /* I2C write function */
{
    unsigned char status;		
    TWDR = data;			            /* Copy data in TWI data register */
    TWCR = (1<<TWEN)|(1<<TWINT);	    /* Enable TWI and clear interrupt flag */
    while (!(TWCR & (1<<TWINT)));	    /* Wait until TWI finish its current job */
    status = TWSR & 0xF8;		        /* Read TWI status register */
    if (status == 0x28)		            /* Check for data transmitted &ack received */
    return 0;			                /* Return 0 to indicate ack received */
    if (status == 0x30)		            /* Check for data transmitted & nack received */
    return 1;			                /* Return 1 to indicate nack received */
    else
    return 2;			                /* Else return 2 for data transmission failure */
} 

char I2C_Read_Ack()		                        /* I2C read ack function */
{
    TWCR=(1<<TWEN)|(1<<TWINT)|(1<<TWEA);        /* Enable TWI, generation of ack */
    while(!(TWCR&(1<<TWINT)));	                /* Wait until TWI finish its current job */
    return TWDR;			                    /* Return received data */
}                      

char I2C_Read_Nack()		    /* I2C read nack function */
{
    TWCR=(1<<TWEN)|(1<<TWINT);	/* Enable TWI and clear interrupt flag */
    while(!(TWCR&(1<<TWINT)));	/* Wait until TWI finish its current job */
    return TWDR;		        /* Return received data */
}

void I2C_Stop()			                        /* I2C stop function */
{
    TWCR=(1<<TWSTO)|(1<<TWINT)|(1<<TWEN);       /* Enable TWI, generate stop */
    while (TWCR & (1<<TWSTO));	                /* Wait until stop condition execution */
}

void I2C_Slave_Init(unsigned char slave_address)
{
    TWAR = slave_address;		            /* Assign Address in TWI address register */
    TWCR = (1<<TWEN)|(1<<TWEA)|(1<<TWINT);  /* Enable TWI, Enable ack generation */
}

unsigned char I2C_Slave_Listen()
{
    while(1)
    {
        unsigned char status;	
        while (!(TWCR & (1<<TWINT)));	    /* Wait to be addressed */
        status = TWSR & 0xF8;		        /* Read TWI status register */
        if(status==0x60||status==0x68)	    /* Own SLA+W received & ack returned */
        return 0;			                /* Return 0 to indicate ack returned */
        if(status==0xA8||status==0xB0)	    /* Own SLA+R received & ack returned */
        return 1;			                /* Return 1 to indicate ack returned */
        if(status==0x70||status==0x78)  	/* General call received & ack returned */
        return 2;			                /* Return 2 to indicate ack returned */
        else continue;		
    }
}

unsigned char I2C_Slave_Transmit(char data)
{
    unsigned char status;
    TWDR = data;			                /* Write data to TWDR to be transmitted */
    TWCR = (1<<TWEN)|(1<<TWINT)|(1<<TWEA);  /* Enable TWI & clear interrupt flag */
    while (!(TWCR & (1<<TWINT)));	        /* Wait until TWI finish its current job */
    status = TWSR & 0xF8;		            /* Read TWI status register */
    if(status == 0xA0)		                /* Check for STOP/REPEATED START received */
    {
        TWCR|=(1<<TWINT);	                /* Clear interrupt flag & return -1 */
        return -1;
    }
    if (status == 0xB8)		                /* Check for data transmitted & ack received */
        return 0;			                /* If yes then return 0 */
    if (status == 0xC0)		                /* Check for data transmitted & nack received */
    {
	    TWCR |= (1<<TWINT);	                /* Clear interrupt flag & return -2 */
	    return -2;
    }
    if (status == 0xC8)	                	/* Last byte transmitted with ack received */
        return -3;		                	/* If yes then return -3 */
    else return -4;
}

char I2C_Slave_Receive()
{
    unsigned char status;	
    TWCR = (1<<TWEN)|(1<<TWEA)|(1<<TWINT);  /* Enable TWI & generation of ack */
    while (!(TWCR & (1<<TWINT)));       	/* Wait until TWI finish its current job */
    status = TWSR & 0xF8;		            /* Read TWI status register */
    if (status==0x80||status==0x90)         /* Check for data received & ack returned */
    return TWDR;	                    	/* If yes then return received data */

/* Check for data received, nack returned & switched to not addressed slave mode */
    if (status==0x88||status==0x98)
    return TWDR;	                    	/* If yes then return received data */
    if (status==0xA0)           	    	/* Check wether STOP/REPEATED START */
    {
	    TWCR|=(1<<TWINT);               	/* Clear interrupt flag & return -1 */
	    return -1;
    }
    else return -2;		
}