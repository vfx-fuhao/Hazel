#include <Hazel.h>

class Sandbox : public Hazel::Application
{
public:
	Sandbox()
	{

	}
	~Sandbox()
	{

	}

};


Hazel::Application* Hazel::CreateApplication()
{
	HZ_ERROR("Hal Error Test.");
	return new Sandbox();
}