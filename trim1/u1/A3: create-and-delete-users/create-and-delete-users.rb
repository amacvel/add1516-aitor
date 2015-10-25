#! /usr/bin/ruby
# encoding: utf-8
# Autor: Aitor Domingo Machado Velázquez

user = `whoami`
puts user


if user == "root"
    users = `cat userslist.txt`
    userslist = users.split("/n")
   
    userslist.each do |usu|
        a = usu.split(":")
       
        nombre = a[0]
        apellido = a[1]
        email = a[2]
        action = a[3]
       
        if action == "delete"
            puts "deluser -f -r #{a[0]}"
        end
       
        if action == "add"
            puts "adduser #{a[0]}"
        end
    end
   
end
