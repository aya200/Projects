################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include Drivers/STM32F1xx_HAL_Driver/Src/subdir.mk
-include Core/Startup/subdir.mk
-include Core/Src/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
EXECUTABLES += \
UVC_Sensor_System.elf \

SIZE_OUTPUT += \
default.size.stdout \

OBJDUMP_LIST += \
UVC_Sensor_System.list \

OBJCOPY_BIN += \
UVC_Sensor_System.bin \


# All Target
all: UVC_Sensor_System.elf secondary-outputs

# Tool invocations
UVC_Sensor_System.elf: $(OBJS) $(USER_OBJS) C:\Engineering\Capstone\UVC\ Sensor\ System\UVC_Sensor_System\STM32F103RBHX_FLASH.ld
	arm-none-eabi-gcc -o "UVC_Sensor_System.elf" @"objects.list" $(USER_OBJS) $(LIBS) -mcpu=cortex-m3 -T"C:\Engineering\Capstone\UVC Sensor System\UVC_Sensor_System\STM32F103RBHX_FLASH.ld" --specs=nosys.specs -Wl,-Map="UVC_Sensor_System.map" -Wl,--gc-sections -static --specs=nano.specs -mfloat-abi=soft -mthumb -Wl,--start-group -lc -lm -Wl,--end-group
	@echo 'Finished building target: $@'
	@echo ' '

default.size.stdout: $(EXECUTABLES)
	arm-none-eabi-size  $(EXECUTABLES)
	@echo 'Finished building: $@'
	@echo ' '

UVC_Sensor_System.list: $(EXECUTABLES)
	arm-none-eabi-objdump -h -S $(EXECUTABLES) > "UVC_Sensor_System.list"
	@echo 'Finished building: $@'
	@echo ' '

UVC_Sensor_System.bin: $(EXECUTABLES)
	arm-none-eabi-objcopy  -O binary $(EXECUTABLES) "UVC_Sensor_System.bin"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) *
	-@echo ' '

secondary-outputs: $(SIZE_OUTPUT) $(OBJDUMP_LIST) $(OBJCOPY_BIN)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
