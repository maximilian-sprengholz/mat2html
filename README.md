# mat2html
Stata .ado to export matrices as HTML tables

## Description
This program exports tables stored as matrix to valid HTML tables.  Labeling and some tweaking/styling is possible, however, styling is assumed to be done via CSS classes assigned to the written HTML table.  Useful in dynamic documents where some table output styling is desired. For Stata V13.0 or greater.

## Installation
```Stata
net install mat2html, from("https://raw.githubusercontent.com/maximilian-sprengholz/mat2html/master/pkg/")
```

## Example
This Stata code...

```Stata
// example matrix
mat M = matuniform(6,8)
forvalues c=1/8 {
   foreach r in 3 6 {
     mat M[`r',`c']=`c'*`r'*1000 // example N
  }
}

// export HTML table

local rowno = rowsof(M)

mat2html M using "mytable.html", ///
    f(rowm, flist(3 %9.0gc) panel (3)) /// every third row (N) formatted as %9.0gc
    par(par, rows(2(3)6)) /// enclose every second row (se) in the 3-row panel in parentheses
    rowl("b" "se" "N") /// add row labels
    coll("Model 1" "Model 2" "Model 3" "Model 4") colspan(2) /// add first set of col labels
    coltwol("Subpop1" "Subpop2") rep /// 2nd set
    class(my-example-class) /// you can see the class when looking at the HTML code
    note("My table note")
```
...creates the following table output of `mytable.html` (of course, the random cell contents will vary with reproduction):

<table class="my-example-class">
<thead>
<tr><th></th><th colspan="2">Model 1</th><th colspan="2">Model 2</th><th colspan="2">Model 3</th><th colspan="2">Model 4</th>
</tr>
<tr><th></th><th>Subpop1</th><th>Subpop2</th><th>Subpop1</th><th>Subpop2</th><th>Subpop1</th><th>Subpop2</th><th>Subpop1</th><th>Subpop2</th></tr>
</thead>
<tbody>
<tr><th>b</th><td>0.145</td><td>0.370</td><td>0.257</td><td>0.155</td><td>0.870</td><td>0.709</td><td>0.439</td><td>0.324</td>
</tr>
<tr><th>se</th><td>(0.895)</td><td>(0.978)</td><td>(0.802)</td><td>(0.349)</td><td>(0.488)</td><td>(0.609)</td><td>(0.724)</td><td>(0.565)</td>
</tr>
<tr><th>N</th><td>3,000</td><td>6,000</td><td>9,000</td><td>12,000</td><td>15,000</td><td>18,000</td><td>21,000</td><td>24,000</td>
</tr>
<tr><th>b</th><td>0.917</td><td>0.549</td><td>0.729</td><td>0.569</td><td>0.966</td><td>0.169</td><td>0.076</td><td>0.781</td>
</tr>
<tr><th>se</th><td>(0.153)</td><td>(0.735)</td><td>(0.084)</td><td>(0.414)</td><td>(0.828)</td><td>(0.552)</td><td>(0.664)</td><td>(0.490)</td>
</tr>
<tr><th>N</th><td>6,000</td><td>12,000</td><td>18,000</td><td>24,000</td><td>30,000</td><td>36,000</td><td>42,000</td><td>48,000</td>
</tr>
</tbody></table>
<span class="legend">My table note</span>

## Documentation
Please use the [help-file](pkg/mat2html.sthlp) installed with the package for details on syntax and options.

## Usage within dynamic documents
There are several possibilities to combine written text and Stata output within dynamic documents. Usually, the Stata output is directly included into the document as a code block: However, such tables look exactly like the ouput in the Stata results window. This might not be desired. Using mat2html, you write tables into extra HTML files which are then included into the HTML files generated by, for example, Stata's own [dyndoc](https://www.stata.com/manuals/pdyndoc.pdf) or Ben Jann's [webdoc](http://repec.sowi.unibe.ch/stata/webdoc/index.html) environment:

```Stata
//  Using dyndoc:
<<dd_include: "mytable.html">>

//  Using webdoc:
webdoc append "mytable.html"
```

Personally, I prefer to write Markdown/HTML and Stata code within editors like Atom providing syntax highlighting for multiple languages within a single file. You could, for example, use the package [markdown-preview-enhanced](https://github.com/shd101wyy/markdown-preview-enhanced) within Atom to include your HTML files at any place in the document, adding it to the DOM via:

```markdown
@import "mytable.html"
```

## Author
Maximilian Sprengholz<br />
Humboldt-Universität zu Berlin<br />
[maximilian.sprengholz@hu-berlin.de](mailto:maximilian.sprengholz@hu-berlin.de)
