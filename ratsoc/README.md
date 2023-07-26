# ratsoc


## Assumptions

* There can be more than one copy of a book at each library branch
* Issued card numbers are globally unique (across branches)
* Adding and removing book operations means adding or removing a single copy, and removal can't remove a currently checked-out book


## Future Work

* Functions on library branches would operate over the collective union of maps (branches)
  * Branches could be stored as collection
* Lots of reaching down into records and changing a leaf value, then wrapping it all back up. Consider optics if familiar for team.
* Demo: Application could have a collection of libraries as a config variable under a `TVar` for use by concurrent users