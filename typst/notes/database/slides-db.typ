#import "@preview/touying:0.4.2": *
#import "@preview/touying-simpl-hkustgz:0.1.0" as hkustgz-theme
#import "@preview/cetz:0.2.2": canvas, draw, tree, decorations, vector, coordinate, plot
#import "@preview/quill:0.3.0": *
#import "@preview/pinit:0.1.3": *
#import "@preview/algorithmic:0.1.0"
#import "lattices.typ": unitcell
#import algorithmic: algorithm

#show raw.where(lang:"python"): it=>{
  par(justify:false,block(fill:rgb("#f0fef0"),inset:1.5em,width:99%,text(it)))
}

#set cite(style: "apa")

#let s = hkustgz-theme.register()
#let ket(x) = $|#x angle.r$
#let bra(x) = $angle.l #x|$
#let braket(x, y) = $angle.l #x|#y angle.r$
#let rbox(x) = box(x, stroke: red, inset: 3pt)
#let jinguo(txt) = {
  //text(blue, [[JG: #x]])
  canvas({
    import draw: *
    content((), text(blue)[[JG: #txt]])
  })
}
// Global information configuration
#let s = (s.methods.info)(
  self: s,
  title: box(width: 70%)[Materials simulation],
  subtitle: [Lecture 1: Materials Databases],
  author: [Jin-Guo Liu],
  date: datetime.today(),
  institution: [HKUST(GZ) - FUNH - AMAT],
)

#let rand(base, seed:666) = {
  let a = 1103515245
  let c = 12345
  return calc.rem((a * seed + c), base);
}
#let box-of-particles() = canvas({
  import draw: *
  let L = 5
  let base = calc.pow(2, 31)
  let seed = rand(base)
  rect((0,0), (L,L), stroke: gray)
  for (i, (x, y, vx, vy)) in ((2, 2, 1.2, 0.4), (3, 0.5, -0.6, 0.4), (3, 4, 0.4, -0.8), (1, 3, -0.8, -0.8)).enumerate(){
    circle((x, y), radius:0.1, fill: blue, stroke:none, name: str(i))
    content((x+0.3, y - 0.1), [$bold(x)_#(i+1)$])
    // draw a random arrow
    line(str(i), (rel: (vx, vy), to: str(i)), stroke: (thickness: 2pt, paint: blue), mark: (end: "straight"))
  }
  let (x1, y1, vx1, vy1) = (2, 2, 1.2, 0.4)
  let (x2, y2, vx2, vy2) = (3, 0.5, -0.6, 0.4)
  content((x1+0.3+vx1, y1+vy1 - 0.2), text(blue, [$bold(v)_1$]))

  let (fx, fy) = ((x2 - x1) * 0.4, (y2 - y1) * 0.4)
  line(str(0), (rel: (fx, fy), to: str(0)), stroke: (thickness: 2pt, paint: orange), mark: (end: "straight"))
  line(str(1), (rel: (-fx, -fy), to: str(1)), stroke: (thickness: 2pt, paint: orange), mark: (end: "straight"))
  content((x1 + 3.2, y1 - 0.5), text(orange, [Inter-atomic forces]))

  bezier(str(0), (rel: (-1, -1), to: str(0)), (rel: (-1.5, -0.5), to: str(0)), str(1), stroke: (thickness: 2pt, paint: gray, dash: "dashed"))
  circle((rel: (-1, -1), to: str(0)), radius: 0.1, fill: gray, stroke: none)
  content((0.9, 0.5), text(gray, [Trajectory]))

  content((8, 4), [$arrow.double.l$ Boundary\ #h(13pt) (periodic or closed)])
})

// Extract methods
#let (init, slides) = utils.methods(s)
#show: init

// Extract slide functions
#let (slide, empty-slide, title-slide, outline-slide, new-section-slide, ending-slide) = utils.slides(s)
#show: slides.with()

#let question(txt) = {
  align(center, box(width: 80%, fill: blue.lighten(80%), inset: 15pt)[#text(blue.darken(50%))[*Q:*] #txt])
}
#let discussion(txt) = {
  align(center, box(width: 80%, fill: blue.lighten(80%), inset: 15pt)[#text(blue.darken(50%))[*Discussion*]: #txt])
}

#let globalvars = state("t", 0)
#let timecounter(minutes) = [
  #globalvars.update(t => t + minutes)
  #place(dx: 97%, dy: 0%, align(right, text(16pt, red)[#context globalvars.get()min]))
]

#outline-slide()

== Lectures on materials simulation
#timecounter(2)

#grid(columns: 2, gutter: 50pt, 
[
- Nov 11: Materials databases
- Nov 13: Molecular simulation (Homework)
- Nov 18: Electronic structure simulation
- Nov 20: Hands-on (Bring laptop)
],
box(width: 200pt)[
  #figure(image("images/jinguoliu.jpg", width: 70pt, height: 100pt), numbering:none, caption: text(14pt)[Jinguo Liu, 刘金国\ Email: jinguoliu\@hkust-gz.edu.cn])
  - Scientific computing
  - Quantum simulation
],
)

= Overview of the Materials Databases

== Material growth
#timecounter(8)

#link("https://youtu.be/CMq30uAev5U?si=DthZbtDzg30Yg7J7")[YouTube: Making New Materials | Makers in the Lab] (2.5 minutes)

#grid(columns: 2, gutter: 50pt,
  [
    - *crystal*: 晶体
    - *crucible*: 坩埚
    - *silica tube*: 石英管
    - *seal*: 密封
    - *blow torch*: 吹管
  ],
  [
    - *growth ampoule*: 生长瓶
    - *furnace*: 炉子
    - *centrifuge*: 离心机
    - *gravitation*: 重力
    - *potassium germanium 2*: 钾锗矿
  ],
)

#discussion([What do you learn from the video?])

==

1. The condition matters: gravity, vacumn
2. Needs some luck, even the same recipe, same process, the outcome may be different (玄学).
3. Safety training is important

== Materials databases
#timecounter(2)

- Databases for Crystalline materials
  - #underline([#link("https://materialsproject.org/")[The Materials Project], 150,000 datasheets])
  - #link("https://mpds.io/")[Materials Platform for Data Science], $50,000$ free to use datasheets and $1,800,000$ datasheets for paid use
  - #link("https://materialsdata.nist.gov/")[Materials Data Facility], #link("https://citrine.io/")[Citrination] etc.

- Databases for Chemical compounds and Organic materials
  - #link("https://www.cas.org/solutions/cas-scifinder-discovery-platform/cas-scifinder")[CAS SciFinder]

= Introduction to database: The Materials Project
#timecounter(2)
Web interface: https://next-gen.materialsproject.org/materials
#align(center, image("images/barcode.png", width: 150pt))
#link("https://next-gen.materialsproject.org/")[The Materials Project] @Jain2013 is a multi-institution, multi-national effort to compute the properties of all *inorganic* materials and provide the data and associated analysis algorithms for every materials researcher *free of charge*.

== Make a query through web
#timecounter(2)

When searching NaCl, three entries are found.

#align(center + top, canvas({
  import draw: *
  content((), image("images/explore-nacl.png", width: 500pt))
  rect((-5.7, -1.3), (-5.2, -0.8), stroke: red.lighten(30%))
  content((-7.7, -0.4), text(red.lighten(30%), size: 14pt)[Experimentally observed])

  rect((-5.1, -3), (-3.8, 0), stroke: blue.lighten(30%))
}))


