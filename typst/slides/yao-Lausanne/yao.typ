#import "@preview/touying:0.6.1": *
#import "@preview/touying-simpl-hkustgz:0.1.2": *
#import "@preview/cetz:0.4.1": canvas, draw, tree
#import "@preview/cetz-plot:0.1.2": plot
#import "@preview/quill:0.7.1": *
#import "@preview/physica:0.9.5": *
#import "@preview/pinit:0.2.2": *
#import "@preview/colorful-boxes:1.4.3": *

#set cite(style: "apa")

#let ket(x) = $|#x angle.r$
#let globalvars = state("t", 0)
#let timecounter(minutes) = [
  #globalvars.update(t => t + minutes)
  #place(dx: 100%, dy: 0%, align(right, text(16pt, red)[#context globalvars.get()min]))
]
#let clip(image, top: 0pt, bottom: 0pt, left: 0pt, right: 0pt) = {
  box(clip: true, image, inset: (top: -top, right: -right, left: -left, bottom: -bottom))
}
#let qft-circuit() = {
  quantum-circuit(
  scale: 125%,
  row-spacing: 5pt,
  column-spacing: 8pt,
  lstick($|j_1〉$), $H$, $R_2$, $R_3$, $R_4$, 8, rstick($$),[\ ],
  lstick($|j_2〉$), 1, ctrl(-1), 2, $H$, $R_2$, $R_3$, 3, rstick($$), [\ ],
  lstick($|j_3〉$), 2, ctrl(-2), 2, ctrl(-1), 1, $H$, $R_2$, 1, rstick($$), [\ ],
  lstick($|j_4〉$), 3, ctrl(-3), 2, ctrl(-2), 1, ctrl(-1), $H$, rstick($$)
)
}

#show raw.where(block: true): it=>{
  par(justify:false,block(fill:rgb("#f0f0fe"),inset:1.5em,width:99%,text(it, 14pt)))
}

#let tensor(location, name, label) = {
  import draw: *
  circle(location, radius: 12pt, name: name)
  content((), text(black, label))
}
#let leftleg(node, distance: 1) = {
  import draw: *
  line(node, (rel: (-distance, 0), to: node))
}
#let rightleg(node, distance: 1) = {
  import draw: *
  line(node, (rel: (distance, 0), to: node))
}

#let labelnode(loc, label) = {
  import draw: *
  content(loc, [$#label$], align: center, fill:white, frame:"rect", padding:0.12, stroke: none, name: label)
}
#let codebox(txt, width: auto) = {
  box(inset: 10pt, stroke: blue.lighten(70%), radius:4pt, fill: blue.transparentize(90%), text(14pt, txt), width: width)
}

#let demo() = {
  import draw: *
  labelnode((0, 0), "a")
  labelnode((0, 3), "b")
  labelnode((3, 0), "d")
  labelnode((3, 3), "c")
  labelnode((5, 1.5), "e")
  tensor((0, 1.5), "A", [])
  tensor((1.5, 0), "B", [])
  tensor((1.5, 1.5), "C", [])
  tensor((3, 1.5), "D", [])
  tensor((1.5, 3), "E", [])
  tensor((4, 0.75), "F", [])
  for (a, b) in (
    ("a", "A"),
    ("b", "A"),
    ("a", "B"),
    ("d", "B"),
    ("a", "C"),
    ("c", "C"),
    ("c", "D"),
    ("d", "D"),
    ("b", "E"),
    ("c", "E"),
    ("d", "F"),
    ("e", "F"),
    ) {
    line(a, b)
  }
}


// Global information configuration
#show: hkustgz-theme.with(
  config-info(
    title: [Tensor network based quantum simulation with Yao.jl],
    subtitle: [(\@ Lausanne)],
    author: [Jin-Guo Liu (GiggleLiu)],
    date: datetime.today(),
    institution: [HKUST(GZ) - FUNH - Advanced Materials Thrust],
  ),
)

#title-slide()
#outline-slide()

= Yao \@ v0.9 - What's new?

== Yao.jl - a Julia package for quantum simulation
#timecounter(2)

