#! /bin/bash

# Make changes to UI
# Change terminal foreground to white
sed -i -e "s/fgcolor=rgb(170,170,170)/fgcolor=rgb(255,255,255)/g" ${HOME}/.config/lxterminal/lxterminal.conf
# Only one workspace
sed -i -e "s|<number>2</number>|<number>1<\/number>|g" ${HOME}/.config/openbox/rc.xml
# Default to local resize
sed -i -e "s/UI.initSetting('resize', 'off');/UI.initSetting('resize', 'local');/g" /usr/local/lib/web/frontend/static/novnc/app/ui.js
# Solid color background
sed -i -e "s/wallpaper_mode=stretch/wallpaper_mode=color/g" /usr/local/share/doro-lxde-wallpapers/desktop-items-0.conf
# Dark teal'ish color
sed -i -e "s/desktop_bg=\#000000/desktop_bg=\#647775/g" /usr/local/share/doro-lxde-wallpapers/desktop-items-0.conf
# Allow scale variable to be changed during session
sed -i -e "s/readQueryVariable('scale', false/readQueryVariable('scale', true/g" /usr/local/lib/web/frontend/static/novnc/vnc_lite.html
# Set default values for scaling and resize
# From https://groups.google.com/g/novnc/c/fxVMUGy53XQ/m/eokPV25BAwAJ
sed -i -e "s/scaleViewport = false/scaleViewport = true/g" /usr/local/lib/web/frontend/static/novnc/core/rfb.js
sed -i -e "s/resizeSession = false/resizeSession = true/g" /usr/local/lib/web/frontend/static/novnc/core/rfb.js


# Desktop
# Add DbSchema launcher
cp /opt/DbSchema/DbSchema.desktop /usr/share/applications
# Put desktop shortcuts for DbSchema and Base on Desktop
cp /etc/startup/desktop/*.desktop ${HOME}/Desktop/
# Add course launchers to bottom task bar
cp /etc/startup/desktop/dot_config_lxpanel_LXDE_panels_panel ${HOME}/.config/lxpanel/LXDE/panels/panel

# DbSchema
# Add default config files
mkdir -p ${HOME}/.DbSchema
cp -ru /etc/startup/desktop/dot.DbSchema/* ${HOME}/.DbSchema

# FlameRobin
# Set up FlameRobin with initial databases
mkdir -p ${HOME}/.flamerobin
cp /etc/startup/desktop/dot_flamerobin_fr_databases.conf ${HOME}/.flamerobin/fr_databases.conf
cp /etc/startup/desktop/dot_flamerobin_fr_settings.conf ${HOME}/.flamerobin/fr_settings.conf

# LibreOffice Base
# LibreOffice does not create .config file until AFTER first launch so we put a version here
# TODO: Figure out a better way to do this. 
mkdir -p ${HOME}/.config/libreoffice
cp -r /etc/startup/desktop/dotconfig.libreoffice/* ${HOME}/.config/libreoffice/
# END TODO
#
# Add jaybird JAR to OpenOffice classpath in javasettings*.xml. Done twice -- sometimes xsi:nil=false. Must be false in final target string
find ${HOME}/.config/libreoffice -name javasettings*.xml -type f -exec sed -i 's|<userClassPath xsi:nil="true"/>|<userClassPath xsi:nil="false">/usr/local/bin/jaybird-full-4.0.6.java11.jar</userClassPath>|g' {} \;
find ${HOME}/.config/libreoffice -name javasettings*.xml -type f -exec sed -i 's|<userClassPath xsi:nil="false"/>|<userClassPath xsi:nil="false">/usr/local/bin/jaybird-full-4.0.6.java11.jar</userClassPath>|g' {} \;
# Add BASE connection files (odb) to Desktop
mkdir -p ${HOME}/Desktop/BaseDatabases
cp -r /etc/startup/desktop/BaseDatabases/*.odb ${HOME}/Desktop/BaseDatabases/

# Prevents complaints that ~/Templates is not present
mkdir -p ${HOME}/Templates


# Make all home files owned by user
chown -R ${USERNAME}:${USERNAME} ${HOME}
