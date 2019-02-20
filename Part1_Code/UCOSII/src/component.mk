# *******************************************************************************
# *                                                                             *
# * License Agreement                                                           *
# *                                                                             *
# * Copyright (c) 2003 Altera Corporation, San Jose, California, USA.           *
# * All rights reserved.                                                        *
# *                                                                             *
# * Permission is hereby granted, free of charge, to any person obtaining a     *
# * copy of this software and associated documentation files (the "Software"),  *
# * to deal in the Software without restriction, including without limitation   *
# * the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
# * and/or sell copies of the Software, and to permit persons to whom the       *
# * Software is furnished to do so, subject to the following conditions:        *
# *                                                                             *
# * The above copyright notice and this permission notice shall be included in  *
# * all copies or substantial portions of the Software.                         *
# *                                                                             *
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
# * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
# * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
# * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
# * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
# * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
# * DEALINGS IN THE SOFTWARE.                                                   *
# *                                                                             *
# * This agreement shall be governed in all respects by the laws of the State   *
# * of California and by the laws of the United States of America.              *
# *                                                                             *
# * Altera does not recommend, suggest or require that this reference design    *
# * file be used in conjunction or combination with any other product.          *
# *******************************************************************************

# List all source files supplied by this component.

C_LIB_SRCS   += os_core.c \
                os_flag.c \
                os_mbox.c \
                os_mem.c \
                os_mutex.c \
                os_q.c \
                os_sem.c \
                os_task.c \
                os_time.c \
                os_tmr.c \
                os_dbg.c \
                alt_malloc_lock.c \
                alt_env_lock.c

ASM_LIB_SRCS +=

INCLUDE_PATH +=

license_reminders: ucosii_license_reminder

ucosii_license_reminder:
	@echo ============== Software License Reminder ===============
	@echo
	@echo uC/OS-II is provided in source form for FREE evaluation,
	@echo for educational use, or for peaceful research. If you
	@echo plan on using uC/OS-II in a commercial product you need
	@echo to contact Micrium to properly license its use in your
	@echo product. Micrium provides ALL the source code on the
	@echo Altera distribution for your convenience and to help you
	@echo experience uC/OS-II. The fact that the source is provided
	@echo does NOT mean that you can use it without paying a
	@echo licensing fee. Please help us continue to provide the
	@echo Embedded community with the finest software available.
	@echo Your honesty is greatly appreciated.
	@echo
	@echo Please contact:
	@echo
	@echo 	    M I C R I U M
	@echo 	 949 Crestview Circle
	@echo 	Weston,  FL 33327-1848
	@echo 		U.S.A.
	@echo
	@echo Phone : +1 954 217 2036
	@echo FAX   : +1 954 217 2037
	@echo WEB   : www.micrium.com
	@echo E-mail: Sales@Micrium.com
	@echo
	@echo ========================================================

.PHONY: ucosii_license_reminder