#grid(image("images/logo.png", width: 80pt), text(36pt, weight: "bold")[Yao.jl (幺 - means unitary)], columns: 2, gutter: 20pt)
- One of the first quantum simulators dedicated to *differentiable quantum simulation* @Luo2020.
   - Simulation of variational quantum algorithms, e.g. quantum machine learning @Mitarai2018, variational quantum eigensolver @Tilly2022, quantum circuit Born machine @Liu2018 et al.
   - Quantum control, e.g. design control pulses.


#grid(image("images/roger.png", width: 50pt), [Xiu-Zhe Luo,],
clip(image("images/jinguoliu.jpg", width: 50pt), bottom: 25pt), [Jin-Guo Liu,], [Lei Wang and Pan Zhang \@ 2018], columns: 5, gutter: 20pt)

== Yao.jl features in v0.6
#timecounter(2)
#grid(box(width: 250pt)[=== Features in v0.6
- Differentiable quantum circuit
- Matrix representation
- Operator arithmetics #v(20pt)
- State-of-the-art performance
- GPU backend
],
clip(image("images/yaoframework.svg", width: 500pt), top: 0pt, bottom: 100pt), columns: 2, gutter: 0pt)
#place(clip(image("images/benchmark.svg", width: 300pt), top: 90pt, right: 150pt), dx: 75%, dy: -80pt)

== v0.6-v0.9, the updates
#timecounter(2)
=== 1. Bloqade.jl \@ QuEraComputing
#link("https://github.com/QuEraComputing/Bloqade.jl")[Bloqade.jl] is a package for the quantum computation and quantum simulation based on the neutral-atom architecture.
- Extended qubit to *qudit* simulation.
- Allows simulation in a *subspace* of the Hilbert space.

=== 2. Classical benchmarking quantum circuits & Quantum error correction
- #highlight[Tensor network backend].
- Basic noise channel and density matrix simulation.

=== 3. Community packages include:
- #link("https://github.com/QuantumBFS/FLOYao.jl")[FLOYao.jl]: A fermionic linear optics simulator backend for Yao.jl (Jan Lukas Bosse et al)
- #link("https://github.com/FZJ-PGI-12/QAOA.jl")[QAOA.jl]: This package implements the Quantum Approximate Optimization Algorithm and the Mean-Field Approximate Optimization Algorithm.


= Fast prototyping with Yao.jl
== Finding the ground state of a Rydberg PXP chain.
#timecounter(2)

The Hamiltonian of a Rydberg PXP chain is given by
$
H = sum_(i=1)^(n) P_(i-1) X_i P_(i+1)
$
where $P_i = |0〉_i〈0|_i$ is a projector to state $|0〉_i$, and $X$ is the Pauli-X operator. Periodic boundary condition is applied, i.e. $0=n$.

== One line for solving the ground state
#timecounter(4)
```julia
julia> using Yao, KrylovKit

julia> @time eigsolve(mat(sum([kron(20, mod1(i-1, 20)=>ConstGate.P0, i=>X, mod1(i+1, 20)=>ConstGate.P0) for i in 1:20])), 1, :SR; ishermitian=true);
  5.259707 seconds (74.84 k allocations: 5.315 GiB, 18.48% gc time, 0.57% compilation time)
```

- `KrylovKit.eigsolve(m, 1, :SR; ishermitian=true)` finds the lowest 1 eigenvalue and eigenvector of a Hermitian matrix $m$. `KrylovKit` is also the time evolution backend for Yao.
- `mat(op)` converts an operator to a sparse matrix.
- `kron(n, pairs...)` raises an operator to a larger Hilbert space,
- $P_0 = mat(1, 0; 0, 0), X = mat(0, 1; 1, 0)$,

= Tensor network based quantum simulation

== A minimum example
#timecounter(2)

- A product state $ket(j_1) times.circle ket(j_2) times.circle ... times.circle ket(j_n)$ as input,
- Goes through a shallow quantum circuit, here we use a quantum Fourier transform (QFT) circuit 
- Q: What is the expectation value of a given observable, e.g. a product of Pauli operators $P_1 times.circle P_2 times.circle ... times.circle P_n$, where $P_i in {I, X, Y, Z}$.