- Material ID: the *unique* identifier of the material.

== Crystal system and space group
#timecounter(2)

#align(center+top, canvas({
  import draw: *
  content((), image("images/explore-nacl.png", width: 500pt))

  let x0 = -1.5
  let width = 6.5
  rect((x0, -3), (x0 + width, 0), stroke: blue.lighten(30%))
}))


- Cristal System: The crystal system of the material.
- Spacegroup: The space group of the material.
- Sites: The number of atoms in the unit cell. #v(1em)

== Crystal system and space group
#timecounter(2)

#align(center, text(size: 14pt)[
  #figure(table(
    columns: (auto, auto, 2cm, 3cm, 2cm),
    table.header(
      table.cell(fill: green.lighten(60%))[*Crystal \ system*],
      table.cell(fill: green.lighten(60%))[*Symmetry*],
      table.cell(fill: green.lighten(60%))[*Point groups*],
      table.cell(fill: green.lighten(60%))[*Lattice \ system*],
      table.cell(fill: green.lighten(60%))[*Space groups*],
    ),
  [*Triclinic*], [],	[2], [Triclinic],	[2],
  [*Monoclinic*], [1 twofold axis of rotation or 1 mirror plane],	[3],	[Monoclinic],	[13],
  [*Orthorhombic*],	[3 twofold axes of rotation or 1 twofold axis of rotation and 2 mirror planes],	[3],	[Orthorhombic],	[59],
  [*Tetragonal*],	[1 fourfold axis of rotation],	[7],	[Tetragonal],	[68],
  table.cell(rowspan: 2)[*Trigonal*],	table.cell(rowspan: 2)[1 threefold axis of rotation],	table.cell(rowspan: 2)[5],	[Rhombohedral],	[7],
  table.cell(rowspan:2)[Hexagonal], [18],
  text(red)[*Hexagonal*], [1 sixfold axis of rotation],	[7],	[27],
  text(red)[*Cubic*],	[4 threefold axes of rotation],	[5],	[Cubic],	[36],
  table.cell(fill: green.lighten(60%))[7],
  table.cell(fill: green.lighten(60%))[*Total*],
  table.cell(fill: green.lighten(60%))[32],
  table.cell(fill: green.lighten(60%))[7],
  table.cell(fill: green.lighten(60%))[230]
  ))
])

