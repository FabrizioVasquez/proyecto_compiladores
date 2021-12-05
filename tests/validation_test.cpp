#include <gtest/gtest.h>

#include <strstream>

#include "FlexScanner.hpp"
#include "parser.hpp"

using namespace utec::compilers;

class ParamTest : public testing::TestWithParam<std::pair<std::string, int>> {};

TEST_P(ParamTest, basicTest) {
  std::istrstream str(GetParam().first.c_str());

  FlexScanner scanner{str, std::cerr};
  int result = 0;
  Parser parser{&scanner, &result};

  parser.parse();
  EXPECT_EQ(result, GetParam().second);
}

INSTANTIATE_TEST_SUITE_P(SimpleTest, ParamTest,
                         testing::Values(std::make_pair("entero a;" ,777),
                                         std::make_pair("entero a[5];", 777),
                                         std::make_pair("sin_tipo a(){}", 777),
                                         std::make_pair("entero a(){}",777)
                                         ));

int main(int argc, char** argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