== Step 1. Create the quantum Fourier transform (QFT) circuit.
#timecounter(2)

#align(center, qft-circuit())

$H = 1/sqrt(2) mat(1, 1; 1, -1)$ is a Hadamard gate, $"CR"_k = mat(1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, e^(i pi / 2^(k-1)))$ is a controlled phase gate.

== One line for creating a QFT circuit
#timecounter(2)
```julia
julia> qft = chain(4, chain(4, i==j ? put(i=>H) : control(4, i, j=>shift(2π/(2^(j-i+1)))) for j in i:4) for i = 1:4)
```
- `chain(n, gates...)` creates a $n$-qubit circuit by concatenating the gates.
- `put(n, loc=>op)` raises an operator to an $n$-qubit Hilbert space.
- `control(n, ctrl_locs, target_loc=>op)` creates a controlled operator in an $n$-qubit Hilbert space.
- `shift(`$θ$`)`$ = mat(1, 0; 0, e^(i theta))$ is a phase shift gate.

== Step 2. Convert a quantum circuit to a tensor network
#timecounter(1)
#align(center, canvas({
  import draw: *
  content((0, 0), [#quantum-circuit(scale: 200%, lstick([]), $H$, rstick([]))])
  tensor((4, 0), "A", [$H$])
  leftleg("A")
  rightleg("A")
  content((2.2, 0), [$arrow.r.double$])
  content((8, 0), [$1/sqrt(2) mat(1, 1; 1, -1)$])

  set-origin((0, -3))
  content((0, 0), [#quantum-circuit(scale: 200%,
    lstick([]), ctrl(1), rstick([]), [\ ],
    lstick([]), ctrl(0), rstick([])
  )])
  tensor((4, 0), "B", [$H$])
  let la = (4, 1)
  let lb = (4, -1)
  line(la, "B")
  line(lb, "B")
  leftleg(la)
  leftleg(lb)
  rightleg(la)
  rightleg(lb)
  content((2.2, 0), [$arrow.r.double$])
  content((6, 0), [$times sqrt(2)$])

  set-origin((0, -3))
  content((0, 0), [#quantum-circuit(scale: 200%,
    lstick([]), ctrl(1), rstick([]), [\ ],
    lstick([]), targ(), rstick([])
  )])
  content((2.2, 0), [$arrow.r.double$])
  set-origin((1, 0))
  tensor((4, 0), "C", [$H$])
  tensor((3, -1), "D", [$H$])
  tensor((5, -1), "E", [$H$])
  let la = (4, 1)
  let lb = (4, -1)
  line(la, "C")
  line(lb, "C")
  line(lb, "D")
  line(lb, "E")
  leftleg(la, distance: 2)
  leftleg("D")
  rightleg(la, distance: 2)
  rightleg("E")
  content((7, 0), [$times sqrt(2)$])
}))

Note: $bot$ is a hyperedge (or delta tensor).

== QFT tensor network
#timecounter(1)

#align(center, qft-circuit())

#align(center, canvas(length: 0.6cm, {
  import draw: *
  for i in range(4){
    tensor((0, -i*2), "j"+str(i+1), text(14pt)[$j_#(i+1)$])
  }
  let end = 22
  for (loc, label) in (((2, 0), "h1"), ((10, -2), "h2"), ((16, -4), "h3"), ((20, -6), "h4")){
    tensor(loc, label, text(14pt)[$H$])
    line(label, (end, loc.at(1)))
  }
  tensor((4, -1), "p1", text(14pt)[$pi/2$])
  tensor((6, -3), "p2", text(14pt)[$pi/4$])
  tensor((8, -3), "p3", text(14pt)[$pi/8$])

  tensor((12, -3), "p4", text(14pt)[$pi/2$])
  tensor((14, -5), "p5", text(14pt)[$pi/4$])
  tensor((18, -5), "p6", text(14pt)[$pi/2$])

  line("j1", "h1")
  line("j2", "h2")
  line("j3", "h3")
  line("j4", "h4")
  line("p1", (4, 0))
  line("p1", (4, -2))
  line("p2", (6, 0))
  line("p2", (6, -4))
  line("p3", (8, 0))
  line("p3", (8, -6))

  line("p4", (12, -2))
  line("p4", (12, -4))
  line("p5", (14, -2))
  line("p5", (14, -6))

  line("p6", (18, -4))
  line("p6", (18, -6))

  tensor((6, -9), "theta", text(14pt)[$theta$])
  line("theta", (rel: (0, 1.2), to: "theta"))
  line("theta", (rel: (0, -1.2), to: "theta"))
  content((10, -9), [$=mat(1, 1; 1, e^(i theta))$])
  content((3, -9), [where])
}))

