#import "@preview/cetz:0.2.2": canvas, draw, tree, vector
#import "@preview/grape-suite:1.0.0": exercise
#import "lattices.typ": unitcell
#import exercise: project, task, subtask

#show: project.with(
  title: [Simulation Methods 1:\ Exploring Materials Database],
  institute: [Advanced Materials Thrust],
  university: [Hong Kong University of Science and Technology (Guangzhou)],
  seminar: [UCUG1702 - Introduction to Materials Science],
  show-outline: true,
  show-solutions: false,
  author: "Authors [Jinguo Liu]",
  task-type: "Quiz",
)

#show raw.where(lang:"python"): it=>{
  par(justify:false,block(fill:rgb("#f0fef0"),inset:1.5em,width:99%,text(it)))
}

#pagebreak()

= The Materials Project
#link("https://next-gen.materialsproject.org/")[The Materials Project] is a multi-institution, multi-national effort to compute the properties of all inorganic materials and provide the data and associated analysis algorithms for every materials researcher free of charge.


== Make a query through web
One can make a query through the web interface: https://next-gen.materialsproject.org/materials

#figure(image("images/explore-nacl.png"), caption: [The Materials Project])

- The star \u{2605} indicates that the material is experimentally observed.
- Material ID: can be useful for accessing the database through the API. #v(1em)
- Cristal System: The crystal system of the material.
- Spacegroup: The space group of the material.
- Sites: The number of atoms in the unit cell. #v(1em)
- Energy Above Hull: The energy above the hull is the minimum energy required to remove an electron from the material.
- Band Gap: The band gap is the energy difference between the valence band and the conduction band.

=== Energy above hull and thermodynamic stability

The formation energy of a material defines the energy required to dissociate that material into its respective elements. It indicates the thermodynamic stability (room temperature $approx$ 0.025 eV) against the elements it consists of.
Usually, the density functional theory (DFT) based first-principles calculations are performed to calculate the formation energy.
Formation energy indicates only whether the material is stable with respect to the constituent elements. However, the main enemy of the material is other competing phases rather than the constituent elements.
The energy above the hull is a measure of the thermodynamic stability of the material against other competing phases, which measures how likely the material is to decompose to other phases. The larger the energy above the hull, the more likely the material is to decompose to other phases.

#figure(image("images/2024-10-20-12-15-46.png", width: 300pt), caption: [Energy above the convex hull. (Image source: @Bartel2022)]) <fig:energyabovehull>

As illustrated in @fig:energyabovehull, for a formula of $A_(1-x)B_x$, multiple compounds can be formed. By plotting the formation energy as a function of $x$, we can find the convex hull. The energy above the hull is the difference between the formation energy and the convex hull. If a material is thermodynamically stable, the energy above the hull must be equal to zero.
For example, in the plot, both $A$ and $A X$ are thermodynamically stable. Then the compound $A_2 X$ is thermodynamically unstable if the energy above the hull $Delta E_d$ is larger than zero, because by decomposing $A_2 X$ into $A$ and $A X$, the energy gain is larger than the energy cost by $Delta E_d$.
On the other hand, it does not mean that $A_2 X$ cannot be synthesized. To decompose $A_2 X$ into $A$ and $A X$, energy barrier must be overcome, which may be a very slow process.

=== Crystal structure and symmetry
The space group description of the salt crystal structure of NaCl (mp-22862) is:
- Crystal System: Cubic
- Lattice System: Cubic
- Hall Number: -F 4 2 3
- International Number: 225
- Symbol: $F m overline(3) m$
- Point Group: $m overline(3) m$

Both the crystal system and lattice system are cubic.By checking the following table, we know the defining symmetry of cubic crystal system is the 4 three fold axies of rotaton.
#align(center)[
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
  [*Hexagonal*], [1 sixfold axis of rotation],	[7],	[27],
  [*Cubic*],	[4 threefold axes of rotation],	[5],	[Cubic],	[36],
  table.cell(fill: green.lighten(60%))[7],
  table.cell(fill: green.lighten(60%))[*Total*],
  table.cell(fill: green.lighten(60%))[32],
  table.cell(fill: green.lighten(60%))[7],
  table.cell(fill: green.lighten(60%))[230]
  ), caption: [Crystal system, lattice system and space groups]) <tbl:crystalsystem>
]

