### Preserving Changes in a Container
1. Create a docker container 
- Here the image used is the *latest* ubuntu image
- -it means -i=interactive and -t = virtual terminal
- --name for custom name
```Bash
docker run -it --name java_lab ubuntu:latest bash
```

2. Setting environment inside the container
- The comand below installs the JDK kit 
- -y = automatically say yes to prompts

```Bash
apt update
apt install -y default-jdk

mkdir -p /home/app
cd /home/app
```
- -p = ensures no error is thrown if folder exists 

3. Java compilation and execution 
- in ~/app create a java file to **print out "Hello World!"**
```JavaScript
public class HelloWorld{
  public static void main(String[] args){
    System.out.println("HelloWorld");
  }
}
```
- compile and run the program
```Bash
javac HelloWorld.java
java HelloWorld
```
- Exit the container
```Bash
exit
```
4. Preserving Changes
- In the Host's terminal
```Bash
docker commit java_lab java-app:1.0
```
- *docker commit* takes the current container state (filesystems) and freezes it into a new read oonly image
- it basically creates a docker image named *java-app* version- 1.0

5. Saving and loading 
- Images can be converted into a archive file to be shared using

- *save* packages an image all layers included into archive
-o= output file
```Bash
docker save -o java-app.tar java-app:1.0
```

- The generated archive file can be convered back to a image using
```Bash
docker load -i java-app.tar
```
- *docker load* is kind of opposite of save 
- It takes that archive and restores it into the local Docker engine's image list.