#import "@preview/cetz:0.4.1": canvas, draw, tree, vector

#let norm(a) = calc.sqrt(a.map(a=>a*a).sum())
#let normalize(a) = {
    let na = norm(a)
    return a.map(x=>x/na)
  }

#let drawangle(p1, pmid, p2, isrect:false, radius:0.2, color: black) = {
  import draw: *
  let a1 = normalize(vector.sub(p1, pmid)).map(x=>x*radius)
  let a2 = normalize(vector.sub(p2, pmid)).map(x=>x*radius)
  if isrect {
    line(vector.add(pmid, a1), vector.add(pmid, vector.add(a1, a2)), vector.add(pmid, a2), stroke: color)
  } else {
    arc-through(vector.add(pmid, a1), vector.add(pmid, vector.add(a1, a2)), vector.add(pmid, a2), stroke: color)
  }
}


#let show-unitcell(ta, a, tb, b, tc, c, angle1, angle2, angle3) = {
  import draw: *
  line((0, 0), a)
  line((0, 0), b)
  line((0, 0), c)

  let ab = (a.at(0) + b.at(0), a.at(1) + b.at(1))
  let ac = (a.at(0) + c.at(0), a.at(1) + c.at(1))
  let bc = (b.at(0) + c.at(0), b.at(1) + c.at(1))
  let abc = (a.at(0) + b.at(0) + c.at(0), a.at(1) + b.at(1) + c.at(1))
  line(a, ab)
  line(a, ac)
  line(b, bc)
  line(b, ab)
  line(c, bc)
  line(c, ac)
  line(abc, ab)
  line(abc, ac)
  line(abc, bc)
  drawangle(a, ac, abc, isrect:angle1, color:green)
  drawangle(abc, ac, c, isrect:angle2, color:green)
  drawangle(a, ac, c, isrect:angle3, color:green)
  for (node, name) in ((a, ta), (b, tb), (c, tc)){
    content((node.at(0) / 2, node.at(1) / 2), text(12pt)[$#name$], fill: white, stroke: none, frame: "rect", padding: 0.1)
  }
}

#let unitcell(name, length:1cm) = canvas({
  if name == "cubic" {
    // cubic: a = b = c, alpha = beta = gamma = 90
    show-unitcell("a", (0, 2), "a", (1, 1), "a", (2, 0), true, true, true)
  } else if name == "tetragonal" {
    // tetragonal: a = b != c, alpha = beta = gamma = 90
    show-unitcell("c", (0, 3), "a", (1, 1), "a", (2, 0), true, true, true)
  } else if name == "orthorhombic" {
    // orthorhombic: a != b != c, alpha = beta = gamma = 90
    show-unitcell("c", (0, 3), "b", (1, 0.6), "a", (2, 0), true, true, true)
  } else if name == "rhombohedral" {
    // rhombohedral: a = b = c, alpha = beta = gamma != 90
    show-unitcell("a", (0.9, 1.4), "a", (0, 1.2), "a", (-0.9, 1.4), false, false, false)
  } else if name == "hexagonal" {
    // Hexagonal: a = b != c, alpha = beta = 90, gamma = 120
    show-unitcell("c", (0, 3), "a", (1.2, 0.8), "a", (2, 0), false, true, true)
  } else if name == "monoclinic" {
    // Monoclinic: a != b != c, alpha = gamma = 90 != beta
    show-unitcell("c", (0.5, 1.5), "b", (1.3, 1.2), "a", (2, 0), true, true, false)
  } else if name == "triclinic" {
    // Triclinic: a != b != c, alpha != beta != gamma != 90
    show-unitcell("c", (0.5, 1.5), "b", (1.3, 0.5), "a", (2, 0), false, false, false)
  }
}, length: length)


// #for name in ("cubic", "tetragonal", "orthorhombic", "rhombohedral", "hexagonal", "monoclinic", "triclinic") {
//     unitcell(name, length: 1cm)
// }