== The tensor network for the expectation value
#timecounter(1)

#align(center, canvas(length: 0.6cm, {
  import draw: *
  for i in range(4){
    tensor((0, -i*2), "j"+str(i+1), text(14pt)[$j_#(i+1)$])
  }
  let end = 22
  for (loc, label) in (((2, 0), "h1"), ((10, -2), "h2"), ((16, -4), "h3"), ((20, -6), "h4")){
    tensor(loc, label, text(14pt)[$H$])
    line(label, (end+6 + loc.at(1), loc.at(1)))
  }
  tensor((4, -1), "p1", text(14pt)[$pi/2$])
  tensor((6, -3), "p2", text(14pt)[$pi/4$])
  tensor((8, -3), "p3", text(14pt)[$pi/8$])

  tensor((12, -3), "p4", text(14pt)[$pi/2$])
  tensor((14, -5), "p5", text(14pt)[$pi/4$])
  tensor((18, -5), "p6", text(14pt)[$pi/2$])

  line("j1", "h1")
  line("j2", "h2")
  line("j3", "h3")
  line("j4", "h4")
  line("p1", (4, 0))
  line("p1", (4, -2))
  line("p2", (6, 0))
  line("p2", (6, -4))
  line("p3", (8, 0))
  line("p3", (8, -6))

  line("p4", (12, -2))
  line("p4", (12, -4))
  line("p5", (14, -2))
  line("p5", (14, -6))

  line("p6", (18, -4))
  line("p6", (18, -6))

  set-origin((0, -12))
  for i in range(4){
    tensor((0, -i*2), "j"+str(i+1), text(14pt)[$j_#(i+1)^*$])
  }
  let end = 22
  for (loc, label) in (((2, 0), "h1"), ((10, -2), "h2"), ((16, -4), "h3"), ((20, -6), "h4")){
    tensor(loc, label, text(14pt)[$H$])
    line(label, (end+6 + loc.at(1), loc.at(1)))
  }
  tensor((4, -1), "p1", text(14pt)[$-pi/2$])
  tensor((6, -3), "p2", text(14pt)[$-pi/4$])
  tensor((8, -3), "p3", text(14pt)[$-pi/8$])

  tensor((12, -3), "p4", text(14pt)[$-pi/2$])
  tensor((14, -5), "p5", text(14pt)[$-pi/4$])
  tensor((18, -5), "p6", text(14pt)[$-pi/2$])

  line("j1", "h1")
  line("j2", "h2")
  line("j3", "h3")
  line("j4", "h4")
  line("p1", (4, 0))
  line("p1", (4, -2))
  line("p2", (6, 0))
  line("p2", (6, -4))
  line("p3", (8, 0))
  line("p3", (8, -6))

  line("p4", (12, -2))
  line("p4", (12, -4))
  line("p5", (14, -2))
  line("p5", (14, -6))

  line("p6", (18, -4))
  line("p6", (18, -6))

  for i in range(4){
    tensor((2*i + end, 2 + i*2), "x"+str(i+1), text(14pt)[$X$])
  }
  line("x1", (end, 6))
  line("x1", (end, -6))

  line("x2", (end+2, 8))
  line("x2", (end+2, -4))

  line("x3", (end+4, 10))
  line("x3", (end+4, -2))

  line("x4", (end+6, 12))
  line("x4", (end+6, 0))
}))


== One line for creating a tensor network
#timecounter(2)
```julia
julia> qft_net = yao2einsum(chain(qft, chain(4, [put(4, i=>X) for i in 1:4]), qft'), initial_state = Dict([i=>zero_state(1) for i=1:4]), final_state = Dict([i=>zero_state(1) for i=1:4]), optimizer = TreeSA(nslices=2))
TensorNetwork
Time complexity: 2^9.10852445677817
Space complexity: 2^2.0
Read-write complexity: 2^10.199672344836365
```
- `yao2einsum(circuit; initial_state, final_state, optimizer)` maps a quantum circuit to a tensor network. Initial and final states are specified by a dictionary.
- `circuit'` is the adjoint of `circuit`.
- `TreeSA(; nslices)` is a heuristic contraction order optimizer with `nslices` slices.

== Step 3: One line to contract a tensor network
#timecounter(1)
```julia
julia> contract(qft_net) # calculate <reg|qft' observable qft|reg>
0-dimensional Array{ComplexF64, 0}:
0.9999999999999993 + 0.0im
```
- `contract(tensor_network)`, use the `OMEinsum.jl` to contract the tensor network.
- Time complexity is the number of multiplications. Space complexity is the number of elements in the largest tensor. Read-write complexity is the number of reads and writes.

= Discussion: Tensor network contraction order optimization
== Tensor network contraction is a sum of products
#timecounter(1)
*Tensor network contraction $arrow.l.r$ sum of products of tensor elements*
#align(center, canvas({
  import draw: *
  demo()
  content("A", [A])
  content("B", [B])
  content("C", [C])
  content("D", [D])
  content("E", [E])
  content("F", [F])
  content((5.7, 1.2), [contract $lr((#v(120pt)#h(170pt))) = sum_(a b c d e) A_(a b) B_(a d) C_(a c) D_(c d) E_(b c) F_(d e)$])
}))

- Multiplication is commutative,
- Addition and multiplication are distributive.

#align(bottom+right, box(width: 500pt, align(left, [$"Note: In this talk, " "tensor network" = &"einsum"\ = &"sum-product network"$])))

== Tensor network contraction order
#timecounter(1)
#let poly() = {
  polygon(
  fill: blue.lighten(80%),
  stroke: blue,
  (20%, 0pt),
  (60%, 0pt),
  (80%, 2cm),
  (0%,  2cm),
  )
}
#align(canvas({
  import draw: *
  line((0, -2), (18, -2), mark : (end: "straight"))
  demo()
  hobby((3, 2), (4, 2), (5, 0), (2, 0), close: true, fill: blue.transparentize(70%), stroke:none)
  set-origin((7, 0))
  demo()
  hobby((1, -1), (2.5, 2), (3, 2.5), (4, 2.5), (5, 0), (2, -1), close: true, fill: blue.transparentize(70%), stroke:none)
  set-origin((7, 0))
  demo()
  hobby((-1, 3), (1, 4), (2, 4), (1, 2), (0, 1), close: true, fill: blue.transparentize(70%), stroke:none)
  hobby((1, -1), (2.5, 2), (3, 2.5), (4, 2.5), (5, 0), (2, -1), close: true, fill: blue.transparentize(70%), stroke:none)
  set-origin((7, 0))
  content((0, -1.5), [$dots$])
}), center)