// == Crystal structure and symmetry

// The crystal system of `mp-22862` is cubic. It has space group $F m overline(3) m$:

// #figure(image("2024-10-21-11-59-23.png", width: 300pt), caption: [The crystal structure of NaCl. (Image source: #link("http://img.chem.ucl.ac.uk/sgp/large/sgp.htm")[Space Group Diagrams and Tables
// ])])

== Cubic structure of `mp-22862` ($F m overline(3) m$)
#timecounter(5)
Symmetry group operations: http://img.chem.ucl.ac.uk/sgp/large/sgp.htm

The lattice vectors are $a$, $b$, $c$, and the angles are $alpha = angle(b, c)$, $beta = angle(a, c)$, $gamma = angle(a, b)$.
#figure(
  grid(columns: 2, gutter: 50pt,
    align(horizon, canvas(length: 1.2cm, {
      import draw: *
      content((),image("images/NaCl-Fm-3m.png", width: 225pt, height: 205pt))
        content((2, -0.3), text(size: 14pt)[Cl])
        content((1, -1.4), text(size: 14pt)[Na])
        content((1.5, -1.0), text(size: 14pt, fill: orange)[a])
        content((-0.1, -1), text(size: 14pt, fill: orange)[b])
        content((-0.2, -1.6), text(size: 14pt, fill: orange)[c])
        content((0.7, -1.6), text(blue, size: 14pt)[$gamma$])
        content((-0.6, 0.2), text(blue, size: 14pt)[$beta$])
        content((2.3, 0.1), text(blue, size: 14pt)[$alpha$])
      })
    ),
    text(14pt)[#table(columns: (auto, auto),
    table.header(
      table.cell(fill: green.lighten(60%))[*Lattice \ Parameters*],
      table.cell(fill: green.lighten(60%))[*Values*],
    ),
    [a], [5.59 Å],
    [b], [5.59 Å],
    [c], [5.59 Å],
    [$alpha$], [90.00 º],
    [$beta$], [90.00 º],
    [$gamma$], [90.00 º],
    [Volume], [174.50 Å³],
  )])
)


#question([What are the 4 3-fold axes of rotation in the cubic space group?])

