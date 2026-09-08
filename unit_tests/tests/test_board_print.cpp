#include <gtest/gtest.h>
#include <sstream>
#include "Board.h"

TEST(BoardPrint, PrintOutputsBoardToConsole)
{
    Board board;
    board.load(std::string(SUDOKU_CONTENT_DIR) + "/easy.txt");

    std::stringstream buffer;
    std::streambuf *oldCout = std::cout.rdbuf(buffer.rdbuf());

    board.print();

    std::cout.rdbuf(oldCout);

    std::string output = buffer.str();

    EXPECT_FALSE(output.empty());
    EXPECT_NE(output.find('|'), std::string::npos);
    EXPECT_NE(output.find('_'), std::string::npos);
}

TEST(BoardPrint, EmptyTilesPrintedAsDash)
{
    Board board;
    board.load(std::string(SUDOKU_CONTENT_DIR) + "/easy.txt");

    std::stringstream buffer;
    std::streambuf *oldCout = std::cout.rdbuf(buffer.rdbuf());
    board.print();
    std::cout.rdbuf(oldCout);

    EXPECT_NE(buffer.str().find('-'), std::string::npos);
}