The international number 225, Hall number -F 4 2 3, and Symbol $F m overline(3) m$ are different ways to represent the same space group. By checking its space group $F m overline(3) m$ (Source: https://www.globalsino.com/EM/page3025.html), the 48 symmetry group operations can be resolved as follows:
#align(center, table(stroke: none, inset: 4pt, column-gutter: 15pt,
columns: (auto, auto, auto, auto, auto),
[$x, y, z$], [$-x, -y, z$], [$-x, y, -z$], [$x, -y, -z$],
[$z, x, y$], [$z, -x, -y$], [$-z, -x, y$], [$-z, x, -y$],
[$y, z, x$], [$-y, z, -x$], [$y, -z, -x$], [$-y, -z, x$],
[$y, x, -z$], [$-y, -x, -z$], [$y, -x, z$], [$-y, x, z$],
[$x, z, -y$], [$-x, z, y$], [$-x, -z, -y$], [$x, -z, y$],
[$z, y, -x$], [$z, -y, x$], [$-z, y, x$], [$-z, -y, -x$],
[$-x, -y, -z$], [$x, y, -z$], [$x, -y, z$], [$-x, y, z$],
[$-z, -x, -y$], [$z, x, -y$], [$z, -x, y$], [$-z, x, y$],
[$-y, -z, -x$], [$y, z, -x$], [$y, -z, x$], [$-y, z, x$],
[$-y, x, -z$], [$y, -x, -z$], [$y, x, z$], [$-y, -x, z$],
[$x, z, -y$], [$-x, z, y$], [$-x, -z, -y$], [$x, -z, y$],
[$z, y, -x$], [$z, -y, x$], [$-z, y, x$], [$-z, -y, -x$],
[$-x, -y, -z$], [$x, y, -z$], [$x, -y, z$], [$-x, y, z$],
[$-z, -x, -y$], [$z, x, -y$], [$z, -x, y$], [$-z, x, y$],
[$-y, -z, -x$], [$y, z, -x$], [$y, -z, x$], [$-y, z, x$],
[$-y, x, -z$], [$y, -x, -z$], [$y, x, z$], [$-y, -x, z$],
[$x, z, -y$], [$-x, z, y$], [$-x, -z, -y$], [$x, -z, y$],
[$z, y, -x$], [$z, -y, x$], [$-z, y, x$], [$-z, -y, -x$],
[$-y, 1/2+x, 1/2+z$], [$x, 1/2+z, 1/2-y$], [$-x, 1/2+z, 1/2+y$], [$-x, 1/2-z, 1/2-y$],
[$x, 1/2-z, 1/2+y$], [$z, 1/2+y, 1/2-x$], [$z, 1/2-y, 1/2+x$], [$-z, 1/2+y, 1/2+x$],
[$-z, 1/2-y, 1/2-x$], [$-x, 1/2-y, 1/2-z$], [$x, 1/2-y, 1/2-z$], [$x, 1/2+y, 1/2+z$],
[$-z, -x, -y$], [$z, x, -y$], [$z, -x, y$], [$-z, x, y$],
))

Each term in the table represents a symmetry operation. For example, the entry $-x, z, y$ means the atom at $x, y, z$ is transformed to $-x, z, y$.
A crystal possesses this symmetry means that if we can find an atom at $x, y, z$, then we can also find an atom at $-x, z, y$.

Together with the Wyckoff positions, we can visualize the crystal structure.
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
#figure(
  grid(columns: 2, gutter: 20pt,
    align(horizon, canvas(length: 0.8cm, {
      import draw: *
      content((),image("images/NaCl-Fm-3m.png", width: 150pt))
        content((2, -0.3), [Cl])
        content((1, -1.4), [Na])
        content((1.3, -0.3), [a])
        content((0.5, -0.3), [b])
        content((0.35, -0.6), [c])
        content((0.85, -0.2), text(blue)[$gamma$])
        content((0.1, 0.7), text(blue)[$beta$])
        content((1.3, 0.5), text(blue)[$alpha$])
      })
    ),
    table(columns: (auto, auto),
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
  )),
  caption: [The crystal structure of NaCl. The lattice vectors are $a$, $b$, $c$, and the angles are $alpha = angle(b, c)$, $beta = angle(a, c)$, $gamma = angle(a, b)$. (Image source: The Materials Project)]
)

