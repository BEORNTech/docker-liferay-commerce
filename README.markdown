# About this repo
This repository contains some **nonofficial** pet-projects on how to use Liferay + Liferay Commerce with Docker.

# Available Liferay Releases
  - Liferay 7.1 RC 1
  
# Environment variables

### DEBUG_MODE

This variable is optional and allows you to specify if the container is run using a debug configuration. In the case of Tomcat, port 9000 will be exposed for debugging the application server.

### JVM_TUNING_MEMORY

This variable is optional and allows you to specify the Xmx and Xms JVM memory configuration. If no variable is passed, then 2048m will be used as default value.

## Supported Databases
These are the supported Database Management System (*DBMS*):
  - HSQL

## Supported Application Servers
These are the supported App servers:
  - Tomcat

# License
These docker images are free software ("Licensed Software"); you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

These docker images are distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; including but not limited to, the implied warranty of MERCHANTABILITY, NONINFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
