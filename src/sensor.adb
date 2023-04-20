with Ada.Numerics.Float_Random;       use Ada.Numerics.Float_Random;
with Ada.Numerics.Long_Elementary_Functions;
use Ada.Numerics.Long_Elementary_Functions;

with Ada.Real_Time;              use Ada.Real_Time;
with Beta_Types;                 use Beta_Types;
with HAL.GPIO;
with HAL.SPI;
with LCD_Std_Out;                use LCD_Std_Out;
with STM32.GPIO;                 use STM32.GPIO;
with STM32.Device;               use STM32.Device;
with STM32.SPI;                  use STM32.SPI;

procedure Sensor is
   Trigger_Pin : GPIO_Point renames PD13;
   Echo_Pin    : GPIO_Point renames PD14;

   NumberOfMeasures : constant Natural := 5;
   MaxDistance      : constant Float := 400.0;

   Distance : Float := 0.0;
   Sum      : Float := 0.0;
   Mean     : Float;

   Port     : aliased Internal_SPI_Port;
   SPI_Inst : SPI_Port (Port'Access);

   --  SPI Mode 0 : CPOL = 0, CPHA = 0: CLK idle state = LOW.
   --  Data sampled on rising edge and shifted on falling edge
   SPI_Config : constant STM32.SPI.SPI_Configuration :=
     (D2Lines_FullDuplex, Master, HAL.SPI.Data_Size_8b, Low, P1Edge,
      Software_Managed, BRP_32, LSB, UInt16 (4));
begin

   Trigger_Pin.Set_Mode (Mode => HAL.GPIO.Output);
   Echo_Pin.Set_Mode (Mode => HAL.GPIO.Input);

   Configure (This => SPI_Inst,
              Conf => SPI_Config);

   for I in 1 .. NumberOfMeasures loop
      --  Send triggered signal

      Trigger_Pin.Drive (True);
      delay until Clock + Milliseconds (10);
      Trigger_Pin.Drive (False);

      --  Waiting for Sensor feedback
      --  TODO : THIS PEACE OF CODE IS WRONG
      --  while Echo_Pin.Set = False loop
      --     null;
      --  end loop;

      --  Measure time elapsed to get the answer
      declare
           Start_Time : constant Time := Clock;
           Period     : Duration;
           Stop_Time  : Time;
      begin
         --  while Echo_Pin.Set = True loop
         --       null;
         --  end loop;
         Stop_Time := Clock;
         Period := To_Duration (Stop_Time - Start_Time);

         Distance := Float (Period) * 0.0343 / 2.0;

         null;
      end;

      --  Add this dist
      Sum := Sum + Distance;
      --
      null;
   end loop;

   --  Calculate the mean of measurements
   Mean := Sum / Float (NumberOfMeasures);
   Clear_Screen;

   if Mean <= MaxDistance then
      Put_Line ("dist: " & Mean'Image & " cm");
   else
      Put_Line ("distance too far");
   end if;

   delay 1.0;
   Clear_Screen;

end Sensor;
