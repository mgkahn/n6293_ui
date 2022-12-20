SET USER_NAME=%USERNAME%
SET USER_ID=501

(
echo version: "3.9"
echo services:
echo  db:
echo   image: mgkahn/db:latest
echo   container_name: db
echo  ui:
echo   image: mgkahn/ui:latest
echo   container_name: ui
) |docker compose -f - pull
(
echo version: "3.9"
echo services:
echo  db:
echo   image: mgkahn/db:latest
echo   container_name: db
echo   environment:
echo    PREFIX: /usr/local/firebird
echo    VOLUME: /firebird
echo    ISC_PASSWORD: nurs6293
echo    DEBIAN_FRONTEND: noninteractive
echo    TZ: America/Denver
echo    NETWORK: 6293_net
echo   ports:
echo    - 3050:3050
echo   volumes:
echo    - %USERPROFILE%:/workspace
echo    - db_vol:/firebird
echo   networks:
echo    - n6293_net
echo  ui:
echo   image: mgkahn/ui:latest
echo   container_name: ui
echo   environment:
echo    DEBIAN_FRONTEND: noninteractive
echo    TZ: America/Denver
echo    LIBGL_ALWAYS_INDIRECT: 1
echo    USERNAME: %USER_NAME%
echo    USERID: %USER_ID%
echo    PASSWORD: nurs6293
echo    RESOLUTION: 1600x900
echo   networks:
echo    - n6293_net
echo   ports:
echo    - 6080:80
echo   volumes:
echo    - %USERPROFILE%:/workspace
echo    - ui_vol:/home/%USER_NAME%
echo    - %USERPROFILE:\=\\%\\Desktop\\Transfer_Station:/home/%USER_NAME%/Desktop/Transfer_Station
echo networks:
echo  n6293_net:
echo   driver: bridge
echo volumes:
echo  ui_vol:
echo   driver: local
echo  db_vol:
echo    driver: local
)|start /B "" docker compose -f - up --abort-on-container-exit --exit-code-from ui
timeout /t 10
start "" http:\\localhost:6080
