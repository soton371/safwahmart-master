Rules for publish a app in play store..

#1. Add below lines of code in android/app/build.gradle

apply plugin>>>>>>>>>>> //For Publish The App in Play Store

def keystoreProperties = new Properties() def keystorePropertiesFile = rootProject.file('key.properties') if (keystorePropertiesFile.exists()) { keystoreProperties.load(new FileInputStream(keystorePropertiesFile)) }

//************************************

defaultConfig>>>>>>>>>>
//For Publish The App in Play Store
signingConfigs { release { keyAlias keystoreProperties['keyAlias'] keyPassword keystoreProperties['keyPassword'] storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null storePassword keystoreProperties['storePassword'] } } buildTypes { release { signingConfig signingConfigs.release } }

//*********************************** #2. Enter this keytool -genkey -v -keystore D:\spider\sarabosorEkrate_assets\key_store\sarabosorekrate.keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key0 in your terminal.

#3. create a file(key.properties) in android folder in paste the follow lines of code 
storePassword=sarabosorekrate123
keyPassword=sarabosorekrate123
keyAlias=upload
storeFile=D:/spider/sarabosorEkrate_assets/key_store/sarabosorekrate.keystore.jks

#4. Then goto the path and copy the folder then paste the folder inside the android folder in your project.

#5. Then goto your terminal and type flutter clean, then flutter pub get and finally flutter build appbundle --no-sound-null-safety in your terminal

If the app bundle make without any error then this is the final output for upload in play store. Otherwise solve the error.