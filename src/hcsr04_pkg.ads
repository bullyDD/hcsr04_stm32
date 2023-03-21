------------------------------------------------------------------------------
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of the copyright holder nor the names of its     --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
-------------------------------------------------------------------------------
-- Ultrasonic distance measurement principle                                --
--                                                                          --
-- Transmitter emits a 8 bursts of an directionnal 40 KHz.                  --
-- The velocity of the ultrasonic burst is 340 m/s in air.                  --
-- the distance can be calculated between the object and the transmitter    --
-- (D = C * T ) with D : distance; C : sound velocity; T: Time rate must be --
-- divided by 2.                                                            --
--                                                                          --
-- @param Trigger_Pin Digital pin that is used for controlling sensor       --
-- (output).                                                                --
-- @param Echo_Pin Digital pin that is used to get information from sensor  --
-- (input).                                                                 --
-- @param MaxDistanceCm Maximum distance sensor can measure, defaults to 4m --
-- for HC-SR04.                                                             --
-- @param MaxTimeoutMicroSec Single measurement will never take longer than -- 
-- whatever value you provide here. You might want to do this in order to   --
-- ensure your program is never blocked for longer than some specific time, --
-- since measurements are blocking. By default, there is no limit on time   --
-- (only on distance). By defining timeout, you are again limiting the      --
-- distance.                                                                --
------------------------------------------------------------------------------
with HAL.GPIO;
with STM32;

with STM32.Device;   use STM32.Device;
with STM32.GPIO;     use STM32.GPIO;

package Hcsr04_Pkg is

   pragma Elaborate_Body;
   --  Specification and primitives for ultrasonicDistanceSensor object
   type States is  (LOW, HIGH) with Size => 8;
   for  States use (LOW => 0, HIGH => 1);
   
   type Real is digits 8;
   type Long is range 0 .. (2**31);
   type Seconds_In_Day is range 0 .. 86_400;
   
   --  Task to retrieve distance from HCSR04 sensor every 10 ms;
   task type Distance;

   procedure HCSR04_New;
   function MeasureDistanceCm return Real;
   --  Return distance in Cm.
   --  Using the approximate formula 19.307°C results in roughly 343m/s 
   --  which is the commonly used value for air
   
   function  MeasureDistanceCm  (Temp : Real) return Real;
   --  Measure distance depend on temperature of the environment
   --  Temperature is in celsius.
   
   procedure Read_Mode;
   
private
   A : constant  := 0.03313;
   B : constant  := 0.0000606;
   
   Trigger_Pin   : GPIO_Point renames PG11;
   Echo_Pin      : GPIO_Point renames PA6;
   
   MaxDistanceCm : constant Real := 400.0;
   MinDistanceCm : constant Real := 2.0;
   
   MaxDistCm   : Real := MaxDistanceCm;
   MinDistCm   : Real := MinDistanceCm;
   MaxTimeOut  : Real := 0.0;
   
   procedure Initialize_HCSR04;

end Hcsr04_Pkg;
