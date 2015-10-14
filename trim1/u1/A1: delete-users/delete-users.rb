#!usr/bin/ruby
#encoding: utf-8
#Autor: Aitor Domingo Machado Velázquez

users = 'cat userlist.txt'

userlist= users.split("\n")

userlist.each { |usu| system("userdel -f -r #{usu}")}
