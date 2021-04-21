/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2020 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under BSD 3-Clause license,
  * the "License"; You may not use this file except in compliance with the
  * License. You may obtain a copy of the License at:
  *                        opensource.org/licenses/BSD-3-Clause
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "cmsis_os.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */
/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
TIM_HandleTypeDef htim2;

UART_HandleTypeDef huart3;

/* Definitions for cliTask */
osThreadId_t cliTaskHandle;
const osThreadAttr_t cliTask_attributes = {
  .name = "cliTask",
  .priority = (osPriority_t) osPriorityNormal,
  .stack_size = 128 * 4
};
/* Definitions for statusUpdate */
osThreadId_t statusUpdateHandle;
const osThreadAttr_t statusUpdate_attributes = {
  .name = "statusUpdate",
  .priority = (osPriority_t) osPriorityBelowNormal,
  .stack_size = 128 * 4
};
/* Definitions for stateController */
osThreadId_t stateControllerHandle;
const osThreadAttr_t stateController_attributes = {
  .name = "stateController",
  .priority = (osPriority_t) osPriorityAboveNormal,
  .stack_size = 128 * 4
};
/* Definitions for CLI_Queue */
osMessageQueueId_t CLI_QueueHandle;
const osMessageQueueAttr_t CLI_Queue_attributes = {
  .name = "CLI_Queue"
};
/* Definitions for Status_Queue */
osMessageQueueId_t Status_QueueHandle;
const osMessageQueueAttr_t Status_Queue_attributes = {
  .name = "Status_Queue"
};
/* Definitions for myTimer01 */
osTimerId_t myTimer01Handle;
const osTimerAttr_t myTimer01_attributes = {
  .name = "myTimer01"
};
/* USER CODE BEGIN PV */

const static char* ENTER_CMD = "Enter command or '?' to see available commands: ";

#define CLEAR "\x1b[2J"
#define RC(r,c) "\x1b[" #r ";" #c "f"
#define ROLL_TO_BOTTOM(r) "\x1b[" #r ";r"
#define SAVE_CURSOR "\x1b[s"
#define RESTORE_CURSOR "\x1b[u"
#define MAX_USER_INPUT  50
#define forward "\x1b[1C"

uint8_t cli_buffer_TX[MAX_USER_INPUT];
uint8_t cli_buffer_RX[MAX_USER_INPUT];
uint8_t cli_char_RX;
int counter = 0;

bool line_complete = false;
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_TIM2_Init(void);
static void MX_USART3_UART_Init(void);
void startcliTask(void *argument);
void updateTask(void *argument);
void controllerTask(void *argument);
void Callback01(void *argument);

