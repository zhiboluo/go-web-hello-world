Task 0: Install a ubuntu 16.04 server 64-bit

    Step 1: Choose OS x hosts and download the virtualbox for Mac (https://www.virtualbox.org/wiki/Downloads)
    Step 2: download ubuntu 16.04 server 64-bit install image (https://releases.ubuntu.com/16.04.7/?_ga=2.177823845.1147325132.1598571763-486386747.1598297836)
    Step 3: install VirtualBox on host machine.
    Step 4: install the guest machine on the VirtualBox.
        -	Open the installed VirtualBox from host machine, choose machine->new…
        -	Fill the name (ubuntu16.04), choose type and version(Ubuntu 64-bit)
        -	Choose memory size (2GB) and file size (10GB). Make sure VDI is chosen for the hard disk file type.
        -	Then choose the default settings in the following steps
        -	Right click the “ubuntu16.04” and choose ->start->normal start, choose the downloaded .iso file and click ‘start’. Then a window will be popup and now you can install the Ubuntu system in the VirtualBox.
        -	Then click the green “start” button, a new window will be popup and the new Ubuntu system will be bootup. Type the username and password will deliver you to the Ubuntu.


Task 1: Update system (upgrade the kernel to the 16.04 latest)

    Step 1: First setup the ssh connection between the host machine and guest machine. Then open a terminal in the host machine and type $ ssh luobozhi@localhost -p 2222 to login the guest machine.
    Step 2: check the installed kernel version
        luobozhi@luobo:~$ uname -sr
        Linux 4.4.0-187-generic
    Step 3: upgrade to the newest kernel.
        In order to upgrade to the newest kernel version, open http://kernel.ubuntu.com/~kernel-ppa/mainline/ and choose the newest kernel version (at this moment, v5.8.5 is the latest version). For 64-bit system, download the following .deb files through wget.
        luobozhi@luobo:~$ wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.8.5/amd64/linux-headers-5.8.5-050805_5.8.5-050805.202008270831_all.deb
        luobozhi@luobo:~$ wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.8.5/amd64/linux-headers-5.8.5-050805-generic_5.8.5-050805.202008270831_amd64.deb
        luobozhi@luobo:~$ wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.8.5/amd64/linux-image-unsigned-5.8.5-050805-generic_5.8.5-050805.202008270831_amd64.deb 
        luobozhi@luobo:~$ wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.8.5/amd64/linux-modules-5.8.5-050805-generic_5.8.5-050805.202008270831_amd64.deb 

        And the following .deb files are downloaded
        luobozhi@luobo:~$ ls
        linux-headers-5.8.5-050805_5.8.5-050805.202008270831_all.deb            linux-image-unsigned-5.8.5-050805-generic_5.8.5-050805.202008270831_amd64.deb
        linux-headers-5.8.5-050805-generic_5.8.5-050805.202008270831_amd64.deb
        linux-modules-5.8.5-050805-generic_5.8.5-050805.202008270831_amd64.deb
        Then, install through the following command.
        $ sudo dpkg -i *.deb
        Finally, reboot the guest machine and check the kernel version. And it can be seen the kernel version is update to v5.8.5.
        luobozhi@luobo:~$ uname -sr
        Linux 5.8.5-050805-generic

Task 2: Install gitlab-ce version in the host

    Step 1: install and configure the necessary dependencies
        sudo apt-get install -y curl openssh-server ca-certificates tzdata
    Step 2: add the Gitlab package repository and install the package
        luobozhi@luobo:~$ curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
        luobozhi@luobo:~$ sudo apt-get install gitlab-ce
        luobozhi@luobo:~$ sudo gitlab-ctl reconfigure
        luobozhi@luobo:~$ sudo gitlab-ctl status  // check gitlab status
    Step 3: browse to the hostname and login
    Step 4: Type http://127.0.0.1:8080 in the browser will redirect to the Gitlab page, setup the new password and finally we can enter the GitLab page.
 
Task 3: Create a demo group/project in gitlab

    Step 1: Create a new group named with “demo” in the above GitLab page.
    Step 2: In the newly created group, create a new project named with “go-web-hello-world”. The project can be accessed through http://127.0.0.1:8080/demo/go-web-hello-world. As shown below. Now the project is empty as displayed below. Next step is to use Golang in the host machine (my MBP) and build a helloweb.go app (listen to 8081).
    Step 3: Download and install Golang (https://golang.org/dl/) in the host machine. Open a terminal and type “go” to validate the correctness of the installation.
        zhiboluo$ go
        Go is a tool for managing Go source code. 
        ....

    Step 4: Create a new folder and create a .go file in that folder.
        zhiboluo$ cd Documents/
        Documents zhiboluo$ mkdir GOProjects
        Documents zhiboluo$ cd GOProjects
        GOProjects zhiboluo$ vim helloweb.go
    Step 5: type the following code in the helloweb.go
        package main
        import (
            "fmt"
            "net/http"
            "strings"
            "log"
        )
        func sayhelloName(w http.ResponseWriter, r *http.Request) {
            r.ParseForm() 
            fmt.Println(r.Form)  
            fmt.Println("path", r.URL.Path)
            fmt.Println("scheme", r.URL.Scheme)
            fmt.Println(r.Form["url_long"])
            for k, v := range r.Form {
                fmt.Println("key:", k)
                fmt.Println("val:", strings.Join(v, ""))
            }
            fmt.Fprintf(w, "Go Web Hello World!\n") // message output to brower
        }

        func main() {
            http.HandleFunc("/", sayhelloName) 
            err := http.ListenAndServe(":8081", nil) // listen port
            if err != nil {
                log.Fatal("ListenAndServe: ", err)
            }
        }

    Step 6: build the go file and start the exe file.
        GOProjects zhiboluo$ go build helloweb.go
        GOProjects zhiboluo$ ./helloweb
    Step 7: open the browser and go to http://127.0.0.1:8081/, appears the following message.
    
    Step 8: At this moment, we have built a hello world web app (listen to 8081 port) using Golang. Next step is to push the code to the newly created project in the GitLab.
    Step 9: cd to the folder where we create the go project. Type the following commands to create a local git repository.
        GOProjects zhiboluo$ git init
        GOProjects zhiboluo$ git remote add origin http://127.0.0.1:8080/demo/go-web-hello-world.git   //followed by typing username(root) and password
        GOProjects zhiboluo$ git add .
        GOProjects zhiboluo$ git commit -m "Initial commit"
        GOProjects zhiboluo$ git push -u origin master

    Step 10: refresh the GitLab page and notice the initial commit has been pushed to this project.
    
Task 4: Build the app and expose ($ go run) the service to 8081 port

    Expect output:
    curl http://127.0.0.1:8081
    Go Web Hello World!

    Step 1: open a new terminal in the host machine and type “curl http://127.0.0.1:8081” will output the following message.
        zhiboluo$ curl http://127.0.0.1:8081
        Go Web Hello World!


Task 5: Install docker

    According to the installation instructions (https://docs.docker.com/install/linux/docker-ce/ubuntu/), there are 3 different ways to install docker in Ubuntu. Here I choose the first method which will install docker using the repository.
    Step 1: Before install the Docker engine, it is suggested to set up the repository. Update the apt package index and install packages to allow apt to use a repository over HTTPS.
        luobozhi@luobo:~$ sudo apt-get update
        luobozhi@luobo:~$ sudo apt-get install \
        >     apt-transport-https \
        >     ca-certificates \
        >     curl \
        >     gnupg-agent \
        >     software-properties-common
    Step 2: Add Docker’s official GPG key, and Verify that you now have the key with the fingerprint 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88, by searching for the last 8 characters of the fingerprint.
        luobozhi@luobo:~$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        OK
        luobozhi@luobo:~$ sudo apt-key fingerprint 0EBFCD88
        pub   4096R/0EBFCD88 2017-02-22
            Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
        uid                  Docker Release (CE deb) <docker@docker.com>
        sub   4096R/F273FCD8 2017-02-22
    Step 3: Use the following command to set up the stable repository.
        luobozhi@luobo:~$ sudo add-apt-repository \
        >    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        >    $(lsb_release -cs) \
        >    stable"
    Step 4: This step is going to install Docker Engine. First update the apt package index, and install the latest version of Docker Engine and containerd, or go to the next step to install a specific version:
        luobozhi@luobo:~$ sudo apt-get update
        luobozhi@luobo:~$ sudo apt-get install docker-ce docker-ce-cli containerd.io
    Step 5: finally, verify that Docker Engine is installed correctly by running the hello-world image. This command downloads a test image and runs it in a container. When the container runs, it prints an informational message and exits.
     luobozhi@luobo:~$ sudo docker run hello-world
        Docker Engine is installed and running. The docker group is created but no users are added to it. You need to use sudo to run Docker commands.

Task 6: Run the app in container

    build a docker image ($ docker build) for the web app and run that in a container ($ docker run), expose the service to 8082 (-p)
    https://docs.docker.com/engine/reference/commandline/build/
    Check in the Dockerfile into gitlab
    Expect output:
    curl http://127.0.0.1:8082
    Go Web Hello World!

    In Task 3 and 4, the hello world program was built and run on the host machine (I made a misunderstanding of this Task). Here I will build the go web app again and expose the service to 8081 port in the guest machine.

    Step 1: create a folder for the Go web project.
        luobozhi@luobo:~$ mkdir web-app
        luobozhi@luobo:~$ cd web-app/

    Step 2: install the Golang in the guest machine.
    l   uobozhi@luobo:~/web-app$ sudo apt install golang-go

    Step 3: create a file named with “helloweb_2.go” and type the following code.
        luobozhi@luobo:~/web-app$ vim helloweb_2.go
        luobozhi@luobo:~/web-app$ cat helloweb_2.go 
        package main

        import (
            "fmt"
            "net/http"
            "log"
        )

        func main() {
            http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
                fmt.Fprintf(w, "GO WEB, Hello World!\n")
            })

            err := http.ListenAndServe(":8081", nil)
            if err != nil {
                log.Fatal("ListenAndServe: ", err)
            }
        }


    Step 4: Build the .go file and run it in the background.
        luobozhi@luobo:~/web-app$ go build helloweb_2.go
        luobozhi@luobo:~/web-app$ ./helloweb_2 &
        [1] 9694
    Step 5: check the output.
        luobozhi@luobo:~/web-app$ curl http://127.0.0.1:8081
        GO WEB, Hello World!

    Next, I will build a docker image ($ docker build) for the web app and run that in a container ($ docker run), expose the service to 8082 (-p)

    Step 6: create a Dockerfile to tell the Docker how to containerize this web app.
        luobozhi@luobo:~/web-app$ vim Dockerfile
        luobozhi@luobo:~/web-app$ cat Dockerfile 
        FROM golang: latest

        RUN mkdir -p /go/src/web-app
        WORKDIR /go/src/web-app
        COPY . /go/src/web-app
        RUN go-wrapper download
        RUN go-wrapper install
        ENV PORT 8082

        EXPOSE 8082
        CMD ["go-wrapper", "run"]

    Step 7: Build the Go web app in the Docker and get some errors,
      luobozhi@luobo:~/web-app$ sudo docker build --rm -t web-app .

        The following error was found.
        ….
        ---> 517a74d637a8
        Step 4/9 : COPY . /go/src/web-app
        ---> fbac6d82795b
        Step 5/9 : RUN go-wrapper download
        ---> Running in b9369dccddf0
        /bin/sh: 1: go-wrapper: not found
        …
    Step 8: After google search, change the image of golang from “latest” to “1.9.6-alpine3.7” and build it again.

    Step 9: now we can docker run the web app. Execute the following command and found the port 8082 has been used.
        luobozhi@luobo:~/web-app$ sudo docker run -p 8082:8082 --name="test" -d web-app
        bfd5aa086a7d81012a55005191e8f1f4c082037e9744d5261d4f2c4ab2c81e5c
        docker: Error response from daemon: driver failed programming external connectivity on endpoint test0 (a88c038c87d0c8712dffd795fffd30ddeaa4899c16af2ada25a7ce49fd83b7b9): Error starting userland proxy: listen tcp 0.0.0.0:8082: bind: address already in use.

    Step 10: Check which process using the 8082 port.
        luobozhi@luobo:~/web-app$ sudo lsof -i:8082
        COMMAND    PID              USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
        prometheu 1268 gitlab-prometheus   30u  IPv4  26615      0t0  TCP localhost:46832->localhost:8082 (ESTABLISHED)
        bundle    1344               git   25u  IPv4  26493      0t0  TCP localhost:8082 (LISTEN)
        bundle    1344               git   78u  IPv4  26616      0t0  TCP localhost:8082->localhost:46832 (ESTABLISHED)

    Step 11: Here I’m not sure if the bundle can be killed, so I check another port 8084 and found no one use it.
        luobozhi@luobo:~/web-app$ sudo docker run -p 8084:8082 --name="test01" -d web-app
        962e37ef6190dce5fbd44082b5302a2808cf841f36428492ffdccc85bfe7d6c9

    Step 12: check the output.
        luobozhi@luobo:~/web-app$ curl http://127.0.0.1:8084
        GO WEB, Hello World!

    Step 13: finally, using this command “git push origin master” to push the “Dockerfile” to GitLab.
        git add Dockerfile
        git commit -m "add Dockerfile"
        git push origin master


Task 7: Push image to dockerhub

    Step 1: create a Docker account to share the web-app image. And create a new repository named with “go-web-hello-world”
    
    Step 2: login to the local machine
        luobozhi@luobo:/$ sudo docker login
        Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
        Username: luobozhi
        Password: 
        WARNING! Your password will be stored unencrypted in /home/luobozhi/.docker/config.json.
        Configure a credential helper to remove this warning. See
        https://docs.docker.com/engine/reference/commandline/login/#credentials-store

        Login Succeeded
    Step 3: tag the image using this command “docker tag image username/repository:tag”.
        luobozhi@luobo:/$ sudo docker images
        REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
        web-app             latest              f439a5478344        3 hours ago         283MB
        luobozhi@luobo:/$ sudo docker tag f439a5478344 luobozhi/go-web-hello-world:v0.1
        luobozhi@luobo:/$ sudo docker images
        REPOSITORY                    TAG                 IMAGE ID            CREATED             SIZE
        luobozhi/go-web-hello-world   v0.1                f439a5478344        3 hours ago         283MB
        web-app                       latest              f439a5478344        3 hours ago         283MB
    Step 4: push the tagged image to Docker hub.
        luobozhi@luobo:/$ sudo docker push luobozhi/go-web-hello-world:v0.1
        The push refers to repository [docker.io/luobozhi/go-web-hello-world]
        5c3d13c97904: Pushed 
        12c3b4d59a45: Pushed 
        40f2c7848dea: Pushed 
        1560f6488009: Pushed 
        dd84dbaa91f8: Mounted from library/golang 
        40451ef226a1: Mounted from library/golang 
        dc7275ed3768: Mounted from library/golang 
        6eeebfabfc25: Mounted from library/golang 
        79d579ee9ade: Mounted from library/golang 
        747a1ba085b0: Mounted from library/golang 
        cd7100a72410: Mounted from library/golang 
        v0.1: digest: sha256:08dd8cda2c5d1017b605db2fcfd63495428dbd187fddf026743fb917364f2eb3 size: 2614
    Step 5: Finally, login to my Docker account and check the repository (https://hub.docker.com/r/luobozhi/go-web-hello-world/)
    

Task 8: Document the procedure in a MarkDown file

    create a README.md file in the gitlab repo and add the technical procedure above (0-7) in this file
    Step 1: login to the GitLab and directly add a README.md file. 


