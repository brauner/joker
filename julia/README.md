docker-ubuntu-julia
===============

Ubuntu image intended for dockerized Julia development.

### Some properties

* Sets up `user` (with sudo rights) so that the container does not need to
  run as root.
* Sets up `/home` for `user` and some basic options `.bashrc` and
  `.inputrc` which should be adapted to your own needs.
* Installs all recommended `Julia` dependencies, pulls `Julia` from
  `Github` and compiles `Julia` from source.

There is a nice and semi-easy way of getting graphical output from a
Docker container without having to run an sshd daemon inside of the
container. Docker can provide bare metal performance when running a single
process which in this case is supposed to be Julia. Running an sshd daemon
will, marginal as it may be, introduce additional overhead. This is not
made better by running the sshd daemon as a child process of the
supervisor daemon. Both can be dispensed with when one makes good use of
bind mounts. After building the image from which the container is supposed
to be run we start an interactive container and bind mount the
`/tmp/.X11-unix` folder into it. I will state the complete command and
explain in detail what it does:

```
docker run -i -t --rm \
# -i sets up an interactive session; -t allocates a pseudo tty; --rm makes
# this container ephemeral
-e DISPLAY=$DISPLAY \
# sets the host display to the local machines display (which will usually
# be :0)
-u chbj \
# -u specify the process should be run by a user (here "chbj") and not by
# root. This step is important (v.i.)!
-v /tmp/.X11-unix:/tmp/.X11-unix \
# - v bind mounts the `X11` socket `/tmp/.X11-unix` into `/tmp/.X11-unix`
# in the container.
--name="jdev" ubuntu-j
# --name="" specify the name of the container (here "jdev"); the image you
# want to run the container from (here "ubuntu-j"); the process you want
# to run in the container (here "Julia").
```

After issuing this command you should be looking at the beautiful `Julia`
start output. If you were to try `demo(graphics)` to see if graphical
output is already working you would note that it is not. That is because
of the `Xsecurity` extension preventing you from accessing the socket. You
could now type `xhost +` on your local machine and try `demo(graphics)` in
your container again. You should now have graphical output. This method
however, is strongly discouraged as you allow access to your xsocket to
any remote host you're currently connected to. As long as you're only
interacting with single-user systems this might be somehow justifiable but
as soon as there are multiple users involved this will be absolutely
unsafe! Hence, you should use a less dangerous method. A good way is to
use the server interpreted `xhost +si:localuser:username` which can be
used to specify a single local user (see `man xhost`). This means
`username` should be the name of the user which runs the `X11` server on
your local machine and which runs the `Docker` container. This is also the
reason why it is important that you specify a user when running your
container. Last but not least there is always the more complex solution of
using `xauth` and `.Xauthority` files to grant access to the `X11` socket
(see `man xauth`). This however will also involve a little more knowledge
how `X` works.

### Entering a running container with `nsenter`

Should you need to enter a running container with a new `tty` you should
use nsenter. First find the `PID` of the (main) process running in the
container by either issuing `docker top containername` or `docker inspect
--format {{.State.Pid}} containername`. Then use `nsenter` which should
usually be installed on your system. If not install it. It can be found
`util-linux` (version must be at least `2.23`). You can use the command
`nsenter --target PID-you-just-found-out --mount --ipc --net --pid` or the
short version `nsenter -t PID-you-just-found-out -m -i -n -p`.

### Entering a running container with `docker exec`
As of release `1.3.` the recommended way of entering a running container
is by using `docker exec -it rdev bash` (`rdev` is the name of the running
container  and `bash` the program which is supposed to be run in the
container in this example.) which will spawn a new process in the running
container.