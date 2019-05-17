# useful commands:

## git hooks
1. prevent common submodule gotchas
2. use existing git tools and such, not use custom helper script
3. maintain as much of the 'monorepo' illusion as posisble

post-checkout: magic hook so `git pull` works as expected
  goal: end up with submodule appearing on the branch at the point in time the developer made the commit. 
  could possibly do like this?:
    checkout git branch from manifest
    reset git branch to commit in submodule

pre-commit:
  update manifest file with current branch of each submodule

pre-push:
  validate all submodules have been pushed



## im-bundle-helper
Script(s) to actually drive the above hooks, and other features.

  `im pull`
  `im track --branch=$branch`
  `im checkout -b $branch_name`
  `im branch $branch_name`

`im push` -- generate PR(s)
tie in with trello, etc.

# Use Cases / Workflows

## CI -- running tests and stuff

CircleCI needs to check out the repo and run the tests.
It doesn't care about branches
It will never need to commit or push anything back

 1. clone `im-bundle` && checkout some branch
 2. git submodule init && update && whatever
 3. run tests and profit!

 4. throw away whatever checkout, because we don't care

## developers -- building a feature, spanning one or more submodules

### Developer needs to start work on ${feature_name}:

0. from `im-bundle` working directory
1. git checkout -b ${feature_name}
2. foreach $submodule in $submodules:
  a. `git checkout master`
3. start work on ${feature_name} in gp-frontend:
  a. cd gp-frontend
  b. git checkout -b ${feature_name}
  c. do stuff, commit in gp-frontend

Possibly with handy ${im-bundle-helper}:
0. from `im-bundle`
1. im-bundle-helper start ${feature_name}
  a. somehow provide configuration for each branch


### Developer actively working on ${feature_name}

Works normally, can completely ignore parent `im-bundle`, etc.
Except at any time, can run tests from `im-bundle` 
Commit to gp-frontend as usual, push commits, whatever.


### Developer nearing "done" on ${feature_name}

Given ${feature_name} is ready to "ship" to QA, run ATs remotely, whatever. 

It's at whatever state means they need to care about `im-bundle` again, and they need to create a "snapshot" to reflect the intended state of `im-bundle` for ${feature_name}.

0. from `im-bundle` working directory
1. foreach $submodule in $submodules where $submodule is dirty:
  a. git add $submodule
2. git commit -m 'package up for ${feature_name}'
  a. note: ensure every submodule has been pushed upstream
3. git push && open PR


### Developer switches to ${feature_name}

0. from `in-bundle` working directory
1. git fetch
2. git checkout ${feature_name}
3. git submodule update
  a. note: every submodule is now in a detached state. (ie: it's no longer tracking a branch. ie. `git pull` will do nothing.)

Really what we want is to be able to do...
0. from `im-bundle` working directory
1. git checkout ${feature_name}
2. pull changes for submodules
  a. pull changes for _every_ submodule: ${im-bundle-helper} pull
  b. pull changes for specific submodule(s): ${im-bundle-helper} pull ${submodule} 




## QA/developers/ops/someone


Someone needs to set the right branches/commits to define what versions should go together to form a "snapshot", "release", "version", ${awesome_name}


It's 

for ex:
  a. cd investor-frontend && git checkout master && cd ..
  b. cd gp-frontned && git checkout sexy-emails && cd ..
  c. cd apm_bundle && git checkout dreamSexyEmails && cd ..
  d. cd im-acceptance && git checkout master && cd ..


    a. compose a release -- pick specific submodule versions, etc.