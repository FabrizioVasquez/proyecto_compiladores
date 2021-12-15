#include<map>

struct element{
    std::string dtype{};
    int value{};
    element() = default;
};

std::string testing = "HOla";
std::map<std::string,element> tablaSimbol;