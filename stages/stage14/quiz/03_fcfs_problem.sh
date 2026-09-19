#!/usr/bin/env bash
QUESTION="What is the convoy effect, and which scheduling algorithm suffers from it?"
QUESTION_HINT="Picture a supermarket queue behind one very full trolley."
ANSWER_PATTERN="(fcfs|first come)|(long.*(job|process|task).*(block|wait|behind|delay))|(short.*(wait|behind|stuck))|convoy"
MODEL_ANSWER="The convoy effect is short jobs stuck behind a long one, inflating average
waiting time for everybody. It is the characteristic failure of FCFS, which runs
jobs in arrival order with no preemption.

In the simulation, job C needs one unit of CPU but does not finish until t=12,
because A arrived first and held the CPU for seven units. One long job punished
three short ones.

SJF fixes the average by running short jobs first, at the risk of starving long
ones. Round robin fixes the worst case by preempting, at the cost of a slightly
worse average. No algorithm wins on every measure - which is the actual point of
the question."