=== Wyckoff Positions
- Ref: https://pyxtal.readthedocs.io/en/latest/Background.html
To complete defining a cyrstal structure, a final piece is required, which is the Wyckoff positions of different spicies of atoms.
Because symmetry operations can be thought of as making copies of parts of an object, we can usually only describe part of a structure, and let symmetry generate the rest. This small part of the structure used to generate the rest is called the asymmetric unit. However, not all points in the asymmetric unit are generated the same. If an atom lies within certain regions - planes, lines, or points - then the atom may not be “copied” as many times as other atoms within the asymmetric unit. A familiar example is in the creation of a paper snowflake. We start with a hexagon, then fold it into a single triangle 6 sheets thick. Then, if we cut out a mark somewhere in the middle of the triangle, the mark is copied 6-fold. However, if we instead cut out a mark alonng the triangle’s edge, or at the tip, the marks will only have 3 or 1 copies:

#figure(image("images/2024-10-26-16-49-41.png", width: 100pt))

These different regions are called Wyckoff positions, and the number of copies is called the multiplicity of the Wyckoff position. So, if an atom lies in a Wyckoff position with multiplicity greater than 1, then that Wyckoff position actually corresponds to multiple atoms. However, thanks to symmetry, we can refer to all of the copies (for that particular atom) as a single Wyckoff position. This makes describing a crystal much easier, since we no longer need to specify the exact location of most of the atoms. Instead, we need only list the space group, the lattice, and the location and type of one atom from each Wyckoff position. Just keep in mind that in this format, a single atomic entry may correspond to multiple atoms in the unit cell.

The largest Wyckoff position, which makes a copy for every symmetry operation, is called the general Wyckoff position, or just the _general position_. In the snowflake example, this was the large inner region of the triangle. In general, the general position will consist of every location which does not lie along some special symmetry axis, plane, or point. For this reason, the other Wyckoff positions are called the _special Wyckoff positions_.

The number and type of Wyckoff positions are different for every space group; a list of them can be found using the Bilbao utility WYCKPOS (). In the utility, (TODO: point to the resource)

Wyckoff positions are described using the $x,y,z$ notation, where each operation shows how the original $\(x,y,z\)$ point is transformed/copied. In other words, if we choose a single set of coordinates, then plugging these coordinates into the Wyckoff position will generate the remaining coordinates. As an example, consider the general position of space group P222 (\#16), which consists of the points $\(x,y,z\)$, $\(-x,-y,z\)$, $\(-x,y,-z\)$, and $\(x,-y,-z\)$. If we choose a random point, say $\(0.321,0.457,0.892\)$, we can determine the remaining points:

$
\(x,y,z\) arrow.r (0.321,0.457,0.892) \
\(-x,-y,z\) arrow.r (0.679,0.543,0.892) \
\(-x,y,-z\) arrow.r (0.679,0.457,0.108) \
\(x,-y,-z\) arrow.r (0.321,0.543,0.108)
$
Here a negative value is equal to 1 minus that value $(-0.321 = 1 - 0.321 = 0.679)$.

To denote Wyckoff positions, a combination of number and letter is used. The number gives the multiplicity of the Wyckoff position, while the letter differentiates between positions with the same multiplicity. The letter 'a' is always given to the smallest Wyckoff position (usually located at the origin or z axis), and the letter increases for positions with higher multiplicity. So, for example, the space group I4mm (\#107) has 5 different Wyckoff positions: 2a, 4b, 8c, 8d, and 16e. Here, 16e is the general position, since it has the largest multiplicity and last letter alphabetically.

Note that for space groups with non-simple lattices (those which begin with a letter other than 'P'), the Wyckoff positions also contain fractional translations. Take for example the space group I4mm (\#107). The Bilbao entry can be found at the url. Each listed Wyckoff position coordinate has a copy which is translated by $\(0.5,0.5,0.5\)$. It is inconvenient to list each of these translated copies for every Wyckoff position, so instead a note is placed at the top. This is why Wyckoff position 16e has only 8 points listed. In this case, to generate the full crystal, one could apply the 8 operations listed, then make a copy of the resulting structure by translating it by the vector $\(0.5,0.5,0.5\)$. Note that in space groups beginning with letters other than P, the smallest Wyckoff position will never have a multiplicity of 1.

In addition to the generating operations, the site symmetry of each Wyckoff position is listed. The site symmetry is just the point group which leaves the Wyckoff position invariant. So, if a Wyckoff position consists of an axis, then the site symmetry might be a rotation about that axis. The general position always has site symmetry 1, since it corresponds to choosing any arbitrary structure or location can be made symmetrical by copying it and applying all of the operations in the space group.

Finally, since crystals are infinitely periodic, a Wyckoff position refers not only to the atoms inside a unit cell, but every periodic copy of those atoms in the other unit cells. Thus, the Wyckoff position $\(x,y,z\)$ is the same as the position $\(x+1,y+1,z\)$, and so on. This is usually a minor detail, but it must be taken into account for certain computational tasks.

=== Band structure and band gap

Quantum many-body dynamics is generally intractable, making materials simulation a challenging task. However, in many cases, the electrons are not so strongly correlated, and we can treat them as single particles. The rest part, including the nuclei and the other electrons, is treated as a potential $V(bold(r))$. We are quite familiar with solving the Schrödinger equation for a single particle, since we already encoutered it in the context of the atomic structure.
In the atomic case, the potential is the *spherical symmetric* Coulomb potential, and the single-particle wavefunction is the atomic orbital labeled by the quantum numbers $n, l, m$.
In the solid case, the potential is the *translational invariant potential*, and the single-particle wavefunction is the Bloch wavefunction labeled by the crystal momentum (or wave vector) $bold(k)$.

#align(center, figure(grid(columns:2, gutter:50pt,
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
  content((0, -2), [
Potential: $V(bold(r)) = V(|bold(r)|)$\
Quantum numbers: $n, l, m$])
  content((0, -2.8), [(a)])
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
  content((0, -2), [
Potential: $V(bold(r)) = V(bold(r) + bold(R))$\
Quantum numbers: $bold(k)$])
  content((0, -2.8), [(b)])
})),
caption: [
(a) Electron cloud (red) around an spherical symmetry
(b) Electron cloud (red) around a translational invariant lattice potential, where $bold(R)$ is a lattice vector.
]))

