#import "@preview/peace-of-posters:0.5.6" as pop
#import "@preview/cetz:0.4.1": canvas, draw, tree
#import "@preview/pinit:0.2.2": *


#show link: set text(blue)
#set page("a0", margin: 1cm)
#pop.set-poster-layout(pop.layout-a0)
#pop.set-theme(pop.uni-fr)
#set text(size: pop.layout-a0.at("body-size"))
#let box-spacing = 1.2em
#set columns(gutter: box-spacing)
#set block(spacing: box-spacing)
#pop.update-poster-layout(spacing: box-spacing)

#pop.title-box(
  "Branching on-the-fly for solving satisfaction problems",
  authors: [Yi-Jia Wang$""^dagger$, Xuan-Zhao Gao$""^*$ (co-first author), Pan Zhang$""^dagger$ and Jin-Guo Liu$""^*$],
  institutes: text(36pt)[
  $""^*$Advanced Materials Thrust, Function Hub, Hong Kong University of Science and Technology (Guangzhou)\
  $""^dagger$CAS Key Laboratory for Theoretical Physics, Institute of Theoretical Physics, Chinese Academy of Sciences
  ],
  logo: image("amat-dark.png", width: 150%),
  title-size: 1.5em,
)

#columns(2,[

  #pop.column-box(heading: "Abstract")[
The branching algorithm is a fundamental technique for designing fast exponential-time algorithms to solve combinatorial constraint satisfaction problems (CSPs) exactly.  
It divides the entire solution space into independent search branches using predetermined branching rules, and ignores the search on suboptimal branches to significantly reduce the exponential time complexity. 
The complexity of a branching algorithm is primarily influenced by the rules it employs.
However, existing branching algorithms are often limited by their predetermined finite rule set which can not cover all possible situations, so that can not achieve optimality in most cases.
In this paper, we focus on the maximum independent set problem, and propose to automatically generate optimal branching rules for a given sub-graph with existing numerical tools including the generic tensor network and the integer/linear programming solvers.
Through experimental evaluation, we demonstrate that our algorithm's ability to discover branching rules with the lowest future complexity. 
Furthermore, it is shown that by integrating our approach with existing methods, we achieve an average complexity of $O(1.0455^n)$ on 3-regular graphs, representing a significant enhancement in performance over previous methods that depend on expert-designed branching rules.
  ]


  #pop.column-box(heading: "Maximum independent set (MIS) problem")[
An independent set is a set of vertices in a graph, no two of which are adjacent.

#grid([
#pad(canvas(length: 1.5cm, {
  import draw: *
  for (loc, name, color) in (((0, 0), "a", black), ((0, 3), "b", red), ((3, 0), "d", red), ((3, 3), "c", black), ((5, 1.5), "e", red)) {
    circle(loc, radius:0.5, name: name, stroke: (paint: color, thickness: 3pt))
    content(loc, [$#name$])
  }
  for (a, b) in (
    ("a", "b"),
    ("a", "d"),
    ("a", "c"),
    ("c", "d"),
    ("b", "c"),
    ("c", "e"),
    ) {
    line(a, b, stroke: 3pt)
  }
  content((1.5, -1.5), [$G = (V, E)$])
}), x:20pt)
],
box(height: 250pt)[
  - Independent sets: ${}, {a}, {b}, {c},{d},{e},$ ${a,e}, {b, d}, {b, e}, {d, e}, {b, d, e}$
  - MIS: ${b, d, e}$, size $alpha(G) = 3$.
  - Independence polynomial: $I(x) = 1 + 5x + #pin(1)4x^2#pin(2) + x^3$

#pinit-highlight(1, 2)
#pinit-point-from(1, pin-dy: 15pt, pin-dx: 10pt, body-dx: -350pt)[4 independent sets with 2 vertices]
],
columns: 2
)
Finding the maximum independent set for a given graph is in #highlight([NP-complete]) - a class of problems that unlikely to be solved in time polynomial in the input size.
  ]

  // These properties will be given to the function which is responsible for creating the heading
  #let hba = pop.uni-fr.heading-box-args
  #hba.insert("stroke", (paint: gradient.linear(green, red, blue), thickness: 10pt))

  // and these are for the body.
  #let bba = pop.uni-fr.body-box-args
  #bba.insert("inset", 30pt)
  #bba.insert("stroke", (paint: gradient.linear(green, red, blue), thickness: 10pt))

  #pop.column-box(heading: "Why branching?", stretch-to-next: true)[
    While the *generic tensor network based algorithm*@Liu2023 can solve the independent set problems efficiently on graphs with small tree width, e.g. tree graph (tree width 1), geometric graphs (tree width $O(n^((d-1)/d))$ such as the grid graph), #highlight([*branching* works much better in high dimensional graphs]), e.g. it can solve a fully connected graph in linear time. The *border line* is a 3-regular graph, high dimensional, but sparse enough. Its tree width is $approx n/6$, rendering a tensor network algorithm with complexity $O(1.1225^n)$. The best branching algorithm gives the lowest complexity of $O(1.0836^n)$ @Xiao2013.
  Theorem (or branching rule) plays a central role in branching. #highlight([Better rule gives lower complexity]). The following example is from the book *Exact Exponential Algorithms* @Fomin2013.