/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_TIM2_Init();
  MX_USART3_UART_Init();

  /* USER CODE BEGIN 2 */
  HAL_GPIO_WritePin(GPIOA, GPIO_PIN_6, GPIO_PIN_SET);
  HAL_GPIO_WritePin(GPIOA, GPIO_PIN_7, GPIO_PIN_SET);
  HAL_GPIO_WritePin(GPIOA, GPIO_PIN_8, GPIO_PIN_SET);
  HAL_GPIO_WritePin(GPIOA, GPIO_PIN_9, GPIO_PIN_SET);
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_SET);
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_13, GPIO_PIN_SET);
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_14, GPIO_PIN_SET);
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_15, GPIO_PIN_SET);

      strcpy (cli_buffer_TX, "\x1b[2J");
      print_string_block("\x1b[2J");
      print_string_block(CLEAR);
      HAL_Delay(500);
      HAL_Delay(2000);
      print_string_block(CLEAR);
      print_string_block(RC(5,1));
      print_string_block(ROLL_TO_BOTTOM(5));
      print_string_block(RC(5,1));
      print_string_block(ENTER_CMD);
  /* USER CODE END 2 */

  /* Init scheduler */
  osKernelInitialize();

  /* USER CODE BEGIN RTOS_MUTEX */
  /* add mutexes, ... */
  /* USER CODE END RTOS_MUTEX */

  /* USER CODE BEGIN RTOS_SEMAPHORES */
  /* add semaphores, ... */
  /* USER CODE END RTOS_SEMAPHORES */

  /* Create the timer(s) */
  /* creation of myTimer01 */
  myTimer01Handle = osTimerNew(Callback01, osTimerPeriodic, NULL, &myTimer01_attributes);

  /* USER CODE BEGIN RTOS_TIMERS */
  /* start timers, add new ones, ... */
  /* USER CODE END RTOS_TIMERS */

  /* Create the queue(s) */
  /* creation of CLI_Queue */
  CLI_QueueHandle = osMessageQueueNew (1, sizeof(uint16_t), &CLI_Queue_attributes);

  /* creation of Status_Queue */
  Status_QueueHandle = osMessageQueueNew (1, sizeof(uint16_t), &Status_Queue_attributes);

  /* USER CODE BEGIN RTOS_QUEUES */
  /* add queues, ... */
  /* USER CODE END RTOS_QUEUES */

  /* Create the thread(s) */
  /* creation of cliTask */
  cliTaskHandle = osThreadNew(startcliTask, NULL, &cliTask_attributes);

  /* creation of statusUpdate */
  statusUpdateHandle = osThreadNew(updateTask, NULL, &statusUpdate_attributes);

  /* creation of stateController */
  stateControllerHandle = osThreadNew(controllerTask, NULL, &stateController_attributes);

  /* USER CODE BEGIN RTOS_THREADS */
  /* add threads, ... */
  /* USER CODE END RTOS_THREADS */

  /* Start scheduler */
  osKernelStart();

  /* We should never get here as control is now taken by the scheduler */
  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
  }
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_NONE;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }
  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSI;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_0) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief TIM2 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM2_Init(void)
{

  /* USER CODE BEGIN TIM2_Init 0 */

  /* USER CODE END TIM2_Init 0 */

  TIM_ClockConfigTypeDef sClockSourceConfig = {0};
  TIM_MasterConfigTypeDef sMasterConfig = {0};

  /* USER CODE BEGIN TIM2_Init 1 */

  /* USER CODE END TIM2_Init 1 */
  htim2.Instance = TIM2;
  htim2.Init.Prescaler = 4000-1;
  htim2.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim2.Init.Period = 1000-1;
  htim2.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim2.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
  if (HAL_TIM_Base_Init(&htim2) != HAL_OK)
  {
    Error_Handler();
  }
  sClockSourceConfig.ClockSource = TIM_CLOCKSOURCE_INTERNAL;
  if (HAL_TIM_ConfigClockSource(&htim2, &sClockSourceConfig) != HAL_OK)
  {
    Error_Handler();
  }
  sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
  sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
  if (HAL_TIMEx_MasterConfigSynchronization(&htim2, &sMasterConfig) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN TIM2_Init 2 */

  /* USER CODE END TIM2_Init 2 */

}

/**
  * @brief USART3 Initialization Function
  * @param None
  * @retval None
  */
static void MX_USART3_UART_Init(void)
{

  /* USER CODE BEGIN USART3_Init 0 */

  /* USER CODE END USART3_Init 0 */

  /* USER CODE BEGIN USART3_Init 1 */

  /* USER CODE END USART3_Init 1 */
  huart3.Instance = USART3;
  huart3.Init.BaudRate = 115200;
  huart3.Init.WordLength = UART_WORDLENGTH_8B;
  huart3.Init.StopBits = UART_STOPBITS_1;
  huart3.Init.Parity = UART_PARITY_NONE;
  huart3.Init.Mode = UART_MODE_TX_RX;
  huart3.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart3.Init.OverSampling = UART_OVERSAMPLING_16;
  if (HAL_UART_Init(&huart3) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN USART3_Init 2 */

  /* USER CODE END USART3_Init 2 */

}

/**
  * @brief GPIO Initialization Function
  * @param None
  * @retval None
  */
static void MX_GPIO_Init(void)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOA, GPIO_PIN_6|GPIO_PIN_7|GPIO_PIN_8|GPIO_PIN_9, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12|GPIO_PIN_13|GPIO_PIN_14|GPIO_PIN_15, GPIO_PIN_RESET);

  /*Configure GPIO pins : PA6 PA7 PA8 PA9 */
  GPIO_InitStruct.Pin = GPIO_PIN_6|GPIO_PIN_7|GPIO_PIN_8|GPIO_PIN_9;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

  /*Configure GPIO pins : PB12 PB13 PB14 PB15 */
  GPIO_InitStruct.Pin = GPIO_PIN_12|GPIO_PIN_13|GPIO_PIN_14|GPIO_PIN_15;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

}

