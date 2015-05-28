vim-conjoiner
=============

Vim plugin for accessing conjoiner managed notes

Please see [conjoiner.txt](/doc/conjoiner.txt) for commands and configuration details.

Managing Repositories
=====================
Each year a new $YEAR_DIR directory is created. This must be manually turning into a git repository, and connected to [gitdocs](https://github.com/nesquena/gitdocs) for automatic syncing. Here is an example of the steps to do this:
```bash
cd $YEAR_DIR
git init
gitdocs add `pwd`
git remote add origin $GIT_HOSTNAME:$REPO_NAME
git push --set-upstream origin master
```

Research and Related Links
==========================
* [VimOutilner](http://www.vimoutliner.org/)
* [GTD and VimOutliner](http://peterstuifzand.nl/gtd-vimoutliner.html)
* [Comparison of notetaking software](https://en.wikipedia.org/wiki/Comparison_of_notetaking_software)
