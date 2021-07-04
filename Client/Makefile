# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: widraugr <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/11/29 13:07:44 by widraugr          #+#    #+#              #
#    Updated: 2021/07/04 11:13:12 by mixfon           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = client

FILE_C = main.cpp

FLAGS = -Wall -Wextra -Werror 

all : $(NAME)

$(NAME):
	g++ -std=c++11 $(FILE_C) -o $(NAME)
	
clean:
	/bin/rm -f $(NAME)
	/bin/rm -rf *.dSYM
	
re: clean all 