#grid(columns: 2, gutter: 50pt,
canvas(length: 1.4cm, {
  import draw: *
  let scircle(loc, radius, name) = {
    circle((loc.at(0)-0.1, loc.at(1)-0.1), radius: radius, fill:black, stroke: 3pt)
    circle(loc, radius: radius, stroke: (paint: black, thickness: 3pt), name: name, fill:white)
  }
  let s = 1.5
  let dy = 3.0
  let la = (-s, 0)
  let lb = (0, s)
  let lc = (0, 0)
  let ld = (s, 0)
  let le = (s, s)
  scircle((0, 0), (3, 2), "branch")
  for (l, n) in ((la, "a"), (lb, "b"), (lc, "c"), (ld, "d"), (le, "e")){
    circle((l.at(0), l.at(1)-s/2), radius:0.4, name: n, stroke: (paint: if n == "a" {red} else {black}, thickness: 3pt))
    content((l.at(0), l.at(1)-s/2), n)
  }
  for (a, b) in (("a", "b"), ("b", "c"), ("c", "d"), ("d", "e"), ("b", "d")){
    line(a, b, stroke: 3pt)
  }
  scircle((-4, -dy), (2, 1.5), "brancha")
  for (l, n) in ((lc, "c"), (ld, "d"), (le, "e")){
    let loc = (l.at(0)-5, l.at(1)-s/2-dy)
    circle(loc, radius:0.4, name: n, stroke: (paint: if n == "c" {red} else {black}, thickness: 3pt))
    content(loc, n)
  }
  for (a, b) in (("c", "d"), ("d", "e"), ("c", "d")){
    line(a, b, stroke: 3pt)
  }
  scircle((4, -dy), (1, 1), "branchb")
  circle((4, -dy), radius:0.4, name: "e", stroke: (paint: red, thickness: 3pt))
  content((4, -dy), "e")
  scircle((-6, -2*dy), (1, 1), "branchaa")
  circle((-6, -2*dy), radius:0.4, name: "e", stroke: (paint: red, thickness: 3pt))
  content((-6, -2*dy), "e")
  scircle((-2, -2*dy), (0.5, 0.5), "branchab")
  scircle((4, -2*dy), (0.5, 0.5), "branchba")
  scircle((-6, -3*dy), (0.5, 0.5), "branchaaa")
  line("branch", "brancha", stroke: 3pt)
  line("branch", "branchb", stroke: 3pt)
  line("brancha", "branchaa", stroke: 3pt)
  line("brancha", "branchab", stroke: 3pt)
  line("branchb", "branchba", stroke: 3pt)
  line("branchaa", "branchaaa", stroke: 3pt)
  content((-5, -dy/2+0.5), text(22pt)[$G \\ N[a]$])
  content((3.5, -dy/2), text(20pt)[$G \\ N[b]$])
  content((-6.8, -3*dy/2), text(20pt)[$G \\ N[c]$])
  content((-1.5, -3*dy/2-0.4), text(20pt)[$G \\ N[d]$])
  content((-5.0, -5*dy/2-0.4), text(20pt)[$G \\ N[e]$])
  content((5.0, -3*dy/2-0.4), text(20pt)[$G \\ N[e]$])
}),
box(width: 530pt)[
1. Given a $n$-vertex graph $G$, select a vertex, e.g. $a$
  - Case 1: $a$ is in the independent set, then create a branch $G \\ N[a]$
  - Case 2: $a$ is not in the independent set, then create a branch $G \\ N[b]$
2. Solve two subproblems with sizes $(n-2)$ and $(n-4)$ recursively.

Let the *computational complexity* be $gamma^n$, we have
$
gamma^n = gamma^(n-2) + gamma^(n-4)
$
]

)

The rule used here is: _If a vertex $v$ is not in the MIS, then at least one of its neighbors must be in the MIS_, which gives the complexity of $gamma = 1.4423$. Finding better branching rules to reduce $gamma$ is the main theme in this field. Well known rules include _domination rule_, _sattelite rule_, _mirror rule_, etc.
  ]

