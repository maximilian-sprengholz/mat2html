********************************************************************************
*
*   mat2html –––
*   Matrix to HTML table conversion
*
*   Author:		Maximilian Sprengholz
*   			maximilian.sprengholz@hu-berlin.de
*
********************************************************************************


cap program drop mat2html
program mat2html
	version 13.0

	syntax name(name=M) [using/] ///
		[ , ///
			append ///
			Format(str) ///
			PARentheses(str) ///
			ROWLabels(str asis) ///
			COLLabels(str asis) ///
			ROWTWOLabels(str asis) ///
			COLTWOLabels(str asis) ///
			REPeatlabels ///
			ROWSpan(integer -1) ///
			COLSpan(integer -1) ///
			ROWTWOSpan(integer -1) ///
			COLTWOSpan(integer -1) ///
			ADDCols(numlist >=0 integer sort) ///
			ADDRows(numlist >=0 integer sort) ///
			PRETable(str) ///
			POSTTable(str) ///
			POSTHead(str) ///
			note(str) ///
			Title(str) ///
			Class(str asis) ///
		]

quietly {
	*---------------------------*
	*        PREP/ERRORS        *
	*---------------------------*
	***	file management
		if ("`using'"=="")  {
		*	add cd path if nothing/only filename specified
			local using "`c(pwd)'/mat2html_`M'.html"
		}
		else if (strpos("`using'", "/")==0 & strpos("`using'", "\")==0)  {
		*	add cd path if nothing/only filename specified
			local using "`c(pwd)'/`using'"
		}
		if "`append'"=="" {
			local append "replace"
		}
	***	process input matrix
		mat M_temp = `M'
	*	rows added?
		if "`addrows'"!="" {
			local r = rowsof(M_temp)
			local c = colsof(M_temp)
			local cnt 0
		*	check if within logical bounds
			foreach addr of numlist `addrows' {
				if (`addr'>`r') | (`addr'<0) {
					noisily dis as error "Option addrows() outside logical bounds [0;rows of matrix]."
					error 198
					exit
				}
			}
		*	add rows
			foreach addr of numlist `addrows' {
			*	check if more than one added rows at the same place
				if `cnt'>0 {
					local prev : word `cnt' of `addrows'
				}
				else {
					local prev
				}
				local ++cnt
			*	one row added
				if ("`prev'"!="`addr'") {
					local m_pt_b = `prev'+1
				*	split part
					if `addr'!=0 {
						mat M_temp_pt_`addr' = M_temp[`m_pt_b'..`addr', 1...]
					}
				*	additional row
					mat M_temp_add_`addr' = J(1,`c',.) // col-wise procedure
				}
			*	additional rows added
				else {
					mat M_temp_add_`addr' = M_temp_add_`addr' \ J(1,`c',.) // interlace rows
				}
			*	if no rows added after last original row: save last split part
				local aopts : word count `addrows'
				if (`cnt'==`aopts') & (`addr'<`r') {
					local m_end_b = `addr'+1
					mat M_temp_end = M_temp[`m_end_b'..`r', 1...]
				}
			}
		*	merge together (as additional loop to keep col/rownumers intact
			local cnt 0
			foreach addr of numlist `addrows' {
			*	check if more than one added row at the same place
				if `cnt'>0 {
					local prev : word `cnt' of `addrows'
				}
				else {
					local prev
				}
				local ++cnt
			*	first rowset
				if `cnt'==1 {
					if `addr'!=0 {
						mat M_temp_temp = M_temp_pt_`addr' \ M_temp_add_`addr'
					}
					else {
						mat M_temp_temp = M_temp_add_`addr'
					}
				}
			*	add rows
				else if ("`prev'"!="`addr'") {
					mat M_temp_temp = M_temp_temp \ M_temp_pt_`addr' \ M_temp_add_`addr'
				}
			*	add last rows of matrix (if not added)
				if (`cnt'==`aopts') & (`addr'<`r') {
					mat M_temp_temp = M_temp_temp \ M_temp_end
				}
			}
			mat M_temp = M_temp_temp
		}
	*	cols added?
		if `"`rowtwolabels'"'!="" {
			local addcols = "0 `addcols'" // add row to the left to add labeling column
		}
		if "`addcols'"!="" {
			local r = rowsof(M_temp)
			local c = colsof(M_temp)
			local cnt 0
		*	check if within logical bounds
			foreach addc of numlist `addcols' {
				if (`addc'>`c') | (`addc'<0) {
					noisily dis as error "Option addcols() outside logical bounds [0;cols of matrix]."
					error 198
					exit
				}
			}
		*	add cols
			foreach addc of numlist `addcols' {
			*	check if more than one added column at the same place
				if `cnt'>0 {
					local prev : word `cnt' of `addcols'
				}
				else {
					local prev
				}
				local ++cnt
			*	one column added
				if ("`prev'"!="`addc'") {
					local m_pt_b = `prev'+1
				*	split part
					if `addc'!=0 {
						mat M_temp_pt_`addc' = M_temp[1...,`m_pt_b'..`addc']
					}
				*	additional col
					mat M_temp_add_`addc' = J(`r',1,.) // col-wise procedure
				}
			*	additional columns added
				else {
					mat M_temp_add_`addc' = M_temp_add_`addc' , J(`r',1,.) // interlace columns
				}
			*	if no colums added after last original column: save last split part
				local aopts : word count `addcols'
				if (`cnt'==`aopts') & (`addc'<`c') {
					local m_end_b = `addc'+1
					mat M_temp_end = M_temp[1...,`m_end_b'..`c']
				}
			}
		*	merge together (as additional loop to keep col/rownumers intact
			local cnt 0
			foreach addc of numlist `addcols' {
			*	check if more than one added column at the same place
				if `cnt'>0 {
					local prev : word `cnt' of `addcols'
				}
				else {
					local prev
				}
				local ++cnt
			*	first colset
				if `cnt'==1 {
					if `addc'!=0 {
						mat M_temp_temp = M_temp_pt_`addc' , M_temp_add_`addc'
					}
					else {
						mat M_temp_temp = M_temp_add_`addc'
					}
				}
			*	add columns
				else if ("`prev'"!="`addc'") {
					mat M_temp_temp = M_temp_temp, M_temp_pt_`addc' , M_temp_add_`addc'
				}
			*	add last cols of matrix (if not added)
				if (`cnt'==`aopts') & (`addc'<`c') {
					mat M_temp_temp = M_temp_temp, M_temp_end
				}
			}
			mat M_temp = M_temp_temp
		}
	*	update row/col numbers and names
		local r = rowsof(M_temp)
		local c = colsof(M_temp)
		local coln: colnames M_temp, quoted
		local rown: rownames M_temp, quoted
	***	format (set fparse)
	*	if not specified
		if "`format'"=="" {
			local defcellformat "%9.3f" // default cellformat
		}
		else {
		*	call program and process
			mat2html_format_opt `format'
			local fparse 	`s(fparse)'
			local flist 	`s(flist)'
			local panelsize 	`s(panelsize)'
			local fparse = strtrim("`s(fparse)'")
			local flist = strtrim("`s(flist)'")
			local defcellformat "%9.3f"
		*	if specified but no format list provided
			if "`fparse'"!="table" & "`flist'"=="" {
				noisily dis as error "Sub-option flist() required for format(`fparse')." ///
					_newline as text "Processed as format(table)."
				local fparse "table"
			}
		*	if specified and format list provided
			if "`flist'"!="" {
			*	if first value is a format: replace def. format
				local flist = strtrim("`flist'") // remove leading and trailing blanks
				local ff : word 1 of `flist'
				if strpos("`ff'","%")!=0 {
				*	replace default only if set
					local defcellformat "`ff'"
				*	cut from string
					local flist = usubinstr("`flist'","`ff' ","",1)
				}
				else {
					local defcellformat "%9.3f" // default cellflist
				}
				if "`fparse'"=="table" {
					local msg1 "Only first specified format in flist() processed for format(`fparse')."
				}
			*	process format list
				local wn : word count `flist'
				local comma ""
				forvalues i=1(2)`wn' {
					local j=`i'+1
					local fn : word `i' of `flist'
					local f : word `j' of `flist'
					if `i'>1 local comma ","
					local ilflist "`ilflist'`comma' `fn'" // set inlist condition
					local f`fn' "`f'" // set corresponding format (easier than extracting the word pos. later)
				}
			}
		}
	*	display user feedback
		noisily dis as result ///
			_newline "mat2html:" ///
			_newline as text "Parsing format list according to format(`fparse')." ///
			_newline as text "Default cell format: `defcellformat'" ///
			_newline as text "`msg1'"
	***	brackets
		if "`parentheses'" != "" {
			mat2html_par_opt `parentheses'
			local parrows 	`s(parrows)'
			local parcols 	`s(parcols)'
			local parstyle 	`s(parstyle)'
		*	for inlist condition
			local ilparrows 0 // fallback 0
			foreach parrow in `parrows' {
				local ilparrows "`ilparrows', `parrow'"
			}
			local ilparcols 0 // fallback 0
			foreach parcol in `parcols' {
				local ilparcols "`ilparcols', `parcol'"
			}
		}
	***	labels
		if `"`rowlabels'"'!="" {
			local rlbls `"`rowlabels'"'
			local rlblcnt : word count `rlbls'
		*	if labellist shall be repeated, repeat given labels until row end
			if "`repeatlabels'"!="" & `rlblcnt'<`r' {
				local rlblno = `rlblcnt'
				while `rlblcnt'<`r' {
					forvalues l=1/`rlblno' {
						local rlbl : word `l' of `rlbls'
						local rlbls `"`rlbls' "`rlbl'""'
						local rlblcnt : word count `rlbls'
					}
				}
			}
		*	extract all labels
			local cnt 0
			while strpos(`"`rlbls'"', char(34))!=0 {
				local rlblb 	= strpos(`"`rlbls'"', char(34)) // collabel begin
				local rlbls 	= subinstr(`"`rlbls'"', char(34),"", 1) // delete first double quotes
				local rlbll 	= strpos(`"`rlbls'"', char(34)) - `rlblb' // collabel length
				local ++cnt
				local rlbl`cnt' = substr(`"`rlbls'"', `rlblb', `rlbll') // extract label
				local rlbls 	= subinstr(`"`rlbls'"', char(34),"", 1) // delete end double quotes
			}
		}
		if `"`rowtwolabels'"'!="" {
			local rtwolbls `"`rowtwolabels'"'
			local rlblcnt : word count `rtwolbls'
		*	if labellist shall be repeated, repeat given labels until row end
			if "`repeatlabels'"!="" & `rlblcnt'<`r' {
				local rlblno = `rlblcnt'
				while `rlblcnt'<`r' {
					forvalues l=1/`rlblno' {
						local rlbl : word `l' of `rtwolbls'
						local rtwolbls `"`rtwolbls' "`rlbl'""'
						local rlblcnt : word count `rtwolbls'
					}
				}
			}
		*	extract all labels
			local cnt 0
			while strpos(`"`rtwolbls'"', char(34))!=0 {
				local rtwolblb 	= strpos(`"`rtwolbls'"', char(34)) // collabel begin
				local rtwolbls 	= subinstr(`"`rtwolbls'"', char(34),"", 1) // delete first double quotes
				local rtwolbll 	= strpos(`"`rtwolbls'"', char(34)) - `rtwolblb' // collabel length
				local ++cnt
				local rtwolbl`cnt' = substr(`"`rtwolbls'"', `rtwolblb', `rtwolbll') // extract label
				local rtwolbls 	= subinstr(`"`rtwolbls'"', char(34),"", 1) // delete end double quotes
			}
		}
		if `"`collabels'"'!="" {
			local clbls `"`collabels'"'
			local clblcnt : word count `clbls'
		*	if labellist shall be repeated, repeat given labels until col end
			if "`repeatlabels'"!="" & `clblcnt'<`c' {
				local clblno = `clblcnt'
				while `clblcnt'<`c' {
					forvalues l=1/`clblno' {
						local clbl : word `l' of `clbls'
						local clbls `"`clbls' "`clbl'""'
						local clblcnt : word count `clbls'
					}
				}
			}
		*	extract all labels
			local cnt 0
			while strpos(`"`clbls'"', char(34))!=0 {
				local clblb 	= strpos(`"`clbls'"', char(34)) // clbl begin
				local clbls 	= subinstr(`"`clbls'"', char(34),"", 1) // delete first double quotes
				local clbll 	= strpos(`"`clbls'"', char(34)) - `clblb' // clbl length
				local ++cnt
				local clbl`cnt' = substr(`"`clbls'"', `clblb', `clbll') // extract label
				local clbls 	= subinstr(`"`clbls'"', char(34),"", 1) // delete end double quotes
			}
		}
		if `"`coltwolabels'"'!="" {
			local ctwolbls `"`coltwolabels'"'
			local clblcnt : word count `ctwolbls'
		*	if labellist shall be repeated, repeat given labels until col end
			if "`repeatlabels'"!="" & `clblcnt'<`c' {
				local clblno = `clblcnt'
				while `clblcnt'<`c' {
					forvalues l=1/`clblno' {
						local clbl : word `l' of `ctwolbls'
						local ctwolbls `"`ctwolbls' "`clbl'""'
						local clblcnt : word count `ctwolbls'
					}
				}
			}
		*	extract all labels
			local cnt 0
			while strpos(`"`ctwolbls'"', char(34))!=0 {
				local ctwolblb 	= strpos(`"`ctwolbls'"', char(34)) // ctwolbl begin
				local ctwolbls 	= subinstr(`"`ctwolbls'"', char(34),"", 1) // delete first double quotes
				local ctwolbll 	= strpos(`"`ctwolbls'"', char(34)) - `ctwolblb' // ctwolbl length
				local ++cnt
				local ctwolbl`cnt' = substr(`"`ctwolbls'"', `ctwolblb', `ctwolbll') // extract label
				local ctwolbls 	= subinstr(`"`ctwolbls'"', char(34),"", 1) // delete end double quotes
			}
		}

	*---------------------------*
	*           TABLE           *
	*---------------------------*
	*** gen file
		capture {
			file open mat2html_file using `"`using'"', write `append'
		}
		if _rc==110 {
		*	if file handle still used within stata but file not closed
			file close mat2html_file
			file open mat2html_file using `"`using'"', write `append'
		}
		else if _rc>0 {
			noisily dis as error `"File "`using'" could not be written."' ///
				_newline "Please check if you have writing permissions or the file opened somewhere else."
			exit
		}
	*** user input to put before table
		if `"`pretable'"'!="" {
			file write mat2html_file `"`pretable'"'
		}
	*	Table title as block (caption cannot be sticky, but is added below)
		if `"`title'"'!="" {
			file write mat2html_file _n `"<p class="tabcap">`title'</p>"' // keep caption for accessibility
		}
	***	start table
		if `"`rowtwolabels'"'!="" {
			local class `"`class' rowtwolabels"'
		}
		if "`class'"!="" {
			local class 	= subinstr(`"`class'"', char(34),"", .) // omit all double quotes
			file write mat2html_file _n `"<table class="`class'">"'
		}
		else {
			file write mat2html_file _n "<table>"
		}
	*	caption
		if `"`title'"'!="" {
			file write mat2html_file `"<caption style="display:none;">`title'</caption>"' _n // keep caption for accessibility
		}
	***	start thead
		file write mat2html_file _n "<thead>" _n "<tr><th></th>"
		local i 0
	*	collabels
		if `"`rowtwolabels'"'!="" {
			local collbl_b 2 // begin at row 2 if additional column
		}
		else {
			local collbl_b 1 // begin at row 1 otherwise
		}
		if `"`collabels'"'!="" {
			local k 1
			foreach col of local coln {
				local ++i
				if `i'<`collbl_b' {
				*	if second column with row labels:
					file write mat2html_file "<th></th>"
				}
				else {
					if `colspan'>0 {
						forvalues cs=`collbl_b'(`colspan')`c' {
							if `i'==`cs' {
								file write mat2html_file `"<th colspan="`colspan'">`clbl`k''</th>"'
								local ++k
							}
						}
					}
					else {
						file write mat2html_file `"<th>`clbl`i''</th>"'
					}
				}
			}
		}
		else {
			foreach col of local coln {
				file write mat2html_file `"<th>`col'</th>"'
			}
		}
		file write mat2html_file _n "</tr>"
	*	collabels if extra 2nd col
		if `"`coltwolabels'"'!="" {
			file write mat2html_file _n "<tr><th></th>"
			local i 0
			local k 1
			foreach col of local coln {
				local ++i
				if `i'<`collbl_b' {
				*	if second column with row labels:
					file write mat2html_file "<th></th>"
				}
				else {
					if `coltwospan'>0 {
						forvalues cs=`collbl_b'(`coltwospan')`c' {
							if `i'==`cs' {
								file write mat2html_file `"<th colspan="`coltwospan'">`ctwolbl`k''</th>"'
								local ++k
							}
						}
					}
					else {
						local k = `i'-`collbl_b'+1 // adjust for additional row label column
						file write mat2html_file `"<th>`ctwolbl`k''</th>"'
					}
				}
			}
			file write mat2html_file "</tr>"
		}
		if `"`posthead'"'!="" {
			file write mat2html_file `"`posthead'"'
		}
		file write mat2html_file _n "</thead>" _n "<tbody>"
	***	put cells (format option)
		local i 0
		local k 1
	*	by row
		foreach row of local rown {
			local ++i
			file write mat2html_file _n "<tr>"
		*	row label
		*	if rowspan defined: skip spanned rows
			if `"`rowlabels'"'!="" {
				if "`rowspan'"!="-1" {
					forvalues rs=1(`rowspan')`r' {
						local rowsspanned = `rs'+`rowspan'
						if `i'==`rs' {
							file write mat2html_file `"<th rowspan="`rowspan'">`rlbl`k''</th>"'
							local ++k
						}
						else if (`i'>`rs') & (`i'<`rowsspanned') {
							file write mat2html_file `"<th style="display:none"></th>"'
						}
					}
				}
				else {
					file write mat2html_file `"<th>`rlbl`i''</th>"'
				}
			}
			else {
				local row : word `i' of `rown'
				file write mat2html_file `"<th>`row'</th>"'
			}
		*	compare rows with user input formats
		*	single values
			if "`fparse'"=="" {
				local cellformat `defcellformat'
			}
			else if "`fparse'"=="rows" {
				if inlist(`i', `ilflist') {
					local cellformat "`f`i''"
				}
				else {
					local cellformat `defcellformat'
				}
			}
		*	by panel
			else if "`fparse'"=="rowm" {
				local frun = ceil(`i'/`panelsize')-1 // determine number of runs (spanning one panel of formatted rows)
				local fset = `i'-(`frun'*`panelsize') // format repeated every panel
				if inlist(`fset', `ilflist') {
					local cellformat "`f`fset''"
				}
				else {
					local cellformat `defcellformat'
				}
			}
		*	by col
			forvalues j = 1/`c' {
			*	compare cols with user input formats
			*	single values
				if "`fparse'"=="cols" {
					if inlist(`j', `ilflist') {
						local cellformat "`f`j''"
					}
					else {
						local cellformat `defcellformat'
					}
				}
				else if "`fparse'"=="colm" {
					local frun = ceil(`j'/`panelsize')-1 // determine number of runs (spanning one panel of formatted rows)
					local fset = `j'-(`frun'*`panelsize') // format repeated every panel
					if inlist(`fset', `ilflist') {
						local cellformat "`f`fset''"
					}
					else {
						local cellformat `defcellformat'
					}
				}
			***	set format for cell + parentheses if requested if no row label column
				if (`"`rowtwolabels'"'!="") & (`j'==1) {
				*	row label
				*	if rowspan defined: skip spanned rows
					if "`rowtwospan'"!="-1" {
						forvalues rs=1(`rowtwospan')`r' {
							if `i'==`rs' {
								file write mat2html_file `"<th rowspan="`rowtwospan'">`rtwolbl`i''</th>"'
							}
						}
					}
					else {
						file write mat2html_file `"<th>`rtwolbl`i''</th>"'
					}
				}
				else {
				*	cell value
					capture {
						local value : display `cellformat' M_temp[`i',`j']
						local value = strtrim("`value'") // remove blanks
					*	omit dot for empty cells
						if "`value'"=="." {
							local value
						}
					}
					local rc=_rc
					if `rc' {
						dis as error "Invalid specification of the format() option." ///
							_newline "Original error message:"
						exit `rc'
					}
				*	parentheses
					if ("`parentheses'" != "") {
						if (inlist(`i', `ilparrows') | inlist(`j', `ilparcols')) {
							if "`parstyle'"=="brackets" {
								local parl "["
								local parr "]"
							}
							else {
								local parl "("
								local parr ")"
							}
						}
						else {
							local parl
							local parr
						}
					}
					file write mat2html_file `"<td>`parl'`value'`parr'</td>"'
				}
			}
			file write mat2html_file _n "</tr>"
		}
	***	close table
		file write mat2html_file _n "</tbody></table>"
	***	add note
		if `"`note'"'!="" {
			file write mat2html_file _n `"<span class="legend">`note'</span>"' _n
		}
	***	user input to put after table
		if `"`posttable'"'!="" {
			file write mat2html_file _n `"`posttable'"' _n
		}
	***	close file
		capture {
			file close mat2html_file
		}
		if _rc {
			noisily dis as error `"File "`using'" could not be completed."' ///
				_newline "This is a generic error:" ///
				_newline "- Ensure you have writing permissions in the specified directory" ///
				_newline "- Use a different filenname and/or directory" ///
				_newline "- Restart Stata"
			exit
		}
		noisily dis `"HTML file written to ({browse "file://`using'"})."'
	}
	// end quietly
end



***
*** Suboption Programs
***
***	parentheses
	cap program drop mat2html_par_opt
	program mat2html_par_opt , sclass
		version 13.0

		syntax namelist(name=parstyle max=1) ///
		[ , ///
			rows(numlist >0 integer) ///
			cols(numlist >0 integer) ///
		]
		sreturn local parrows `rows'
		sreturn local parcols `cols'
		sreturn local parstyle `parstyle'
	end

***	format
	cap program drop mat2html_format_opt
	program mat2html_format_opt , sclass
		version 13.0

		syntax namelist(name=fparse max=1) ///
		[ , ///
			FList(str) ///
			PANelsize(integer 2) ///
		]
		if inlist("`fparse'", "table", "rows", "rowm", "cols", "colm") {
			sreturn local fparse `fparse'
			sreturn local flist `flist'
			sreturn local panelsize `panelsize'
		}
		else {
			dis as error "Format() option `fparse' not allowed."
			error 198
			exit
		}
	end