== Cubic structure of `mp-22851` ($P m overline(3) m$)
#timecounter(1)
#figure(
  grid(columns: 2, gutter: 20pt,
    align(horizon, canvas(length: 1.2cm, {
      import draw: *
      content((),image("images/NaCl-Pm-3m.png", width: 225pt))
      })
    ),
    table(columns: (auto, auto),
    table.header(
      table.cell(fill: green.lighten(60%))[*Lattice \ Parameters*],
      table.cell(fill: green.lighten(60%))[*Values*],
    ),
    [a], [3.50 Å],
    [b], [3.50 Å],
    [c], [3.50 Å],
    [$alpha$], [90.00 º],
    [$beta$], [90.00 º],
    [$gamma$], [90.00 º],
    [Volume], [42.96 Å³],
  ))
)

== Hexagonal structure of `mp-1120767` ($P 6_3\/m m c$)
#timecounter(2)
#figure(
  grid(columns: 2, gutter: 20pt,
    align(horizon, canvas(length: 1.2cm, {
      import draw: *
      content((),image("images/NaCl-P-62m.png", width: 225pt))
      })
    ),
    table(columns: (auto, auto),
    table.header(
      table.cell(fill: green.lighten(60%))[*Lattice \ Parameters*],
      table.cell(fill: green.lighten(60%))[*Values*],
    ),
    [a], [6.80 Å],
    [b], [6.80 Å],
    [c], [7.09 Å],
    [$alpha$], [90.00 º],
    [$beta$], [90.00 º],
    [$gamma$], [120.00 º],
    [Volume], [284.08 Å³],
  ))
)

== Energy properties
#timecounter(2)

#align(center+top, canvas({
  import draw: *
  content((), image("images/explore-nacl.png", width: 500pt))

  let x0 = 5
  let width = 3.7
  rect((x0, -3), (x0 + width, 0), stroke: blue.lighten(30%))
}))

In the following, we will focus on the interpretation of the energy properties.

== Formation energy, a measure of thermodynamic stability
#timecounter(2)

*Formation energy*: the energy required to dissociate that material into its respective elements.

Thus, it indicates the thermodynamic stability (room temperature $approx$ 0.025 eV) against the elements it consists of.

#align(center, canvas({
  import draw: *
  //set text(size: 10)
  circle((0, 0), radius: 0.3, fill: blue, stroke: none, name: "A")
  content((0, 0), text(white, size:12pt)[A])
  circle((2, 0), radius: 0.3, fill: red, stroke: none, name: "B")
  content((2, 0), text(white, size:12pt)[X])
  circle((-2, 2), radius: 0.3, fill: blue, stroke: none, name: "C")
  content((-2, 2), text(white, size:12pt)[A])
  circle((4, 2), radius: 0.3, fill: red, stroke: none, name: "D")
  content((4, 2), text(white, size:12pt)[X])
  decorations.wave(line("A", "B"), amplitude: 0.2, period: 0.5, phase: 0.2)
  line("A", "C", mark: (end: "straight"), stroke: (dash: "dashed"))
  line("B", "D", mark: (end: "straight"), stroke: (dash: "dashed"))
}))

$
  E_("formation")(A_(1-x)X_x) = E(A_(1-x)X_x) - x E(X) - (1-x) E(A)
$

== Energy above hull, a better measure
#timecounter(5)

*Energy above hull*:
- the energy required to dissociate that material into its competing phases.
- the difference between the formation energy and the convex hull.

#figure(image("images/2024-10-20-12-15-46.png", width: 300pt))

If a material is thermodynamically stable, the energy above the hull must be equal to zero.

== Which one is thermodynamically stable?
#timecounter(4)

#figure(image("images/explore-nacl.png", width: 500pt))

#question([Given the data in the table, which one is the salt that we are familiar with?])

== Salt crystal structure of NaCl (mp-22862):

#timecounter(5)

- *International number* (225), *Hall number* (-F 4 2 3), and *Symbol* ($F m overline(3) m$) are different ways to represent the space group.
- *Wyckoff* positions: distinct symmetry-equivalent sites within a crystal structure