$bold(k)$ has discrete values, just like $n, l, m$ have discrete values. They live in the *dual lattice* of the crystal, i.e. have a periodic structure. The unit cell of the dual lattice is called the *Brillouin zone*. Unsupprisingly, the Brillouin zone has the same point group symmetry as its real space lattice.
By walking through high symmetry points (e.g. $Gamma$, $X$, $W$, $K$, $L$ below), we get the band structure.
Although the band looks continuous, it is actually a series of many discrete energy levels. By counting the number of energy levels at each energy value, we get the density of states.


#figure(grid(columns: 2, gutter: 20pt,
  align(horizon, canvas(length: 0.8cm,
    {
      import draw: *
      content((),image("images/2024-10-20-12-39-56.png", width: 120pt), caption: [Band structure of CaTiO₃. (Image source: The Materials Project)])
      content((1.2, 1.8), [$W$])
      content((1.8, 1.5), [$K$])
      content((1.4, 0), [$L$])
      content((0, 1.8), [$X$])
      content((-0.2, 0), [$Gamma$])
      content((0.5, 0.8), [$U$])
      content((0, -4.3), [(a)])
    }
  )),
  canvas({
    import draw: *
    content((),image("images/2024-10-20-12-46-26.png", width: 330pt))
    line((-2.07, 1.1), (-2.07, -0.2), mark: (start: "straight", end: "straight"), name: "gap")
    content((rel: (0.8, 0.0), to: "gap.mid"), "Band gap")
    content((0, -3), [(b)])
  }),
), caption: [The electronic properties of NaCl. (a) The Brillouin zone. (b) The band structure and density of states.]) <fig:bandstructure>

= Case study: CaTiO₃
Calcium titanate (CaTiO₃) is Orthorhombic Perovskite structured. The material ID is `mp-4019`: https://next-gen.materialsproject.org/materials/mp-4019