#colbreak()

  #pop.column-box(
    heading: "Discover optimal branching rules automatically!",
  )[
We show computer programs can automatically discover the optimal branching rules on sub-graphs up to size tens of vertices, which is way beyond the capability of human experts.
For example, we consider a sub-graph $R$ with boundary vertices $partial R = {a, b, c}$, where the dashed lines indicate their connections to vertices in the environment $G$ without $R$.
Due to the independence constrains on this local graph, most local configurations are _irrelevant_. The remaining configurations are listed below, grouped by the boundary configurations $bold(s)_(partial R) = {000, 001, 010, 111}$.

  #grid(
    columns: 2,
    gutter: 20pt,
    canvas(length: 3cm, {
        import draw: *
        // Draw outer ellipse
        circle((0,0), radius: (2.2, 1.7), stroke: (paint: black, thickness: 3pt), fill: green.lighten(80%))
        
        // Draw inner ellipse 
        circle((0,0), radius: (1.6, 1.2), stroke: none, fill: white.lighten(70%))
        
        // Draw vertices
        let vertices = (
          ((-0.9, -0.5), "a"),
          ((-0.4, 0.6), "b"), 
          ((0.9, -0.6), "c"),
          ((0.1, -0.5), "d"),
          ((-0.4, 0.0), "e")
        )
        
        for ((x,y), label) in vertices {
          circle((x,y), radius: 0.2, fill: black, name: label, stroke: (paint: black, thickness: 3pt))
          content((x,y), text(white, label))
        }
        
        // Draw solid edges
        line("a", "e", stroke: (paint: black, thickness: 3pt)) // a-e
        line("a", "d", stroke: (paint: black, thickness: 3pt)) // a-d  
        line("b", "e", stroke: (paint: black, thickness: 3pt)) // b-e
        line("c", "d", stroke: (paint: black, thickness: 3pt)) // c-d
        line("d", "e", stroke: (paint: black, thickness: 3pt)) // d-e
        
        // Draw dashed edges to external vertices
        line("a", (rel: (-0.5, -0.5), to: "a"), stroke: (dash: "dashed", paint: black, thickness: 3pt)) // a-f
        line("b", (rel: (0, 0.8), to: "b"), stroke: (dash: "dashed", paint: black, thickness: 3pt)) // b-g
        line("c", (rel: (0.5, -0.5), to: "c"), stroke: (dash: "dashed", paint: black, thickness: 3pt)) // c-h
        // Add labels
        content((0.7,0.4), $R$)
        content((1.84,-0.28), $G$)
      }),
    canvas(length: 3cm, {
        import draw: *
        let y = 1.8
        content((2.5,y), $bold(s)_(a b c d e)$)
        y -= 0.6
        content((2.5,y), $S_(000) = {00001, 00010}$)
        y -= 0.6
        content((2.5,y), $S_(001) = {00101}$)
        y -= 0.6
        content((2.5,y), $S_(010) = {01010}$)
        y -= 0.6
        content((2.5,y), $S_(111) = {11100}$)
        
        content((6.3,1.8), [clauses in $cal(D)$])
        
        // Draw brace
        line((4.5,0.6), (4.7, 0.9), (4.5,1.2), stroke: (paint: black, thickness: 1pt))
        
        // Add clauses
        content((6.3,0.9), $not a and not b and not d and e$)
        content((6.3,0.0), $not a and b and not c and d and not e$)
        content((6.3,-0.6), $a and b and c and not d and not e$)
      })
  )
  #highlight([The optimal branching rule is about how to capture the patterns of the relevant configurations.]) Formally,

    *Definition*: _A branching strategy for bitstring searching_ denoted as $delta$, is a function that maps a subgraph $R$ to a boolean formula in disjunctive normal form (DNF) $cal(D) = c_1 or c_2 or \ldots or c_(|cal(D)|)$, where each clause $c_k = l_1 and l_2 and dots and l_(|V(c_k)|)$ is associated with a branch, in which a positive or negative literal $l_i = v$ or $l_i = not v$ represents the vertex $v in V(R)$ is or isn't in the set.
    Here, $V(c_k)$ is the set of vertices involved in the $k$-th clause $c_k$.

For a $n$-vertex sub-graph, the number of possible branching rules (DNF) scales as $2^(3^n)$, for $n = 6$, this number is: 28240139587082174969491088422046278633513539
11851577524683401930862693830361198499905873920995229996970897865498283
99657812329686587839094762655308848694610643079609148271612057263207249
2703527723757359478834530365734912.

  #highlight([In our work@Wang2024, we developed an algorithm to find the best (with the lowest $gamma$) branching rule from the super-exponential number of branching rules (page too short, algorithm omitted, talk to Xuan-Zhao Gao or Jin-Guo Liu).])
  ]

  #pop.column-box(heading: "Benchmark on 3-regular graphs")[
    #grid(columns:2, gutter:0pt, image("benchmark.svg", width: 530pt),
    box(inset: 20pt)[
- Better (practical) performance than state of the art methods, with computer generated branching rules!
- Source code on GitHub:\
  #link("https://github.com/ArrogantGao/OptimalBranching.jl")[ArrogantGao/OptimalBranching.jl]
  #image("barcode.png", width: 130pt)
    ])
  ]

  #pop.column-box(heading: "References", stretch-to-next: true)[ 
    #bibliography("bibliography.bib", title: none)
  ]
])

#pop.bottom-box()[
  #align(right, [#align(horizon, grid(columns:5, column-gutter: 30pt, image("github-dark.png", width: 70pt), "GiggleLiu", h(50pt), image("email.png", width: 70pt), "jinguoliu@hkust-gz.edu.cn"))])
]

