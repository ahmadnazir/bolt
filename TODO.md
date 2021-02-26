# What to do?

## DONE Emacs Minor Mode:
[Update: minor mode not needed after all. Will reevaluate it at a later point]
Let's start with a bare bones emacs minor mode. Taking inspiration from how
rest-client, or the database client works. I did something like this when
building an emacs mode for pine.

## DONE Evaluation Strategy:
Once we make it possible to select text and send for evaluation, decide on the
evaluation engine. I want this to be anything like bash, python scripts, etc or
anything that can be executed from he command line.

## DONE Conventions:
Assuming that we use bash to evaluation the actions, the actions need to be
namespaced and some convention for storing those actions are needed.
  
## DONE Displaying results:
[Update: using a separate buffer to show the results. This is more useful then a
pop-up for the applications that I have for bolt]

I love how results are shown when working with the clojure repl. Something like
that would be amazing. Also, we need to be able to print to standard out.
Deciding what the the output form is something I haven't really thought about.
Let's do that once we get there.
