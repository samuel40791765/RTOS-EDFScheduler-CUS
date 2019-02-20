#Modifying the kernel into an EDF Scheduler and adding a Constant Utilization Server for aperiodic tasks on the Nios II 12sp2.<br/>
Code only includes the basic OS Files of the RTOS System and the files I modified.<br/><br/>

PART 1 EDF Scheduler Implementation <br/>
1.	Implementation Description: <br/>
The main objective of this project is to implement an earliest deadline first (EDF) scheduler. After observing the structure of this code, I decided to implement my code within OS_SchedNew().
OS_SchedNew is used within OS_IntExit, OS_Start, and OS_Sched. OS_SchedNew is responsible for deciding which task to perform next, so I decided to rewrite the code within this function.
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic1.png)

(1)	Highest Priority Implementation <br/>
I noticed that OS_SchedNew gave a new value to OSPrioHighRdy each time it was used. I decided to give a new value to OSPrioHighRdy within this function. First we iterate through all of the TCBs within our OS. We check if the DEADLINE within each TCB, and save the TCB with the nearest deadline. We give OSPrioHighRdy the priority of the one we just saved.
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic2.png)
 

(2)	When Two or More Tasks have the Same Deadline <br/>
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic3.png)
The while loop I set up starts from the last task to the first task I inputted (loops from Task3 ~ Task 1 in this figure).
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic4.png)
With the line “ptcb->DEADLINE <= nearest”, I let the last task with the same deadline in the while loop be the next task to run (which is task 1 if all deadlines are the same).
In other words, I chose to use the first task I inputted as the prioritized task when two task deadlines were the same.

(3)	Problems that occurred <br/>
A circumstance with the scheduler that I didn’t encounter before was if the next task to run was the same task that was just finished (ex: Complete From Task(1,5)  Task(1,6)).
To fix this problem, I implemented an if statement to check if the delay time was 0.
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic5.png)
 


2.	Simulation Results <br/>
(1) Task Set 1: Task1(1,4); Task2(3,6); Task3(6,24) <br/>
In Task set 1, the EDF scheduler lets the tasks run smoothly in a pattern every 24 seconds. Task 1 allows just enough time for Task 3 to finish right before its deadline.
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic6.png)


 
(2) Task Set 2: Task1(1,3); Task2(2,8); Task3(4,15); Task4(5,20) <br/>
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic7.png)
In Task Set 2, Task4 misses its deadline by 1 tick. The main reason for this is probably because Task 1’s period is too short, and doesn’t allow enough time for other tasks to compute.

3.	Schedulability Analysis <br/>
EDF scheduler is a scheduler that can let most tasks meet its deadline. However, it requires longer periods of time to let the other tasks meet their deadline.
If the period of time for one task is too short, then its deadline will often be the nearest. When this happens, the other tasks won’t be computed long enough for them to meet their own deadline. An example of this is like Task Set 2. Task 1’s period is only 3, and its deadline is always about to arrive. This eventually leads to Task 4 failing to meet its deadline.

4.	Experience/Impression <br/>
This project let me understand the concept and shortcomings of the EDF scheduler more clearly. Simulating tasks and observing when the tasks would miss their deadline helped me recognize how to optimize the tasks to let them run smoothly within a EDF scheduler.
I feel like an EDF is able to accomplish meet task deadlines more efficiently than the rate-monotonic scheduler. The rate-monotonic gives priorities to task based on the shortest period. However, the rate-monotonic isn’t dynamic enough for longer period tasks to meet its deadline. EDF computes the most urgent task and lets tasks efficiently finish most of the time.
 
PART 2 Constant Utilization Server <br/>
1.	Implementation Description: <br/>
The main objective of this part is to implement a constant utilization server (CUS). After observing the structure of this code, I decided to implement my code within OSTimeTick()
OSTimeTick is run for each tick. I decided to implement my CUS decision making here, so I can check if a new task has arrived whenever I want to.
 
