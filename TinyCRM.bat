@echo off
::Author: André Ossamu Sato
::Direitos reservados
echo ---------- Programa de cadastro virtual ----------
set /p pet="Digite o nome do pet: " %=%
set /p owner="Digite o nome do dono: " %=%
set /p breed="Digite a raca: " %=%
set /p phone="Digite o telefone: " %=%

echo Voce esta cadastrando o %pet% do %owner% de raca %breed% com o telefone %phone%
set /p confirmation="Deseja continuar? (s/n): " %=%

IF %confirmation%==s (
	Echo processando...
	
	:CHECKPETNAME
	if exist %pet%\\%pet%.html (
		set /p pet="Nome do pet ja cadastrado! Digite outro nome para o pet: " %=%
		goto CHECKPETNAME
	) 
	Echo criando pagina web...
	md %pet%
	SETLOCAL DisableDelayedExpansion
	FOR /F "usebackq delims=" %%a in (`"findstr /n ^^ template.html"`) do (
	    set "var=%%a"
	    SETLOCAL EnableDelayedExpansion
	    set "var=!var:*:=!"
	    set "var=!var:PET_NAME=%pet%!"
	    set "var=!var:BREED=%breed%!"
	    set "var=!var:OWNER=%owner%!"
	    set "var=!var:PHONE=%phone%!"
	    echo !var! >> %pet%\\%pet%.html
	    ENDLOCAL
	)

	
	Echo atualizando página índice...

	SETLOCAL DisableDelayedExpansion
	FOR /F "usebackq delims=" %%a in (`"findstr /n ^^ index.html"`) do (
	    set "var=%%a"
	    SETLOCAL EnableDelayedExpansion
	    set "var=!var:*:=!"
	    set "var=!var:----=----<li><a id='%pet%' href='%pet%/%pet%.html'>%pet%</a></li>!"	    
	    echo !var! >> index2.html
	    ENDLOCAL
	)

	Echo deletando arquivos temporarios
	if exist index2.html (
		copy index2.html index.html
		del index2.html
	)
	Echo registro salvo!
) ELSE (
	IF NOT %confirmation%==s (
		Echo Processo cancelado!
	)
)
pause