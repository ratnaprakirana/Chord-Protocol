<h3>Chord Protocol</h3>

<b>Distributed Operating Systems - COP5615</b>

<b>Group Members</b>
```
Ratna Prakirana (UFID 3663-9969)
Eesh Kant Joshi (UFID 1010-1069)
```
<b>Path to the running file</b>
```
project3/lib/project3.ex
```

<b>Execution command</b>
```
Command 1: mix escript.build
Command 2: escript project3 numNodes numRequests

eg: escript project3 5000 3
```

<b>Working</b>
```
Message delivered to all the nodes of the Chord protocol
```

<b>Largest Network</b>
```
15000 for no. of requests 2

possible to go even beyond but may take more time for the execution.

```

<b>PROJECT3 BONUS</b>
 <b>Path to the running file</b>
```
project3/lib/project3.ex
```

<b>Execution command</b>
```
Command 1: mix escript.build
Command 2: escript project3_bonus numNodes numRequests failureNodes

eg: escript project3 5000 3 750
```

<b>Working</b>
```
Message delivered to all the nodes of the Chord protocol
when the number of failure nodes are less than 15% of the total nodes.
```

<b>Largest Network</b>
```
10000 for no. of requests 2 and 15% failure nodes
possible to go even beyond but may take more time for the execution.
and the average hop count increases as % failure node increases.