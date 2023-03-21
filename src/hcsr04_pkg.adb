--  with Ada.Calendar; use Ada.Calendar;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Unchecked_Conversion;

with Beta_Types;     use Beta_Types;
with LCD_Std_Out;    use LCD_Std_Out;

package body Hcsr04_Pkg is  
   ---------------------
   -- To_Microseconds --
   ---------------------
   function To_Microseconds (T : Real) return Real is
      (T / 0.000002);
   ----------------------------
   -- From_Time to duration  --
   ----------------------------
   function From_Time (This : Ada.Real_Time.Time) return Duration is
      TS : Ada.Real_Time.Time_Span;
      MS : Ada.Real_Time.Seconds_Count;
   begin
      Ada.Real_Time.Split (T  => This, SC => MS, TS => TS);
      return Ada.Real_Time.To_Duration (TS => TS);
   end From_Time;
   ----------------------------------------------------------------
   -- Sensor_Reading                                             --
   -- Subprogram take from Ada for embedded system by Pat Rogers --
   -- Help to validate state of pin before used the returned val --
   ----------------------------------------------------------------
   function Sensor_Reading (Default : States) return States is
      function As_Toggle_States is new Ada.Unchecked_Conversion 
        (Source => UInt8, Target => States);
      Result : States;
      Sensor : UInt8;
      pragma Unreferenced (Sensor);
   begin
      Result := As_Toggle_States (Sensor);
      return (if Result'Valid then Result else Default);
   end Sensor_Reading;
   ----------------------------------------------
   -- PulseIn:                                 --
   -- Measure the length of signal (This),     --
   -- which is equal to the MaxDuration        --
   -- for sound to go there and back           --
   -----------------------------------------------
   function PulseIn (This : in out GPIO_Point; State : States; TimeOut : Real)
                     return Real is
      PinState  : Boolean := STM32.GPIO.Set (This => This);
      StateMask : Boolean;
      Width     : Real := 0.0;
      NumLoops  : Long := 0;
      MaxLoops  : Long := 0;
   begin
      return Real (0.0);
   end PulseIn;
   -------------
   -- Minimum --
   -------------
   function Min (D1 : Real; D2 : Real) return Real is
   begin
      return (if D1 < D2 then D1 else D2);
   end Min;
   ---------------
   -- Read_Mode --
   ---------------
   procedure Read_Mode is
   begin
      Put_Line ("Trigger pin :" & 
                  HAL.GPIO.GPIO_Mode'Image (Mode (This => Trigger_Pin)));
      Put_Line ("Echo pin : " & 
                  HAL.GPIO.GPIO_Mode'Image (Mode (This => Echo_Pin)));
      delay 1.0;
      Clear_Screen;
   end Read_Mode;
   --------------------------------
   --  Initialize_HCSR04         --
   --  Echo pin params:          --
   --  @Mode : Input             --
   --  Trigger Pin params        --
   --  @Mode : Output            --
   --  @Speed : High speed       --
   --  @Output_Type : Push_Pull  --
   --------------------------------
   procedure Initialize_HCSR04 is
      Pin_Mode : GPIO_Port_Configuration (Mode_Out);
      --  Define Output config mode for Trigger pin
   begin
      Put_Line ("HCSR04 initialization...");
      delay 0.5;
      Clear_Screen;
      --  Configure Echo Pin
      Set_Mode (This => Echo_Pin,
                Mode => HAL.GPIO.Input);
      Enable_Clock (Point => Echo_Pin);
      --  Configure Trigger Pin
      Pin_Mode.Output_Type := Push_Pull;
      Pin_Mode.Speed := Speed_High;
      Enable_Clock (Point => Trigger_Pin);
      Configure_IO (This  => Trigger_Pin,  Config => Pin_Mode);
      Put_Line ("Initialization finished ...");
      delay 0.5;
      Clear_Screen;
   end Initialize_HCSR04;
   ----------------
   -- HCSR04_New --
   ----------------
   procedure HCSR04_New is
   begin
      Initialize_HCSR04;
      Read_Mode;
   end HCSR04_New;
   --------------------------------------------
   -- MeasureDistanceCm based on temperature --
   --------------------------------------------
   function MeasureDistanceCm (Temp : Real) return Real is
      Pin_State : Boolean;
   begin
      Pin_State := Set (This => Trigger_Pin);
      Clear_Screen;
      Put_Line  (" Within MeasureDistance");
      delay 0.5;
      Clear_Screen;
      Put_Line  (" State= " & Pin_State'Image);
      delay 0.5;
      Clear_Screen;
      Toggle (This => Trigger_Pin);
      delay 0.0000100;
      Pin_State := Set (This => Trigger_Pin);
      Put_Line  (" State= " & Pin_State'Image);
      delay 0.5;
      Clear_Screen;
      return Real (0.0);
   end MeasureDistanceCm;
   -----------------------
   -- MeasureDistanceCm --
   -----------------------
   function MeasureDistanceCm return Real is
     (MeasureDistanceCm (Temp => 19.307));
   -----------------------
   -- Get_Distance task --
   -----------------------
   task body Distance is
      Period : constant Ada.Real_Time.Time_Span := 
        Ada.Real_Time.Milliseconds (10);
      Next : Ada.Real_Time.Time := Ada.Real_Time.Clock;
   begin
      Clear_Screen;
      Put_Line ("Meausre distance in CM");
      Next := Next + Period;
      delay until Next;
      Put_Line ("D = " & Real'Image (MeasureDistanceCm) & " cm");
      Clear_Screen;
   end Distance;
   --  End task
begin
   HCSR04_New;
end Hcsr04_Pkg;
