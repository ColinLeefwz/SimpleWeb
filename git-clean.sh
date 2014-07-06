git filter-branch -f --tree-filter 'rm -rf DFace/' -- --all
git filter-branch -f --tree-filter 'rm -rf build/' -- --all
git filter-branch --prune-empty -f HEAD
git gc --prune=now 

