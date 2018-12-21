defmodule Chord_Protocol do
	use GenServer

	def start_link(arguments) do
		{nodeID, _, _, _} = arguments
		GenServer.start_link(Chord_Protocol, arguments, name: :"#{nodeID}")
	end

	def init(arguments) do
		{nodeID, numRequests, numNodes, nodeList} = arguments
		updateTableRequest()
		maxPower = (:math.log(numNodes) / :math.log(2)) |> :math.ceil |> round
		fingerTable = Enum.map(0..maxPower-1, fn i ->
			successorNode = :math.pow(2, i) + nodeID |> round
			if(successorNode > numNodes) do
				rem(successorNode, numNodes)
			else
				successorNode
			end
		end)
		{:ok, {nodeID, numRequests, numNodes, fingerTable, nodeList}}
	end

	def handle_cast({:send, {successorNode, numHops}}, state) do
		{nodeID, _, numNodes, fingerTable, _} = state
		if(successorNode == nodeID) do
			GenServer.cast(ChordNetwork, {:msgSent, numHops})
		else
			newSuccessorNode = getSuccessorNode(successorNode, fingerTable)
			maxPower = (:math.log(numNodes) / :math.log(2)) |> :math.ceil |> round
			if(numHops <= maxPower) do
				GenServer.cast(String.to_atom("#{newSuccessorNode}"), {:send, {successorNode, numHops+1}})
			else
				GenServer.cast(ChordNetwork, {:msgSent, numHops})
			end
		end
		{:noreply, state}
	end

	def getSuccessorNode(successorNode, fingerTable) do
		if(Enum.member?(fingerTable, successorNode)) do
			successorNode
		else
			index = Enum.find_index(fingerTable, fn x-> x > successorNode end)
			if(index == nil) do
				[val|_]=Enum.reverse(fingerTable)
				val
			else
				Enum.at(fingerTable, index-1)
			end
		end
	end

	def handle_info(:requestCounter, state) do
		{nodeID, numRequests, numNodes, fingerTable, nodeList} = state
		if(numRequests == 0) do
			GenServer.cast(ChordNetwork, {:requestsCompleted, numNodes})
			{:noreply, state}
		else
			successorNode = Enum.random(1..numNodes)
			GenServer.cast(String.to_atom("#{nodeID}"), {:send, {successorNode, 0}})
			updateTableRequest()
			updatedState = {nodeID, numRequests-1, numNodes, fingerTable, nodeList}
			{:noreply, updatedState}
		end
	end

	defp updateTableRequest() do
		Process.send_after(self(), :requestCounter, 1000)
	end
end


defmodule Project3 do
	use GenServer

	def main(arguments) do
		{numNodes, numRequests} = {String.to_integer(Enum.at(arguments, 0)), String.to_integer(Enum.at(arguments, 1))}
		start(numNodes, numRequests, self())
		receive do
			:done ->
				:ok
			end
		end

	def start_link(arguments) do
		GenServer.start_link(Project3, arguments, name: ChordNetwork)
	end

	def init(arguments) do
		{initialPID, numNodes, numRequests} = arguments
		{:ok, {initialPID, numNodes, numRequests, 0}}
	end

  def start(numNodes, numRequests, pid) do
  	start_link({pid, numNodes, numRequests})
  	create_network(numNodes, numRequests)
  end

  def create_network(numNodes, numRequests) do
  	Enum.each(1..numNodes, fn _ -> :crypto.hash(:sha, "SHA-1")|> Base.encode16 end)
  	maxpower = (:math.log(numNodes) / :math.log(2)) |> :math.ceil
  	maxnodes = trunc(:math.pow(2, maxpower))
  	list2 = [numNodes, maxnodes]
  	[val|_] = list2
  	if(maxnodes > 0) do
  		nodeList = 1..val |> Enum.shuffle() 
  		nodeList = Enum.slice(nodeList, 0..numNodes-1) |> Enum.sort()
  		Enum.each(nodeList, fn nodeID ->
  			Chord_Protocol.start_link({nodeID, numRequests, numNodes, nodeList})
  		end)
  	end
  end

  def handle_cast({:msgSent, numHops}, state) do
  	{initialPID, numNodes, numRequests, hopsCounter} = state
  	updatedState = {initialPID, numNodes, numRequests, hopsCounter+numHops}
  	{:noreply, updatedState}
  end

  def handle_cast({:requestsCompleted, initialNodes}, state) do
  	{initialPID, numNodes, numRequests, hopsCounter} = state
  	nodesLeft = numNodes-1
  	if(nodesLeft == 0) do
  		averageHops = hopsCounter / (initialNodes*numRequests)
  		IO.puts("#{averageHops}")
  		send(initialPID, :done)
  		Process.exit(self(), :normal)
  	end
  	updatedState = {initialPID, nodesLeft, numRequests, hopsCounter}
  	{:noreply, updatedState}
  end
end