(1)	Information <br/>
First, I added the necessary information I needed for the aperiodic tasks. The information includes: <br/>
a)	The CUS server size of the aperiodic task <br/>
b)	The current number of the aperiodic task running <br/>
c)	An array of the arrival time for each aperiodic job <br/>
d)	An array of the actual arrival time for each aperiodic job (arrival time could be affected by a previous job’s deadline) <br/>
e)	An array of the computation time for each aperiodic job <br/>
f)	An array of the deadline for each aperiodic job <br/>
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic8.png)


(2)	Application Layer
I.	Main function information input <br/>
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic9.png)
 
a)	The array “arrive” is used to input the arrival time of each job. <br/>
b)	The array “deadline” is used to input the computation time of each job. <br/>
c)	“0.2” is the server size of the aperiodic task. <br/>
d)	“APERIODIC_TASK_NUM” is the number of aperiodic jobs that we expect to compute. <br/>

II.	Running the Aperiodic task <br/>
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic10.png) 
The aperiodic task is slightly different than a normal task. The new remaining time is not immediately given and is given when a new aperiodic job arrives.

(3)	OSTimeTick
I.	Deciding the appropriate way to set up an aperiodic job <br/>
Because my EDF implementation kept on considering the aperiodic task’s deadline (which it shouldn’t), I decided to suspend the aperiodic task when there were no job’s available. When a new job arrives, I immediately resume the aperiodic task.
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic11.png)
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic12.png)

II.	Deciding when to run a job <br/>
There were three main circumstances I considered. <br/>
A.	The first job arrives normally. <br/>
B.	A new job arrives before the previous job’s deadline. <br/>
C.	A new job arrives after the previous job’s deadline. <br/>

a)	The first job arrives normally. <br/>
This implementation is pretty straight forward. If the current time equals the first aperiodic job’s arrival time, then we resume the task. give the aperiodic task’s TCB the information necessary for this job, and calculate the deadline of the current job.
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic13.png)

b)	A new job arrives after the previous job’s deadline. <br/>
When an aperiodic job arrives after the first job, we start comparing its arrival time to the previous job’s deadline. If the arrival time is smaller than the previous job’s deadline, that means the aperiodic task is still delaying and we cannot run the new job immediately.
If the arrival time is after the previous job’s deadline, then we can run the job normally. If so, we resume the aperiodic task, apply the job’s information into the TCB and calculate the new deadline.
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic14.png)
 

c)	A new job arrives after the previous job’s deadline. <br/>
When an aperiodic job arrives after the first job, we start comparing its arrival time to the previous job’s deadline. If the arrival time is smaller than the previous job’s deadline, that means the aperiodic task is still delaying and we cannot run the new job immediately.
If this happens, we have to update the arrival time of the new job. We change the “actual arrival time” of the new job into the deadline of the previous aperiodic job. When the OS eventually reaches the previous job’s deadline, it simultaneously starts the new job’s computation. Once this happens, we apply the job’s information into the TCB and calculate the new deadline according to the new arrival time.
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic15.png)
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic16.png) 
 

2.	Simulation Results <br/>
(1)	Task Set 1: Task1(1,3); Task2(4,15); Task3(3,20) CUS Server: 1/4 Aperiodic Job: {arrival time, computation}, Job1: (1,5), (22,4) <br/>
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic17.png)
 
(2)	Task Set 1: Task1(2,5); Task2(1,10); Task3(6,20) CUS Server: 1/5 Aperiodic Job: {arrival time, computation}, Job1: (3,4), (15,3) <br/>
![alt text](https://raw.githubusercontent.com/samuel40791765/RTOS-EDFScheduler-CUS/master/projectimages/pic18.png)


3.	Experience/Impression <br/>
This project let me understand how to successfully implement aperiodic tasks. Basically an aperiodic task is a task that checks if a new job about to arrive at all times. Using the algorithm to compute the deadline of an aperiodic job paired with the EDF algorithm, I feel like this scheduler is able to meet task deadlines efficiently. As long as, the original task set is able to achieve its deadlines, the aperiodic task merely uses up the idling time to finish its tasks, and doesn’t affect the performance of the entire OS as much. This leads to many possibilities, as tasks can be run as aperiodic tasks, without having to be afraid of affecting the entire performance.
Over the course of this project, I felt I have attained an even better understanding and perspective of the EDF scheduler and CUS.
