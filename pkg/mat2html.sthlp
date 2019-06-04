{smcl}
{* *! version 0.9  04jun2019}{...}
{hi:help mat2html}{...}
{right:Jump to: {help mat2html##syntax:Syntax}, {help mat2html##description:Description}, {help mat2html##options:Options}, {help mat2html##examples:Examples}, {help mat2html##usage:Usage within dynamic documents}}
{hline}

{title:Title}

{pstd}
{hi: mat2html()} {hline 2} Export matrices as HTML tables

{marker syntax}{...}
{title:Syntax}

{p 4 29 2}
{cmdab:mat2html}
{it:name}
[ using {it: filename} ]
{cmd:,}
[
{it: options}
]

{pstd}
where {it:name} is the name of the matrix to be converted to a HTML table.
If you do not specifiy a filename, the HTML file will be saved in the current
working directory under "mat2html_{it:name}".

{synoptset 35}{...}
{p2col:Options}Description{p_end}
{synoptline}
{p2col:{cmd:Format(}{it:string [, suboptions]}{cmd:)}}Numerical formatting for rows/columns{p_end}
{p2col:{cmd:PARentheses(}{it:string [, suboptions]}{cmd:)}}Parentheses or brackets for rows/columns{p_end}
{p2col:{cmd:ROWLabels(}{it:string}{cmd:)}}First set of row labels{p_end}
{p2col:{cmd:COLLabels(}{it:string}{cmd:)}}First set of column labels{p_end}
{p2col:{cmd:ROWTWOLabels(}{it:string}{cmd:)}}Second set of row labels{p_end}
{p2col:{cmd:COLTWOLabels(}{it:string}{cmd:)}}Second set of column labels{p_end}
{p2col:{cmd:ROWSpan(}{it:int}{cmd:)}}Rows to be spanned by first set of row labels{p_end}
{p2col:{cmd:COLSpan(}{it:int}{cmd:)}}Columns to be spanned by first set of column labels{p_end}
{p2col:{cmd:ROWTWOSpan(}{it:int}{cmd:)}}Rows to be spanned by second set of row labels{p_end}
{p2col:{cmd:COLTWOSpan(}{it:int}{cmd:)}}Columns to be spanned by second set of column labels{p_end}
{p2col:{cmd:ADDRows(}{it:numlist}{cmd:)}}Add empty rows to table{p_end}
{p2col:{cmd:ADDCols(}{it:numlist}{cmd:)}}Add empty columns to table{p_end}
{p2col:{cmd:Title(}{it:string}{cmd:)}}Add title to table{p_end}
{p2col:{cmd:Class(}{it:str}{cmd:)}}Assign CSS classes to table{p_end}
{p2col:{cmd:Note(}{it:string}{cmd:)}}Add note to table{p_end}
{p2col:{cmd:PRETable(}{it:string}{cmd:)}}Add text/code to be printed before table code{p_end}
{p2col:{cmd:POSTTable(}{it:string}{cmd:)}}Add text/code to be printed after table code{p_end}
{p2col:{cmd:POSTHead(}{it:string}{cmd:)}}Add table code before </thead>{p_end}
{p2col:{cmd:append}}Append table to specified file (default: replace){p_end}
{p2colset 5 30 31 2}{...}
{p2line}

{marker description}{...}
{title:Description}

{pstd}
This program exports tables stored as matrix to valid HTML tables.
Labeling and some tweaking/styling is possible, however, styling is assumed to
be done via CSS classes assigned to the written HTML table.
Useful in dynamic documents where some table output styling is desired.

{marker options}
{title:Options}

{p 4 8 2}
{cmd:Format(}{it:string [, suboptions]}{cmd:)} allows to change the formatting
of the whole table as well as the formatting of single/multiple rows or columns.

{p 8 8 2}
{it: String} is one of the five options
{cmd:table}, {cmd:rows}, {cmd:rowm}, {cmd:cols} or {cmd:colm}.

{p 8 8 2}
{it: Suboptions} are {cmd:Flist(}{it:string}{cmd:)} and {cmd:PANelsize(}{it:int}{cmd:)}
contain the row or column numbers as well as corresponding formats to be applied.
Usage depends on the format option chosen:

{p 10 12 2}
{cmd:table}: Single format for the whole table, e.g. {cmd:format(}table, flist(%9.0gc){cmd:)}.
The default format is %9.3f.

{p 10 12 2}
{cmd:rows} or {cmd:cols}: Specify formats applied to single rows or columns. Syntax is:

{p 12 12 2}
{cmd:format(}rows, flist({it:defcellformat rownumber rowformat [rownumber rowformat ...]}){cmd:)}

{p 12 12 2}
If you do not specify the {it: defcellformat}, then the default cell format %9.3f will be applied
to all rows/columns without specified format. The row or column numbers correspond to your matrix.
For example, if you want to set the default format of your table cells to %9.2f, but want to have
the format %9.0gc applied to rows 3 and 6, you could type:

{p 12 14 2}
{cmd:format(}rows, flist(%9.2f 3 %9.0c 6 %9.0c){cmd:)}

{p 10 12 2}
{cmd:rowm} or {cmd:colm}: Specify formats applied to rows or columns within repeated panels.
For example, consider a matrix containing multiple panels, where each panel is made up of
four rows. If you want to apply a different format to the fourth row of each panel, you can
use the {cmd:rowm} option. Syntax is:

{p 12 12 2}
{cmd:format(}rows, flist({it:defcellformat rownumber rowformat [rownumber rowformat ...])}
{cmd:panelsize(}{it:int}{cmd:)}{cmd:)}

{p 12 12 2}
To use the options {cmd: rowm} or {cmd: colm} you should specify the {cmd: panelsize()} option, indicating
the height in rows or width in columns of the panels (default is 2). For the stated example, you could type:

{p 12 14 2}
{cmd:format(}rowm, flist(4 %9.0c) multi(4){cmd:)}

{p 4 8 2}
{cmd:PARentheses(}{it:string [, suboptions]}{cmd:)} allows to set parentheses for rows and columns.

{p 8 8 2}
{it: String} is one of the two options
{cmd:parentheses}, resulting in (value), or {cmd:brackets}, resulting in [value].
Default is {it: parentheses}.

{p 8 8 2}
{it: Suboptions} are {cmd:rows(}{it:numlist}{cmd:)} or {cmd:cols(}{it:numlist}{cmd:)},
where {it: numlist} contains the row or column numbers in which values should be printed
with parentheses.

{p 8 8 2}
In the following example, the values in every second row would be bracketed:

{p 8 8 2}
{cmd: local} rown = rowsof(mymatrix) {break}
{cmd:par(}brackets, rows(2(2)`rown'){cmd:)}

{p 4 8 2}
{cmd:ROWLabels(}{it:string}{cmd:)}, {cmd:COLLabels(}{it:string}{cmd:)},
{cmd:ROWTWOLabels(}{it:string}{cmd:)} and {cmd:COLTWOLabels(}{it:string}{cmd:)} allow to
label the rows and columns of the table. {cmd:rowtwolabels} or {cmd: coltwolabels} add a
second labeling column or row, respectively. {cmd: Labels need to be enclosed by double quotes.}
If you do not specifiy any labels, the row and column names of the matrix are used.

{p 8 8 2}
A 4x4 matrix with a single row for column labels and a single column for row labels could be
labeled by typing:

{p 8 8 2}
{cmd:rowl(}"Rowlabel 1" "Rowlabel 2" "Rowlabel 3" "Rowlabel4"{cmd:)}, /// {break}
{cmd:coll(}"Collabel 1" "Collabel 2" "Collabel 3" "Collabel4"{cmd:)}

{p 8 8 2}
If you additionally used the {cmd: addrows} or {cmd: addcols} option, you would need to alter
the labeling accordingly.

{p 4 8 2}
{cmd:ROWSpan(}{it:int}{cmd:)}, {cmd:COLSpan(}{it:int}{cmd:)},
{cmd:ROWTWOSpan(}{it:int}{cmd:)} and {cmd:COLTWOSpan(}{it:int}{cmd:)} allow the
row/column labels to span multiple rows/colums. However, within rows or columns,
only one span value is possible.

{p 8 8 2}
To add a second row containing column labels to a table containing a 4x4 matrix,
where the column labels of the first row span two columns each, you could type:

{p 8 8 2}
{cmd:coll(}"Collabel spanning two cols 1" "Collabel spanning two cols 1"{cmd:)}, {cmd:colspan(}2{cmd:)} /// {break}
{cmd:coltwol(}"Subcollabel 1" "Subcollabel 2" "Subcollabel 3" "Subcollabel4"{cmd:)}

{p 4 8 2}
{cmd:ADDRows(}{it:numlist}{cmd:)} and {cmd:ADDCols(}{it:numlist}{cmd:)} allow to
add empty rows and columns to the matrix. The rows/columns are inserted {it: after}
the specified rows/columns. Naturally, you cannot specifiy negative values as well as
row/column numbers exceeding the number of rows/columns of the matrix.

{p 8 8 2}
In the following example, one row would be inserted before the first row
(after row 0), one row after row 3, and two columns after column 2:

{p 8 8 2}
{cmd:addr(}0 3{cmd:)}, {cmd:addc(}2 2{cmd:)}

{p 4 8 2}
{cmd:Title(}{it:string}{cmd:)} adds a title above the table as <p class="tabcap">Title<p>,
which you can style by class. You could, for example, to prevent the title scrolling
out of the viewport when you scroll large tables add: p.tabcap "position: sticky; left:0" to your CSS.
However, for accessibility, the title is also added as <caption style="display:none">Title</caption>
(which will show up with deactivated CSS).

{p 4 8 2}
{cmd:Class()}{it:namelist}{cmd:)} adds a CSS class to the table.
You can specifiy multiple classes which is very useful to style the table.
However, classes cannot have spaces in HTML, so a valid class option might look
like this:

{p 8 8 2}
{cmd: class(my-table-class1 my-table-class-2)} ,

{p 8 8 2}
what will result in the opening tag <table class="my-table-class1 my-table-class2">.

{p 8 8 2}
When you use the option {cmd: rowtwolabels}, the table will aditionally have the
class "rowtwolabels", useful when experimenting with large tables and the
"position: sticky" option in CSS.

{p 4 8 2}
{cmd:Note(}{it:string}{cmd:)} adds a note below the table.

{p 4 8 2}
{cmd:PRETable(}{it:string}{cmd:)} and {cmd:POSTable(}{it:string}{cmd:)} adds {it: string}
prior to the <table> opening or </table> closing tag. Particularly useful to wrap the table in tags.

{p 8 8 2}
For example, to hide the table first and let the user reveal it on click, you
could use:

{p 8 8 2}
{cmd: pret(}<details><summary>My summary...</summary>{cmd:})}, /// {break}
{cmd: postt(}</details>{cmd:})}

{p 4 8 2}
{cmd:POSTHead(}{it:string}{cmd:)} adds {it: string} right before the closing of
the table header </thead>. Useful to add an additional row with column labels,
however, this would need to be HTML code.

{p 4 8 2}
{cmd:append} specifies the table to be appended to the specified output file.
Default behavior is to replace the file.

{marker examples}
{title:Examples}


   // example matrix
      {cmd:mat} M = matuniform(6,8)
      {cmd:forvalues} c=1/8 {
        {cmd: foreach} r in 3 6 {
          {cmd: mat} M[`r',`c']=`c'*`r'*1000 // example N
        }
      }

   // set labels/parentheses
      {cmd:forvalues} i=1/2 {
        local rlabels = `" `rlabels' "Eq. 1" "Eq. 2""'
        local r2labels = `" `r2labels' "b" "se" "N" "' // use double quotes within compound double quotes!
      }
      local rowno = rowsof(M)

   // export HTML table
      mat2html M using "mytable.html", ///
          f(rowm, flist(3 %9.0gc) panel (3)) /// every third row (N) formatted as %9.0gc
          par(par, rows(2(3)`rowno')) /// enclose every second row (se) in parentheses
          rowl(`rlabels') rowspan(3) /// add row labels and span
          rowtwol(`r2labels') /// 2nd set
          coll("Model 1" "Model 2" "Model 3" "Model 4") colspan(2) /// add first set of col labels
          coltwol("Subpop1" "Subpop2" "Subpop1" "Subpop2" "Subpop1" "Subpop2" "Subpop1" "Subpop2") /// 2nd set
          title("My table title") class(my-example-class) /// you can see the class when looking at the HTML code
          note("My table note")


{marker usage}
{title:Usage within dynamic documents}

{pstd}
There are several possibilities to combine written text and Stata output within
dynamic documents. Usually, the Stata output is directly included into the document
as a code block: However, such tables look exactly like the ouput in the Stata
results window. This might not be desired. Using {cmd:mat2html}, you write tables
into extra HTML files which are then included into the HTML files generated by, for example,
Stata's own {help dyndoc} or Ben Jann's {help webdoc} environment:

{p 4 12 2}
Using {help dyndoc}:

{p 8 12 2}
{cmd:<<dd_include:} "mytable.html"{cmd:>>}

{p 4 12 2}
Using {help webdoc}:

{p 8 12 2}
{cmd:webdoc append} "mytable.html"

{pstd}
Personally, I prefer to write Markdown/HTML and Stata code within editors like
{browse "https://atom.io":Atom} providing syntax highlighting for multiple languages
within a single file. You could, for example, use the package
{browse "https://shd101wyy.github.io/markdown-preview-enhanced/#/":markdown-preview-enhanced} within Atom
to include your HTML files at any place in the document, adding it to the DOM via:

{p 8 12 2}
@import "mytable.html"

{marker author}
{title:Author}

{pstd}
Maximilian Sprengholz {break}
{browse "mailto:maximilian.sprengholz@hu-berlin.de"}
