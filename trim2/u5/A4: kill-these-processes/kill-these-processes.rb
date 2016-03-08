#! /usr/bin/ruby
# encoding: utf-8
# Autor: Aitor Domingo Machado Velázquez


require "rainbow"
def comprobar_root

user=`whoami`

if user != "root\n"
	puts "No eres el usuario administrador, así que no podrás ejecutar este script."
	exit
end


end

def listar

file=`cat processes-black-list.txt`
filas=file.split("\n")
return filas

end


def comprobar_procesos(proceso, accion)

ejecutar = system("ps -e| grep #{proceso} 1>/dev/null")
	
	if (accion == "kill" or accion == "k") and ejecutar==true
                system("killall #{proceso} 1>/dev/null")
                puts Rainbow("_KILL_: Proceso #{proceso} eliminado").color(:red)
            
            elsif (accion == "notify" or accion == "n") and ejecutar==true
                puts Rainbow("NOTICE: Proceso #{proceso} en ejecución").color(:green)
            
			end
end

comprobar_root
filas = listar
system ("touch state.running 1>/dev/null")


while(File.exist?('state.running'))  do
	filas.each do |linea|
		datos=linea.split(":")
		comprobar_procesos(datos[0],datos[1])
end
	sleep(5)

end
