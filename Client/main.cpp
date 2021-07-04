#include "HTTPRequest.hpp"
#include <iostream>

std::string g_host = "192.168.0.102";
std::string g_port = "8090";

void sendGetRequest(const std::string &folder)
{
	try
	{
		// you can pass http::InternetProtocol::V6 to Request to make an IPv6 request
		http::Request request("http://" + g_host + ":" + g_port + "/?path=" + folder);
		// send a get request
		http::Response response = request.send("GET");
		// print the result
		std::cout << std::string(response.body.begin(), response.body.end()) << std::endl;
	}
	catch (const std::exception& e)
	{
		std::cerr << "Request failed, error: " << e.what() << std::endl;
	}
}

void checkArguments(int ac, char **av)
{
	if (ac != 3)
	{
		std::cerr << "Invalid number of arguments." << std::endl;
		std::cerr << "./client host port" << std::endl;
		exit(-1);
	}
	g_host = std::string(av[1]);
	g_port = std::string(av[2]);
}

int main(int ac, char **av)
{
	std::string line;

	checkArguments(ac, av);
	std::cout << "Client start." << std::endl;
	std::cout << "To shut down the client and server, enter exit." << std::endl;
	while (21)
	{
		std::cout << "Enter the path to the folder to be checked." << std::endl;
		getline(std::cin, line);
		sendGetRequest(line);
		if (line == "exit")
		{
			std::cout << "Client stop." << std::endl;
			break;
		}
	}
	return 0;
}
