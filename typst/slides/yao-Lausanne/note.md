# Yao talk

Hi, everyone. This is Jin-Guo Liu. Today I will introduce Yao.jl - a Julia package for quantum simulation, with a focus on its tensor network backend.

This talk contains the following four components.
First, I will introduce the features in Yao, especially the new features since the Yao paper.
Then I will show a few examples about how to fast proto-type your quantum program with Yao.
In the 3rd part, I will introduce the tensor network backend.
And finally, I will explain the tensor network contraction techniques that plays a central role.

Ok.
Yao means unitary. It is designed for quantum simulation. It is one of the earliest package that can simulate a quantum circuit in a differential style.
The reason why Roger and me, and also Lei Wang and Pan Zhang are interested in developing this tool is highly motivated by the need in the quantum simulation community. We need a tool simulate variational quantum algorithm, as well as a tool to optimize a pulses or gate parameters variationally.
So we started this project in 2018.
In the Yao paper, we released Yao at version 0.6. Except the feature of variational quantum simulation. Yao also supports operator airthmetics and matrix representation. Yao is also proud of its performance.

During the last 5 years, we have a continued input into this package.
It became the dependent of the Bloqade package, the neutral atoms array simulator in QuEra computing company. To support the new using cases, we extended the qubits to qudits, which means, the information unit of a quantum register is no longer limited to two-level systems.
Roger also implemented the simulation on a subset of the full Hilbert space to support the simulation on Bloqade subspaces in neutral atoms array.

On the other side, due to the emergent need of classical benchmarking quantum devices and quantum error correction. We added the tensor network backend and basic noise channel support to Yao as well.

Finally, I want to highlight a few community packages. One is the FLOYao, which implements match gate based exact simulation to Yao.
Another is QAOA.jl, a toolbox for quantum optimization.


In the following, let me introduce how to fast prototype with Yao.
In this example, I want to use one line to find the ground state of a Rydberg 1D chain. The Hamiltonian of a Rydberg 1D chain can be approximated as the PXP model. It is a Hamiltonian consists of three body terms. Each term is a Pauli X sandwiched by two zero-state projectors on its neighboring sites.
For simplicity, we use the periodic boundary condition.

To obtain the ground state of this toy Hamiltonian, we just need one line. Not including the line to import Yao and KrylovKit.
In the top level, we use KrylovKit.eigsolve to solve the ground state of a sparse matrix. Here, we are interested in obtaining single state, which is the one with the smallest real eigenvalue. The input matrix is Hermitian, which gives the solver a hint to use Lanczos iteration rather than the more general Anoldi iteration.
The `mat` function in Yao returns the sparse matrix representation of a quantum operator.
The quantum operator can be constructed by summing and multiplying operators.
No real allocation happens in the operator construction phase.
Here, we use the function `kron` to raise an operator to a larger Hilbert space.
At the lowest level, we make use of two predefined gates, one is P0, which is a projector to the zero state. It is defined in Yao.ConstGate, a module for constant gates.
The other is Pauli X gate.

In the following I will show another example of fast prototyping with Yao. That is simulating a quantum circuit with the tensor network backend of Yao.
Again, we only use a few lines to achieve the goal.
The goal is to simulate a product state goes into a quantum circuit, which is the quantum fourier transformation circuit in our case.
Then the quantity we want is the expectation value of an operator. Here, we set the operator to a Pauli string.

Ok, let us see how the QFT circuit looks like. The n qubit QFT circuit has roughly half of n^2 gates. They are either Hadamard gates or control phase gates.
To construct this circuit in Yao, we need just a single line.
In the out most layer, we use the chain function to stack the quantum gates into a circuit.
The quantum gates to be stacked has already been raised to the n-qubit Hilbert space with `put` or `control`.
The `put` is similar to `kron`, it can be more flexible to specify multi-qubit gates. Here, we can also use `kron`.
The `control` is similar to `put`, except taking an additional argument for control bit locations. It is a flexible interface, which supports both multi-control and inverse control.
At the lowest level, we have the phase shift gate.

A quantum circuit can be directly converted to a tensor network. Each quantum gate has its own tensor network representation. Here, we just show some examples.

The QFT circuit can be converted to a tensor network with a very similar topology. To get the expectation value, we just sandwich the operator with a quantum state and its hermitian conjugate. The tensor network diagram representation is as follows.

To construct this tensor network, we just need a single line.
At the top level, we have the `yao2einsum`, which takes a quantum circuit, an input state and an output state as inputs and convert it to a tensor network.
It also takes a keyword argument optimizer, which is for specifying the tensor network contraction order optimizer. The TreeSA is a state-of-the-art contraction order optimizer, which supports slicing to reduce the space cost.
We will go back to these optimizers later.
The Hermitian conjugate of a quantum circuit can be constructed by adding a single prime to it.

To contract this tensor network, we just call `contract` on it.
The time, space complexity as well as the read-write complexity of the contraction was printed in the previous screen. The time complexity counts the number of multiplication operations, the space complexity counts the number of elements in the largest tensor during contraction. And, the read-write complexity counts the number of element-wise read-write operations.

You may wonder that is happened under the hood, and what are the typical using cases of the tensor network backend.
In the following, I will have a brief introduction to the tensor network contraction technique.
The tensor network in this talk, is the same as the einsum in numpy. Both are defined as a sum over the product of tensor elements.
Regarding the fact that the multiplications are communicative, and the addition and multiplications are distributive. We can evaluate the contraction of a tensor network in different ways.
The study of optimizing the way to exactly evaluate a tensor network is known as the contraction order optimization.
A contraction order can be specified by a binary tree, each time we take two tensors from the tensor pool, contract, and merge into a new tensor.
Different contraction order gives different complexity.
The optimal contraction order can not be found in polynomial time using existing methods.
This task belongs to the NP-complete category.
The optimal space complexity of tensor contraction is determined by the tree width of a graph topology. It is a quantity that measures how close a graph is to a tree. The smaller, the more similar. For example, the tree graph has the smallest treewidth 1. For grid graphs, the treewidth is propotional to the length of one of its axes.
Both are very suited for tensor networks to simulate.
A relatively harder graph is the 3-regular graph. Although it is very sparse, it is very high dimensional. Its treewidth grows linearly w.r.t. the number of vertices n.
Users do not need to worry about the details of the tensor network contraction optimization too much. In the past 5 years, quantum information scientists made remarkable progress in tensor network contraction optimization algorithms. Maybe of them has already been implemented in a Julia package called OMEinsum. It is involved in two seasons of Google summer of code projects.
Although finding provable optimal contraction order is still hard. We have many heuristic algorithms that can give us a close to optimal contraction order.
Typically, the longer it takes to optimize the contraction order, the better contraction performance you will get.
Most algorithm in this plot, including greedy, bipartition, local search and positive instance driven methods can handle more than 10k tensors.
The provable optimal methods, such as the exact tree-width method, or the state compression method that Jutho implemented in his TensorOperations.jl, requires exponential long time. The number of tensor these methods can handle is usually limited to approximately 50.

So, the tensor network method is suited for graphs with small tree-widths, such as shallow quantum circuits.
It is general-purposed, and can handle not only the expectation values, but also the sampling tasks.
Moreover, it can be extended to noisy quantum systems.

The limitation is, when handling deep circuits, the tensor network backend does not show advantage over exact simulation.

As an application, we used this backend to study the coherent errors. Since in this application, the tensor network turns out to have much lower treewidth than the number of qubits.

To summarize, Yao is an excellent utility for fast prototyping. If you also want to become a quantum onliner, use Yao!