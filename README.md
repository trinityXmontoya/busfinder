## Bus Finder

Looking for the best price on a bus ride?
Look no further! Just enter your departure and arrival city and get back a list of the cheapest ride options pulling from various sites!

**Note: Currently only for Boston<->NYC**

### Background
I found myself having 6-7 tabs open every time I wanted to find a bus from BOS<->NYC so I built this to make that process more efficient.

### TODOS
* cron job to run query for the next day daily to cache
* watir + phantomjs w bolt bus is so slow it times out


### Sources
* [GoToBus](gotobus.com)
* [Megabus](megabus.com)
* [PeterPan](https://peterpanbus.com)
* [LuckyStar](http://www.luckystarbus.com/)

Note: I made this before [Wanderu](https://www.wanderu.com/en/) was popular. They still do not include Chinatown bus schedules which are often the cheapest.