#grid(figure(image("images/mp-4019.png", width:130pt), caption: [The crystal structure of CaTiO₃.], numbering: none),
table(columns: (auto, auto, auto),
  table.header(
    table.cell(fill: green.lighten(60%))[],
    table.cell(fill: green.lighten(60%))[*Property*],
    table.cell(fill: green.lighten(60%))[*Value*],
  ),
  table.cell(rowspan: 2)[Meta data], [Material ID], [mp-4019],
  [Experimentally Observed], [Yes],
  table.cell(rowspan: 3)[Energy],
  [Energy Above Hull], [0.000 eV/atom],
  [Band Gap], [2.31 eV],
  [Predicted Formation Energy], [-3.453 eV/atom],
  table.cell(rowspan: 2)[Magnetic property], [Magnetic Ordering], [Non-magnetic],
  [Total Magnetization], [0.00 µB/f.u.],
  table.cell(rowspan: 4)[Physical properties], [Number of Atoms], [20],
  [Density], [4.03 g·cm⁻³],
  [Dimensionality], [3D],
  [Possible Oxidation States], [Ca²⁺, Ti⁴⁺, O²⁻],
), columns: 2, gutter: 20pt)

The space group description of CaTiO₃ is:
- Crystal System: Orthorhombic
- Lattice System: Orthorhombic
- Hall Number: -P 2ac 2n
- International Number: 62
- Symbol: Pnma
- Point Group: mmm

The international number, Hall number, and Symbol are different ways to represent the same space group. 
With the following information, we can visualize the crystal structure.
#align(center, grid(columns:2, table(columns: (auto, auto),
table.header(
  table.cell(fill: green.lighten(60%))[*Lattice \ Parameters*],
  table.cell(fill: green.lighten(60%))[*Values*],
),
[$a$], [$5.37 angstrom$],
[$b$], [$5.46 angstrom$],
[$c$], [$7.64 angstrom$],
[$alpha$], [$90.00 degree$],
[$beta$], [$90.00 degree$],
[$gamma$], [$90.00 degree$],
), [#unitcell("orthorhombic")], gutter: 68pt))

#align(center, table(columns: (auto, auto, auto, auto, auto),
  table.header(
    table.cell(fill: green.lighten(60%))[*Wyckoff site*],
    table.cell(fill: green.lighten(60%))[*Element*],
    table.cell(fill: green.lighten(60%))[*x*],
    table.cell(fill: green.lighten(60%))[*y*],
    table.cell(fill: green.lighten(60%))[*z*],
  ),
  [4b], [Ti], [0], [1/2], [1/2],
  [4c], [Ca], [0.509067], [0.542398], [3/4],
  [4c], [O], [0.076781], [0.481328], [3/4],
  [8d], [O], [0.790294], [0.789614], [0.959841],
))

Please refer to #link("https://opengeology.org/Mineralogy/10-crystal-morphology-and-symmetry/")[Crystal morphology and symmetry] for more details.



// #figure(image("LaNiO3.png"), caption: [The Material Details Page])

// Q:
// 1. What are Bravais lattices?
// 2. What is the difference between point group and space groups?

= Access database through API

== Pull data from the material project

