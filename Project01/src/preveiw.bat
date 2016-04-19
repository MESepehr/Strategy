set adt="D:\software\air18\bin\adt.bat"
set adl="D:\software\air18\bin\adl.exe"

set name=ZombyLand
set appNane=ZombyLand


set contents=AppIconsForPublish Data
rem "AppIconsForPublish"



set dAA3=1024x768:1024x768
rem debugger V
%adl% "%name%-app.xml"
rem -profile mobileDevice -screensize %dAA3% 

rem android export V
rem %adt% -package -target apk-captive-runtime -storetype pkcs12 -storepass 18381 -keystore "D:\MES Job 93-1-11\MESepehr.p12" "%name%.apk" "%name%-app.xml" %name%.swf %contents%




set mobprevision="D:\Sepehr\ElectroPeik\Certificate\electropeyc_dis.mobileprovision"
pause
set targ=ipa-debug
rem ipa-ad-hoc    ipa-app-store   ipa-debug -connect 192.168.0.15

set fastGenerate=-useLegacyAOT no
rem  -useLegacyAOT no

set ios_contents=
rem "Default-568h@2x.png" "Default-Landscape.png"

rem IOS export V
rem %adt% -package -target %targ%   %fastGenerate%  -keystore  "D:\Sepehr\ElectroPeik\Certificate\Certificates_dist.p12" -storetype pkcs12 -storepass NewPass123$      -provisioning-profile  %mobprevision%  "%appNane%.ipa" "%name%-app%onlineversion%.xml"  "%name%.swf"  %contents% %ios_contents%