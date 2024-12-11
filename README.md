<a name="readme-top"></a>
<br>
# PickSchool Project 
[![Contributors][contributors-shield]][contributors-url]
[![Issues][issues-shield]][issues-url]
[![Stargazers][stars-shield]][stars-url]
[![LinkedIn][linkedin-shield]][linkedin-url] 

<br>
<img src="https://media.istockphoto.com/id/1372327639/vector/business-decision-making-career-path-work-direction-or-choose-the-right-way-to-success.jpg?s=612x612&w=0&k=20&c=1PfTTOp6MT3AAo3GxPM95jykFghCzOYs_zywH_GwiE0=" width="1000" height="300">


<br>

 ## About project


The purpose of this initiative is to help students forecast their likelihood of being accepted into a specific school. The approach helps students make decisions by giving them insights into their chances of admission through the analysis of multiple criteria and factors. 

## Project objective
In the modern workplace, educational approaches are vital in determining one's professional path. As a result, selecting a college to continue your education after high school is crucial. Our project's objective is to assist you in estimating the probability that you will be admitted to the school of your choice. Furthermore, our research will offer tailored suggestions regarding the best educational institution for every student to attend.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### connection ro the database --firebase 
You should create a new account on Firebase <a href="https://firebase.google.com/"> Firebase Official Website  </a>and create a database by giving all the information that is required.
<img src="assets/image/db1.png" alt="firebase">
you should enable the tool to use for my case i am using the email process
<img src="image/db2.png" alt="pic"> <br>
<p align="right">(<a href="#readme-top">back to top</a>)</p>
after this you create a new project and open it on vs code or android to connect it with the database. <br>
1. verify that you are login to the firebase

   ```
   firebase login
   ```
<br>
the result must be that your are login successfully and the email that you have register with will appeare on the console
you should also download the cli  and execute this commande  <br>
   2. activate flutterfire cli  
   
   ```
   dart pub global activate flutterfire_cli
   ```
 <br> 
ater you should just add this command to configure the connection. <br>
3. configure the connection  

   ```
   flutterfire configure
   ``` 

<br>

once you execute this commande  succesful you will find the  firebase_core library in the pubsbec.yaml file with the version.

4. add dependencies for firebase_core  
   ```
   flutter pub add firebase_core
   ``` 
 <br>
 <p align="right">(<a href="#readme-top">back to top</a>)</p>
you should modify your main function to be like this <br>
this is the initialisiation of the database 
 <br>

```
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```
<br>
add these imports to your main.dart file. to import the firebase materiels in order to work with. <br>

```
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
```
<br>
know you can use connect to farebase or use my code. 
<br>

## how to use my code  <br>
after creting a new database in firebase on peut utiliser my code you should just ensure the connetion to the firebase. <br>



## demanstration


 <video width="640" height="360" controls>
  <source src="image/PickSchool.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>


#  Figma_app
<img src="image/Capture d’écran 2024-12-01 165904.png" title="reset password"> <br>
<img src="image/sign_in .png" title="sign_in"> <br>
 <img src="image/profile.png" title="profile" height="485"> <br>
 <img src="image/home.png" title="home" height="485"> <br>
 
<p align="right">(<a href="#readme-top">back to top</a>)</p>
<p align="right">(<a href="#readme-top">back to top</a>)</p>
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Documentation 
flutter <a href="https://docs.flutter.dev/"> documentation </a> <br>
dart <a href="https://dart.dev/guides"> documentation </a> <br>
firebase <a href="https://docs.flutter.dev/data-and-backend/firebase"> documentation </a> <br>
lottie <a href="https://pub.dev/packages/lottie"> documentation </a> <br>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Application Stucture 
 <img src="image/useCase.png" title="home" height="485"> <br>
 
 <p align="right">(<a href="#readme-top">back to top</a>)</p>



### 🌐 Find Me Around the Web 
- **Fiverr:** <a href="https://fr.fiverr.com/fatiha_laa?up_rollout=true"> Fiverr</a>
- **Email:** <a href="laaouafifatiha@gmail.com"> laaouafifatiha@gmail.com </a>
- **LinkedIn:** <a href="https://www.linkedin.com/in/fatiha-laaouafi-4227252ba/"> Linkdin </a>

## To use this project 

#### Installation
- install Flutter <a href = "https://docs.flutter.dev/get-started/install"> Install Now</a>
- install Git  <a href = "https://gitforwindows.org/">  for Windows </a>
- install Android Studio <a href = "https://developer.android.com/studio/install#windows"> Install Now</a>
<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->



[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/fatiha-laaouafi-4227252ba/

[issues-shield]: https://img.shields.io/github/issues/LAAOUAFIFATIHA/PickSchool_Flutter_project?style=for-the-badge
[issues-url]: https://github.com/LAAOUAFIFATIHA/PickSchool_Flutter_project/issues

[contributors-shield]: https://img.shields.io/github/contributors/LAAOUAFIFATIHA/PickSchool_Flutter_project?style=for-the-badge
[contributors-url]: https://github.com/LAAOUAFIFATIHA/PickSchool_Flutter_project/blob/main/CONTRIBUTING.md


[stars-shield]: https://img.shields.io/github/stars/LAAOUAFIFATIHA/PickSchool_Flutter_project?style=for-the-badge
[stars-url]: https://github.com/LAAOUAFIFATIHA/PickSchool_Flutter_project/stargazers
