@echo off
cd ..
@echo on
echo Installing libreries manager...
@echo off
haxelib install hmm
@echo on
echo Installing libreries...
haxelib run hmm install
echo Finished libreries installation!
pause