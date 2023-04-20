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
-- (input).                                                                 --                                                              --
------------------------------------------------------------------------------
with Beta_Types;     use Beta_Types;
with STM32;

with STM32.Device;   use STM32.Device;
with STM32.GPIO;     use STM32.GPIO;
with STM32.Timers;   use STM32.Timers;
with STM32.PWM;      use STM32.PWM;

package Hcsr04 is

   pragma Elaborate_Body;
   procedure Initialize_Pins;
   procedure Initialize;
   procedure Set_Duty (Duty : STM32.PWM.Microseconds := UInt32 (0.01));
   function Is_Enabled return Boolean with 
     Post => Is_Enabled'Result = True,
     Inline;
   
private
   --  Trigger Pin
   Duty               : constant := 0.01;
   Trigger_PWM_Pin    : GPIO_Point renames PA0;
   Trigger_PWM_Timer  : Timer renames Timer_2;
   Trigger_PWM_Output : PWM_Modulator;
   Trigger_Output_AF  : constant STM32.GPIO_Alternate_Function :=
     GPIO_AF_TIM2_1;
   PWM_Frequency      : constant := 100_000;
   --  Echo Pin
   Echo_Pin           : GPIO_Point renames PA2;
   Echo_Pin_Timer     : Timer renames Timer_5;
end Hcsr04;
