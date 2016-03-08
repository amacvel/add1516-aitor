#! /usr/bin/ruby
# encoding: utf-8
# Autor: Aitor Domingo Machado Velázquez

user=`whoami`

if user != "root\n"
	puts "No eres el usuario administrador, así que no podrás ejecutar este script."
	exit
end

archivo=`cat userslist.txt`
filas=archivo.split("\n")
   
filas.each do |linea| 									 
	posicion=linea.split(":")

    if posicion[2] == ""
            puts "El usuario #{posicion[0]} no posee ningún email."
        
        else
        
            if posicion[4] == "add"
                system("adduser #{posicion[0]}")
                puts "Se ha creado el usuario #{posicion[0]}"
            
            elseif posicion[4] == "delete"
                system("deluser #{posicion[0]}")
                puts "Se ha eliminado el usuario #{posicion[0]}"
            end
            
	end
	
    end
    
end
