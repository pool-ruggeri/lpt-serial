README

here implemented a quick example to see whether it is working. useful to test mmbt-s device w/ matlab on new setup

But for the perfect use, do like the demo downloaded for psychopy: use flags to tell when the condition that needs to be met to onset the trigger.
To put it down (pin to 0) after xx ms, make sure that the condition pin to 0 is evaluated in the for loop of the image bein presented and that is executed if the pin was previosly activated AND xx ms have elapsed.
In kate's task, I haven't developed things with such detail (because we do connectivity over 3 secs). But for event related analyses, this might be key (i.e., avoid a pause between trigger on and trigger down) 


---> If you use the MMBTS in pulse mode, no need to think about resetting Pins to 0 !! So in this case, no headache with the above ! Indeed, it factory sets pins to 0 after 8 ms, which is great for any bioamp with a sampling rate > 250 Hz ! 