/* USER CODE BEGIN 4 */
void print_string(const char* text)
{
    int i = 0;
    HAL_StatusTypeDef status_a;

    while(huart3.gState == HAL_UART_STATE_BUSY_TX){}

	for (const char* p = text; *p; ++p)
	{
    	cli_buffer_TX[i] =  *p;
    	i++;
    }

	status_a = HAL_UART_Transmit_IT(&huart3, cli_buffer_TX, i);

	if (status_a != HAL_OK)
	{
		Error_Handler();
	}
}

void print_string_block(const char* text)
{
    int i=0;
    HAL_StatusTypeDef status_a;

    while(huart3.gState == HAL_UART_STATE_BUSY_TX){}

	for (const char* p = text; *p; ++p)
	{
    	cli_buffer_TX[i] = *p;
    	i++;
    }

	status_a = HAL_UART_Transmit(&huart3, cli_buffer_TX, i, 1000);

	if (status_a != HAL_OK)
	{
		Error_Handler();
	}
}

void byte_send (char msgChar)
{
    while(huart3.gState == HAL_UART_STATE_BUSY_TX){}
	HAL_UART_Transmit(&huart3, &msgChar, 1,1000);
}

_Bool line_return (cli_buffer_RX, cli_char_RX)
{
	  char enter_char = '\r';
	  char text_1;
	  _Bool update = false;

	  byte_send(cli_char_RX);
	  text_1 = (char)cli_char_RX;

	  if(text_1 != enter_char)
	  {
		  update = false;
	  }

	  if(text_1 == enter_char)
	  {
		  update = true;
	  }

	 return update;
}

/* USER CODE END 4 */

/* USER CODE BEGIN Header_startcliTask */
/**
  * @brief  Function implementing the cliTask thread.
  * @param  argument: Not used
  * @retval None
  */
/* USER CODE END Header_startcliTask */

void startcliTask(void *argument)
{
  /* USER CODE BEGIN 5 */
	uint16_t update_text =1000;
	uint16_t value = 0;
	uint8_t accl_factor[5];

	char failsafe_mode[] = "fsmode";
	char static_mode[] = "scmode";
	char help[] = "?";
	char space = ' ';

  /* Infinite loop */
	while(1)
	{
	 if ((HAL_UART_Receive ( &huart3, &cli_char_RX, 1, 10) == HAL_OK))
	 {
		line_complete =  line_return (cli_buffer_RX, cli_char_RX);

		if(!line_complete)
		{
			cli_buffer_RX[strlen((char*) cli_buffer_RX)] = cli_char_RX;
		}

		if(line_complete)
		{
			if((strcmp((char*)cli_buffer_RX, (char*)failsafe_mode)) == 0)
			{
				update_text = 1111;
			}

			else if((strcmp((char*)cli_buffer_RX, (char*)static_mode)) == 0)
			{
				update_text = 2222;
			}

			else if((strcmp((char*)cli_buffer_RX, (char*)help)) == 0)
			{
				update_text = 4444;
			}

			else if(cli_buffer_RX[0] == 'a' && cli_buffer_RX[1] == 't' && cli_buffer_RX[2] == 'm' && cli_buffer_RX[3] == 'o' && cli_buffer_RX[4] == 'd' && cli_buffer_RX[5] == 'e')
			{
				if((char)cli_buffer_RX[6] == space)
				{
					for(int j = 0; j < (strlen((char*) cli_buffer_RX) - 7); j++)
					{
						accl_factor[j] =  cli_buffer_RX[j + 7];
					}

					value = atoi((char*)accl_factor);

					if((value <= 100) && (value > 0))
					{
						update_text = value;
					}

					else
					{
						update_text = 1010;
					}
				}

				else if((char)cli_buffer_RX[6] != space)
				{
					update_text = 1010;
				}
			}

			else
			{
				update_text = update_text;
			}

			memset(cli_buffer_RX, 0, sizeof(cli_buffer_RX));
			memset(accl_factor, 0, sizeof(accl_factor));

			print_string_block("\r\n");
			print_string_block(ENTER_CMD);

			if(osMessageQueuePut(CLI_QueueHandle, &update_text, 1U, 0U)!= osOK)
			{
			   Error_Handler();
			}
		 }
	 }
	 osDelay(50);
  }
  /* USER CODE END 5 */
}