- Contraction is performed in pair-wise manner.
- The pair-wise contraction order determines the complexity (time, space, read-write).


== The hardness of finding optimal contraction order
#timecounter(1)
#align(center, box(inset: 10pt, stroke: blue)[*NP-complete*])

*Theorem @Markov2008*: Let $C$ be a quantum circuit (tensor network) with $T$ gates (tensors) and whose underlying circuit graph is $G_C$. Then $C$ can be simulated deterministically in time $T^(O(1)) exp[O(text("tw")(G_C))]$.

Tree width (measures how similar a graph is to a tree, the smaller the more tree-like):
- Tree graphs and line graphs: $1$
- $L times L$ grid graph: $O(L)$
- $n$-vertex 3-regular graph: $approx n/6$

== Heuristic search for optimal contraction order
#timecounter(1)

#align(center, box(grid(image("images/omeinsum.png", width: 100pt), [`OMEinsum.jl` (GSoC 2019, 2024)], columns: 2, gutter: 20pt), inset: 10pt, stroke: blue))

Can handle $>10^4$ tensors!

- `GreedyMethod`: fast but not optimal
- `ExactTreewidth`: optimal but exponential time @Bouchitté2001
- `TreeSA`: heuristic local search, close to optimal, *slicing* supported @Kalachev2022
- `KaHyParBipartite` and `SABipartite`: min-cut based bipartition, better heuristic for extremely large tensor networks @Gray2021