#align(center, table(columns: (auto, auto, auto, auto, auto),
  table.header(
    table.cell(fill: green.lighten(60%))[*Wyckoff site*],
    table.cell(fill: green.lighten(60%))[*Element*],
    table.cell(fill: green.lighten(60%))[*x*],
    table.cell(fill: green.lighten(60%))[*y*],
    table.cell(fill: green.lighten(60%))[*z*],
  ),
  [4a], [Na], [0], [0], [0],
  [4b], [Cl], [0], [0], [1/2],
))

#question([Why there are only 2 positions in the table?])

== Exercise: From Wyckoff positions to unit cell
#timecounter(5)
#box(stroke: black, inset: 20pt,[
Exercise: Generate all atoms in the unit cell
- Symmetry group operations: $\(x,y,z\)$, $\(-x,-y,z\)$, $\(-x,y,-z\)$, and $\(x,-y,-z\)$.
- Wychoff position: $\(0.321,0.457,0.892\)$
]
)
$
\(x,y,z\) arrow.r (0.321,0.457,0.892) \
\(-x,-y,z\) arrow.r (0.679,0.543,0.892) \
\(-x,y,-z\) arrow.r (0.679,0.457,0.108) \
\(x,-y,-z\) arrow.r (0.321,0.543,0.108)
$

== The symmetry operations of $F m overline(3) m$
#timecounter(1)
The 48 symmetry group operations (Source: https://www.globalsino.com/EM/page3025.html) can be resolved as follows:
#let s(x) = text(size: 14pt)[#x]
#align(center, table(stroke: none, inset: 3pt, column-gutter: 15pt,
columns: (auto, auto, auto, auto, auto, auto),
s[$x, y, z$], s[$-x, -y, z$], s[$-x, y, -z$], s[$x, -y, -z$],
s[$z, x, y$], s[$z, -x, -y$], s[$-z, -x, y$], s[$-z, x, -y$],
s[$y, z, x$], s[$-y, z, -x$], s[$y, -z, -x$], s[$-y, -z, x$],
s[$y, x, -z$], s[$-y, -x, -z$], s[$y, -x, z$], s[$-y, x, z$],
s[$x, z, -y$], s[$-x, z, y$], s[$-x, -z, -y$], s[$x, -z, y$],
s[$z, y, -x$], s[$z, -y, x$], s[$-z, y, x$], s[$-z, -y, -x$],
s[$-x, -y, -z$], s[$x, y, -z$], s[$x, -y, z$], s[$-x, y, z$],
s[$-z, -x, -y$], s[$z, x, -y$], s[$z, -x, y$], s[$-z, x, y$],
s[$-y, -z, -x$], s[$y, z, -x$], s[$y, -z, x$], s[$-y, z, x$],
s[$-y, x, -z$], s[$y, -x, -z$], s[$y, x, z$], s[$-y, -x, z$],
s[$x, z, -y$], s[$-x, z, y$], s[$-x, -z, -y$], s[$x, -z, y$],
s[$z, y, -x$], s[$z, -y, x$], s[$-z, y, x$], s[$-z, -y, -x$],
s[$-x, -y, -z$], s[$x, y, -z$], s[$x, -y, z$], s[$-x, y, z$],
s[$-z, -x, -y$], s[$z, x, -y$], s[$z, -x, y$], s[$-z, x, y$],
s[$-y, -z, -x$], s[$y, z, -x$], s[$y, -z, x$], s[$-y, z, x$],
s[$-y, x, -z$], s[$y, -x, -z$], s[$y, x, z$], s[$-y, -x, z$],
s[$x, z, -y$], s[$-x, z, y$], s[$-x, -z, -y$], s[$x, -z, y$],
s[$z, y, -x$], s[$z, -y, x$], s[$-z, y, x$], s[$-z, -y, -x$],
s[$-y, 1/2+x, 1/2+z$], s[$x, 1/2+z, 1/2-y$], s[$-x, 1/2+z, 1/2+y$], s[$-x, 1/2-z, 1/2-y$],
s[$x, 1/2-z, 1/2+y$], s[$z, 1/2+y, 1/2-x$], s[$z, 1/2-y, 1/2+x$], s[$-z, 1/2+y, 1/2+x$],
s[$-z, 1/2-y, 1/2-x$], s[$-x, 1/2-y, 1/2-z$], s[$x, 1/2-y, 1/2-z$], s[$x, 1/2+y, 1/2+z$],
s[$-z, -x, -y$], s[$z, x, -y$], s[$z, -x, y$], s[$-z, x, y$],
))