/* USER CODE BEGIN Header_updateTask */
/**
* @brief Function implementing the statusUpdate thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_updateTask */
void updateTask(void *argument)
{
  /* USER CODE BEGIN updateTask */
	uint16_t status_text;
	uint16_t period;
	osStatus_t status;

  /* Infinite loop */
  for(;;)
  {
	  static char outstring[100];
	  status = osMessageQueueGet(Status_QueueHandle, &status_text, NULL, 0U );
	  if(status == osOK)
	  {
		  period = status_text;
	  }

	  print_string_block(SAVE_CURSOR);
	  print_string_block(RC(1,1));
	  RC(1,1);

	  if((period > 100) && (period < 0) && (period != 2222) && (period != 4444) && (period != 1111))
	  {
		  strcpy ( outstring, "Wrong command! Enter '?' to see available commands \r\n" );
	  }

	  else if((period == 4444))
	  {
		  strcpy ( outstring, "Enter 'fsmode' for failsafe mode, 'scmode' for static cycle mode & 'atmode #' for accelerated-time mode \r\n" );
	  }

	  else
	  {
		  snprintf(outstring, 100,"period:% 5d \r\n",period);
	  }

	  print_string_block(outstring);
	  print_string_block(RESTORE_CURSOR);

	  osDelay(50);
  }
  /* USER CODE END updateTask */
}

