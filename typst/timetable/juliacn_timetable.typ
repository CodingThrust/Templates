// Enhanced timetable template with modern Typst features
#set page(margin: 1cm)
#set text(font: "Arial", lang: "zh")

#align(center)[
  #block(spacing: 1.5em)[
    #text(size: 30pt, weight: "bold")[JuliaCN 2024 见面会]
    #v(3em)
  ]
]

#align(center, text(size: 10pt)[
  #figure(table(
    columns: (auto, auto, auto, auto),
    table.header(
      table.cell(fill: green.lighten(60%))[*时间*],
      table.cell(fill: green.lighten(60%))[*11月1日 \ 星期五 \ (注册日)*],
      table.cell(fill: green.lighten(60%))[*11月2日 \ 星期六 \ (W-4, 1楼, 101)*],
      table.cell(fill: green.lighten(60%))[*11月3日 \ 星期日 \ (W-4, 1楼, 101)*],
    ),
table.cell(rowspan:2)[*10:00-10:40*], table.cell(rowspan:2)[], table.cell(rowspan: 2)[通过变分量子算法探测多体贝尔关联 #v(0.1em) 
李炜康], table.cell(rowspan: 2)[边值微分代数方程的配点法求解器 #v(0.1em) 
曲庆宇],
[*11:00-11:40*], [], [KitAMR.jl: 分布式、自适应的非平衡流动求解器 #v(0.1em) 
葛龙庆], [QuantumClifford.jl 中的纠错码 #v(0.1em) 
鄢语轩],
[*12:00-14:00*], table.cell(colspan: 3)[午餐],
table.cell(rowspan: 2)[*14:00-14:40*], table.cell(rowspan: 2)[], table.cell(rowspan: 2)[在张量网络机器学习模型中制定无免费午餐理论 #v(0.1em) 
于立伟], table.cell([Hackathon],rowspan: 6,align: center + horizon),
table.cell(rowspan: 2)[*15:00-15:40*], table.cell(rowspan: 2)[], table.cell(rowspan: 2)[Julia 与量子速度极限101 #v(0.1em) 
余怀明], 
table.cell(rowspan: 2)[*16:00-16:40*], table.cell(rowspan: 2)[], table.cell(rowspan: 2)[TreeWidthSolver.jl: 从树宽度到张量网络收缩顺序 #v(0.1em) 
高煊钊], 
table.cell(rowspan: 1)[*18:00-19:00*], table.cell(colspan: 3)[晚餐],
table.cell(rowspan: 2)[*19:00-21:00*], table.cell(rowspan: 2)[新手教程: 高性能计算导引及其在 AI 中的应用 #v(0.1em) 
陈久宁], table.cell(rowspan:2)[], table.cell(rowspan:2)[],
table.cell(rowspan:2)[*21:00-21:40*], table.cell(rowspan: 2)[Symbolic-numerics. New methods we have that do better than traditional numerical solvers #v(0.1em) 
Chris Rackauckas (Online)], table.cell(rowspan:2)[], table.cell(rowspan:2)[],
table.cell(rowspan:2)[*22:00-22:40*], table.cell(rowspan: 2)[大型张量网络收缩技术及其应用 #v(0.1em) 
刘金国], table.cell(rowspan:2)[], table.cell(rowspan:2)[],
  ))
])
