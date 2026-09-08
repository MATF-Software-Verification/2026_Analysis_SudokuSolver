#include <gtest/gtest.h>
#include "Board.h"

TEST(BoardIndexing, TranslateTopLeftCorner)
{
    Board board;
    EXPECT_EQ(board.translate(0, 0, 9), 0u);
}

TEST(BoardIndexing, TranslateBottomRightCorner)
{
    Board board;
    EXPECT_EQ(board.translate(8, 8, 9), 80u);
}

TEST(BoardIndexing, GetRowAndColumnRoundTrip)
{
    Board board;
    unsigned int index = 37;
    auto r = board.getRow(index, 9);
    auto c = board.getColumn(index, 9);
    EXPECT_EQ(board.translate(c, r, 9), index);
}


TEST(BoardIndexing, GetTileSquareAllNineRegions)
{
    Board board;
    // (kolona, red) -> ocekivani broj kvadrata (0-8)
    EXPECT_EQ(board.getTileSquare(0, 0), 0u);
    EXPECT_EQ(board.getTileSquare(4, 0), 1u);
    EXPECT_EQ(board.getTileSquare(8, 0), 2u);
    EXPECT_EQ(board.getTileSquare(0, 4), 3u);
    EXPECT_EQ(board.getTileSquare(4, 4), 4u);
    EXPECT_EQ(board.getTileSquare(8, 4), 5u);
    EXPECT_EQ(board.getTileSquare(0, 8), 6u);
    EXPECT_EQ(board.getTileSquare(4, 8), 7u);
    EXPECT_EQ(board.getTileSquare(8, 8), 8u);
}