/* USER CODE BEGIN Header_controllerTask */
/**
* @brief Function implementing the stateController thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_controllerTask */
void controllerTask(void *argument)
{
  /* USER CODE BEGIN controllerTask */

		_Bool FS_MODE = true;
		_Bool SC_MODE = false;

		osStatus_t status;
		uint16_t count_time;
		uint16_t status_text;
	 	uint16_t update_text;
		uint16_t states = 0;
		uint16_t state_option = 0;
		uint16_t option = 1000;
		uint16_t period = 1000;

		HAL_TIM_Base_Start(&htim2);

	if(osMessageQueuePut(Status_QueueHandle, &status_text, 1U, 0U)!= osOK)
	  {
	    Error_Handler();
	  }

  /* Infinite loop */
  for(;;)
  {
		status = osMessageQueueGet(CLI_QueueHandle, &update_text, NULL, 0U );
		if(status == osOK)
		{
			period = update_text;
			status_text = update_text;

			if(osMessageQueuePut(Status_QueueHandle, &status_text, 1U, 0U)!= osOK)
		    {
			  Error_Handler();
			}

			if(update_text == 1111)
			{
				FS_MODE = true;
				SC_MODE = false;
				states = 0;
				HAL_GPIO_WritePin(GPIOA, GPIO_PIN_6, GPIO_PIN_SET);
				HAL_GPIO_WritePin(GPIOA, GPIO_PIN_7, GPIO_PIN_SET);
				HAL_GPIO_WritePin(GPIOA, GPIO_PIN_8, GPIO_PIN_SET);
				HAL_GPIO_WritePin(GPIOA, GPIO_PIN_9, GPIO_PIN_SET);
				HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_SET);
				HAL_GPIO_WritePin(GPIOB, GPIO_PIN_13, GPIO_PIN_SET);
				HAL_GPIO_WritePin(GPIOB, GPIO_PIN_14, GPIO_PIN_SET);
				HAL_GPIO_WritePin(GPIOB, GPIO_PIN_15, GPIO_PIN_SET);
			}

			else if(update_text == 2222)
			{
				FS_MODE = false;
				SC_MODE = true;
				state_option = 0;
				HAL_GPIO_WritePin(GPIOA, GPIO_PIN_6, GPIO_PIN_SET);
				HAL_GPIO_WritePin(GPIOA, GPIO_PIN_7, GPIO_PIN_SET);
				HAL_GPIO_WritePin(GPIOA, GPIO_PIN_8, GPIO_PIN_SET);
				HAL_GPIO_WritePin(GPIOA, GPIO_PIN_9, GPIO_PIN_SET);
				HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_SET);
				HAL_GPIO_WritePin(GPIOB, GPIO_PIN_13, GPIO_PIN_SET);
				HAL_GPIO_WritePin(GPIOB, GPIO_PIN_14, GPIO_PIN_SET);
				HAL_GPIO_WritePin(GPIOB, GPIO_PIN_15, GPIO_PIN_SET);
			}

			else if((period <= 100) && (period > 0))
			{
				option = 1000 / update_text;
			}

		}
		if(FS_MODE)
		{
			count_time =  __HAL_TIM_GET_COUNTER(&htim2);

			if(!(count_time % 1000))
			{
				HAL_GPIO_TogglePin(GPIOA, GPIO_PIN_6);
				HAL_GPIO_TogglePin(GPIOB, GPIO_PIN_12);
				while(!(__HAL_TIM_GET_COUNTER(&htim2) % 1000)){}
			}
		}

		if(SC_MODE)
		{
			count_time =  __HAL_TIM_GET_COUNTER(&htim2);

			if(!(count_time % option))
			{
				while(!(__HAL_TIM_GET_COUNTER(&htim2) % option)){}
				state_option++;

				if(state_option == 1)
				{
					states = 0;

					//ON - primary green, primary walk, secondary red
					//OFF - secondary green, secondary yellow, secondary walk
					HAL_GPIO_WritePin(GPIOA, GPIO_PIN_8, GPIO_PIN_RESET);
					HAL_GPIO_WritePin(GPIOA, GPIO_PIN_9, GPIO_PIN_RESET);
					HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_RESET);
					HAL_GPIO_WritePin(GPIOA, GPIO_PIN_6, GPIO_PIN_SET);
					HAL_GPIO_WritePin(GPIOB, GPIO_PIN_13, GPIO_PIN_SET);
					HAL_GPIO_WritePin(GPIOB, GPIO_PIN_15, GPIO_PIN_SET);
				}

				else if(state_option == 141)
				{
					states = 1;
				}

				else if (state_option == 167)
				{
					states = 0;

					//ON - primary yellow
					//OFF - primary green, primary walk
					HAL_GPIO_WritePin(GPIOA, GPIO_PIN_7, GPIO_PIN_RESET);
					HAL_GPIO_WritePin(GPIOA, GPIO_PIN_8, GPIO_PIN_SET);
					HAL_GPIO_WritePin(GPIOA, GPIO_PIN_9, GPIO_PIN_SET);
				}

				else if (state_option == 174)
				{
					//ON - primary red
					//OFF - primary yellow
					HAL_GPIO_WritePin(GPIOA, GPIO_PIN_6, GPIO_PIN_RESET);
					HAL_GPIO_WritePin(GPIOA, GPIO_PIN_7, GPIO_PIN_SET);
				}

				else if (state_option == 186)
				{
					//ON - secondary green, secondary walk
					//OFF - secondary red
					HAL_GPIO_WritePin(GPIOB, GPIO_PIN_14, GPIO_PIN_RESET);
					HAL_GPIO_WritePin(GPIOB, GPIO_PIN_15, GPIO_PIN_RESET);
					HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_SET);
				}

				else if(state_option == 226)
				{
					states = 2;
				}

				else if(state_option == 242)
				{
					states = 0;

					//ON - secondary yellow
					//OFF - secondary green
					HAL_GPIO_WritePin(GPIOB, GPIO_PIN_14, GPIO_PIN_SET);
					HAL_GPIO_WritePin(GPIOB, GPIO_PIN_13, GPIO_PIN_RESET);
				}

				else if(state_option == 249)
				{
					state_option = 0;
				}

				if (states == 1)
				{
					//TOGGLE - primary walk
					HAL_GPIO_TogglePin(GPIOA, GPIO_PIN_9);
				}

				else if (states == 2)
				{
					//TOGGLE - secondary walk
					HAL_GPIO_TogglePin(GPIOB, GPIO_PIN_15);
				}
			}
		}

	    osDelay(50);
  }
  /* USER CODE END controllerTask */
}

/* Callback01 function */
void Callback01(void *argument)
{
  /* USER CODE BEGIN Callback01 */
	//HAL_GPIO_TogglePin(GPIOA, GPIO_PIN_6);

  /* USER CODE END Callback01 */
}

/**
  * @brief  Period elapsed callback in non blocking mode
  * @note   This function is called  when TIM4 interrupt took place, inside
  * HAL_TIM_IRQHandler(). It makes a direct call to HAL_IncTick() to increment
  * a global variable "uwTick" used as application time base.
  * @param  htim : TIM handle
  * @retval None
  */
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
  /* USER CODE BEGIN Callback 0 */

  /* USER CODE END Callback 0 */
  if (htim->Instance == TIM4) {
    HAL_IncTick();
  }
  /* USER CODE BEGIN Callback 1 */

  /* USER CODE END Callback 1 */
}

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */

  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line num_1ber
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source num_1ber
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     tex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