== Band structure and band gap
#timecounter(5)

- Band Gap: The band gap is the energy difference between the valence band and the conduction band.

#figure(numbering: none, grid(columns: 2, gutter: 20pt,
  align(horizon, canvas(length: 0.8cm,
    {
      import draw: *
      content((),image("images/2024-10-20-12-39-56.png", width: 120pt))
      content((1.2, 1.8), text(size: 14pt)[$W$])
      content((1.8, 1.5), text(size: 14pt)[$K$])
      content((1.4, 0), text(size: 14pt)[$L$])
      content((0, 1.8), text(size: 14pt)[$X$])
      content((-0.2, 0), text(size: 14pt)[$Gamma$])
      content((0.5, 0.8), text(size: 14pt)[$U$])
      content((0, -4.3), text(size: 14pt)[(a)])
    }
  )),
  canvas({
    import draw: *
    content((),image("images/2024-10-20-12-46-26.png", width: 330pt))
    line((-2.07, 1.1), (-2.07, -0.2), mark: (start: "straight", end: "straight"), name: "gap")
    content((rel: (1, 0.0), to: "gap.mid"), text(size: 14pt)[Band gap])
    content((0, -3), text(size: 14pt)[(b)])
  }),
), caption: [(a) The Brillouin zone. (b) The band structure and density of states.]) <fig:bandstructure>

#question([Is NaCl a metal, semiconductor, or insulator? and why?])

== Understanding band structure

#align(center, grid(columns:2, gutter:50pt,
canvas({
  import draw: *
  circle((0, 0), radius: 1.0, stroke: none, fill: red.transparentize(80%), name:"e")
  circle((0, 0), radius: 0.2, stroke: none, fill: blue, name:"c")
  let n = 10
  let r = 1.2
  for i in range(n){
    let theta = i/n*calc.pi * 2
    let dx = r * calc.cos(theta)
    let dy = r * calc.sin(theta)
    line("c", (rel: (dx, dy), to: "c"), mark: (start: "straight", pos: 50%), stroke: (dash: "dashed"))
    line("c", (rel: (dx, dy), to: "c"), stroke: (dash: "dashed"))
  }
  content((0, -3.5), text(14pt)[Electronic cloud (red) around an atom
- *Symmtry*: Spherical symmetry
- *Quantum numbers*: n, l, m
])
}),
canvas({
  import draw: *
  let n = 5
  let dx = 0.5
  circle((0, 0), radius: ((n+1)*dx/2, 1), stroke: none, fill: red.transparentize(80%), name:"e")
  for i in range(n){
    circle((i*dx - (n - 1)*dx/2, 0), radius: 0.2, stroke: none, fill: blue, name: "c" + str(i))
  }
  let r = 1.2
  for i in range(n){
    for theta in (-calc.pi/2, calc.pi/2){
      let dx = r * calc.cos(theta)
      let dy = r * calc.sin(theta)
      line("c"+str(i), (rel: (dx, dy), to: "c"+str(i)), mark: (start: "straight", pos: 50%), stroke: (dash: "dashed"))
      line("c"+str(i), (rel: (dx, dy), to: "c"+str(i)), stroke: (dash: "dashed"))
    }
  }
  content((0, -3.5), text(14pt)[Electronic cloud (red) around a lattice
- *Symmtry*: Translational symmetry
- *Quantum numbers*: momentum $bold(k)$
])
})
))

- The "momentum" $bold(k)$ has finite values, they live in the *dual lattice* of the crystal.
- The unique values of $bold(k)$ lives in *Brillouin zone*, which has the same point group symmetry as its real space lattice. (Square lattice example)
- Walk through high symmetry points, we get the band structure. (Square lattice example)

== Learn more about band structure
#timecounter(2)