1. Go to website: https://next-gen.materialsproject.org/, Click "Login or Register".
2. Click "API" in the top right corner, or just check #link("https://next-gen.materialsproject.org/api")[this link]. Move to the section "API Key" and you will see your API key.
3. To use the Materials Project API, you need to install the `mp-api` package:
  ```bash
  pip install mp-api
  ```
  Please make sure you have a python version >= 3.11 (helpful links: #link("https://docs.anaconda.com/miniconda/")[Miniconda]).

4. Then you can use the following Python code to retrieve a list of materials:
  ```python 
  from mp_api.client import MPRester

  with MPRester(api_key="your_api_key_here") as mpr:
      # retrieve SummaryDocs for a list of materials
      docs = mpr.summary.search(material_ids=["mp-149", "mp-13"])
  ```

== Band structure visualization with `pymatgen`

#link("https://pymatgen.org/")[Pymatgen (Python Materials Genomics)] is a robust, open-source Python library for materials analysis. It is based on the Materials Project database, and its has already been installed when you install the `mp-api` package.

```python
from mp_api.client import MPRester
from pymatgen.electronic_structure.core import Spin
with MPRester(api_key="your_api_key_here") as mpr:
    bs = mpr.get_bandstructure_by_material_id("mp-4019")
    # is the material a metal (i.e., the fermi level cross a band)
    print(bs.is_metal())
    # print information on the band gap
    print(bs.get_band_gap())
    # print the energy of the 20th band and 10th kpoint
    print(bs.bands[Spin.up][20][10])
    # print energy of direct band gap
    print(bs.get_direct_band_gap())
    # print information on the vbm
    print(bs.get_vbm())

# visualization
from pymatgen.electronic_structure.plotter import BSPlotter
plotter = BSPlotter(bs)

# plot the band structure
plotter.show()

# plot the brillouin zone
plotter.plot_brillouin()
```

== Matminer: An open source toolkit for materials data mining

Four commonly used materials databases in matminer@Ward2018 are:
1. #link("https://citrination.com")[Citrination]@Michel2016.
2. #link("https://materialsproject.org/")[The Materials Project (MP)]@Jain2013
3. #link("https://github.com/materials-data-facility/forge")[The Materials Data Facility (MDF)]
4. #link("https://mpds.io/")[The Materials Platform for Data Science (MPDS)]
5. #link("https://www.mongodb.com/")[MongoDB]

#pagebreak()
= Appendix
== All 230 space groups

Source: http://pd.chem.ucl.ac.uk/pdnn/symm3/allsgp.htm and http://img.chem.ucl.ac.uk/sgp/large/sgp.htm

#table(columns: (auto, auto, auto, auto, auto),
  table.header(
    table.cell(fill: green.lighten(60%))[*Crystal \ System*],
    table.cell(fill: green.lighten(60%))[*Laue \ Class*],
    table.cell(fill: green.lighten(60%))[*Crystal \ Class*],
    table.cell(fill: green.lighten(60%))[*Lattice \ Centering*],
    table.cell(fill: green.lighten(60%))[*230 3D Space Groups*],
  ),
  table.cell(rowspan: 2)[Triclinic], table.cell(rowspan: 2)[-1], [1], table.cell(rowspan: 2)[P], [P1],
  [-1], [P-1],
  table.cell(rowspan: 6)[Monoclinic], table.cell(rowspan: 6)[2/m], table.cell(rowspan: 2)[2], [P], [P2, P2#sub[1]],
  [C], [C2],
  table.cell(rowspan: 2)[m], [P], [Pm, Pc],
  [C], [Cm, Cc],
  table.cell(rowspan: 2)[2/m], [P], [P2/m, P2#sub[1]m, P2/c, P2#sub[1]c],
  [C], [C2/m, C2/c],
  table.cell(rowspan: 12)[Orthorhombic], table.cell(rowspan: 12)[mmm], table.cell(rowspan: 4)[222], [P], [P222, P222#sub[1], P2#sub[1]2#sub[1]2, P2#sub[1]2#sub[1]2#sub[1]],
  [C], [C222, C222#sub[1]],
  [F], [F222],
  [I], [I222, I2#sub[1]2#sub[1]2#sub[1]],
  table.cell(rowspan: 4)[mm2], [P], [Pmm2, Pmc2#sub[1], Pcc2, Pma2, Pca2#sub[1], Pnc2, Pmn2#sub[1], Pba2, Pna2#sub[1], Pnn2],
  [C or A], [Cmm2, Cmc2#sub[1], Ccc2, Amm2, Abm2, Ama2, Aba2],
  [F], [Fmm2, Fdd2],
  [I], [Imm2, Iba2, Ima2],
  table.cell(rowspan: 4)[mmm], [P], [Pmmm, Pnnn, Pccm, Pban, Pmma, Pnna, Pmna, Pcca, Pbam, Pccn, Pbcm, Pnnm, Pmmn, Pbcn, Pbca, Pnma],
  [C], [Cmmm, Cmcm, Cmca, Cccm, Cmma, Ccca],
  [F], [Fmmm, Fddd],
  [I], [Immm, Ibam, Ibcm, Imma],
  table.cell(rowspan: 16)[Tetragonal], table.cell(rowspan: 6)[4/m], table.cell(rowspan: 2)[4], [P], [P4, P4#sub[1], P4#sub[2], P4#sub[3]],
  [I], [I4, I4#sub[1]],
  table.cell(rowspan:2)[-4], [P], [P-4],
  [I], [I-4],
  table.cell(rowspan: 2)[4/m], [P], [P4/m, P4#sub[2]/m, P4/n, P4#sub[2]/n],
  [I], [I4/m, I4#sub[1]/a],
  table.cell(rowspan: 10)[4/mmm], table.cell(rowspan: 2)[422], [P], [P422, P42#sub[1]2, P4#sub[1]22, P4#sub[1]2#sub[1]2, P4#sub[2]22, P4#sub[2]2#sub[1]2, P4#sub[3]22, P4#sub[3]2#sub[1]2],
  [I], [I422, I42#sub[1]2],
  table.cell(rowspan: 2)[4mm], [P], [P4mm, P4bm, P4#sub[2]cm, P4#sub[2]nm, P4cc, P4nc, P4#sub[2]mc, P4#sub[2]bc],
  [I], [I4mm, I4cm, I4#sub[1]md, I4#sub[1]cd],
  table.cell(rowspan: 2)[-42m], [P], [P-42m, P-42c, P-42#sub[1]m, P-42#sub[1]c],
  [I], [I-42m, I-42d],
  table.cell(rowspan: 2)[-4m2], [P], [P-4m2, P-4c2, P-4b2, P-4n2],
  [I], [I-4m2, I-4c2],
  table.cell(rowspan: 2)[4/mmm], [P], [P4/mmm, P4/mcc, P4/nbm, P4/nnc, P4/mbm, P4/mnc, P4/nmm, P4/ncc, P4#sub[2]/mmc, P4#sub[2]/mcm, P4#sub[2]/nbc, P4#sub[2]/nnm, P4#sub[2]/mbc, P4#sub[2]/mcm, P4#sub[2]/nmc, P4#sub[2]/ncm],
  [I], [I4/mmm, I4/mcm, I4#sub[1]/amd, I4#sub[1]/acd],
  table.cell(rowspan: 13)[Trigonal], table.cell(rowspan: 4)[-3], table.cell(rowspan: 2)[3], [P], [P3, P3#sub[1], P3#sub[2]],
  [R], [R3],
  table.cell(rowspan: 2)[-3], [P], [P-3],
  [R], [R-3],
  table.cell(rowspan: 9)[-3m], [312], table.cell(rowspan: 2)[P], [P312, P3#sub[1]12, P3#sub[2]12],
  table.cell(rowspan: 2)[321], [P321, P3#sub[1]21, P3#sub[2]21],
  [R], [R32],
  [31m], table.cell(rowspan: 2)[P], [P31m, P31c],
  table.cell(rowspan: 2)[3m1], [P3m1, P3c1],
  [R], [R3m, R3c],
  [-31m], table.cell(rowspan: 2)[P], [P-31m, P-31c],
  table.cell(rowspan: 2)[-3m1], [P-3m1, P-3c1],
  [R], [R-3m, R-3c],
  table.cell(rowspan: 8)[Hexagonal], table.cell(rowspan: 3)[6/m], [6], table.cell(rowspan: 8)[P], [P6, P6#sub[1], P6#sub[2], P6#sub[3], P6#sub[4], P6#sub[5]],
  [-6], [P-6],
  [6/m], [P6/m, P6#sub[3]/m],
  table.cell(rowspan: 5)[6/mmm], [622], [P622, P6122, P6222, P6322, P6422, P6522],
  [6mm], [P6mm, P6cc, P6#sub[3]cm, P6#sub[3]mc],
  [-6m2], [P-6m2, P-6c2],
  [-62m], [P-62m, P62c],
  [6/mmm], [P6/mmm, P6/mcc, P6#sub[3]/mcm, P6#sub[3]/mmc],
  table.cell(rowspan: 15)[Cubic], table.cell(rowspan: 6)[m-3], table.cell(rowspan: 3)[23], [P], [P23, P2#sub[1]3],
  [F], [F23],
  [I], [I23, I2#sub[1]3],
  table.cell(rowspan: 3)[m-3], [P], [Pm-3, Pn-3, Pa-3],
  [F], [Fm-3, Fd-3],
  [I], [Im-3, Ia-3],
  table.cell(rowspan: 9)[m-3m], table.cell(rowspan: 3)[432], [P], [P432, P4#sub[2]32, P4#sub[3]32, P4#sub[1]32],
  [F], [F432, F4#sub[1]32],
  [I], [I432, I4#sub[1]32],
  table.cell(rowspan: 3)[-43m], [P], [P-43m, P-43n],
  [F], [F-43m, F-43c],
  [I], [I-43m, I-43d],
  table.cell(rowspan: 3)[m-3m], [P], [Pm-3m, Pn-3n, Pm-3n, Pn-3m],
  [F], [Fm-3m, Fm-3c, Fd-3m, Fd-3c],
  [I], [Im-3m, Ia-3d],
)

== Colab notebook
https://colab.research.google.com/drive/1d_JOp2sTzBds4EAycePP-UDhapOQpIr9?usp=sharing

#pagebreak()
#bibliography("refs.bib")

