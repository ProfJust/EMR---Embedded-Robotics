# !/bin/bash

# youBot Installation auf Remote-PC
# OJ fuer robotik.bocholt@w-hs.de

# script to setup youbot-Workspace for ROS melodic
# EMR SS2021 OJ

echo -e "\033[1;92m ---------- Skript zur Einrichtung des youBot Workspace in ROS melodic ------------ \033[0m "

echo -e "\033[42m ---------- Systemupdates werden ausgefuehrt - Passwort erforderlich  ------------ \033[0m "
cd ~/catkin_ws/src/
sudo apt update -y
sudo apt dist-upgrade -y   #-y ist ohne Ja Abfrage

echo -e "\033[42m ---------- Installation der noetigen ROS-Pakete  ------------ \033[0m "
sudo apt install ros-melodic-urg-node -y
sudo apt install ros-melodic-scan-tools -y #fehlt noch
sudo apt install ros-melodic-map-server -y
sudo apt install ros-melodic-slam-gmapping -y #fehlt noch
sudo apt install ros-melodic-amcl -y
sudo apt install ros-melodic-move-base -y
sudo apt install ros-melodic-pr2-msgs -y #  melodic-release jetzt verfuegbar
# git clone https://github.com/GeraldHebinck/pr2_common.git -b msg_only
sudo apt install ros-melodic-joint-trajectory-controller -y
sudo apt install ros-melodic-rqt-joint-trajectory-controller -y # fuer Armsteuerung mit RQT
sudo apt-get install ros-melodic-moveit-simple-controller-manager -y # Für MoveIt! in Gazebo
sudo apt-get install ros-melodic-moveit -y


git clone https://github.com/GeraldHebinck/emr -b noetic-devel
git clone https://github.com/GeraldHebinck/youbot_navigation.git -b noetic-devel # fork von https://github.com/youbot/youbot_navigation
git clone https://github.com/youbot/youbot_driver -b hydro-devel
git clone https://github.com/GeraldHebinck/youbot_driver_ros_interface.git -b noetic-devel # fork von git clone https://github.com/youbot/youbot_driver_ros_interface.git
git clone https://github.com/GeraldHebinck/youbot_description.git -b noetic-devel # fork von https://github.com/mas-group/youbot_description.git
git clone https://github.com/GeraldHebinck/youbot_simulation.git -b noetic-devel # fork von https://github.com/mas-group/youbot_simulation.git
git clone https://github.com/wnowak/brics_actuator.git
git clone https://github.com/pschillinger/youbot_integration.git
git clone https://github.com/FlexBE/youbot_behaviors.git
git clone https://github.com/pal-robotics-forks/point_cloud_converter
git clone https://github.com/team-vigir/flexbe_behavior_engine.git
git clone https://github.com/wnowak/youbot_moveit.git
# braucht man nicht wirklich: git clone https://github.com/wnowak/youbot_applications.git
# android_app needs BLUETOOTH_INCLUDE_DIR => delete directory
#cd catkin_ws/src/youbot_applications/
#rm -r  android_app_pc_client
#rm -r keyboard_remote_control

echo -e "\033[42m ---------- Aktualisiere alle Abhaengigkeiten der ROS-Pakete ---------- \033[0m"
source ~/.bashrc
rosdep update
rosdep install --from-paths . --ignore-src -r -y

echo -e "\033[42m ---------- Ausfuehren von catkin_make ---------- \033[0m"
cd ~/catkin_ws/
catkin_make

sudo setcap cap_net_raw+ep ~/catkin_ws/devel/lib/youbot_driver_ros_interface/youbot_driver_ros_interface

echo -e "\033[42m ---------- Robotik-Labor Arena in Gazebo einfuegen ---------- \033[0m"
mkdir -p ~/.gazebo/models/arena_robotiklabor
cp ~/catkin_ws/src/emr/emr_worlds/arena_robotiklabor/* -t ~/.gazebo/models/arena_robotiklabor -r

echo -e "\033[42m ---------- youBot Workspace ist installiert - have fun! ----------   \033[0m"
echo -e "\033[42m $ roslaunch emr_worlds youbot_arena.launch \033[0m"