Course: *AMAT 5600*: Solid State Physics and Quantum Materials (PG course next semester)
#grid(columns: 2, gutter: 50pt,
  figure(image("images/2024-10-26-02-19-53.png", width: 150pt), numbering:none, caption: text(14pt)[Introduction to Solid State Physics\ by Charles Kittel]),
  text(size: 14pt, grid(columns: 2, gutter: 20pt,
  box(width: 200pt)[
    #figure(image("images/haoxiangli.png", width: 70pt, height: 100pt), numbering:none, caption: text(14pt)[Haoxiang Li, 李昊翔\ Office: W3 L5 505])
    - Quantum materials
    - Strongly correlated systems
  ],
  box(width: 200pt)[
    #figure(image("images/guoyizhu.jpg", width: 70pt, height: 100pt), numbering:none, caption: text(14pt)[Guoyi Zhu, 朱国毅\ Office: W4 L3 313])
    - Many-body physics
    - Topological phases of matter
  ],
  )
),
)

== Exercise: Searching CaTiO₃
#timecounter(2)

CaTiO₃ is a perovskite solar cell (PSC) that includes a *perovskite-structured* compound.

#align(center, grid(columns: 2, gutter: 40pt,
  image("images/2024-10-26-14-44-59.png", width:300pt),
  image("images/mp-4019.png", width:150pt),
))

== Search a material
#timecounter(2)

=== Search by formula
1. Login the website: https://next-gen.materialsproject.org/
2. Show the materials explorer: Type Ca-Ti-O in the search bar, and click the "Search" button.
3. Search formula: NaCl, Fe2O3, CaTiO3, etc.
4. Using broadcast: \*-O, \*2*3, etc.
=== Search by properties
1. Search band gap: 0.1-3.0eV (semiconductors)
2. Search stable materials: Energy above hull: 0-0.1 eV

= Access database through API

== Python libraries for materials analysis
- #link("https://next-gen.materialsproject.org/api")[The Materials Project API] is a RESTful web service that provides access to the Materials Project database.
- #link("https://pymatgen.org/")[Pymatgen] @Ong2013 is a robust, open-source Python library for materials analysis. It is based on the Materials Project database.
- #link("https://hackingmaterials.lbl.gov/matminer/")[Matminer] @Ward2018: An open source toolkit for materials data mining. In includes four commonly used materials databases: Citrination, Materials Project (MP), Materials Data Facility (MDF), and Materials Platform for Data Science (MPDS).

== Installation
#timecounter(2)

1. Please make sure you have a python with version >= 3.11.
2. To use the Materials Project API, you need to install the `mp-api` package:
  ```bash
  pip install mp-api
  ```

3. Type the following code in a Python REPL to verify your installation:
  ```python 
  from mp_api.client import MPRester
  ```

== Search materials by ID
#timecounter(3)

```python
with MPRester(api_key="your_api_key_here") as mpr:
    # retrieve SummaryDocs for a list of materials
    docs = mpr.summary.search(material_ids=["mp-149", "mp-13"])
```


How to get the API key?
1. Go to website: https://next-gen.materialsproject.org/, Click "Login or Register".
2. Click "API" in the top right corner, or just check #link("https://next-gen.materialsproject.org/api")[this link]. Move to the section "API Key" and you will see your API key.

== Live coding
#timecounter(10)

Visualizing the band structure of `mp-4019` (CaTiO₃).

// == Details page
// 1. Drag the lattice structure, configure the view.
// 2. The atom positions and the lattice system.
// 3. Show the band structure and density of states (total and partial). These properties are calculated by DFT.
// 4. Interactive plot, the Brillouin zone is shown.
// 8. How to cite the materials?
// 9. For questions, please check the forumn (https://matsci.org/c/materials-project/8)

== Final remarks
#timecounter(2)

=== Interact with the community (important)
1. Please feel free to ask questions on the forum (https://matsci.org/c/materials-project/8).
2. Please credit the helpful materials by citing them.

=== Next time

Numerical methods for molecular similation.

==
#bibliography("refs.bib")