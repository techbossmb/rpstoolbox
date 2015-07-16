Changes were made to the following files in the Netlab toolbox:

gmmem.m
  Date changed:  09/30/2002
  Changes made by:  Felice Roberts

  Change 1
  Line numbers:72-101, 116-146, 151-153, 172-176, 199-207, 255-263
  	Changes made to deal with large data sets.
  

gmmactive.m
  Date changed:  07/07/2003
  Changes made by:  Richard Povinelli

  Change 1
  Line numbers:  68-77
	tweak the matrix to make it positive devinite to avoid chol error

  Date changed:  07/15/2003
  Changes made by:  Sarah Schmit
  
  Change 2
  Line numbers:  35-39
	add options(5) as optional input, set options(5)=1 to use change 1
	
	Change 3
	Line numbers: 86-95
  added back in original chol code


gmminit.m
  Date changed:  03/17/2003
  Changes made by:  Xiaolin Liu
  
  Change 1
  Line number: 86
  	Loop variable 'i' changed to 'j', as i is not totally defined.  The change was made to fix an error that occurred 
  	occasionally during GMM modeling iwth a full covariance matrix.  There are still occasional problems with full covarience 
  	GMM modeling at line 85.
  	

gmmprob.m
  Date changed:  07/15/2003
  Changes made by:  Sarah Schmit
  
  Change 1
  Line numbers:  25-29
	add options(5) as optional input, set options(5)=1 to use change 1 of gmmactiv.m


kmeans.m
  Date changed:  09/30/2002
  Changes made by:  Felice Roberts
  
  Change 1
  Line numbers: 55-73, 115-150, 159
	Changes made to deal with large data sets.
	options(19) is the databreak; default 50000