Check the blog post for more details: https://arrogantgao.github.io/blogs/contractionorder/


== Heuristic search for optimal contraction order
#timecounter(2)

#canvas({
  import plot
  import draw: *
  plot.plot(size: (14,10),
    x-tick-step: none,
    y-tick-step: none,
    x-label: "Time to optimize contraction order",
    y-label: "Time to contract",
    y-max: 10,
    y-min: 0,
    x-max: 10,
    x-min: 0,
    name: "plot",
    {
      let greedy = (1, 9)
      let localsearch = (4, 3)
      let bipartition = (3, 4)
      let tw = (9, 1)
      let tamaki = (5, 2)
      plot.add(
        (greedy, bipartition, localsearch, tamaki, tw), style: (stroke: gray), mark:"o",
      )
      plot.add-anchor("greedy", greedy)
      plot.add-anchor("localsearch", localsearch)
      plot.add-anchor("bipartition", bipartition)
      plot.add-anchor("tw", tw)
      plot.add-anchor("tamaki", tamaki)
    }
  )
  content((rel: (1.3, 0), to: "plot.greedy"), [Greedy])
  content((rel: (5, 0), to: "plot.localsearch"), [Local Search@Kalachev2022])
  content((rel: (5, 0), to: "plot.bipartition"), [Bipartition @Gray2021])
  content((rel: (6.5, -0.5), to: "plot.tw"), [Exact tree-width @Bouchitté2001\ #text(gray)[State compression (Jutho)]])
  content((rel: (6.5, 0), to: "plot.tamaki"), text(gray)[Positive instance driven @Althaus2021])
})

#place(dx: 60%, dy: -90%, [Note: #text(gray)[gray] colored methods are not\ yet implemented in `OMEinsum`.])

== Pros and cons
#timecounter(1)

- Suited for *shallow* quantum circuit simulation, e.g. solving the sampling problem of the sycamore quantum circuits (53 qubits) @pan2022solving
- Can handle common tasks, such as *sampling* and *obtaining expectation values*.
- Can easily generalize the noisy quantum systems @Gao2024.

#v(30pt)
- For general circuits, the simulation is still exponentially hard.

== Example application: Quantum error correction
#timecounter(1)

Using tensor network as the simulation backend for studying *coherent errors*@Ni2024.

#image("images/qec.svg", width: 800pt)

#align(right, image("images/tensorqec.png", width: 200pt))


== Summary
#timecounter(1)

#align(center, box([Yao.jl: a utility for quantum onliners.], stroke: black, inset:10pt))

#grid(columns: 2, gutter: 50pt,
[
- Yao paper: @Luo2020
- GitHub repo: Yao.jl
  #image("images/barcode.png", width:150pt)
  1000 - \# of stars = 65!
],
[
=== Collaborators
#grid(columns: 4, gutter: 20pt,
image("images/roger.png", width:50pt, height:60pt), [Xiu-Zhe Luo],
image("images/leiwang.png", width:50pt, height:60pt), [Lei Wang],
image("images/panzhang.png", width:50pt, height:60pt), [Pan Zhang],
image("images/xuanzhao.png", width:50pt, height:60pt), [Xuan-Zhao Gao\ (TreeWidthSolver.jl)],
image("images/zhongyi.jpg", width:50pt, height:60pt), [Zhong-Yi Ni\ (TensorQEC.jl)],
)]
)

==

#bibliography("refs.bib")