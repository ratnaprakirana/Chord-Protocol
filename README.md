# Chord-Protocol
 Projects      Edit project Chord Peer-to-Peer Network Protocol  Project name Chord Peer-to-Peer Network Protocol  Nov 2018 – Nov 2018  Project description Chord is a protocol and algorithm for a peer-to-peer distributed hash table. A distributed hash table stores key-value pairs by assigning keys to different computers (known as "nodes"); a node will store the values for all the keys for which it is responsible. Chord specifies how keys are assigned to nodes, and how a node can discover the value for a given key by first locating the node responsible for that key. The SHA-1 algorithm is the base hashing function for consistent hashing
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
