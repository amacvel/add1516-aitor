#!/usr/bin/ruby
# encoding: utf-8
# Autor: Aitor Domingo Machado Velázquez

user=`whoami`

if user != "root\n"
	puts "No eres el usuario administrador, así que no podrás ejecutar este script."
	exit
end

archivo=`cat software-list.txt`
filas=archivo.split("\n")

filas.each do |linea| 										# Acepta un bloque de código y lo ejecuta por cada elemento de la lista.
	posicion=linea.split(":")
	comprobacion = system("dpkg -l #{posicion[0]}|grep ii") # Muestra si el paquete está o no instalado.
		
		if (posicion[1] == "remove" or posicion[1] == "r") and comprobacion==true
		
			system("apt-get purge -y #{posicion[0]}")
			puts "Se ha desinstalado correctamente: #{posicion[0]}"
		
		elsif posicion[1] == "install" or posicion[1] =="i" and comprobacion==false
			
			system("apt-get install -y #{posicion[0]}")
			puts "Se ha instalado correctamente: #{posicion[0]}"
			
		end
	
end
