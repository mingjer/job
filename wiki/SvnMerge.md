# svn 合并规则

#### 1.查看合并前信息，为合并准备：

    $ svn update
    $ svn status
    $ svn info
    ## 以上几部保证代码最新，本地无更改。并查看当前Revision。

    $ cd my-branch; svn mergeinfo http://xxxxxx/trunk
    Or $ svn mergeinfo http://xxxxxx/trunk http://xxxxxx/branch/my-branch
    ## 以上两步返回为空，表明当前并没有版本被合并到branch。

    $ svn mergeinfo http://xxxxxx/trunk http://xxxxxx/branch/my-branch --show-revs eligible
    ## 返回适合从trunk合并到branch的版本列表。可查看具体提交记录。

    $ svn merge  http://xxxxxx/trunk/  --dry-run
    ## 合并预览

> --dry-run : try operation but make no changes

#### 2.分支开发中，发现主干有更新，需在分支上 merge 进主干的变化：

(1)先分支提交所有改变，保证本地 clean ，用`svn status`查看状态。

(2)merge 主干的变化到分支，`svn merge http://xxxxxx/trunk`。

(3)无冲突直接 commit，有冲突`svn revert . -R`回退，或解决冲突后提交。

> 注意：merge 后不理想，执行 revert，对于新加的文件或目录，只会变成不在版本控制中的文件和目录，要多使用 svn status 查看状态，确保本地环境的 clean。

#### 3.分支开发完毕，合并回主干：

(1)如果拉分支后，主干有 commit，则必须先进行步骤 1，合并主干的变化到分支。主干没有 commit，则直接将分支合并回主干。

(2)svn checkout 主干，或 svn switch 切换到主干。注意，此时主干必须没有任何编辑或改变，并`svn update`保证目录最新。

(3)`svn merge --reintegrate http://xxxxxx/branch/my-branch`将**分支**合并回主干。

> --reintegrate : merge a branch back into its parent branch

(4)无误后可删除分支，此时，分支将不再可用（不能再进行1、2操作，否则spurious conflicts）。

**[推荐]** 如发现 bug ，需修复并合并到主干，建议删除旧分支，新拉同名分支进行修复：

    $ svn delete http://xxxxxx/branche/my-branch -m "Remove my-branch, reintegrated with trunk in r391."
    Committed revision 392.

    $ svn copy http://xxxxxx/trunk http://xxxxxx/branche/my-branch -m "Recreate my-branch from trunk@HEAD."
    Committed revision 393.

**[不推荐]** 为避免"Merged via"信息混乱，可行但不建议的 cherry-picking 操作。这里假设之前分支合并到主干，产生的版本是391：

    $ cd my-branch
    $ svn update
    Updated to revision 393.
    $ svn merge --record-only -c 391 http://xxxxxx/trunk
    $ svn commit -m "Block revision 391 from being merged into my-branch."
    Sending        .
    Committed revision 394.

#### 4.查看合并后信息：

(1)合并后，可以通过`svn propget svn:mergeinfo .`查看合并范围(从拉分支到当前合并主干到分支)相关的信息。例如在分支上查看合并信息，显示结果为`变化来源：合并版本范围`：

    $ cd my-branch
    $ svn propget svn:mergeinfo .
    /trunk:341-390      ## 从/trunk合并变化到my-branch，合并版本范围为341-390

(2)查看已经被合并到当前分支的版本号信息：

    $ cd my-branch
    $ svn mergeinfo http://xxxxxx/trunk
    r341
    r342
    r343
    …
    r388
    r389      ## 已经合并到branch的版本号，即拉出分支后，在trunk上发生变化提交的commit
    r390      ## 不一定和上面合并版本范围相同，可 svn log -g 留意"Merged via"相关信息
