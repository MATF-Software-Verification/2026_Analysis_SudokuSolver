#include <gtest/gtest.h>
#include "Board.h"

TEST(BoardLoad, ValidFile)
{
    Board board;
    std::string path = std::string(SUDOKU_CONTENT_DIR) + "/easy.txt";
    EXPECT_TRUE(board.load(path));
}

TEST(BoardLoad, NonexistingFile)
{
    Board board;
    EXPECT_FALSE(board.load("does_not_exist.txt"));
}

TEST(BoardLoad, WrongLength)
{
    std::string path = std::string(SUDOKU_FIXTURES_DIR) + "/wrong_length.txt";
    Board board;
    EXPECT_FALSE(board.load(path));
}

TEST(BoardLoad, Whitespace)
{
    std::string path = std::string(SUDOKU_FIXTURES_DIR) + "/whitespace.txt";
    Board board;
    EXPECT_TRUE(board.load(path));
}