#include <gtest/gtest.h>
#include "Board.h"

TEST(BoardSolve, EasyIsSolvable)
{
    Board board;
    board.load(std::string(SUDOKU_CONTENT_DIR) + "/easy.txt");
    auto result = board.solve();
    EXPECT_TRUE(result.solved);
}

TEST(BoardSolve, HardIsSolvable)
{
    Board board;
    board.load(std::string(SUDOKU_CONTENT_DIR) + "/hard.txt");
    auto result = board.solve();
    EXPECT_TRUE(result.solved);
}

TEST(BoardSolve, WorldHardestIsSolvable)
{
    Board board;
    board.load(std::string(SUDOKU_CONTENT_DIR) + "/world_hardest.txt");
    auto result = board.solve();
    EXPECT_TRUE(result.solved);
}

TEST(BoardSolve, NotSolveable)
{
    Board board;
    board.load(std::string(SUDOKU_CONTENT_DIR) + "/not_solveable.txt");
    auto result = board.solve();
    EXPECT_FALSE(result.solved);
}


TEST(BoardValidity, DuplicateInRowIsNotSolveable)
{
    Board board;
    board.load(std::string(SUDOKU_FIXTURES_DIR) + "/duplicate_in_row.txt");
    EXPECT_FALSE(board.isSolveable());
}

TEST(BoardValidity, DuplicateInColumnIsNotSolveable)
{
    Board board;
    board.load(std::string(SUDOKU_FIXTURES_DIR) + "/duplicate_in_column.txt");
    EXPECT_FALSE(board.isSolveable());
}

TEST(BoardValidity, DuplicateInSquareIsNotSolveable)
{
    Board board;
    board.load(std::string(SUDOKU_FIXTURES_DIR) + "/duplicate_in_square.txt");
    EXPECT_FALSE(board.isSolveable());
}