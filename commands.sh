# Some commands I use from my history and don't want to lose

cd ~

# status about all projects
git-sum2/git-summary -lq
# more status about list of projects
for r in blog leaflet clock geotools bootcamp_python_kai lapeste yuansu-react uketabs tools; do echo $r : `git -C $r status | grep ahead`; done
# push it
for r in blog leaflet clock geotools bootcamp_python_kai lapeste yuansu-react uketabs tools; do echo $r : `git -C $r push`; done
