import networkx as nx
import random
import sys

def generate_random_graph(num_states):
    """
    Generate a random directed graph with states [0], [1], ..., [n-1].
    Starting from state [i], add at least 1 but at most 4 outgoing transitions,
    each with a distinct random label from {a, b, c, d}.

    :param num_states: Number of states in the graph.
    :return: A NetworkX directed graph with labeled edges.
    """
    if num_states < 2:
        raise ValueError("The graph must have at least 2 states.")

    labels = ['a', 'b', 'c', 'd']
    graph = nx.MultiDiGraph()

    # Add nodes to the graph
    graph.add_nodes_from(range(num_states))
    
    #
    start = 0
    end = random.randint(start, num_states)
    while end < num_states:  
        # Add outgoing transitions for each state [0] to [n-1]
        for state in range(start, end):
            possible_targets = [t for t in range(start, end)]
            num_transitions = random.randint(1, min(4, len(possible_targets)))
            possible_labels = labels.copy()
        
            for _ in range(num_transitions):
                target = random.choice(possible_targets)
                label = random.choice(possible_labels)
                graph.add_edge(state, target, label=label)
                possible_labels.remove(label)
        if start != 0:
             s = random.randint(0, start)
             t = random.randint(start, end)
             outgoing_edges = list(graph.out_edges(s, data=True))
             if outgoing_edges:
                 random_transition = random.choice(outgoing_edges)  # Randomly pick one edge
                 target_state = random_transition[1]  # The target state of the transition
                 label = random_transition[2].get('label', None)  # The label of the transition
                 remove_edge_multidigraph(graph, s, target_state, label)
                 graph.add_edge(s, t, label=label)
        start = end
        end = random.randint(end, num_states)
    return graph


def remove_edge_multidigraph(graph, source, target, label):
    """
    Remove an edge from a MultiDiGraph based on its source, target, and label.

    :param graph: A NetworkX MultiDiGraph.
    :param source: The source node of the edge to remove.
    :param target: The target node of the edge to remove.
    :param label: The label of the edge to remove.
    """
    if graph.has_edge(source, target):
        # Find all edges between source and target with the specified label
        edges_to_remove = [
            key for key, data in graph[source][target].items() if data.get('label') == label
        ]
        for key in edges_to_remove:
            graph.remove_edge(source, target, key)

def write_graph_to_file(graph, filename):
    """
    Write the graph to a text file in the specified format.

    :param graph: A NetworkX directed graph with labeled edges.
    :param filename: The name of the file to write to.
    """
    with open(filename, 'w') as file:
        file.write("[0]\n")
        for u, v, data in graph.edges(data=True):
            if 'label' in data:
                label = data['label']
                file.write(f"{label},[{u}]->[{v}]\n")

def analyze_graph(graph):
    """
    Analyze the graph to compute SCCs and non-trivial SCCs.

    :param graph: A NetworkX directed graph.
    :return: Tuple of total SCCs and non-trivial SCCs count.
    """
    sccs = list(nx.strongly_connected_components(graph))
    num_sccs = len(sccs)
    non_trivial_sccs = sum(1 for scc in sccs if len(scc) > 1)

    return num_sccs, non_trivial_sccs

def select_and_output_scc(graph, scc_groups, filename):
    """
    Select at least one non-trivial SCC and write the states to a file.

    :param graph: A NetworkX directed graph.
    :param scc_groups: List of SCCs (groups of states).
    :param filename: The name of the file to write to.
    """
    if len(scc_groups) == 1:
        selected_sccs = scc_groups  # Select the only SCC if it's the only one
    else:
        selected_sccs = [scc for scc in scc_groups if len(scc) > 1]

    with open(filename, 'a') as file:
        for scc in selected_sccs:
            for state in scc:
                file.write(f"[{state}]\n")

if __name__ == "__main__":
    # Check for the required command-line arguments
    if len(sys.argv) != 3:
        print("Usage: python generate_random_graph.py <number_of_states> <output_filename>")
        sys.exit(1)

    try:
        # Parse the number of states from the command line
        num_states = int(sys.argv[1])
        if num_states < 2:
            raise ValueError("The number of states must be at least 2.")
    except ValueError as e:
        print(f"Error: {e}")
        sys.exit(1)

    # Get the output file name from the second command-line argument
    output_file = sys.argv[2]

    # Generate the graph
    graph = generate_random_graph(num_states)

    # Write the graph to a file
    write_graph_to_file(graph, output_file)

    # Analyze the graph
    num_sccs, non_trivial_sccs = analyze_graph(graph)

    print(f"Graph transitions have been written to {output_file}.")
    print(f"The graph has {num_sccs} strongly connected component(s).")
    print(f"Number of non-trivial SCCs: {non_trivial_sccs}")

    # Select and output at least one non-trivial SCC
    select_and_output_scc(graph, list(nx.strongly_connected_components(graph)), output_file)