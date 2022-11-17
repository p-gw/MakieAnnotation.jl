using CairoMakie
using MakieAnnotation
using RDatasets

mtcars = dataset("datasets", "mtcars")

f, ax = scatter(mtcars.MPG, mtcars.HP)
voronoilabels!(mtcars.MPG, mtcars.HP, mtcars.Model)
